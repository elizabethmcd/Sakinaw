#!/bin/bash
#SBATCH --account=def-shallam
#SBATCH --array=1-16
#SBATCH --time 12:0:0
#SBATCH --cpus-per-task=8
#SBATCH --mem-per-cpu=10G
#SBATCH --job-name=bowtie2-mapping-to-bins
#SBATCH --output=bowtie2-mapping-to-bins.out
#SBATCH --mail-user=eamcdani@mail.ubc.ca
#SBATCH --mail-type=ALL

# array jobs 
mapping_file=$(sed -n "${SLURM_ARRAY_TASK_ID}p" sakinaw_metagenomes.txt)

# paths 
project_path="/home/eamcdani/projects/def-shallam/eamcdani/sakinaw"
ref_path="${project_path}/final_bins/bt2/all_sakinaw_bins.fasta"
reads_path="${project_path}/metaG_mapping/qced_reads"
out_path="${project_path}/metaG_mapping/mappingResults"
sample_name=$(basename $mapping_file _pe_1.fastq)
r1_file="${reads_path}/${sample_name}_pe_1.fastq"
r2_file="${reads_path}/${sample_name}_pe_2.fastq"
out_name="${out_path}/${sample_name}-vs-bins"

# load modules
module load bowtie2 samtools

# bowtie2 mapping command 
bowtie2 -x $ref_path -1 $r1_file -2 $r2_file -q --very-sensitive -p 8 -S ${out_name}.sam

# samtools SAM to BAM 
samtools view -@ 12 -S -b ${out_name}.sam > ${out_name}.bam

# samtools sort and index
samtools sort -@ 12 ${out_name}.bam -o ${out_name}.sorted.bam
samtools index ${out_name}.sorted.bam