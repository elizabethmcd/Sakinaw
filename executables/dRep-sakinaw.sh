#!/bin/bash
#SBATCH --account=rrg-ziels
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=15G
#SBATCH --time=6:0:0
#SBATCH --job-name=dRep
#SBATCH --output=%x.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

#paths
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins/all_bins"
out_path="${project_path}/final_bins/dRep"
dRep_env="/home/eamcdani/virtual_envs/dRep/bin/activate"
bin_stats="${project_path}/final_bins/all_bins_stats.csv"

# load dRep virtual env
source ${dRep_env}

# load necessary modules 
module load StdEnv/2020 gcc/9.3.0 mash/2.3 mummer fastani prodigal centrifuge
PYTHONPATH=''

# dRep command 
dRep dereplicate ${out_path} -g ${bins_path}/*.fa --genomeInfo ${bin_stats}

deactivate