This document describes methods used in the paper **'Progress,
challenges and opportunities for plant Red Listing'**. Each numbered
section relates to numbered sections in the manuscript. See section
[04\_docs](https://github.com/stevenpbachman/RedList_Challenges/tree/master/02_docs)
for the manuscript.

### 1. Introduction

*Total number of taxa on the Red List:*

    #install.packages("rredlist")
    library(rredlist)

    # get the total number of taxa
    rl_count = rredlist::rl_sp_count(key = rlkey)
    rl_count = rl_count$count

    # note the version of the Red List
    rl_ver = rredlist::rl_version(key = rlkey)

**Number of taxa on the Red List = 95922**

**Red List version = 2018-1**

*Total number of species on the Red List:*

    # this function will get basic data from the Red List
    rl_all_IDs = function(rlkey){
      
      # get page with 10,000   
      i=1
      testcount = 1
      rl = rl_sp(0, key = rlkey)
      rl.all = rl$result
      
      # use 'while' to loop through pages until there are no more pages
      while ((testcount)>'0'){
        test = rl_sp(i, key = rlkey)
        testcount = test$count
        rl.all = rbind(rl.all,test$result)
        i = i+1
      }
    return(rl.all)  

    }

Run the rl\_all\_IDs function to get the full red list of taxa. Subset
to remove infra rank and populations to get all species

    # run rl_all_IDs to get dataframe of all taxa on Red List 
    all_taxa = rl_all_IDs(rlkey)

    # subset to remove subspecies and infra ranks
    all_RL_species = subset(all_taxa, is.na(all_taxa$infra_rank) & is.na(all_taxa$population))

    # Get total number of 'species' on Red List
    rl_row = nrow(all_RL_species)

**Number of species on the Red List = 93577**

### 1.1 Gaps in Red List coverage – why the missing species matter

*Percentage of described vertebrate species that have been Red Listed:*

Estimated number of described species of vertebrates, invertebrates,
plants and fungi. Source:
<http://cmsdocs.s3.amazonaws.com/summarystats/2018-1_Summary_Stats_Page_Documents/2018_1_RL_Stats_Table_1.pdf>

    # subset all species to get only vertebrates
    all.verts = subset(all_RL_species, all_RL_species$phylum_name == "CHORDATA")

    # estimated number of described species of VERTEBRATES
    described.verts = 69276

    # proportion vert species described that have been Red Listed
    prop.verts.RL = round((nrow(all.verts)/described.verts)*100, digits = 2)

**Proportion of vertebrate species described that have been Red Listed =
67.2%**

*Percentage of described invertebrates, plants and fungi species that
have been Red Listed:*

    # subset all species to get only plants
    all.plants = subset(all_RL_species, all_RL_species$kingdom_name == "PLANTAE") #KINGDOM = PLANTAE
    all.plants.count = nrow(all.plants)

**Number of plant species Red Listed = 25452**

    # fungi and protists covered in two kingdoms so use 'which' and pipe symbol to combine
    all.fungi = all_RL_species[ which(all_RL_species$kingdom_name == "FUNGI" | all_RL_species$kingdom_name == "CHROMISTA"),]
    all.fungi.count = nrow(all.fungi)

**Number of fungi species Red Listed= 71**

    # inverts is any animalia that isn't phylum CHORDATA so use kingdom == ANIMALIA & phylum != CHORDATA
    all.inverts = all_RL_species[ which(all_RL_species$kingdom_name == "ANIMALIA" & all_RL_species$phylum_name != "CHORDATA"),]
    all.inverts.count = nrow(all.inverts)

**Number of invertebrate species Red Listed = 21498**

    # combine all the non-vertebrates 
    all.RL.nonverts =  all.plants.count + all.fungi.count + all.inverts.count

**Number of != vertebrate species Red Listed = 47021**

Estimated number of described species of invertebrates, plants and
fungi. Source:
<http://cmsdocs.s3.amazonaws.com/summarystats/2018-1_Summary_Stats_Page_Documents/2018_1_RL_Stats_Table_1.pdf>

For vascular plants source:  
Lughadha, E.M., Govaerts, R., Belayaeva, I., Black, N., Lindon, H.,
Allkin, R., Magill, R.E., Nicholson, N., 2016. Counting counts: revised
estimates of numbers of accepted species of flowering plants, seed
plants, vascular plants and land plants with a review of other recent
estimates. Phytotaxa 272, 82–88.
<https://www.biotaxa.org/Phytotaxa/article/view/phytotaxa.272.1.5>

    described.vasc.plants.niclughadha2016 = 383671
    described.fungi = 52280
    described.inverts = 1305250
    described.nonvert = described.vasc.plants.niclughadha2016 + described.fungi + described.inverts

    # proportion described invertebrates, plants and fungi species that have been Red Listed
    prop.nonverts.RL = all.RL.nonverts/described.nonvert*100

**Proportion of invertebrates described that have been Red Listed =
2.7%**

### 1.2 Growing the Red List - vascular plants as a case study

filter on vascular plants only and compare with best estimate for total
number of vascular plants i.e. Nic Lughadha et al 2016

    vasc_plants = subset(all.plants, all.plants$phylum_name == "TRACHEOPHYTA") #PHYLUM = TRACHEOPHYTA (vascular plants)
    prop_vasc = nrow(vasc_plants)/described.vasc.plants.niclughadha2016*100

**Proportion of vascular plants that have been Red Listed = 6.59**

### 2.3 Batch assessment upload with ‘SIS Connect’

Percentage of assessments published on the Red List via SIS Connect
Craig Hilton-Taylor, pers. comm (10th August 2018)

    sis_connect_pub = 509
    sis_connect_pre_pub = 915

**Assessments published via SIS Connect = 509**

**Assessments in SIS Connect pipeline = 915**

### 2.4 Inclusion of assessments in languages other than English

List of mega diverse countries derived from this source:
<http://www.biodiversitya-z.org/content/megadiverse-countries.pdf>

    # read in table of mega diverse countries
    mega_diverse_countries <- read.csv("01_data/mega_diverse countries.csv")

    # get the number of megadiverse countries that speak Spanish, Portuguese or French as main language
    country.count = nrow(subset(mega_diverse_countries, mega_diverse_countries$Span.Port.or.French == "Yes"))

**Number of mega diverse countries that Spanish, Portuguese or French =
7**

    # Red list assessments in other languages
    brazil_2016_prt = 20
    haiti_2018_1_frnch = 38

### 2.5 Spatial tools support Red List automation

Craig Hilton-Taylor, pers. comm (10th August 2018)

    spatial_tools_citations = 1939

**Number of publications citing spatial tools = 1939**

### 2.6 Linking new species and Red List assessment publications

To get the average number of new taxa described every year, data were
downloaded from IPNI Beta site: <https://beta.ipni.org/>

A query was made for each year, with a filter on 'Specific' taxa
(species). A csv for each year from 1999 - 2017 inclusive was
downloaded. See
[01\_data](https://github.com/stevenpbachman/RedList_Challenges/tree/master/01_data)
for raw data.

    # read in raw files. Thanks to Hayward Godwin: https://www.r-bloggers.com/merge-all-files-in-a-directory-using-r-into-a-single-dataframe/

    # get list of files, note full.names = true to get full path
    file_list = list.files("01_data/IPNI_downloads_25_07_2018/", full.names = TRUE)

    #create first dataset
    IPNI_raw <- read.csv("01_data/IPNI_downloads_25_07_2018/citations_1999.txt")

    # make blank DF with structure
    IPNI_raw = IPNI_raw[0,]

    for (file in file_list){
           
    # if the merged dataset does exist, append to it
      if (exists("IPNI_raw")){
        temp_dataset <-read.csv(file)
        IPNI_raw = rbind(IPNI_raw, temp_dataset)
        rm(temp_dataset)
      }
    }

    # save this down
    path = getwd()
    respath = paste0(path,"/04_outputs/IPNI_raw.csv")
    write.table(IPNI_raw, respath,row.names = FALSE, na="", sep = ",")

Subset the IPNI data to just tax.nov.

    tax.nov = subset(IPNI_raw, IPNI_raw$citation.type == "tax. nov.")

Summarise number of tax.nov by year

    ## -- Attaching packages ------------------------------------------------------------------------------------------ tidyverse 1.2.1 --

    ## v ggplot2 3.0.0     v purrr   0.2.4
    ## v tibble  1.4.2     v dplyr   0.7.5
    ## v tidyr   0.8.0     v stringr 1.3.0
    ## v readr   1.1.1     v forcats 0.3.0

    ## -- Conflicts --------------------------------------------------------------------------------------------- tidyverse_conflicts() --
    ## x dplyr::filter() masks stats::filter()
    ## x dplyr::lag()    masks stats::lag()

    tax.nov.year = tax.nov %>% dplyr::group_by(published) %>% dplyr::count(published)

Plot number of newly described taxa per year

    colnames(tax.nov.year)[which(names(tax.nov.year) == "published")] = "Year"
    colnames(tax.nov.year)[which(names(tax.nov.year) == "n")] = "Count"

    library(ggplot2)
    plot = ggplot(data = tax.nov.year) + 
      geom_col(aes(x = Year, y = Count))
    plot

![](Methods_files/figure-markdown_strict/unnamed-chunk-22-1.png)

    # get average number of described tax now between 1999 and 2017
    tax.nov.year.mean = round((mean(tax.nov.year$Count)),0)

**The description of new plants occurs at a fairly consistent rate, with
a mean of 2242 per year (1999 – 2017)**

Kew Bulletin example - how many newly described taxa published in Kew
Bulletin from 2003–2017 are currently on the Red List?

    # get Kew Bull species 2003 - 2017
    #create first dataset
    KewBull_raw <- read.csv("01_data/IPNI_Kew_Bulletin_IPNI_downloads_25_07_2018/citations_KewBull_2003-2017.txt")

    # summarise to just tax.nov
    KewBull_tax.nov = subset(KewBull_raw, KewBull_raw$citation.type == "tax. nov.")
    nrow(KewBull_tax.nov)

    ## [1] 1235

    # change column names to match
    colnames(KewBull_tax.nov)[which(names(KewBull_tax.nov) == "scientific.name")] = "scientific_name"

    # now link to the red list to see how many have been assessed
    KB_RL_joined = merge(KewBull_tax.nov, all.plants, by = "scientific_name" )

    # Get totals
    nrow(KB_RL_joined)

    ## [1] 116

    nrow(KB_RL_joined)/nrow(KewBull_tax.nov)*100

    ## [1] 9.392713

**Of the 1,234 newly described taxa published in Kew Bulletin from
2003–2017, only 1235 9.39 are currently on the Red List**

How much time had elapsed between formal description of a species and
publication of an assessment for that species on the Red List? Species
described and then assessed within 5 years were labelled as ‘New’, and
species that were assessed more than 5 years since they were described
were labelled ‘Old’.

Use [POWO](http://www.plantsoftheworldonline.org/) API to assign IPNI
IDs to Red List plant names. Then use IPNI ID to get date/year that
plant name description was published Compare assessment year with name
description publication year

    ### Query Red List binomials against POWO to see taxonomic status according to POWO
    ### POWO = Plants of the World Online

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

    #check if names are accepted on POWO - query on the binomial field - change this for exact column name rather than col number?
    checkACC_apply = lapply(all.plants[,8],check.accepted.POWO)
    accepted.result = do.call(rbind.fill, checkACC_apply)

    # reduce to just the rows with IPNI IDs - convert blanks to NA first
    accepted.result$IPNI_ID[accepted.result$IPNI_ID==""] = NA

    # omit NAs
    all.plants.IPNI = accepted.result %>% na.omit()

    # reduce to non null results
    all.plants.IPNI = subset(all.plants.IPNI, rank =="Species") 

    # keep accepted red_list in memory, but save as hard copy for later use if necessary
    path = getwd()
    respath = paste0(path,"/all.plants.IPNI.csv")
    write.table(all.plants.IPNI, respath,row.names = FALSE, na="", sep = ",")

Now that we have IPNI IDs for the Red List assessments for plants, we
need to pull out the date/year of publication so we can compare
assessment date vs publication date.

Use [OpenRefine](http://openrefine.org/) to access structured IPNI data.
Thanks to [Nicky Nicholson](https://github.com/nickynicolson) for
method.

1.  Call IPNI to get structured data for each record:

<!-- -->

1.  Click dropdown next to the IPNI id, select “Edit column” -&gt; “Add
    column by fetching URLs”
2.  Build the URL by entering the following into the expression box:
    '<http://ipni.org/urn:lsid:ipni.org:names>:'+value
3.  Give your new column a title (e.g. “IPNI LSID data”) and a throttle
    delay of 1000 milliseconds, click OK You should now have a new
    column with RDF-XML formatted data – these cells will be massive but
    you can drop (or hide) the column after the next step is completed

<!-- -->

1.  Extract the publication year from the RDF XML:

<!-- -->

1.  Click the dropdown next to the “IPNI LSID data” column, select “Edit
    column” -&gt; “Add column based on this column”
2.  Select the year tag in the RDF XML and extract its contents: type
    in: value.parseHtml().select("tn|year")\[0\].htmlText()
3.  Give your new column a title (‘publication year’) and click OK

Save as
[all.plants.IPNI.csv](https://github.com/stevenpbachman/RedList_Challenges/blob/master/01_data/all.plants.IPNI.csv)

Now import

    # import the RL data with IPNI ID and year
    path = getwd()
    all_plants_IPNI <- read_csv(paste0(path,"/01_data/all.plants.IPNI.csv"))

    ## Parsed with column specification:
    ## cols(
    ##   accepted = col_integer(),
    ##   author = col_character(),
    ##   kingdom = col_character(),
    ##   name = col_character(),
    ##   rank = col_character(),
    ##   base_url = col_character(),
    ##   IPNI_ID = col_character(),
    ##   search_name = col_character()
    ## )

    IPNI_year = all_plants_IPNI

    # change column name so that you can merge with full red list data
    colnames(IPNI_year)[which(names(IPNI_year) == "search_name")] = "scientific_name"

### 3.3 Supporting the Plant assessment champions –Specialist Groups and Authorities

How much time had elapsed between formal description of a species and
publication of an assessment for that species on the Red List.Species
described and then assessed within 5 years were labelled as ‘New’, and
species that were assessed more than 5 years since they were described
were labelled ‘Old’.

We need to get IPNI IDs for red list plant species and then match that
with IPNI file so that we have year described and year on red list

    # describe method to get IPNI year for all species on the Red List
    # Open refine

    # merge all.plants.IPNI with full IPNI list
