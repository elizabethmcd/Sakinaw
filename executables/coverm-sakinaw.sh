#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=15G
#SBATCH --time=12:0:0
#SBATCH --job-name=coverm-sakinaw.sh
#SBATCH --output=coverm-sakinaw.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

#paths
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins/all_bins"
coverm_path="/home/eamcdani/.cargo/bin/coverm"

# load modules for coverm 
module load rust samtools

# coverm command
# faster calculations if mapping has already been performed to bins and BAM files converted to SAM and sorted, but coverm does perform these steps if not done beforehand