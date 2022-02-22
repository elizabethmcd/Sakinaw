#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=16
#SBATCH --mem-per-cpu=10G
#SBATCH --time=22:0:0
#SBATCH --job-name=bowtie2-build-index
#SBATCH --output=bowtie2-build-index.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# modules
module load bowtie2 

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
mapping_dir="${project_path}/mappingResults"

for dir in ${mapping_dir}/*_FD; do
	sample=`basename $dir`
	bowtie2-build ${mapping_dir}/${sample}/$sample.final.contigs.fasta ${mapping_dir}/${sample}/bt2/$sample.fasta 

done