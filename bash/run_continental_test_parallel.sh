#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=continental_test
#SBATCH --output=/data/p287218/DAISIEprepExtra/logs/continental_test%a.log
#SBATCH --array=1-216
#SBATCH --mem=5GB

ml R
Rscript /data/p287218/DAISIEprepExtra/scripts/performance_parallel.R ${SLURM_ARRAY_TASK_ID}
