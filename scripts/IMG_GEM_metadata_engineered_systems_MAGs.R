library(tidyverse)
library(networkD3)
library(ggridges)
library(viridis)

metagenome_info <- read.csv("raw_IMG_data/GEM_metagenome_info.csv")
mag_info <- read.csv("raw_IMG_data/GEM_MAGs_Quality_Info.csv")

colnames(metagenome_info)[1] <- c("img_taxon_id")

metagenome_cond <- metagenome_info %>% select(IMG_TAXON_ID, ECOSYSTEM, ECOSYSTEM_CATEGORY, ECOSYSTEM_TYPE, ECOSYSTEM_SUBTYPE, HABITAT)
colnames(metagenome_cond)[1] <- c("img_taxon_id")

mag_env_data <- left_join(mag_info, metagenome_cond) %>% 
  select(genome_id, img_taxon_id, completeness, contamination, num_5s, num_16s, num_23s, num_trnas, quality_tier, species_id, ECOSYSTEM, ECOSYSTEM_CATEGORY, ECOSYSTEM_TYPE, ECOSYSTEM_SUBTYPE, HABITAT)

mag_table <- left_join(mag_info, metagenome_info)
write.csv(mag_table, "IMG_results/all_mag_info.csv", quote = FALSE, row.names = FALSE)

species_info <- read.csv("raw_IMG_data/GEM_taxonomy.csv") %>% 
  select(otu_id, gtdb_taxonomy)

colnames(species_info)[1] <- c("species_id")

mag_metadata <- left_join(mag_table, species_info) %>% select(genome_id, gtdb_taxonomy, completeness, contamination, num_contigs, genome_length, num_5s, num_16s, num_23s, num_trnas, STUDY_NAME, BIOSAMPLE_NAME, ECOSYSTEM, ECOSYSTEM_CATEGORY, ECOSYSTEM_TYPE, ECOSYSTEM_SUBTYPE, SPECIFIC_ECOSYSTEM, HABITAT, img_taxon_id)

write.csv(mag_metadata, "IMG_results/IMG_MAG_INFO.csv", quote = FALSE, row.names = FALSE)

mag_metadata %>% 
  group_by(img_taxon_id) %>% 
  count() %>% 
  arrange(desc(n))

mag_metadata %>% 
  count(HABITAT, img_taxon_id) %>% 
  arrange(desc(n)) %>% 
  group_by(img_taxon_id)

metagenome_info %>% 
  group_by(ECOSYSTEM_CATEGORY) %>% 
  count()

engineered_MAGs <- mag_env_data %>% 
  filter(ECOSYSTEM == 'Engineered')

engineered_type <- engineered_MAGs %>% 
  group_by(ECOSYSTEM_CATEGORY) %>% 
  count()

habitat_type <- engineered_MAGs %>% 
  group_by(HABITAT) %>% 
  count()

engineered_MAGs_filtered <- engineered_MAGs %>% 
  filter(HABITAT != 'anaerobic benzene degrading fresh water medium' & HABITAT != 'Anode biofilm' & HABITAT != 'Bioremediated contaminated groundwater' & HABITAT != 'Cellulose-adapted' & HABITAT != 'city subway' & HABITAT != 'City subway' & HABITAT != 'city subway metal' & HABITAT != 'city subway metal/plastic' & HABITAT != 'City subway metal/plastic' & HABITAT != 'city subway plastic' & HABITAT != 'city subway water' & HABITAT != 'city subway wood' & HABITAT != 'city subway wood/metal' & HABITAT != 'Compost' & HABITAT != 'Cyanobacterial' & HABITAT != 'Decomposing wood' & HABITAT != 'defined medium' & HABITAT != 'Enriched contaminated groundwater' & HABITAT !='enriched sediment' & HABITAT != 'Enviromental' & HABITAT !='Feedstock adapted compost' & HABITAT != 'Fermentation pit mud' & HABITAT != 'Groundwater' & HABITAT != 'Hydrocarbon resource environments' & HABITAT !='Ionic liquid and high solid enriched' & HABITAT != 'landfill leachate' & HABITAT != 'Mixed alcohol bioreactor' & HABITAT != 'Nitrate-dependent Fe(III)-oxidizing enrichment culture' & HABITAT != 'sediment' & HABITAT != 'Poplar biomass bioreactor' & HABITAT != 'Xylose enrichment biomass' & HABITAT!= 'Synthetic' & HABITAT!= 'Synthetic lake water' & HABITAT!= 'Switchgrass degrading' & HABITAT != 'Switchgrass adapted compost' & HABITAT != 'solar cell surface' & HABITAT != 'Soil from Bioreactor' & HABITAT != 'Aerobic enrichment media' & HABITAT != 'Halorespirating mixed culture' & HABITAT  != 'Rice-straw enriched compost' & HABITAT != 'PCE-dechlorinating' & HABITAT != 'Sediment' & HABITAT != 'Laboratory microcosms' & HABITAT != 'Laboratory enrichment broth' & ECOSYSTEM_CATEGORY != 'Solid waste')

filtered_habitat_type <- engineered_MAGs_filtered %>% 
  group_by(HABITAT) %>% 
  count()

filtered_ecosystem_type <- engineered_MAGs_filtered %>% 
  group_by(ECOSYSTEM_TYPE) %>% 
  count()

filtered_ecosystem_category <- engineered_MAGs_filtered %>% 
  group_by(ECOSYSTEM_CATEGORY) %>% 
  count()

filtered_metadata <- engineered_MAGs_filtered %>% 
  filter(ECOSYSTEM_TYPE != 'Aerobic' & ECOSYSTEM_TYPE != 'Microbial enhanced oil recovery' & ECOSYSTEM_TYPE != 'Continuous culture' & ECOSYSTEM_TYPE != 'Terephthalate' & ECOSYSTEM_CATEGORY != 'Lab enrichment')

filtered_metadata$ECOSYSTEM_TYPE <- gsub("Anaerobic", "Anaerobic digestor", filtered_metadata$ECOSYSTEM_TYPE)

filtered_metadata$ECOSYSTEM_TYPE <- gsub("Anaerobic digestor digestor", "Anaerobic digestor", filtered_metadata$ECOSYSTEM_TYPE)

filtered_metadata$ECOSYSTEM_TYPE <- gsub("Nutrient removal", "Activated Sludge", filtered_metadata$ECOSYSTEM_TYPE)

filtered_metadata %>% group_by(ECOSYSTEM_TYPE) %>% count()

filtered_metadata %>% ggplot(aes(x=completeness, y=ECOSYSTEM_CATEGORY, fill= stat(x))) + geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) + scale_fill_viridis(name = "Completeness", option = "C") + theme_ridges()

eng_qual <- filtered_metadata %>% ggplot(aes(x=completeness, y=fct_rev(ECOSYSTEM_TYPE), fill=stat(x))) + geom_density_ridges_gradient(scale = 3, rel_min_height = 0.01) + scale_fill_viridis(name = "Completeness", option = "A") + theme_ridges()

ggsave(filename="IMG_results/eng_qual_plot.png", plot=eng_qual, width=15, height=10, units=c("in"))


high <- filtered_metadata %>% filter(completeness > 9 & contamination < 5 & quality_tier != 'HQ')

hq <- filterer_metadata %>% filter(quality_tier == 'HQ')

mq <- filtered_metadata %>% filter(completeness < 90)

tiers <- data.frame("Category" = c("HQ", "High", "MQ"), "Genomes" = c(594, 2886, 2073))

bp <- ggplot(tiers, aes(x="", y=Genomes, fill=Category)) + geom_bar(width=1, stat="identity")
pie <- bp + coord_polar("y", start=0)
blank_theme <- theme_minimal()+
  theme(
    axis.title.x = element_blank(),
    axis.title.y = element_blank(),
    panel.border = element_blank(),
    panel.grid=element_blank(),
    axis.ticks = element_blank(),
    plot.title=element_text(size=14, face="bold")
  )

final_pie <- pie + scale_fill_grey() + blank_theme +  theme(axis.text.x=element_blank())
final_pie

ggsave(filename="IMG_results/MAG_quality_eng_systems.png", plot=final_pie, width=10, height=10, units=c("in"))

