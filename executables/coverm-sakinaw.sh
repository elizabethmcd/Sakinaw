#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=15G
#SBATCH --time=12:0:0
#SBATCH --job-name=coverm-sakinaw.sh
#SBATCH --output=coverm-sakinaw.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --time 5:0:0
#SBATCH --cpus-per-task=4
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=coverm-relative-abundance
#SBATCH --output=coverm-relative-abundance.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# paths
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
mapping_path="${project_path}/metaG_mapping/mappingResults"
out_path="${project_path}/metaG_mapping"

# load modules
module load minimap2 samtools

# coverm command

/home/eamcdani/.cargo/bin/coverm genome -s "~" -m relative_abundance --bam-files ${mapping_path}/*.sorted.bam --min-read-aligned-percent 0.75 --min-read-percent-identity 0.95 --min-covered-fraction 0 -x fasta -t 1 &> ${out_path}/sakinaw_relative_abundance.txt