#!/usr/bin/env python3

from pathlib import Path
from collections import defaultdict
import math

YMBEG = 196101
YMEND = 202512

INDIR = Path("/scratch/smos/Observations/MFB/full_time_series")
OUTDIR = Path("/scratch/smos/Observations/MFB/full_time_series_30davg_python")

OUTDIR.mkdir(parents=True, exist_ok=True)


def month_range(ymbeg, ymend):
    """Generate YYYYMM values, inclusive."""
    year = ymbeg // 100
    month = ymbeg % 100

    while year * 100 + month <= ymend:
        yield year * 100 + month

        month += 1
        if month > 12:
            month = 1
            year += 1


months = list(month_range(YMBEG, YMEND))

for infile in sorted(INDIR.glob("*.dat")):

    print(infile.name)

    # Monthly accumulators:
    # count, sum(column 2), sum(column 3), sum(column 4)
    stats = defaultdict(lambda: [0, 0.0, 0.0, 0.0])

    with infile.open("r") as f:
        for line in f:

            fields = line.split()

            if len(fields) < 4:
                continue

            ym = fields[0][:6]

            if not ym.isdigit():
                continue

            ym = int(ym)

            if ym < YMBEG or ym > YMEND:
                continue

            if fields[1] == "NaN":
                continue

            try:
                v2 = float(fields[1])
                v3 = float(fields[2])
                v4 = float(fields[3])
            except ValueError:
                continue

            s = stats[ym]

            s[0] += 1
            s[1] += v2
            s[2] += v3
            s[3] += v4

    outfile = OUTDIR / f"{infile.stem}_30davg.dat"

    with outfile.open("w") as f:
        for ym in months:

            count, s1, s2, s3 = stats[ym]

            if count > 0:
                f.write(
                    f"{ym} {s1 / count:.5f} "
                    f"{s2 / count:.5f} {int(s3)}\n"
                )
            else:
                f.write(f"{ym} NaN NaN NaN\n")
