Invasive Herpetofauna
================
Gavin Masterson
29/11/2019

``` r
knitr::opts_chunk$set(echo = TRUE)
```

# Invasive Herpetofauna

How many species of alien invasive herpetofauna are there globally? What
are they? Where are they from? Where are they invasive? Keeping up to
date with global trends and situations in herpetofaunal conservation is
an ongoing challenge. Some of the most infamous invasive species are
reptiles - think of the Burmese Python (*Python bivittatus*) in Florida,
or the Brown Tree Snake (*Boiga irregularis*) in Guam - and amphibians -
think of the Cane Toad (*Rhinella marina*) in Australia or the Common
Platanna (*Xenopus laevis*) in Europe. As a herpetologist, I wanted to
develop a reproducible webscraping method that will allow me to keep up
to date on alien/invasive herpetofaunal species.

[The Global Invasive Species Database](http://www.iucngisd.org/gisd/)
(GISD) is a product of the work of the IUCN’s Species Survival
Commission. Initial development of the GISD took place between 1998 and
2000, and the database received a functionality/cosmetic upgrade in
2004. The GISD database is an ongoing project and is curated by the work
of specialists who volunteer their valuable time and expertise. More
information can be found [here](http://www.iucngisd.org/gisd/about.php)
on the GISD website.

For the work presented below, I was inspired by [this
tutorial](https://naturaldatasolutions.com/2018/11/28/scraping-and-visualizing-the-gisd-with-r/)
by Jim Sheehan on November 28, 2018. Jim’s work facilitated this - my
first webscraping project - and I relied on his post for the mechanics
of the coding. I am grateful to him for his post.

## Setting up

As always the first thing to do is to load the list of packages required
for the project. This list usually gets built over time as you go
through the project and then ends up complete by the end of the work.

``` r
library(robotstxt)    # check website scraping rules
library(tidyverse)    # simultaneously load the stringr, dplyr, ggplot2, purrr and readr packages
library(rvest)        # web scraping
library(knitr)        # HTML table creation
library(kableExtra)   # additional HTML table formatting
library(plotly)       # interactive plots
library(gganimate)    # animate ggplots
library(rworldmap)    # world chloropleth mapping
```

## Webscraping Invasive Herpetofauna from the GISD

The code below imports the saved .csv file from my Advanced Search on
the GISD.I limited my search to Reptiles and Amphibians and saved the
search return as a .csv file named “amrep\_gisd.csv”. After importing
the data I noticed that there were two issues. Several entries in the
“Order” column are currently missing from the database. The second
issue is that the importing process adds an additional column of NA
values, which needs to be removed. The last two lines of code in the
chunk below generate a table of a random sample of 10 of the species.
The table is just to give us a quick glance of what the data look like,
so the presentation order of the species is not important in this case.

``` r
sp_list <- read_delim("amrep_gisd.csv", trim_ws = TRUE, delim = ";") %>% .[,-8] # import .csv and remove X8 column of "NA" values

kable(sp_list[sample(nrow(sp_list),10),]) %>% 
  kable_styling(bootstrap_options = c("striped", "hover", "condensed"))
```

<table class="table table-striped table-hover table-condensed" style="margin-left: auto; margin-right: auto;">

<thead>

<tr>

<th style="text-align:left;">

Species

</th>

<th style="text-align:left;">

Kingdom

</th>

<th style="text-align:left;">

Phylum

</th>

<th style="text-align:left;">

Class

</th>

<th style="text-align:left;">

Order

</th>

<th style="text-align:left;">

Family

</th>

<th style="text-align:left;">

System

</th>

</tr>

</thead>

<tbody>

<tr>

<td style="text-align:left;">

Varanus indicus

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Squamata

</td>

<td style="text-align:left;">

Varanidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Norops grahami

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Squamata

</td>

<td style="text-align:left;">

Polychrotidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Iguana iguana

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Squamata

</td>

<td style="text-align:left;">

Iguanidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Anolis leachii

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Polychrotidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Chamaeleo jacksonii

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Squamata

</td>

<td style="text-align:left;">

Chamaeleonidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Anolis wattsi

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Polychrotidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Anolis equestris

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Polychrotidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Caiman crocodilus

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Crocodilia

</td>

<td style="text-align:left;">

Alligatoridae

</td>

<td style="text-align:left;">

Freshwater\_terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Natrix maura

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

Squamata

</td>

<td style="text-align:left;">

Colubridae

</td>

<td style="text-align:left;">

Freshwater\_terrestrial

</td>

</tr>

<tr>

<td style="text-align:left;">

Anolis cristatellus

</td>

<td style="text-align:left;">

Animalia

</td>

<td style="text-align:left;">

Chordata

</td>

<td style="text-align:left;">

Reptilia

</td>

<td style="text-align:left;">

NA

</td>

<td style="text-align:left;">

Polychrotidae

</td>

<td style="text-align:left;">

Terrestrial

</td>

</tr>

</tbody>

</table>

Herpetofaunal taxonomy is quirky because of the historical use of
subspecies. This means that we need to allow for the possibility of
species whose names contain a *generic name*, *specific epithet* and a
*subspecific epithet* in the “Species” column of our dataset. For
example, the Red-eared Slider is a widespread invasive that is known by
the Latin name of *Trachemys scripta elegans*, where the subspecific
epithet is “elegans”. The problem here is that whenever a species has no
*subspecific epithet*, the code below will add “+NA” to the end of the
URL rendering it useless for accessing the page of that species.

``` r
sp_list <- sp_list %>% 
              separate(Species, c("Genus", "Specific_Epithet", "Subspecific_Epithet"),
                       sep = " ", 
                       remove = FALSE) %>% 
              unite(c(Genus, Specific_Epithet, Subspecific_Epithet), 
                    col = "genspp", 
                    sep = "+",
                    remove = FALSE) %>% 
              mutate(url = paste0("http://www.iucngisd.org/gisd/speciesname/", genspp)) %>% 
              select(-genspp)

sp_list[sample(nrow(sp_list),5),]$url  # display a random sample of 5 URLs
```

    ## [1] "http://www.iucngisd.org/gisd/speciesname/Natrix+maura+NA"        
    ## [2] "http://www.iucngisd.org/gisd/speciesname/Elaphe+guttata+NA"      
    ## [3] "http://www.iucngisd.org/gisd/speciesname/Boiga+irregularis+NA"   
    ## [4] "http://www.iucngisd.org/gisd/speciesname/Hemidactylus+mabouia+NA"
    ## [5] "http://www.iucngisd.org/gisd/speciesname/Podarcis+sicula+NA"

To fix the URLs we need to snip the ends of the URLS that end in exactly
“+NA”. The code below has the additional step for removing “+NA” from
the URLs of species that do not have a subspecific name. (Note: if you
are using R in a language other than English, you should refer to
documentation for the ’locale’argument of the `coll()` function in
`stringr`.)

``` r
sp_list$url <- str_replace(sp_list$url, pattern = coll(pattern = "+NA"), replacement = "")

sp_list[c(1, 15, 17, 19, 40),]$url  # display five selected URLs
```

    ## [1] "http://www.iucngisd.org/gisd/speciesname/Anolis+aeneus"            
    ## [2] "http://www.iucngisd.org/gisd/speciesname/Boa+constrictor+imperator"
    ## [3] "http://www.iucngisd.org/gisd/speciesname/Caiman+crocodilus"        
    ## [4] "http://www.iucngisd.org/gisd/speciesname/Ctenosaura+similis"       
    ## [5] "http://www.iucngisd.org/gisd/speciesname/Trachemys+scripta+elegans"

The URLs are now correctly specified and we can now scrape each of the
species reports. As mentioned above, I am interested in keeping
up-to-date with the total number of invasive herpetofauna, where they’re
invasive and where they’re from. The total number can already be deduced
from the length of the `sp_list` object. Now we need to scrape the lists
of countries where each species is native and where they have
established. Below I use the same approach that Jim Sheehan used in the
post I linked above. It involves looping across each URL in `sp_list`
and selecting the correct HTML nodes to populate the two, pre-specified
lists that are created to receive the scraped information. I have
modified the object names, have not used `tryCatch` and I have directly
assigned each scrape into the relevant list.

``` r
urls <- pull(sp_list, url)
sp_names <- pull(sp_list, Species)
a_range <- vector(mode = "list", length = length(urls))
n_range <- vector(mode = "list", length = length(urls))

names(a_range) <- sp_names 
names(n_range) <- sp_names

# Scrape each URL with a 5-second delay in between each iteration

for(i in 1:length(urls)){
    a_range[[i]] <-  read_html(urls[i]) %>% 
                html_nodes(xpath = '//*[@id="l-1st-step"]') %>% 
                html_nodes("li") %>% 
                html_text()
    
    n_range[[i]] <-  read_html(urls[i]) %>% 
                html_nodes(xpath = '//*[@id="nr-col"]') %>% 
                html_nodes("li") %>% 
                html_text()
    
    Sys.sleep(5)
}
rm(i)
```

The next step is to build the tibbles containing either the native range
or alien range data in tidy format. Due to the differences in the number
of native range and the alien range countries for each species, merging
the two tibbles while the countries are specified individually creates
readability issues that I would rather sidestep here.

### Countries where the species is indigenous

``` r
n_range_df <- data.frame(Species = rep(names(n_range), 
                                       sapply(n_range, length)),
                         Native_range = unlist(n_range), 
                         row.names = NULL, 
                         stringsAsFactors = FALSE)

n_range_tbl <- inner_join(sp_list, n_range_df, 
                          by = "Species") %>%
               as_tibble()
```

### Countries where the species has established an alien or invasive population

``` r
a_range_df <- data.frame(Species = rep(names(a_range), 
                                       sapply(a_range, length)),
                         Alien_range = unlist(a_range), 
                         row.names = NULL, 
                         stringsAsFactors = FALSE)

a_range_df$Alien_range <- str_replace(a_range_df$Alien_range, 
                                      pattern = "\\[[:digit:]+\\]\\s?", 
                                      "")

a_range_tbl <-  inner_join(sp_list,
                           a_range_df,
                           by = "Species") %>% 
                as_tibble()
```

# Analysis

## Welcome to the world of the \#HerpMafia

Closely-related species are known to share biological, behavioural and
ecological characteristics. This is important in invasion science
because when one species establishes an invasive population it is a good
rule-of-thumb to treat closely-related species with extreme caution. So
let’s start with a look at: 1. which herpetofaunal families have already
demonstrated invasive potential and how often? 2. how many species in
each family have established populations outside their natural range? 3.
how many total unique invasions each family is responsible for? 4. which
countries are the currently the most impacted by the \#HerpMafia?

### 1\. Who comprises the \#HerpMafia?

The \#HerpMafia currently consists of 43 species, from 18 families.
There are six families of anuran amphibians (i.e. frogs), but no
salamanders (yet?). The most infamous invasive amphibian species to date
are the African Clawed Frog *Xenopus laevis* and the Cane Toad *Rhinella
marina*. There are 12 reptile families, representing crocodiles, lizards
and snakes. The most infamous invasive species of reptile are the
Red-eared Slider *Trachemys scripta elegans* (Worldwide), the Burmese
Python *Python bivittatus* (Everglades, Florida, USA) and the Brown Tree
Snake *Boiga irregularis* (Guam). Thankfully, there are no records of
any of the cobra (e.g. Elapidae) or viper (e.g. Viperidae, Crotalidae)
families in the GISD. Snakebite is [**already enough of a
burden**](https://www.who.int/snakebites/resources/s40409-017-0127-6/en/)
in countries with indigenous populations of these snakes. Having to
identify bites from, and source venom for an alien invasive venomous
snake would be a medical and logistical nightmare with potentially
serious outcomes for envenomated individuals.

### 2\. How many species represent for each \#HerpMafia family?

Eleven of the \#HerpMafia families are represented by exactly one
species, which makes me wonder if they can be called ‘families’ in the
\#HerpMafia context… but don’t discount them because as we’ll see next -
all it takes is one\!

Of the seven families for which more than one species has established an
alien range population, five are reptiles and two are amphibians. The
family with the most representatives is the Polychrotidae, with 14
*Anolis* species and two *Norops* species. Technically speaking these
species have been assigned to the Dactyloidae family by a recent
taxonomic revision - possibly so they can try to dodge the invasion
police\!. (Refer to the Appendix for further discussion on ‘Taxonomic
Issues’.)

``` r
sp_fam <- a_range_tbl %>%
          mutate(Family = as_factor(Family)) %>% 
          group_by(Family) %>% 
          tally(n_distinct(Species), name = "Total_species")

#NEED TO LOOK AT WHETHER THIS IS WORTH INCLUDING - IT MEANS THAT THINGS CAN BREAK IF YOU RERUN THIS SECTION OF CODE AND NOT THE WHOLE CHUNK

(sp_fam <- inner_join(x = filter(unique(sp_list[,c(7,9)])), y = sp_fam, by = "Family") %>% 
          mutate(Family = as_factor(str_replace(Family, 
                                      pattern = coll("Polychrotidae"), 
                                      replacement = "Dactyloidae"))) %>% 
          arrange(desc(Total_species)))
```

    ## # A tibble: 18 x 3
    ##    Class    Family          Total_species
    ##    <chr>    <fct>                   <int>
    ##  1 Reptilia Dactyloidae                16
    ##  2 Amphibia Hylidae                     4
    ##  3 Reptilia Colubridae                  3
    ##  4 Amphibia Leptodactylidae             3
    ##  5 Reptilia Iguanidae                   2
    ##  6 Reptilia Gekkonidae                  2
    ##  7 Reptilia Varanidae                   2
    ##  8 Reptilia Boidae                      1
    ##  9 Reptilia Alligatoridae               1
    ## 10 Reptilia Chamaeleonidae              1
    ## 11 Amphibia Microhylidae                1
    ## 12 Amphibia Ranidae                     1
    ## 13 Reptilia Lacertidae                  1
    ## 14 Reptilia Pythonidae                  1
    ## 15 Reptilia Typhlopidae                 1
    ## 16 Amphibia Bufonidae                   1
    ## 17 Reptilia Emydidae                    1
    ## 18 Amphibia Pipidae                     1

### 3\. How many unique invasions can be linked to each \#HerpMafia family?

The code below counts the number of rows for each family and then
generates an interactive ggplot of the result. (Try mousing over the
bars\!) I call the measure “total unique invasions” because each unique
species + country pair counts towards the total, even if the same
country is invaded by multiple species from the same \#HerpMafia family.

``` r
inv_family <- a_range_tbl %>%
              mutate (Family = str_replace(Family, 
                                           pattern = coll("Polychrotidae"), 
                                           replacement = "Dactyloidae")) %>% 
              group_by (Family) %>% 
              count(name = "Total_invasions")

inv_family <- inner_join(x = sp_fam, y = inv_family, by = "Family") %>% 
              mutate(Class = as_factor(Class),
                     Family = as_factor(Family)) %>% 
              arrange(desc(Total_invasions))
              
invfam_plot <-  ggplot(inv_family) + 
                geom_col(mapping = aes(x = reorder(Family, -Total_invasions), 
                                       y = Total_invasions,
                                       fill = Class,
                                       text = paste('Family:', Family,
                                                    '<br> Total Unique Invasions:', Total_invasions))) +
                scale_fill_manual(values =c("darkgoldenrod1","chartreuse3")) +
                ylab("Total number of Unique Invasions") +
                xlab("Family") +
                ggtitle("Total Unique Invasions by each #HerpMafia Family") +
                theme(legend.position = "right", 
                      legend.title = element_blank(),
                      axis.text.x = element_text(angle = 90, hjust = 1, vjust = -0.3))

ggplotly(invfam_plot, tooltip = "text")
```

    ## PhantomJS not found. You can install it with webshot::install_phantomjs(). If it is installed, please make sure the phantomjs executable can be found via the PATH variable.

<!--html_preserve-->

<div id="htmlwidget-0b9963d33beee3bb997c" class="plotly html-widget" style="width:672px;height:480px;">

</div>

<script type="application/json" data-for="htmlwidget-0b9963d33beee3bb997c">{"x":{"data":[{"orientation":"v","width":[0.9,0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0,0,0,0,0,0,0,0,0,0,0,0],"x":[1,2,3,5,8,10,11,13,14,15,17,18],"y":[83,66,54,46,24,15,14,5,4,3,2,1],"text":["Family: Gekkonidae <br> Total Unique Invasions: 83","Family: Emydidae <br> Total Unique Invasions: 66","Family: Typhlopidae <br> Total Unique Invasions: 54","Family: Dactyloidae <br> Total Unique Invasions: 46","Family: Colubridae <br> Total Unique Invasions: 24","Family: Varanidae <br> Total Unique Invasions: 15","Family: Iguanidae <br> Total Unique Invasions: 14","Family: Boidae <br> Total Unique Invasions: 5","Family: Alligatoridae <br> Total Unique Invasions: 4","Family: Lacertidae <br> Total Unique Invasions: 3","Family: Pythonidae <br> Total Unique Invasions: 2","Family: Chamaeleonidae <br> Total Unique Invasions: 1"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(255,185,15,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"Reptilia","legendgroup":"Reptilia","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null},{"orientation":"v","width":[0.9,0.9,0.9,0.899999999999999,0.899999999999999,0.899999999999999],"base":[0,0,0,0,0,0],"x":[4,6,7,9,12,16],"y":[47,38,25,17,12,2],"text":["Family: Bufonidae <br> Total Unique Invasions: 47","Family: Ranidae <br> Total Unique Invasions: 38","Family: Hylidae <br> Total Unique Invasions: 25","Family: Leptodactylidae <br> Total Unique Invasions: 17","Family: Pipidae <br> Total Unique Invasions: 12","Family: Microhylidae <br> Total Unique Invasions: 2"],"type":"bar","marker":{"autocolorscale":false,"color":"rgba(102,205,0,1)","line":{"width":1.88976377952756,"color":"transparent"}},"name":"Amphibia","legendgroup":"Amphibia","showlegend":true,"xaxis":"x","yaxis":"y","hoverinfo":"text","frame":null}],"layout":{"margin":{"t":43.7625570776256,"r":7.30593607305936,"b":116.164383561644,"l":37.2602739726027},"plot_bgcolor":"rgba(235,235,235,1)","paper_bgcolor":"rgba(255,255,255,1)","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187},"title":{"text":"Total Unique Invasions by each #HerpMafia Family","font":{"color":"rgba(0,0,0,1)","family":"","size":17.5342465753425},"x":0,"xref":"paper"},"xaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[0.4,18.6],"tickmode":"array","ticktext":["Gekkonidae","Emydidae","Typhlopidae","Bufonidae","Dactyloidae","Ranidae","Hylidae","Colubridae","Leptodactylidae","Varanidae","Iguanidae","Pipidae","Boidae","Alligatoridae","Lacertidae","Microhylidae","Pythonidae","Chamaeleonidae"],"tickvals":[1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18],"categoryorder":"array","categoryarray":["Gekkonidae","Emydidae","Typhlopidae","Bufonidae","Dactyloidae","Ranidae","Hylidae","Colubridae","Leptodactylidae","Varanidae","Iguanidae","Pipidae","Boidae","Alligatoridae","Lacertidae","Microhylidae","Pythonidae","Chamaeleonidae"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-90,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"y","title":{"text":"Family","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"yaxis":{"domain":[0,1],"automargin":true,"type":"linear","autorange":false,"range":[-4.15,87.15],"tickmode":"array","ticktext":["0","20","40","60","80"],"tickvals":[0,20,40,60,80],"categoryorder":"array","categoryarray":["0","20","40","60","80"],"nticks":null,"ticks":"outside","tickcolor":"rgba(51,51,51,1)","ticklen":3.65296803652968,"tickwidth":0.66417600664176,"showticklabels":true,"tickfont":{"color":"rgba(77,77,77,1)","family":"","size":11.689497716895},"tickangle":-0,"showline":false,"linecolor":null,"linewidth":0,"showgrid":true,"gridcolor":"rgba(255,255,255,1)","gridwidth":0.66417600664176,"zeroline":false,"anchor":"x","title":{"text":"Total number of Unique Invasions","font":{"color":"rgba(0,0,0,1)","family":"","size":14.6118721461187}},"hoverformat":".2f"},"shapes":[{"type":"rect","fillcolor":null,"line":{"color":null,"width":0,"linetype":[]},"yref":"paper","xref":"paper","x0":0,"x1":1,"y0":0,"y1":1}],"showlegend":true,"legend":{"bgcolor":"rgba(255,255,255,1)","bordercolor":"transparent","borderwidth":1.88976377952756,"font":{"color":"rgba(0,0,0,1)","family":"","size":11.689497716895},"y":1},"hovermode":"closest","barmode":"relative"},"config":{"doubleClick":"reset","showSendToCloud":false},"source":"A","attrs":{"395871ee4e03":{"x":{},"y":{},"fill":{},"text":{},"type":"bar"}},"cur_data":"395871ee4e03","visdat":{"395871ee4e03":["function (y) ","x"]},"highlight":{"on":"plotly_click","persistent":false,"dynamic":false,"selectize":false,"opacityDim":0.2,"selected":{"opacity":1},"debounce":0},"shinyEvents":["plotly_hover","plotly_click","plotly_selected","plotly_relayout","plotly_brushed","plotly_brushing","plotly_clickannotation","plotly_doubleclick","plotly_deselect","plotly_afterplot","plotly_sunburstclick"],"base_url":"https://plot.ly"},"evals":[],"jsHooks":[]}</script>

<!--/html_preserve-->

The graph above is simple enough to interpret but for a clearer
understanding of herpetofaunal invasions we need to add the information
about each family’s species tally. Let’s do that now.

``` r
(XYplot <- ggplot(inv_family) +
          geom_point(mapping = aes(x = Total_species,
                                   y = Total_invasions,
                                   colour = Class)) +
          labs(title = "Scatterplot of Species vs Unique Invasions",
               x = "Invasive Species per Family",
               y = "Total Unique Invasions"))
```

![](Invasive_reptiles_webscrape_files/figure-gfm/two%20plus%20three-1.png)<!-- -->

Despite being outnumbered and outrepresented, the amphibian families
punch above their weight in terms of total unique invasions.

## Number of alien range countries for each species

# Appendix

## Bonus Code Snippets

I made an animated version of the Total Unique Invasions bar chart to
post to my Twitter account on 25 Feb 2020. This is the code for
generating the animated version with the Family names removed from the
X-axis. The biggest difference is that you need to add a variable that
specifies the states of the chart during animation. In this case I added
a variable called “Frame” with two states - 0 invasions or all
invasions. I had to create a dataframe with zero invasions for all
families and then join them together for the plot.

``` r
a <- data.frame(Family = c(inv_family$Family), Total_invasions = rep(0,18), frame = rep('a',18))
b <- data.frame(Family = c(inv_family$Family), Total_invasions = c(inv_family$Total_invasions), frame = rep('b',18))
invfa_anim_df <- rbind(a,b); rm(a,b)

invfam_anim <- ggplot(invfa_anim_df, aes(x = reorder(Family,-Total_invasions), 
                                         y = Total_invasions, 
                                         fill = reorder(Family,-Total_invasions))) +
                geom_bar(stat = 'identity') + 
                labs(x ="Family",
                     y = "Total number of Unique Invasions",
                     title = "Total Unique Invasions for each #HerpMafia Family") +
                #scale_x_discrete(labels= c(rep("?",18))) +
                theme(legend.position = "none",
                      axis.text.x = element_text(angle = 90, hjust = 1)) +
                transition_states(
                    frame,
                    transition_length = 2,
                    state_length = 1,
                    wrap = TRUE
                )

print(invfam_anim) 
```

![](Invasive_reptiles_webscrape_files/figure-gfm/animated%20plot-1.gif)<!-- -->

``` r
#anim_save("unique_invasions_by_family_ordered.gif", animation = invfam_anim)
```

``` r
poll_fig <- ggplot(inv_family) + 
                geom_col(mapping = aes(x = Family, 
                                       y = Total_invasions,
                                       fill = Family,
                                       text = paste('Family:', Family,
                                                    '<br> Total Unique Invasions:', Total_invasions))) +
                ylab("Total number of Unique Invasions") +
                xlab("Family") +
                ggtitle("Total Unique Invasions by each #HerpMafia Family") +
                theme(legend.position = "none", 
                      legend.title = element_blank(),
                      axis.text.x = element_text(angle = 90, hjust = 1, vjust = 0.4))
```

    ## Warning: Ignoring unknown aesthetics: text

``` r
#ggsave(filename = "poll_fig.png", plot = poll_fig, width = 15, height = 10, dpi = 200, units = "cm", device='png')
```
