#!/bin/bash
#SBATCH --time=0-01:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=analysis
#SBATCH --output=/home3/p287218/DAISIEcontinental/logs/analysis%a.log
#SBATCH --array=1-12
#SBATCH --mem=1GB

sbatch /home3/p287218/DAISIEcontinental/bash/run_analysis_i.sh ${SLURM_ARRAY_TASK_ID}
