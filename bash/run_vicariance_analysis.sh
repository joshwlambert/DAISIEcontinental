#!/bin/bash
#SBATCH --time=0-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=vicariance_analysis
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/%x-%j-array-%a.log
#SBATCH --array=1-800
#SBATCH --mem=5GB

module purge
ml R
Rscript /home3/p287218/DAISIEcontinental/scripts/run_vicariance_analysis.R ${SLURM_ARRAY_TASK_ID}
