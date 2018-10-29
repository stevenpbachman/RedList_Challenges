This document describes methods used in the paper **'Progress,
challenges and opportunities for plant Red Listing'**. Each numbered
section relates to numbered sections in the manuscript. See section
**'04\_outputs'** for the manuscript.

### 1. Introduction

*Total number of taxa on the Red List:*

    #install.packages("rredlist")
    library(rredlist)

    # get the total number of taxa
    rl_count = rredlist::rl_sp_count(key = rlkey)
    rl_count = rl_count$count

    # note the version of the Red List
    rl_ver = rredlist::rl_version(key = rlkey)

**Number of taxa on the Red List = 95922** **Red List version = 2018-1**

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
    prop.verts.RL = round((nrow(all.verts)/described.verts), digits = 2)

**Proportion of vertebrate species described that have been Red Listed =
0.67**

*Percentage of described invertebrates, plants and fungi species that
have been Red Listed:*

    # subset all species to get only plants
    all.plants = subset(all_RL_species, all_RL_species$kingdom_name == "PLANTAE") #KINGDOM = PLANTAE
    all.plants.count = nrow(all.plants)

    # print
    print(paste0('Number of plant species Red Listed = ',all.plants.count))

    ## [1] "Number of plant species Red Listed = 25452"

**Number of plant species Red Listed = 25452**

    # fungi and protists covered in two kingdoms so use 'which' and pipe symbol to combine
    all.fungi = all_RL_species[ which(all_RL_species$kingdom_name == "FUNGI" | all_RL_species$kingdom_name == "CHROMISTA"),]
    all.fungi.count = nrow(all.fungi)

**Number of fungi species Red Listed= 71**

    # inverts is any animalia that isn't phylum CHORDATA so use kingdom == ANIMALIA & phylum != CHORDATA
    all.inverts = all_RL_species[ which(all_RL_species$kingdom_name == "ANIMALIA" & all_RL_species$phylum_name != "CHORDATA"),]
    all.inverts.count = nrow(all.inverts)

**Number of invertebrate species Red Listed = 21498**

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
    prop.nonverts.RL = all.RL.nonverts/described.nonvert

**Proportion of vertebrates described that have been Red Listed = 2.7**

### 1.2 Growing the Red List - vascular plants as a case study

filter on vascular plants only and compare with best estimate for total
number of vascular plants i.e. Nic Lughadha et al 2016

    vasc_plants = subset(all.plants, all.plants$phylum_name == "TRACHEOPHYTA") #PHYLUM = TRACHEOPHYTA (vascular plants)

**Proportion of vascular plants that have been Red Listed = 6.5887179**

### 2.3 Batch assessment upload with ‘SIS Connect’

Percentage of assessments published on the Red List via SIS Connect
Craig Hilton-Taylor, pers. comm (10th August 2018)

    sis_connect_pub = 509
    sis_connect_pre_pub = 915

**Assessments published via SIS Connect = 509** **Assessments in SIS
Connect pipeline = 915**

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

**Number of publications citing spatial tools 1939**

### 2.6 Linking new species and Red List assessment publications

To get the average number of new taxa described every year, data were
downloaded from IPNI Beta site: <https://beta.ipni.org/>

A query was made for each year, with a filter on 'Specific' taxa
(species). A csv for each year from 1999 - 2017 inclusive was
downloaded. See 01\_data folder
<https://github.com/stevenpbachman/RedList_Challenges/tree/master/01_data>
