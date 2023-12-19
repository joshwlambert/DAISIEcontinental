#!/bin/bash
#SBATCH --time=1-23:00:00
#SBATCH --partition=gelifes
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --job-name=install_ContinentalTesting
#SBATCH --output=/home3/p287218/ContinentalTesting/install_ContinentalTesting.log
#SBATCH --mem=5GB

mkdir -p logs
mkdir -p results
ml R
Rscript -e "remotes::install_github('joshwlambert/ContinentalTesting')"
