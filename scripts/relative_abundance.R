library(tidyverse)
library(reshape2)
library(viridis)
library(ggpubr)
library(patchwork)

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
  
rel_abund_info_table <- left_join(rel_abund_stats, final_bins_table) %>% 
  mutate(mean_abundance = mean, max_abundance = max, min_abundance = min, median_abundance = median) %>% 
  mutate(size = size / 1000000) %>% 
  select(Genome, classification, completeness, contamination, GC, size, mean_abundance, max_abundance, min_abundance, median_abundance)

write.csv(rel_abund_info_table, "results/final_metawrap_bins_relative_abundance_info_table.csv", quote=FALSE, row.names = FALSE)

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

# Extract by separate dates
sak_2010 <- rel_abund_long %>% 
  extract(sample, into = c("date", "depth"), "(.*)_([^_]+)$") %>% 
  mutate(date = gsub("sak_", "", date)) %>%
  mutate(depth= gsub("m", "", depth)) %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2010_1_5')
sak_2010$depth <- factor(sak_2010$depth, levels=c(45, 50, 55, 80, 120))

sak_2010 %>% 
  ggplot(aes(x=relative_abundance, y=fct_rev(depth), color=phylum, group=Genome)) +
  geom_line(aes(color=phylum)) +
  geom_point(aes(color=phylum)) +
  theme(legend.position="none")
  
sak_2011 <- rel_abund_long %>% 
  extract(sample, into = c("date", "depth"), "(.*)_([^_]+)$") %>% 
  mutate(date = gsub("sak_", "", date)) %>%
  mutate(depth= gsub("m", "", depth)) %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2011_5_24')
sak_2011$depth <- factor(sak_2011$depth, levels=c(36, 40, 50, 80, 120))

sak_2011 %>% 
  ggplot(aes(x=relative_abundance, y=fct_rev(depth), color=phylum, group=Genome)) +
  geom_line(aes(color=phylum)) +
  geom_point(aes(color=phylum)) +
  theme(legend.position="none")

sak_2013 <- rel_abund_long %>% 
  extract(sample, into = c("date", "depth"), "(.*)_([^_]+)$") %>% 
  mutate(date = gsub("sak_", "", date)) %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2013_06_06')

# Extract lineages with total abundance greater than at least 0.5% across all samples and dates 

top_lineages <- relative_abundance %>% 
  filter(Genome != "unmapped") %>% 
  pivot_longer(!Genome, names_to="sample", values_to="relative_abundance") %>% 
  group_by(Genome) %>% 
  summarise(mean = mean(relative_abundance), max=max(relative_abundance), min=min(relative_abundance), median=median(relative_abundance), total=sum(relative_abundance)) %>% 
  arrange(desc(max)) %>% 
  filter(max > 1) %>% 
  pull(Genome)

filtered_genomes_table <- rel_abund_long %>% 
  filter(Genome %in% top_lineages) %>% 
  extract(sample, into = c("date", "depth"), "(.*)_([^_]+)$") %>% 
  mutate(date = gsub("sak_", "", date)) %>% 
  mutate(class = gsub(";o__.*", "", classification))

final_bins_classf_top <- final_bins_table %>% 
  filter(Genome %in% top_lineages) %>% 
  select(Genome, classification) %>% 
  mutate(class = gsub(";o__.*", "", classification)) %>% 
  arrange(classification)
final_bins_classf_top$Genome <- as.factor(final_bins_classf_top$Genome)

# 2010 sampling point
sak_2010_filtered <- filtered_genomes_table %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2010_1_5')
sak_2010_filtered$depth <- factor(sak_2010_filtered$depth, levels=c("45m", "50m", "55m", "80m", "120m"))
sak_2010_filtered$Genome <- as.factor(sak_2010_filtered$Genome)
sak_2010_filtered$Genome <- factor(sak_2010_filtered$Genome, levels=final_bins_classf_top$Genome)

sak_2010_plot <- sak_2010_filtered %>% 
  ggplot(aes(x=Genome, y=fct_rev(depth), fill=relative_abundance)) + 
  geom_tile(color="white") + 
  scale_x_discrete(labels=final_bins_classf_top$class, expand=c(0,0)) +
  scale_y_discrete(expand=c(0,0)) +
  scale_fill_viridis(option="magma", alpha=1, begin=0, end=1, direction=-1) + 
  theme(axis.text.x=element_blank(), axis.title.x=element_blank(), axis.ticks.x = element_blank()) +
  ylab("Depth") +
  ggtitle("2010-01-05")
sak_2010_plot


# 2011 sampling date
sak_2011_filtered <- filtered_genomes_table %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2011_5_24')
sak_2011_filtered$depth <- factor(sak_2011_filtered$depth, levels=c("36m", "40m", "50m", "80m", "120m"))
sak_2011_filtered$Genome <- as.factor(sak_2011_filtered$Genome)
sak_2011_filtered$Genome <- factor(sak_2011_filtered$Genome, levels=final_bins_classf_top$Genome)
  
sak_2011_plot <- sak_2011_filtered %>% 
  ggplot(aes(x=Genome, y=fct_rev(depth), fill=relative_abundance)) + 
  geom_tile(color="white") + 
  scale_x_discrete(labels=final_bins_classf_top$class, expand=c(0,0)) +
  scale_y_discrete(expand=c(0,0)) +
  scale_fill_viridis(option="magma", alpha=1, begin=0, end=1, direction=-1) + 
  theme(axis.text.x=element_blank(), axis.title.x=element_blank(), axis.ticks.x = element_blank()) +
  ylab("Depth") +
  xlab("Genome") +
  ggtitle("2011-05-24")

# 2013 sampling date
sak_2013_filtered <- filtered_genomes_table %>% 
  filter(depth != "May2011") %>% 
  filter(date == '2013_06_06')
sak_2013_filtered$depth <- factor(sak_2013_filtered$depth, levels=c("36m", "40m", "50m", "60m", "120m"))
sak_2013_filtered$Genome <- as.factor(sak_2013_filtered$Genome)
sak_2013_filtered$Genome <- factor(sak_2013_filtered$Genome, levels=final_bins_classf_top$Genome)

sak_2013_plot <- sak_2013_filtered %>% 
  ggplot(aes(x=Genome, y=fct_rev(depth), fill=relative_abundance)) + 
  geom_tile(color="white") + 
  scale_x_discrete(labels=final_bins_classf_top$class, expand=c(0,0)) +
  scale_y_discrete(expand=c(0,0)) +
  scale_fill_viridis(option="magma", alpha=1, begin=0, end=1, direction=-1) + 
  theme(axis.text.x=element_text(angle=85, hjust=1)) +
  ylab("Depth") +
  xlab("Genome") +
  ggtitle("2013-06-06")

sakinaw_grid_1 <- ggarrange(sak_2010_plot, sak_2011_plot, ncol=1)
complete_grid <- ggarrange(sakinaw_grid_1, sak_2013_plot, ncol=1, heights=c(1.7,3))

ggsave("figs/sakinaw-relAbund-top-grid.png", complete_grid, width=25, height=20, units=c("cm"))


