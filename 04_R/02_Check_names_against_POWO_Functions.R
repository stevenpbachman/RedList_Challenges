###
### Function to query binomials against POWO to see taxonomic status according to POWO
### note - doesn't check authors
### doesn't handle varieties? Eugenia cordata var. cordata http://www.plantsoftheworldonline.org/taxon/urn:lsid:ipni.org:names:77168281-1
### 


# install packages
#install.packages('jsonlite', dependencies=TRUE, repos='http://cran.rstudio.com/')
#install.packages("tidyverse")

library(jsonlite)
library(tidyverse)
library(plyr)

check.accepted.POWO = function(binomial) {
  
  #binomial = "Solanum polygamum"
  
  # use ID full name to search API  
  full_url =  paste("http://plantsoftheworldonline.org/api/1/search?q=names:", binomial, sep = "")
  
  # get raw json data
  raw.data <- readLines(full_url, warn = "F", encoding = "UTF-8")
  
  # organise
  rd <- fromJSON(raw.data)
  
  if (length(rd$results) == 0) {
    # add new column to results and call it warning
    
    accepted = "NA"          
    author = ""  
    kingdom = ""  
    name = ""  
    rank  = "" 
    #synonymOf = ""
    base_url = ""    
    IPNI_ID = ""
    search_name = binomial  
    results = data.frame(accepted,author, kingdom, name, rank, base_url, IPNI_ID,search_name)
    
  } else {
    
    # make data frame
    results = as.data.frame(rd$results)
    
    # add original search term
    results$search_name = binomial
    
    # returns null because there is more than one result - come back to this later and print out extra rows
    if (nrow(results) >1) {
      
      accepted = "FALSE"          
      author = ""  
      kingdom = ""  
      name = ""  
      rank  = "" 
      #synonymOf = ""
      base_url = ""    
      IPNI_ID = ""
      search_name = binomial  
      results = data.frame(accepted,author, kingdom, name, rank, base_url, IPNI_ID,search_name)
      
    } else {
      
      # PROBLEM HERE - var with no author - replace with blank field?
      if (!"author" %in% colnames(results)) {
        results$author = NA
      }
      
      # only include these fields - you don't want synonym of
      results = subset(results, select=c(accepted, author, kingdom,name,rank, url, search_name))
      
      # split url to get url and IPNI_ID
      results = results %>% separate(url, into = c("base_url", "IPNI_ID"), sep = "names:")
      
      # take out any results where it matched on something that wasn't species 
      #results = subset(results, rank == "Species") 
      
      # check if 
      if (nrow(results) < 1) {
        # add new column to results and call it warning
        
        accepted = "NA"          
        author = ""  
        kingdom = ""  
        name = ""  
        rank  = "" 
        #synonymOf = ""
        base_url = ""    
        IPNI_ID = ""
        search_name = binomial  
        results = data.frame(accepted,author, kingdom, name, rank, base_url, IPNI_ID,search_name)
        
      }
      # make data frame
      results = as.data.frame(results)
    }
    
    return(results)
    
  }
}
