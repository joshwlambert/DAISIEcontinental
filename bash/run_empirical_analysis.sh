#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=empirical_analysis
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/%x-%j-array-%a.log
#SBATCH --array=1-20
#SBATCH --mem=5GB

module purge
ml R
Rscript /home3/p287218/DAISIEcontinental/scripts/run_empirical_analysis.R $1 ${SLURM_ARRAY_TASK_ID}
