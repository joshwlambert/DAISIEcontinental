#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=install_DAISIEcontinental
#SBATCH --output=/home3/p287218/DAISIEcontinental/install_DAISIEcontinental.log
#SBATCH --mem=5GB

mkdir -p logs
mkdir -p results
ml R
Rscript -e "install.packages(c('renv', 'devtools'))"
Rscript -e "renv::restore(prompt = FALSE)"
Rscript -e "remotes::install_github('joshwlambert/DAISIEcontinental@new_parallel')"
