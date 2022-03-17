#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --array=1-16
#SBATCH --time 12:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=inStrain_quick_profile
#SBATCH --output=inStrain_quick_profile.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# array jobs 
mapping_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sakinaw_sorted_bams.txt)

# sample name
sample_name=$(basename $mapping_file .sorted.bam)

# paths 
inStrain_env="/home/eamcdani/virtual_envs/inStrain/bin/activate"
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bam_path="${project_path}/metaG_mapping/mappingResults"
out_path="${project_path}/inStrain/quick_profiles"
out_name="${out_path}/${sample_name}"
fasta="${project_path}/final_bins/all_sakinaw_bins.fasta"
stb="${project_path}/final_bins/sakinaw-stb.tsv"

# load modules and programs
source ${inStrain_env}
export PATH="/home/eamcdani/.cargo/bin/:$PATH"
module load samtools

# cd to mapping directory 
cd ${bam_path}

# quick profile command
inStrain quick_profile -p 2 -s $stb -o $out_name $mapping_file $fasta