#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --time 5:0:0
#SBATCH --cpus-per-task=5
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=kallisto-index 
#SBATCH --output=kallisto-index.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# paths
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
metaT_mapping="${project_path}/metaT_mapping"

# load modules
module load kallisto

# kallisto index

kallisto index -i ${metaT_mapping}/sakinaw-orfs ${metaT_mapping}/all-sakinaw-orfs.ffn