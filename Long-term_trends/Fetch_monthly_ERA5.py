import cdsapi

# --------------------------------------------------
# Configuration
# --------------------------------------------------

dataset = "reanalysis-era5-single-levels-monthly-means"

first_year = 1961
last_year = 2025

variables = [
    "2m_temperature",
    "10m_wind_speed"
]

months = [f"{m:02d}" for m in range(1, 13)]

area = [90, -60, -20, 60]  # N, W, S, E

# --------------------------------------------------
# CDS client
# --------------------------------------------------

client = cdsapi.Client()

# --------------------------------------------------
# Loop over decades
# --------------------------------------------------

for decade in range((first_year // 10) * 10,
                    last_year + 1, 10):

    start = max(first_year, decade)
    end = min(last_year, decade + 9)

    years = [str(y) for y in range(start, end + 1)]

    target = f"/ec/res4/scratch/smos/Long-term/ERA5/ERA5_monthly_{start}-{end}.grib"

    print("================================================")
    print(f"Downloading ERA5: {start}-{end}")
    print(f"Output: {target}")
    print("================================================")

    request = {
        "product_type": ["monthly_averaged_reanalysis"],
        "variable": variables,
        "year": years,
        "month": months,
        "time": ["00:00"],
        "data_format": "grib",
        "download_format": "unarchived",
        "area": area
    }

    client.retrieve(dataset, request, target)

    print(f"Finished: {target}")
