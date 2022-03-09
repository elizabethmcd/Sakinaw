library(tidyverse)

########################################
# Bin Info
########################################

# Sample 1 SAK_2010_01_05

sample1_checkm <- read_delim("results/bin_info/sak_2010_1_5_120m_checkM_qa_modified.tsv", delim="\t", col_names = FALSE)

colnames(sample1_checkm) <- c("binID", "lineage", "completeness", "contamination", "heterogeneity")

sample1_gtdb_ar <- read_delim("results/bin_info/sak_2010_1_5_120m_MAG.ar122.summary.tsv", delim="\t") %>% select("user_genome", "classification")

sample1_gtdb_bac <- read_delim("results/bin_info/sak_2010_1_5_120m_MAG.bac120.summary.tsv", delim="\t") %>% select("user_genome", "classification")

sample1_gtdb_all <- rbind(sample1_gtdb_ar, sample1_gtdb_bac)

colnames(sample1_gtdb_all) <- c("binID", "GTDB_classification")

sak2010_01_05_bins_info <- left_join(sample1_checkm, sample1_gtdb_all) %>% 
  select(binID, GTDB_classification, completeness, contamination, heterogeneity)

sak2010_01_05_bins_info$sample <- c("sak-2010-01-05")

# Sample 2 SAK 2011_05_24

sample2_checkm <- read_delim("results/bin_info/sak_2011_5_24_120m_checkM_qa_modified.tsv", delim="\t", col_names = FALSE)

colnames(sample2_checkm) <- c("binID", "lineage", "completeness", "contamination", "heterogeneity")

sample2_gtdb_ar <- read_delim("results/bin_info/sak_2011_5_24_120m_MAG.ar122.summary.tsv", delim="\t")

sample2_gtdb_bac <- read_delim("results/bin_info/sak_2011_5_24_120m_MAG.bac120.summary.tsv", delim="\t")

sample2_gtdb_all <- rbind(sample2_gtdb_ar, sample2_gtdb_bac) %>% select(user_genome, classification)
colnames(sample2_gtdb_all) <- c("binID", "GTDB_classification")

sak2011_05_24_bins_info <- left_join(sample2_checkm, sample2_gtdb_all) %>% 
  select(binID, GTDB_classification, completeness, contamination, heterogeneity)

sak2011_05_24_bins_info$sample <- c("sak-2011-05-24")

# Sample 3 SAK 2013-06-06

sample3_checkm <- read_delim("results/bin_info/sak_2013_06_06_120m_checkM_qa_modified.tsv", delim="\t", col_names = FALSE)
colnames(sample3_checkm) <- c("binID", "lineage", "completeness", "contamination", "heterogeneity")

sample3_gtdb_ar <- read_tsv("results/bin_info/sak_2013_06_06_120m_MAG.ar122.summary.tsv")

sample3_gtdb_bac <- read_tsv("results/bin_info/sak_2013_06_06_120m_MAG.bac120.summary.tsv")

sample3_gtdb_all <- rbind(sample3_gtdb_ar, sample3_gtdb_bac) %>% select(user_genome, classification)
colnames(sample3_gtdb_all) <- c("binID", "GTDB_classification")

sak2013_06_06_bins_info <- left_join(sample3_checkm, sample3_gtdb_all) %>% select(-lineage)

sak2013_06_06_bins_info$sample <- c("sak-2013-06-06")

sakinaw_bins_info <- rbind(sak2010_01_05_bins_info, sak2011_05_24_bins_info, sak2013_06_06_bins_info)
write.csv(sakinaw_bins_info, "results/sakinaw_bins_info.csv", quote=FALSE, row.names = FALSE)


########################################
# Mapping Info
########################################

# Sample 1 Sakinaw 2010-01-05 
sakinaw2010_mapping <- read.csv("Binned_assemblies/sak_2010_1_5_120m/sak_2010_1_5_120m_binned.rpkm.csv") %>% 
  select(Sequence_name, Reads_mapped, RPKM)

sakinaw2010_scaffolds <- read_delim("results/mapping/sak_2010_01_05_bins_to_scaffolds.tsv", delim="\t", col_names = FALSE)
colnames(sakinaw2010_scaffolds) <- c("binID", "Sequence_name")

sakinaw2010_Bins_scaffolds_RPKM <- left_join(sakinaw2010_scaffolds, sakinaw2010_mapping)

sakinaw2010_reads_mapped_bin <- aggregate(Reads_mapped ~ binID, sakinaw2010_Bins_scaffolds_RPKM, sum)

sakinaw2010_reads_mapped_bin$reads_proportion <- (sakinaw2010_reads_mapped_bin$Reads_mapped / 49937409) * 100

sakinaw2010_bins_reads_mapped_info <- left_join(sak2010_01_05_bins_info, sakinaw2010_reads_mapped_bin)

# Sample 2 Sakinaw 2011
sakinaw2011_mapping <- read.csv("Binned_assemblies/sak_2011_5_24_120m/sak_2011_5_24_120m_binned.rpkm.csv") %>% 
  select(Sequence_name, Reads_mapped, RPKM)

sakinaw2011_scaffolds <- read_delim("results/mapping/sak_2011_05_24_bins_to_scaffolds.tsv", delim="\t", col_names = FALSE)
colnames(sakinaw2011_scaffolds) <- c("binID", "Sequence_name")

sakinaw2011_Bins_scaffolds_RPKM <- left_join(sakinaw2011_scaffolds, sakinaw2011_mapping)

sakinaw2011_reads_mapped_bin <- aggregate(Reads_mapped ~ binID, sakinaw2011_Bins_scaffolds_RPKM, sum)

sakinaw2011_reads_mapped_bin$reads_proportion <- (sakinaw2011_reads_mapped_bin$Reads_mapped / 51839676) * 100

sakinaw2011_bins_reads_mapped_info <- left_join(sak2011_05_24_bins_info, sakinaw2011_reads_mapped_bin)

# Sample 3 Sakinaw 2013 
sakinaw2013_mapping <- read.csv("Binned_assemblies/sak_2013_06_06_120m/sak_2013_06_06_120m_binned.rpkm.csv") %>% 
  select(Sequence_name, Reads_mapped, RPKM)

sakinaw2013_scaffolds <- read_delim("results/mapping/sak_2013_06_06_bins_to_scaffolds.tsv", delim="\t", col_names = FALSE)
colnames(sakinaw2013_scaffolds) <- c("binID", "Sequence_name")

sakinaw2013_Bins_scaffolds_RPKM <- left_join(sakinaw2013_scaffolds, sakinaw2013_mapping)

sakinaw2013_reads_mapped_bin <- aggregate(Reads_mapped ~ binID, sakinaw2013_Bins_scaffolds_RPKM, sum)

sakinaw2013_reads_mapped_bin$reads_proportion <- (sakinaw2013_reads_mapped_bin$Reads_mapped / 54441296) * 100

sakinaw2013_bins_reads_mapped_info <- left_join(sak2013_06_06_bins_info, sakinaw2013_reads_mapped_bin)

sakinaw_bins_mapping_info <- rbind(sakinaw2010_bins_reads_mapped_info, sakinaw2011_bins_reads_mapped_info, sakinaw2013_bins_reads_mapped_info)

write.csv(sakinaw_bins_mapping_info, "results/sakinaw_bins_info_total_reads_mapped.csv", quote=FALSE, row.names = FALSE)

########################################
# Figure Analysis w/ Quality Information & Total Reads Mapped to Bin
########################################
sakinaw_bins_all_info <- read.csv("results/sakinaw_bins_info_total_reads_mapped_groups.csv")

bin_plot <- sakinaw_bins_all_info %>% ggplot(aes(x=completeness, y=contamination)) + geom_point(aes(size=reads_proportion, color=Phylum)) + theme_bw()

ggsave("figs/sakinaw_bins_qual_reads_plot.png", bin_plot, width=30, height=20, units=c("cm"))
