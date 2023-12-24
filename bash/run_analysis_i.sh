#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=analysis_i
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/analysis_i%a.log
#SBATCH --array=1-10
#SBATCH --mem=5GB

ml R
Rscript /home3/p287218/DAISIEcontinental/scripts/run_analysis.R $1 ${SLURM_ARRAY_TASK_ID}
