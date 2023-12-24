#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=empirical_analysis
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/empirical_analysis%a.log
#SBATCH --array=1-45
#SBATCH --mem=5GB

ml R
Rscript /home3/p287218/DAISIEcontinental/scripts/run_empirical_analysis.R ${SLURM_ARRAY_TASK_ID}
