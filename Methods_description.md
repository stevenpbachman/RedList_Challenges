This document describes methods used in the paper **'Progress,
challenges and opportunities for plant Red Listing'**. Each numbered
section header relates to numbered sections in the manuscript.

#### 1. Introduction

*Total number of taxa on the Red List:*

    #install.packages("rredlist")
    library(rredlist)

    # get total number of taxa
    rredlist::rl_sp_count(key = rlkey)

    ## $count
    ## [1] "95922"
    ## 
    ## $note
    ## [1] "This total includes species, subspecies and subpopulations"

    # note the version of the Red List
    rredlist::rl_version(key = rlkey)

    ## [1] "2018-1"
