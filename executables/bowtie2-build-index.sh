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
	mkdir $dir/bt2
	bowtie2-build $dir/$dir.final.contigs.fasta $dir/bt2/$dir.fasta 

done