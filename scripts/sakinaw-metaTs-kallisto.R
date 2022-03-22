library(tximport)
library(tidyverse)
library(ggpubr)

########################
# Parsing kallisto output files to raw and normalized tables 
########################

dir <- "results/metawrap_bins_metaT_mapping/kallisto_output"
samples <- read.table("results/metawrap_bins_metaT_mapping/metatranscriptome-samples-codes.txt", header=TRUE)
files <- file.path(dir, samples$sample_name, "abundance.h5")
names(files) <- samples$sample_name
txi.kallisto <- tximport(files, type="kallisto", txOut = TRUE)
counts <- as.data.frame(txi.kallisto)
finalcounts <- rownames_to_column(counts, var="ID")
write.csv(finalcounts, 'results/2013_transcriptomes/2013R1R2-ebpr-bins-kallisto-count-table.csv', row.names = FALSE, quote=FALSE)

# tables of raw and normalized counts from txi dataframe
# raw
rawcounts <- as.data.frame(txi.kallisto$counts)
rawTable <- rownames_to_column(rawcounts, var="ID")
rawTable.split <- rawTable %>% separate(ID, c("Genome"), sep='~') %>% cbind(rawTable$ID)
rawTable.formatted <- rawTable.split[, c(1,21, c(2:20))]
colnames(rawTable.formatted)[2] <- c("locus_tag")
write_tsv(rawTable.formatted, "results/metawrap_bins_metaT_mapping/sakinaw_metaT_mapping_rawCounts.tsv")

# normalized
normcounts <- as.data.frame(txi.kallisto$abundance)
normTable <- rownames_to_column(normcounts, var='ID')
norm.split <- normTable %>% separate(ID, c("Genome"), sep='~') %>% cbind(normTable$ID)
norm.formatted <- norm.split[, c(1,21, c(2:20))]
colnames(norm.formatted)[2] <- c("locus_tag")
write_tsv(norm.formatted, "results/metawrap_bins_metaT_mapping/sakinaw_metaT_mapping_normTPMcounts.tsv")

########################
# Preliminary stats 
########################

# total counts for each bin : sample pair
rawTable.formatted %>% 
  select(-locus_tag) %>% 
  pivot_longer(!Genome, names_to="sample", values_to="count") %>% 
  group_by(Genome, sample) %>% 
  summarise(total = sum(count)) %>% 
  arrange(desc(total))

# total counts for each bin for all samples 
total_raw_counts <- rawTable.formatted %>% 
  select(-locus_tag) %>% 
  pivot_longer(!Genome, names_to="sample", values_to="count") %>% 
  group_by(Genome) %>% 
  summarise(total = sum(count)) %>% 
  left_join(final_bins_table) %>% 
  select(Genome, classification, phylum, completeness, contamination, total) %>% 
  arrange(desc(total))

# plot comparing completeness and contamination of a bin with total metaT reads mapped across all samples
total_raw_counts %>% 
  ggplot(aes(x=completeness, y=contamination)) + 
  geom_point(aes(size=total, color=phylum)) + 
  theme_pubr()

top_totalCounts <- rawTable.formatted %>% 
  select(-locus_tag) %>% 
  pivot_longer(!Genome, names_to="sample", values_to="count") %>% 
  group_by(Genome, sample) %>% 
  summarise(total = sum(count)) %>% 
  left_join(final_bins_table) %>% 
  select(Genome, classification, sample, total) %>% 
  filter(total > 500000) %>% 
  arrange(desc(total))

# selecting genomes where at least one sample has more than 100000 raw counts to then compare profiles 
highGenomes <- rawTable.formatted %>% 
  select(-locus_tag) %>% 
  pivot_longer(!Genome, names_to="sample", values_to="count") %>% 
  group_by(Genome, sample) %>% 
  summarise(total = sum(count)) %>% 
  arrange(desc(total)) %>% 
  filter(total > 100000) %>% 
  pull(Genome) %>% 
  unique()

highGenomes_classification <- final_bins_table %>% 
  filter(Genome %in% highGenomes) %>% 
  select(Genome, classification, phylum)

highGenomes_classification$Genome <- as.factor(highGenomes_classification$Genome)
  

highGenomes_long <- rawTable.formatted %>% 
  filter(Genome %in% highGenomes) %>% 
  select(-locus_tag) %>% 
  pivot_longer(!Genome, names_to="sample", values_to="count") %>% 
  group_by(Genome, sample) %>% 
  summarise(total = sum(count))

sample_order <- c('sak_2011_1_27_36m',
                  'sak_2011_5_24_36m',
                  'sak_2013_6_6_36m',
                  'sak_2011_1_27_40m',
                  'sak_2011_5_24_40m',
                  'sak_2013_6_6_40m',
                  'sak_2010_1_5_45m',
                  'sak_2010_1_5_50m',
                  'sak_2011_1_27_50m',
                  'sak_2011_5_24_50m',
                  'sak_2013_6_6_50m',
                  'sak_2010_1_5_55m',
                  'sak_2013_6_6_60m',
                  'sak_2010_1_5_80m',
                  'sak_2011_1_27_80m',
                  'sak_2011_5_24_80m',
                  'sak_2010_1_5_120m',
                  'sak_2011_5_24_120m',
                  'sak_2013_6_6_120m')

highGenomes_long$sample <- factor(highGenomes_long$sample, levels = sample_order)
highGenomes_long$Genome <- factor(highGenomes_long$Genome, levels = highGenomes_classification$Genome)

highGenomes_rawCounts_plot <- highGenomes_long %>% 
  ggplot(aes(x=Genome, y=fct_rev(sample), fill=total)) +
  geom_tile(color="white") + 
  scale_x_discrete(expand=c(0,0), labels=highGenomes_classification$phylum) +
  scale_y_discrete(expand=c(0,0)) +
  scale_fill_viridis(alpha=1, begin=0, end=1, direction=-1) + 
  theme(axis.text.x=element_text(angle=85, hjust=1)) +
  ylab("Sample") +
  xlab("Genome") + 
  geom_hline(yintercept=16.5, linetype="dashed") + 
  geom_hline(yintercept=12.5, linetype="dashed") + 
  geom_hline(yintercept=6.5, linetype="dashed") + 
  geom_hline(yintercept=3.5, linetype="dashed")

ggsave("figs/metaT_highGenomes_rawCounts_plot.png", highGenomes_rawCounts_plot, width=20, height=15, units=c("cm"))
