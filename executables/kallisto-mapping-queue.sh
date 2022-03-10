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
sample_name=$(sed -n "${metatranscriptome-sample-codes.txt}p" sakinaw_metagenomes.txt | awk -F "\t" '{print $3}')
metaT_file=$(sed -n "${metatranscriptome-sample-codes.txt}p" sakinaw_metagenomes.txt | awk -F "\t" '{print $2}')

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
index_file="${project_path}/metaT_mapping/all-sakinaw-orfs.ffn"
metaT_path="${project_path}/metaT_mapping/fastqs/${metaT_file}"
out_dir="${project_path}/metaT_mapping/kallisto_output/${sample_name}"

# load modules
module load kallisto

# kallisto quant command
kallisto quant -i $index_file -o $out_dir $metaT_path


