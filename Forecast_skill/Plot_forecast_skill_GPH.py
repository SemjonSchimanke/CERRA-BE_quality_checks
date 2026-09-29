import pandas as pd
import matplotlib.pyplot as plt
from pathlib import Path

# Directory containing the four txt files
data_dir = Path("./")

# List of input files
files = [
    "Forecast_skill_std.txt",
    "Forecast_skill_std_inner.txt",
    "Forecast_skill_diff.txt",
    "Forecast_skill_diff_inner.txt",
]

fig, ax = plt.subplots(figsize=(10, 5))

for filename in files:
    # Read whitespace-separated columns
    df = pd.read_csv(
        data_dir / filename,
        sep=r"\s+",
        header=None,
        names=["variable", "date", "value"]
    )

    # Convert date column to datetime
    df["date"] = pd.to_datetime(df["date"])

    # Plot time series, using the filename as the legend label
    ax.plot(df["date"], df["value"], marker="o", label=filename)

# Labels and formatting
ax.set_xlabel("Date")
ax.set_ylabel("Geopotential [m**2/s**2]")
ax.set_title("Forcast skill at 500 hPa")
ax.legend(["STD full domain", "STD inner domain", "Diff full domain", "Diff inner domain"])
ax.grid(True, linestyle="--", alpha=0.5)
ax.vlines(pd.to_datetime("1984-09-01"), -10, 140, colors="k", linestyles="dashed")
ax.vlines(pd.to_datetime("2021-07-01"), -10, 140, colors="k", linestyles="dashed")

fig.autofmt_xdate()
plt.tight_layout()
plt.show()
