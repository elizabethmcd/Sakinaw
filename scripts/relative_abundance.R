library(tidyverse)
library(matrixStats)

########################################
# Preliminary metawrap bins 
# Relative abundance by mapping back metagenomic reads to the dereplicated set of genomes
########################################

relative_abundance <- read_tsv("results/metawrap_bins/sakinaw_rel_abund_table.tsv")
colnames(relative_abundance) <- gsub("_metaG-vs-bins.sorted.*", "", colnames(relative_abundance))
colnames(relative_abundance) <- gsub("-vs-bins.sorted.*", "", colnames(relative_abundance))

rel_abund_stats <- relative_abundance %>% 
  filter(Genome != "unmapped") %>% 
  pivot_longer(!Genome, names_to="sample", values_to="relative_abundance") %>% 
  group_by(Genome) %>% 
  summarise(mean = mean(relative_abundance), max=max(relative_abundance), min=min(relative_abundance), median=median(relative_abundance)) %>% 
  arrange(desc(max))

colnames(final_bins_table)[1] <- c("Genome")
  
rel_abund_info_table <- left_join(rel_abund_stats, final_bins_table)

rel_abund_long <- relative_abundance %>% 
  filter(Genome != "unmapped") %>% 
  pivot_longer(!Genome, names_to="sample", values_to="relative_abundance") %>% 
  left_join(final_bins_table)

rel_abund_long %>% 
  ggplot(aes(x=Genome, y=relative_abundance)) +
  geom_bar(aes(fill=phylum), stat="identity") +
  facet_wrap(~ sample)

rel_abund_long %>% 
  extract(sample, into = c("date", "depth"), "(.*)_([^_]+)$") %>% 
  mutate(date = gsub("sak_", "", date)) %>% 
  filter(depth != "May2011") %>% 
  ggplot(aes(x=relative_abundance, y=(depth))) +
  geom_point(aes(color=Genome)) +
  facet_grid(~ date) + 
  theme(legend.position="none")

# Facet by genome and date

  