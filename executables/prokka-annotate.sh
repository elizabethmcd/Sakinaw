#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=5G
#SBATCH --time=6:0:0
#SBATCH --job-name=prokka-annotate.sh
#SBATCH --output=prokka-annotate.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
bins_path="${project_path}/final_bins/fastas"
out_path="${project_path}/final_bins/annotations"

# load modules 
module load StdEnv/2020 gcc/9.3.0 prokka/1.14.5 

# prokka command
cd ${bins_path}

for fasta in *.fa; do
    N=$(basename $fasta .fa);
    prokka --outdir ${out_path}/$N --prefix $N --cpus 8 $fasta --centre X --compliant;
done
