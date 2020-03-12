library(taxadb)
library(dplyr)

td_create("iucn")
database <- filter_rank(c("Amphibia", "Reptilia"), "class")

sp_list %>% mutate(db_check = if_else(any(database$scientificName == sp_list$Species), true = TRUE, false = NULL))
