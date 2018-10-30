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

**Number of non-vertebrate species Red Listed = 47021**

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

Filter on vascular plants only and compare with best estimate for total
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
[01\_data](https://github.com/stevenpbachman/RedList_Challenges/tree/master/01_data/IPNI_downloads_25_07_2018)
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

Plot number of newly described species per year

    colnames(tax.nov.year)[which(names(tax.nov.year) == "published")] = "Year"
    colnames(tax.nov.year)[which(names(tax.nov.year) == "n")] = "Count"

    library(ggplot2)
    plot = ggplot(data = tax.nov.year) + 
      geom_col(aes(x = Year, y = Count))
    plot

![](Methods_files/figure-markdown_strict/unnamed-chunk-22-1.png)

    # get average number of described species between 1999 and 2017
    tax.nov.year.mean = round((mean(tax.nov.year$Count)),0)

**The description of new plant species occurs at a fairly consistent
rate, with a mean of 2242 per year (1999 – 2017)**

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
2003–2017, only 1235, 9.39% are currently on the Red List**

How much time has elapsed between formal description of a species and
publication of an assessment for that species on the Red List? Species
described and then assessed within 5 years were labelled as ‘New’, and
species that were assessed more than 5 years since they were described
were labelled ‘Old’.

1.  Use [POWO](http://www.plantsoftheworldonline.org/) API to assign
    IPNI IDs to Red List plant names.
2.  Then use [OpenRefine](http://openrefine.org/) and IPNI ID to get
    date/year that plant name description was published
3.  Query Red List to get assessment year (this doesn't come with the
    summary data)
4.  Compare Red List assessment year with name description publication
    year - plot results.

5.  Use [POWO](http://www.plantsoftheworldonline.org/) API to assign
    IPNI IDs to Red List plant names.

<!-- -->

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

1.  Then use [OpenRefine](http://openrefine.org/) and IPNI ID to get
    date/year that plant name description was published

Now that we have IPNI IDs for the Red List assessments for plants, we
need to pull out the date/year of publication so we can compare
assessment date vs publication date.

Use [OpenRefine](http://openrefine.org/) to access structured IPNI data.
Thanks to [Nicky Nicholson](https://github.com/nickynicolson) for
method.

1.  Call IPNI to get structured data for each record: ⋅⋅\* Click
    dropdown next to the IPNI id, select “Edit column” -&gt; “Add column
    by fetching URLs” ⋅⋅\* Build the URL by entering the following into
    the expression box:
    '<http://ipni.org/urn:lsid:ipni.org:names>:'+value ⋅⋅\* Give your
    new column a title (e.g. “IPNI LSID data”) and a throttle delay of
    1000 milliseconds, click OK You should now have a new column with
    RDF-XML formatted data – these cells will be massive but you can
    drop (or hide) the column after the next step is completed
2.  Extract the publication year from the RDF XML: ⋅⋅\* Click the
    dropdown next to the “IPNI LSID data” column, select “Edit column”
    -&gt; “Add column based on this column” ⋅⋅\* Select the year tag in
    the RDF XML and extract its contents: type in:
    value.parseHtml().select("tn|year")\[0\].htmlText() ⋅⋅\* Give your
    new column a title (‘publication year’) and click OK

Save as
[RedList2018\_1\_powo\_species\_IPNI\_LSID](https://github.com/stevenpbachman/RedList_Challenges/blob/master/01_data/RedList2018_1_powo_species_IPNI_LSID.csv)

1.  Query Red List to get assessment year (this doesn't come with the
    summary data)

<!-- -->

    #get red list year
    # import the names list with IPNI ID and year
    path = getwd()
    all_plants_IPNI <- read_csv(paste0(path,"/01_data/all.plants.IPNI.csv"))

    # use the binomial to get the Red List extra data
    IPNI_year = all_plants_IPNI
    rl_names = IPNI_year[,4]

    # load the red list library
    library(rredlist)

    #run this function to get the extra red list data
    rl = function(x, key){
      sp = rl_search(name = x, key = key)
      sp = sp$result
      return(sp)
    }

    # use apply to run through all in the list
    t = proc.time()
    test_apply = apply(rl_names, 1, rl, key = rlkey)
    rl_df = as.data.frame(do.call(rbind,test_apply))
    proc.time()- t

    # now join back with all_plants_IPNI
    # change column name so that you can merge with full red list data
    colnames(all_plants_IPNI)[which(names(all_plants_IPNI) == "search_name")] = "scientific_name"
    rl_IPNI = merge(all_plants_IPNI, rl_df, by = "scientific_name")

1.  Compare Red List assessment year with name description publication
    year - plot results.

<!-- -->

    path = getwd()
    RedList2018_1_powo_species_IPNI_LSID <- read.csv(paste0(path,"/01_data/RedList2018_1_powo_species_IPNI_LSID.csv"))
    rl_IPNI_year = RedList2018_1_powo_species_IPNI_LSID
    rl_IPNI_year = subset(rl_IPNI_year, select = -IPNI_LSID)
    colnames(rl_IPNI_year)[which(names(rl_IPNI_year) == "search_name")] = "scientific_name"

    # merge IPNI year and Red List 
    merged_taxnov_RL = merge(rl_IPNI, rl_IPNI_year, by = "scientific_name")

    # now take the described year away from the published year
    merged_taxnov_RL_diff = data.frame(diff = merged_taxnov_RL$published_year - merged_taxnov_RL$Year)
    diff = cbind(merged_taxnov_RL_diff, merged_taxnov_RL)

    # now add column for New (5 years or less) and Old (>5 years)
    diff$age[diff$diff < 6] <- "New"
    diff$age[diff$diff >=6] <- "Old"
    diff$age[is.na(diff$diff)] <- "Unknown"

    diffplot = subset(diff, published_year > 2002 & published_year <2018, select=c(published_year, age))

    # adding in a single record to get a point for 2005 - must be another way to do this...
    extralev = data.frame(published_year = "2005", age = "Unknown")
    diffplot = rbind(diffplot, extralev)

    tax.nov.plot = subset(tax.nov.year, tax.nov.year$Year >="2003" & tax.nov.year$Year < "2018")

    # now summarise the ratio of old and new for each red list assessment year
    library(ggplot2)
    plot = ggplot() + 
      geom_bar(data = diffplot, aes(x = as.factor(published_year), fill = as.factor(age)), 
               position = position_dodge(preserve = 'single')) + 
      
      labs(x = "Red List Publication Year", y = "Number of plant species assessments", fill = "") +
      theme_minimal() +
      scale_fill_manual(values = c("New" = "#f37735", "Old" = "#ffc425", "Unknown" = "light grey")) +
      geom_point(data = tax.nov.plot, aes(x = as.factor(Year), y = Count), stat = "identity", size = 2, shape = 16) +
      #scale_colour_manual(name = "Year", labels = "test", values = "black") +
      scale_x_discrete(expand = c(0, 0)) + scale_y_continuous(expand = c(0,100)) 

    plot

\`\`\`

### 3.3 Supporting the Plant assessment champions – Specialist Groups and Authorities

Compare number of species assessed vs not assessed for specialist groups
and non-specialist groups

    #pull out just vascular plants
    RL_vasc_plants = subset(all.plants, all.plants$phylum == "TRACHEOPHYTA" )
    RL_vasc_plants$SG = ""

    # total number of described vascualr plants 
    described.vasc.plants.niclughadha2016 

    ## [1] 383671

    # update SG with specialist group name
    RL_vasc_plants$SG[RL_vasc_plants$family == "CYMODOCEACEAE"] = "Seagrass"
    RL_vasc_plants$SG[RL_vasc_plants$family == "HYDROCHARITACEAE"] = "Seagrass"
    RL_vasc_plants$SG[RL_vasc_plants$family == "POSIDONIACEAE"] = "Seagrass"
    RL_vasc_plants$SG[RL_vasc_plants$family == "ZOSTERACEAE"] = "Seagrass"

    RL_vasc_plants$SG[RL_vasc_plants$family == "ARECACEAE"] = "Palm"

    RL_vasc_plants$SG[RL_vasc_plants$family == "ORCHIDACEAE"] = "Orchid"

    RL_vasc_plants$SG[RL_vasc_plants$family == "CYCADACEAE"] = "Cycad"
    RL_vasc_plants$SG[RL_vasc_plants$family == "ZAMIACEAE"] = "Cycad"
    RL_vasc_plants$SG[RL_vasc_plants$family == "STANGERIACEAE"] = "Cycad"

    RL_vasc_plants$SG[RL_vasc_plants$family == "ARAUCARIACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "CUPRESSACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "PINACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "PODOCARPACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "PHYLLOCLADACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "SCIADOPITYACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "TAXACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "CEPHALOTAXACEAE"] = "Conifer"
    RL_vasc_plants$SG[RL_vasc_plants$family == "STANGERIACEAE"] = "Conifer"

    RL_vasc_plants$SG[RL_vasc_plants$family == "CACTACEAE"] = "Cacti & Succulents"

    RL_vasc_plants$SG[RL_vasc_plants$family == "NEPENTHACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "DROSERACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "CEPHALOTACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "SARRACENIACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "LENTIBULARIACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "RORIDULACEAE"] = "Carnivorous"
    RL_vasc_plants$SG[RL_vasc_plants$family == "DIONCOPHYLLACEAE"] = "Carnivorous"

For each group (specialist group or not) get the count (n rows)

    #now group them up and get counts
    library(tidyverse)
    RL_vasc_noSG = subset(RL_vasc_plants, SG == "" )
    Non_SG_assessed = nrow(RL_vasc_noSG)

    RL_vasc_yesSG = subset(RL_vasc_plants, SG != "" )
    SG_assessed = nrow(RL_vasc_yesSG)

Now import the count of species per family - derived from [Catalogue of
life](http://www.catalogueoflife.org/col/browse/tree)

    path = getwd()
    CoL_24thSep_2018 <- read.csv(paste0(path,"/01_data/CoL_24thSep_2018.csv"))

    # get the total species count for SG groups
    sumCoL = sum(CoL_24thSep_2018$Count)

    # get the count of species in SGs not assessed
    SGs_not_assessed = sumCoL - SG_assessed

    # work out the remainder non SG and not assessed
    Non_SG_not_assesseed = (described.vasc.plants.niclughadha2016 - sum(SG_assessed,SGs_not_assessed,Non_SG_assessed))

Combine to run the chi square test

    SGs = c(SG_assessed,SGs_not_assessed)
    NonSGs = c(Non_SG_assessed,Non_SG_not_assesseed)

    SG.test = as.data.frame(cbind(SGs,NonSGs))
    names(SG.test) = c('assessed','not assessed')

    rownames(SG.test) = c("SGs","NonSGs" )

    chisq.test(SG.test)

    ## 
    ##  Pearson's Chi-squared test with Yates' continuity correction
    ## 
    ## data:  SG.test
    ## X-squared = 2977.5, df = 1, p-value < 2.2e-16
