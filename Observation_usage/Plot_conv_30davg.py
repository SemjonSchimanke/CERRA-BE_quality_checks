#!/usr/bin/env python3
"""Python/Matplotlib replacement for conv_plot_30davg.sh.

Reads the CERRA 30-day-averaged statistics in DDIR and
produces PNG figures.
"""

from __future__ import annotations

import argparse
from pathlib import Path

import matplotlib
matplotlib.use("Agg")
import matplotlib.dates as mdates
import matplotlib.pyplot as plt
import pandas as pd

DOMAIN = "CERRA"
LEVELS = [0, 1500, 2500, 4000, 6500, 8500, 12500, 17500,
          22500, 27500, 35000, 45000, 60000, 80000, 92500, 200000]
START_LEVELS = (1, 6, 11)  # 1-based indices, matching the shell script
VARIABLES = {
    2: ("Temperature", "K"),
    3: ("u-wind", "m/s"),
    7: ("Specific humidity", "kg/kg"),
}
PANEL_Y = [0.82, 0.64, 0.44, 0.26, 0.08]


def month_bounds(date_text: str) -> str:
    """Return YYYYMM from a YYYYMMDD[HH] date argument."""
    if len(date_text) < 6 or not date_text[:6].isdigit():
        raise ValueError(f"Expected date in YYYYMMDD or YYYYMMDDHH format: {date_text!r}")
    return date_text[:6]


def read_stats(path: Path, start_month: str, end_month: str) -> pd.DataFrame:
    """Read columns YYYYMM, O-B stdev, O-A stdev and number of observations."""
    if not path.is_file():
        raise FileNotFoundError(f"Statistics file not found: {path}")
    # The original gnuplot uses columns 1-4. Ignore blank lines and # comments.
    df = pd.read_csv(path, sep=r"\s+", comment="#", header=None,
                     usecols=[0, 1, 2, 3], names=["ym", "ob", "oa", "nobs"],
                     engine="python")
    df["date"] = pd.to_datetime(df["ym"].astype(str).str.strip(), format="%Y%m", errors="coerce")
    df = df.dropna(subset=["date"])
    df = df[(df["ym"].astype(str) >= start_month) & (df["ym"].astype(str) <= end_month)]
    return df.sort_values("date")


def format_time_axis(ax: plt.Axes, start_month: str, end_month: str) -> None:
    start = pd.to_datetime(start_month, format="%Y%m")
    end = pd.to_datetime(end_month, format="%Y%m") + pd.offsets.MonthEnd(1)
    ax.set_xlim(start, end)
    ax.xaxis.set_major_locator(mdates.YearLocator())
    ax.xaxis.set_major_formatter(mdates.DateFormatter("%Y"))
    ax.tick_params(axis="x", labelrotation=30)
    ax.grid(True, alpha=0.6)


def plot_stats_panel(ax: plt.Axes, path: Path, start_month: str, end_month: str,
                     title: str, ylabel: str, show_departures: bool = True) -> None:
    df = read_stats(path, start_month, end_month)
    if show_departures:
        ax.plot(df["date"], df["ob"], color="blue", linewidth=2.0,
                marker="o", markersize=3, label="STDEV(O-B)")
        ax.plot(df["date"], df["oa"], color="red", linewidth=2.0,
                marker="o", markersize=3, label="STDEV(O-A)")
    else:
        ax.plot(df["date"], df["nobs"], color="black", linewidth=2.0,
                marker="o", markersize=3, label="Nr obs")
    ax.set_title(title, loc="left")
    ax.set_ylabel(ylabel)
    ax.grid(True, alpha=0.6)
    ax.legend(loc="upper left", bbox_to_anchor=(1.01, 1.0), borderaxespad=0.0)
    format_time_axis(ax, start_month, end_month)


def save_panels(panels: list[tuple[Path, str, str, bool]], output: Path,
                start_month: str, end_month: str, figsize=(15, 15)) -> None:
    """Create a vertical stack of panels; each tuple is (file, title, ylabel, departures?)."""
    fig, axes = plt.subplots(len(panels), 1, figsize=figsize, sharex=True,
                             constrained_layout=False)
    if len(panels) == 1:
        axes = [axes]
    for ax, (path, title, ylabel, departures) in zip(axes, panels):
        plot_stats_panel(ax, path, start_month, end_month, title, ylabel, departures)
        ax.set_xlabel("")
    fig.subplots_adjust(left=0.09, right=0.79, top=0.96, bottom=0.09, hspace=0.65)
    output.parent.mkdir(parents=True, exist_ok=True)
    fig.savefig(output, dpi=100, format="png")
    plt.close(fig)
    print(f"Wrote {output}")


def plot_surf(ddir: Path, start_month: str, end_month: str, outdir: Path) -> None:
    prefix = f"{DOMAIN}_"
    fig = outdir / f"{DOMAIN}_surf_z_{start_month}_{end_month}_30davg.png"
    panels = []
    for obs, label in (("landsynop", "SYNOP"), ("ship", "SHIP"), ("dribu", "DRIBU")):
        panels.append((ddir / f"{prefix}{obs}_z_30davg.dat", f"CERRA {DOMAIN} {label} z", "m", True))
        panels.append((ddir / f"{prefix}{obs}_z_30davg.dat", "", "Nobs", False))
    save_panels(panels, fig, start_month, end_month)

    fig = outdir / f"{DOMAIN}_surfana_{start_month}_{end_month}_30davg.png"
    panels = [
        (ddir / f"{prefix}landsynop_t2m_30davg.dat", f"CERRA {DOMAIN} SYNOP T2m", "K", True),
        (ddir / f"{prefix}landsynop_t2m_30davg.dat", "", "Nobs", False),
        (ddir / f"{prefix}landsynop_rh2m_30davg.dat", f"CERRA {DOMAIN} SYNOP RH2m", "%", True),
        (ddir / f"{prefix}landsynop_rh2m_30davg.dat", "", "Nobs", False),
    ]
    save_panels(panels, fig, start_month, end_month)


def level_info(index_1based: int) -> tuple[int, int, str, str]:
    p1 = LEVELS[index_1based - 1]
    p2 = LEVELS[index_1based]
    p1_label = f"{p1 // 100:03d}"
    p2_label = "sfc" if index_1based == 15 else f"{p2 // 100:03d}"
    return p1, p2, p1_label, p2_label


def plot_profile_family(family: str, ddir: Path, start_month: str,
                        end_month: str, outdir: Path) -> None:
    for varno, (var_label, unit) in VARIABLES.items():
        for first_level in START_LEVELS:
            last_level = first_level + 4
            departure_panels = []
            nobs_panels = []
            for level_index in range(first_level, last_level + 1):
                p1, p2, p1_label, p2_label = level_info(level_index)
                title = f"{var_label}. {p1_label} - {p2_label} hPa"
                datafile = ddir / f"{DOMAIN}_{family}_{varno}_{p1}_{p2}_30davg.dat"
                departure_panels.append((datafile, f"CERRA {DOMAIN} {family.upper()} {title}", unit, True))
                nobs_panels.append((datafile, f"CERRA {DOMAIN} {family.upper()} {title} Nobs", "Nobs", False))

            output1 = outdir / f"{family}_{DOMAIN}_{varno}_{start_month}_{end_month}_{first_level}_fgdep_30davg.png"
            output2 = outdir / f"{family}_{DOMAIN}_{varno}_{start_month}_{end_month}_{first_level}_nobs_30davg.png"
            save_panels(departure_panels, output1, start_month, end_month)
            save_panels(nobs_panels, output2, start_month, end_month)
            print("-------------------")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("date_start", help="Start date, e.g. 1985090100")
    parser.add_argument("date_end", help="End date, e.g. 2025123121")
    parser.add_argument("--data-dir", type=Path,
                        default=Path("/ec/res4/scratch/smos/Observations/MFB/full_time_series_30davg"),
                        help="Directory containing the .dat statistics files")
    parser.add_argument("--output-dir", type=Path, default=Path("/home/smos/Figures/Obs_usage"),
                        help="Directory for generated PNG files")
    args = parser.parse_args()
    start_month = month_bounds(args.date_start)
    end_month = month_bounds(args.date_end)
    if start_month > end_month:
        parser.error("date_start must not be later than date_end")

    args.output_dir.mkdir(parents=True, exist_ok=True)
    plot_surf(args.data_dir, start_month, end_month, args.output_dir)
    plot_profile_family("temp", args.data_dir, start_month, end_month, args.output_dir)
    plot_profile_family("tempdesc", args.data_dir, start_month, end_month, args.output_dir)
    plot_profile_family("airep", args.data_dir, start_month, end_month, args.output_dir)


if __name__ == "__main__":
    main()
