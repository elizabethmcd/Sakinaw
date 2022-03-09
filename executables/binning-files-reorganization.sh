#!/bin/bash 

while read "dir"; do
	sample=$(basename "$dir");
	cd ${sample}/BIN_REFINEMENT/metawrap_70_10_bins;
	for file in *.fa; do name=${sample}_$file; cp $file /home/eamcdani/projects/def-shallam/eamcdani/sakinaw/metawrap_binning/all_metawrap_bins/$name; done;
done < sakinaw_metagenome_samples.txt


while read "dir"; do
	sample=$(basename "$dir");
	cd ${sample}/BIN_REFINEMENT;
	cp metawrap_70_10_bins.stats /home/eamcdani/projects/def-shallam/eamcdani/sakinaw/metawrap_binning/all_bin_stats/${sample}_bins_stats.txt;
done < sakinaw_metagenome_samples.txt
	

