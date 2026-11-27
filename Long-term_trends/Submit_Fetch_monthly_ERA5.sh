#!/bin/bash -e
#SBATCH --job-name=ERA_mon
#SBATCH --qos=nf
#SBATCH --time=1-0

# Change to submission directory
cd "$SLURM_SUBMIT_DIR"

echo "Starting ERA5 download: $(date)"
echo "Running on host: $(hostname)"

python3 Fetch_monthly_ERA5.py

echo "All data fetched: $(date)"



