#!/bin/bash
#SBATCH --time=0-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=install_DAISIEcontinental
#SBATCH --output=/home3/p287218/DAISIEcontinental/install_DAISIEcontinental.log
#SBATCH --mem=2GB

mkdir -p logs
mkdir -p inst/pre_processed_daisie_results
mkdir -p inst/pre_processed_empirical_results
ml R
Rscript -e "install.packages(c('renv', 'devtools'))"
Rscript -e "renv::restore(prompt = FALSE)"
Rscript -e "remotes::install_github('joshwlambert/DAISIEcontinental@emp_analysis3')"
