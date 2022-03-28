library(tidyverse)

########################################
# Preliminary metawrap bins 
# Coverage and breadth stats for each bin in each sample to determine if have enough coverage for downstream diversity analyses 
########################################

coverage_info_path <- "results/metawrap_bins/inStrain/covg/"
files <- dir(coverage_info_path, pattern="*.csv")
all_coverage <- data_frame(filename = files) %>% 
  mutate(file_contents = map(filename, ~ read.csv(file.path(coverage_info_path, .)))
         ) %>% 
  unnest()

coverage_filtered_table <- all_coverage %>% 
  mutate(sample = gsub("-vs-bins.csv", "", filename)) %>% 
  mutate(sample = gsub("_metaG", "", sample)) %>% 
  mutate(Genome = genome) %>% 
  filter(coverage > 10 & breadth > 0.9) %>% 
  select(Genome, sample, coverage, breadth) %>% 
  left_join(final_bins_table)

covg_counts <- coverage_filtered_table %>% 
  group_by(Genome, classification) %>% 
  summarise(n = n()) %>% 
  arrange(desc(n))

covg_counts
