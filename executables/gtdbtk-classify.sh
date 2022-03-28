#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --array=1-16
#SBATCH --time 12:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=gtdbtk-classify
#SBATCH --output=gtdbtk-classify.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL


#paths
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins/fastas"
out_path="${project_path}/final_bins/GTDB"
gtdbtk_path="/home/eamcdani/virtual_envs/gtdbtk/bin/activate"

# modules and gtdbtk env load
source ${gtdbtk_path}
module load StdEnv/2020 gcc/9.3.0 prodigal hmmer pplacer fastani fasttree mash/2.3

# export gtdbtk data path
PYTHONPATH=''
export GTDBTK_DATA_PATH=/home/eamcdani/projects/rrg-ziels/shared_tools/release202

# gtdbtk command

gtdbtk classify_wf --cpus 16 --extension fa --genome_dir ${bins_path}/ --out_dir ${out_path}