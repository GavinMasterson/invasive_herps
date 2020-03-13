``` {r scrape alternative}
urls <- pull(sp_list, url)[1:4]
sp_names <- pull(sp_list, Species)[1:4]
alien_range <- vector(mode = "list", length = length(urls))
native_range <- vector(mode = "list", length = length(urls))

names(alien_range) <- sp_names 
names(native_range) <- sp_names

alien_range_scrape <- function(urls){
                          urls %>% 
                                read_html() %>% 
                                html_nodes(xpath = '//*[@id="l-1st-step"]') %>% 
                                html_nodes("li") %>% 
                                html_text()
                           
                          Sys.sleep(5)
                          }

native_range_scrape <- function(urls){
                          urls %>% 
                                read_html() %>% 
                                html_nodes(xpath = '//*[@id="nr-col"]') %>%
                                html_nodes("li") %>% 
                                html_text()
                          
                          Sys.sleep(5)
                          }

alien_range <- map(urls, alien_range_scrape)
native_range <- map(urls, native_range_scrape)

```
# Both of these single calls work but not the map() call where it applies across all the URLS
urls[42] %>% 
  read_html() %>% 
  html_nodes(xpath = '//*[@id="nr-col"]') %>%
  html_nodes("li") %>% 
  html_text()

urls[42] %>% 
  read_html() %>% 
  html_nodes(xpath = '//*[@id="l-1st-step"]') %>% 
  html_nodes("li") %>% 
  html_text()
