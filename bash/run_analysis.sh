#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=analysis
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/analysis%a.log
#SBATCH --array=1-12
#SBATCH --mem=5GB

ml R
Rscript /home3/p287218/DAISIEcontinental/scripts/run_analysis.R ${SLURM_ARRAY_TASK_ID}
