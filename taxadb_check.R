library(taxadb)
library(dplyr)

td_create("iucn")
database <- filter_rank(c("Amphibia", "Reptilia"), "class")

db_check <- sp_list %>% 
                left_join(database, by = c("Species" = "scientificName")) %>%
                mutate(Genus = genus.x,
                       SpecificEpithet = species,
                       InfraSpecificEpithet = subspecies,
                       ) %>% 
                select(species_GISD = Species,
                       vernacularName_ITIS = vernacularName,
                       order_GISD = Order, order_ITIS = order,
                       family_GISD = Family, family_ITIS = family,
                       taxonomicStatus_ITIS = taxonomicStatus)


synonym <- db_check[which(db_check$taxonomicStatus_ITIS == "synonym"),]
no_match <- db_check[which(is.na(db_check$order_ITIS) == TRUE),]

