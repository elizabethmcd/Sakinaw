library(tidyverse)

########################################
# Bin Info for all MetaWrap Bins
# Dereplicated by binner (metabat vs maxbin) within each sample, not dereplicated across all samples for different depths and timepoints 
########################################

stats_path <- "results/metawrap_bins/bin_stats/"
stats_files <- dir(stats_path, pattern="*.txt")
all_stats <- data_frame(filename = stats_files) %>%
  mutate(file_contents = map(filename, ~ read_tsv(file.path(stats_path, .)))
  ) %>%
  unnest()

gtdb_archaea <- read_tsv("results/metawrap_bins/GTDB/gtdbtk.ar122.summary.tsv")
gtdb_bacteria <- read_tsv('results/metawrap_bins/GTDB/gtdbtk.bac120.summary.tsv')

gtdb_table <- rbind(gtdb_archaea, gtdb_bacteria) %>% 
  mutate(binName = user_genome) %>% 
  select(binName, classification)

stats_table <- all_stats %>% 
  mutate(sample = gsub("stats.txt", "", filename)) %>% 
  mutate(binName = paste0(sample, bin)) %>% 
  select(binName, completeness, contamination, GC, lineage, size)

bins_table <- left_join(gtdb_table, stats_table) %>% 
  mutate(phylum = gsub(";c__.*", "", classification))

bins_table %>% 
  group_by(phylum) %>% 
  count() %>% 
  arrange(desc(n))

bins_table %>% 
  ggplot(aes(x=completeness, y=contamination)) + 
  geom_point(aes(color=phylum))

genome_stats <- bins_table %>% 
  select(binName, completeness, contamination) %>% 
  mutate(genome = paste0(binName, ".fa")) %>% 
  select(genome, completeness, contamination)

write.csv(genome_stats, "results/metawrap_bins/bin_stats/all_bins_stats.csv", row.names = FALSE, quote = FALSE)
