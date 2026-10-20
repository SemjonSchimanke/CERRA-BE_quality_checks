
#!/usr/bin/env python3

import argparse
import numpy as np
import pandas as pd
from scipy.spatial import cKDTree

EARTH_RADIUS_KM = 6371.0088


def main():
    parser = argparse.ArgumentParser(
        description="Check geographic extent, duplicate coordinates "
                    "and nearby observations."
    )
    parser.add_argument("file", help="ODC ASCII output file")
    parser.add_argument(
        "--bounds", nargs=4, type=float,
        metavar=("LON_MIN", "LON_MAX", "LAT_MIN", "LAT_MAX"),
        default=[-15, 35, 35, 72],
        help="Bounding box; default: -15 35 35 72"
    )
    parser.add_argument(
        "--radius", type=float, default=5.0,
        help="Distance threshold for nearby pairs in km (default: 5)"
    )
    parser.add_argument(
        "--show", type=int, default=20,
        help="Maximum number of rows/pairs to display (default: 20)"
    )
    args = parser.parse_args()

    # Read the ODC ASCII output, including its column header.
    df = pd.read_csv(args.file, sep=r"\s+")
    df.columns = [c.strip() for c in df.columns]

    # Identify the coordinate columns.
    lat_col = next(c for c in df.columns if c.startswith("lat"))
    lon_col = next(c for c in df.columns if c.startswith("lon"))

    df["lat"] = pd.to_numeric(df[lat_col], errors="coerce")
    df["lon"] = pd.to_numeric(df[lon_col], errors="coerce")

    invalid = (
        df[["lat", "lon"]].isna().any(axis=1)
        | ~df["lat"].between(-90, 90)
        | ~df["lon"].between(-180, 180)
    )
    print(f"Total rows: {len(df)}")
    print(f"Invalid/missing coordinates: {invalid.sum()}")

    valid = df.loc[~invalid].copy().reset_index(drop=True)
    print(f"Rows with valid coordinates: {len(valid)}")

    # 1. Geographic bounds
    lon_min, lon_max, lat_min, lat_max = args.bounds

    outside = ~(
        valid["lon"].between(lon_min, lon_max)
        & valid["lat"].between(lat_min, lat_max)
    )
    outside_df = valid.loc[outside]

    print("\n--- Geographic bounds ---")
    print(
        f"Bounds: lon [{lon_min}, {lon_max}], "
        f"lat [{lat_min}, {lat_max}]"
    )
    print(f"Outside bounds: {len(outside_df)} "
          f"({100 * outside.sum() / max(len(valid), 1):.2f}%)")

    print("\nCoordinate extremes:")
    print(f"  Longitude: {valid['lon'].min():.4f} to "
          f"{valid['lon'].max():.4f}")
    print(f"  Latitude:  {valid['lat'].min():.4f} to "
          f"{valid['lat'].max():.4f}")

    if len(outside_df):
        print("\nFirst outside-boundary observations:")
        print(outside_df[["lat", "lon"]].head(args.show).to_string(index=True))

    # 2. Exact duplicate coordinates
    duplicated = valid.duplicated(["lat", "lon"], keep=False)
    duplicate_rows = valid.loc[duplicated]
    duplicate_groups = (
        valid.groupby(["lat", "lon"]).size().loc[lambda x: x > 1]
    )

    print("\n--- Exact duplicate coordinates ---")
    print(f"Rows belonging to duplicate-coordinate groups: "
          f"{len(duplicate_rows)}")
    print(f"Number of duplicated coordinate groups: {len(duplicate_groups)}")

    if len(duplicate_groups):
        print("\nLargest duplicate groups:")
        print(duplicate_groups.sort_values(ascending=False)
              .head(args.show).to_string())

    # 3. Nearby coordinate pairs, using great-circle distance
    print(f"\n--- Nearby pairs within {args.radius:g} km ---")

    if args.radius <= 0:
        raise ValueError("--radius must be greater than zero")

    # Convert latitude/longitude to radians and build a unit-sphere tree.
    coords_rad = np.radians(valid[["lat", "lon"]].to_numpy())
    lat_rad, lon_rad = coords_rad[:, 0], coords_rad[:, 1]
    xyz = np.column_stack((
        np.cos(lat_rad) * np.cos(lon_rad),
        np.cos(lat_rad) * np.sin(lon_rad),
        np.sin(lat_rad)
    ))

    # Chord distance corresponding to the requested surface distance.
    angle = min(args.radius / EARTH_RADIUS_KM, np.pi)
    chord = 2 * np.sin(angle / 2)

    tree = cKDTree(xyz)
    pairs = tree.query_pairs(chord, output_type="ndarray")

    print(f"Number of pairs within radius: {len(pairs)}")
    if len(pairs):
        # Calculate accurate great-circle distances for each pair.
        a = coords_rad[pairs[:, 0]]
        b = coords_rad[pairs[:, 1]]
        dlat = b[:, 0] - a[:, 0]
        dlon = b[:, 1] - a[:, 1]
        h = (
            np.sin(dlat / 2) ** 2
            + np.cos(a[:, 0]) * np.cos(b[:, 0])
            * np.sin(dlon / 2) ** 2
        )
        distances = 2 * EARTH_RADIUS_KM * np.arcsin(
            np.sqrt(np.clip(h, 0, 1))
        )

        order = np.argsort(distances)
        involved = np.unique(pairs.ravel())

        print(f"Observations involved in at least one close pair: "
              f"{len(involved)}")
        print(f"Shortest pair distance: {distances.min():.4f} km")

        print("\nClosest pairs:")
        for k in order[:args.show]:
            i, j = pairs[k]
            print(
                f"Rows {i}, {j}: "
                f"({valid.loc[i, 'lat']:.5f}, {valid.loc[i, 'lon']:.5f}) "
                f"<-> ({valid.loc[j, 'lat']:.5f}, "
                f"{valid.loc[j, 'lon']:.5f}), "
                f"distance = {distances[k]:.3f} km"
            )


if __name__ == "__main__":
    main()
