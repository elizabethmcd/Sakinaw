#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --array=1-19
#SBATCH --time 12:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=kallisto-mapping-queue
#SBATCH --output=kallisto-mapping-queue.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# array jobs 
sample_name=$(sed -n "${SLURM_ARRAY_TASK_ID}p" metatranscriptome_samples_codes.txt | awk -F "\t" '{print $3}')
metaT_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" metatranscriptome_samples_codes.txt | awk -F "\t" '{print $2}')

metaT_name=$(basename $metaT_file .fastq)

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
index_file="${project_path}/metaT_mapping/sakinaw-orfs"
metaT_path="${project_path}/metaT_mapping/deinterleaved"
out_dir="${project_path}/metaT_mapping/kallisto_output/${sample_name}"

# load modules
module load kallisto

# kallisto quant command
kallisto quant -i $index_file -o $out_dir ${metaT_path}/${metaT_name}_1.fastq ${metaT_path}/${metaT_name}_2.fastq


