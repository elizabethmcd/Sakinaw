library(tidyverse)
library(viridis)

########################
# Sakinaw bins pathway analysis
########################

# pathway presence/absence results
sakinaw_pathways <- read.table("results/metawrap_bins/pathway_results/sakinaw-kofamkoala-decoded.txt", sep="\t", header=TRUE) %>% 
  pivot_longer(!Function, names_to="pathway", values_to="percent_complete")

colnames(sakinaw_pathways)[1] <- c("Genome")
sakinaw_pathways$Genome <- gsub("-", "_", sakinaw_pathways$Genome)

# join with final bins info from metawrap-bins-stats.R 
sakinaw_pathway_table <- left_join(sakinaw_pathways, final_bins_table) %>% 
  select(Genome, classification, completeness, contamination, pathway, percent_complete) %>% 
  separate(classification, into = c("database", "kingdom", "phylum", "class", "order", "family", "genus", "species"), sep="__") %>% 
  select(-database) %>% 
  mutate(kingdom = gsub(";p","", kingdom)) %>% 
  mutate(phylum = gsub(";c", "", phylum)) %>% 
  mutate(class = gsub(";o", "", class)) %>% 
  mutate(order = gsub(";f", "", order)) %>% 
  mutate(family = gsub(";g", "", family)) %>% 
  mutate(genus = gsub(";s", "", genus))

sakinaw_pathway_table_filtered <- sakinaw_pathway_table %>% 
  filter(completeness > 85 & contamination < 10)

community_pathways_distribution <- sakinaw_pathway_table_filtered %>% 
  select(pathway, percent_complete) %>% 
  group_by(pathway) %>% 
  summarise(mean = mean(percent_complete)) %>% 
  arrange(desc(mean)) %>% 
  filter(mean > 0)

pathways_of_interest <- sakinaw_pathway_table_filtered %>% 
  select(pathway, percent_complete) %>% 
  group_by(pathway) %>% 
  summarise(mean = mean(percent_complete)) %>% 
  arrange(desc(mean)) %>% 
  filter(mean > .1) %>% 
  pull(pathway)

enriched_pathways <- sakinaw_pathway_table_filtered %>% 
  filter(pathway %in% pathways_of_interest) %>% 
  select(phylum, pathway, percent_complete) %>% 
  group_by(phylum, pathway) %>% 
  summarise(mean = mean(percent_complete))

enriched_pathways %>% 
  ggplot(aes(x=pathway, y=fct_rev(phylum), fill=mean)) + 
  geom_tile(color="white") +
  scale_fill_viridis(option="magma", alpha=1, begin=0, end=1, direction=-1) + 
  theme(axis.text.x=element_text(angle=85, hjust=1))
