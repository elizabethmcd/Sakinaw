#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --time=24:0:0
#SBATCH --job-name=kofam-annotate-all.sh
#SBATCH --output=kofam-annotate-all.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# run all genome proteins concatenated together with kofamkoala - runs faster than protein FASTAs split individually for each genome
# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins/"
kofam_path="/home/eamcdani/bin/kofam_scan-1.3.0"

# load modules 
module load ruby/2.7.1 hmmer 

# cd to directory
cd ${bins_path}

${kofam_path}/exec_annotation ${bins_path}/all_sakinaw_prots.faa -o ${bins_path}/all-sakinaw-kofam-annotations.txt -p ${kofam_path}/profiles/ -k ${kofam_path}/ko_list --cpu 16

# after annotate, modify the output
# grep -w '*' all-sakinaw-kofam-annotations.txt | awk -F " " '{print $2"\t"$3}' | sed 's/_/-/g' | sed 's/~/_/g' > all-sakinaw-kofam-modified.txt
# pass to KEGG-decoder for pathway analysis
# source ~/virtualenvs/KEGG-decoder/bin/activate
# KEGG-decoder -i all-sakinaw-kofam-modified.txt -o sakinaw-results