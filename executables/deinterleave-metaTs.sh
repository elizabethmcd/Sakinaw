#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --array=1-19
#SBATCH --time 12:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=2G
#SBATCH --job-name=deinterleave-metaTs
#SBATCH --output=deinterleave-metaTs.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# array job
metaT_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" metatranscriptome_samples_codes.txt | awk -F "\t" '{print $2}')
metaT_name=$(basename $metaT_file .fastq)

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
metaT_path="${project_path}/metaT_mapping/fastqs/${metaT_file}"
out_path="${project_path}/metaT_mapping/deinterleaved"

# load module
module load bbmap 

# reformat from interleaved to deinterleaved
reformat.sh in=$metaT_path out1=${out_path}/${metaT_name}_1.fastq out2=${out_path}/${metaT_name}_2.fastq