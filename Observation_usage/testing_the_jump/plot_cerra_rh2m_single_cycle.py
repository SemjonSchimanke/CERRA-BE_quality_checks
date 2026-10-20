import pandas as pd
import matplotlib.pyplot as plt
import cartopy.crs as ccrs
import cartopy.feature as cfeature

df = pd.read_csv(
    "obs1978122906.dat",
    sep=r"\s+",
    skiprows=1,
    header=None,
    names=["lat", "lon"]
)

fig = plt.figure(figsize=(10, 8))
ax = plt.axes(projection=ccrs.PlateCarree())

ax.set_extent([-15, 35, 35, 75], crs=ccrs.PlateCarree())
ax.add_feature(cfeature.COASTLINE)
ax.add_feature(cfeature.BORDERS, linestyle=":")
ax.add_feature(cfeature.LAND, facecolor="lightgray")

ax.scatter(
    df["lon"], df["lat"],
    s=8,
    transform=ccrs.PlateCarree()
)

ax.set_title("Relative humidity observations - 1978122906")
plt.savefig("rh_observations_1978122906.png", dpi=150, bbox_inches="tight")
plt.show()


# Next date
df2 = pd.read_csv(
    "obs1979010306.dat",
    sep=r"\s+",
    skiprows=1,
    header=None,
    names=["lat", "lon"]
)

fig = plt.figure(figsize=(10, 8))
ax = plt.axes(projection=ccrs.PlateCarree())

ax.set_extent([-15, 35, 35, 75], crs=ccrs.PlateCarree())
ax.add_feature(cfeature.COASTLINE)
ax.add_feature(cfeature.BORDERS, linestyle=":")
ax.add_feature(cfeature.LAND, facecolor="lightgray")

ax.scatter(
    df2["lon"], df2["lat"],
    s=8,
    transform=ccrs.PlateCarree()
)

ax.set_title("Relative humidity observations - 1979010306")
plt.savefig("rh_observations_1979010306.png", dpi=150, bbox_inches="tight")
plt.show()

