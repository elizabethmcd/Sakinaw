#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10G
#SBATCH --time=22:0:0
#SBATCH --job-name=bowtie2-build-index-bins
#SBATCH --output=bowtie2-build-index-bins.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins"

# load module
module load bowtie2

# index
bowtie2-build ${bins_path}/all_sakinaw_bins.fasta ${bins_path}/bt2/all_sakinaw_bins.fasta