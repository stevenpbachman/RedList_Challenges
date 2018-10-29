###
### Download the IUCN Red List 
### Use this script to get top level information e.g. taxonomy and Red List rating for all plants

### Steve Bachman 
### Feb 2018

# install rredlist package and load library
#install.packages("rredlist")
#devtools::install_github("ropensci/rredlist")
library(rredlist)

# Get basic data from ID, use later within rl_plants_IDs script-------------------------------------
rl.apply = function(x, key){
  sp <- rl_search(id=x,key=rlkey)
  sp = sp$result
  return(sp)
}

# Get IDs for plants to they can be passed to rl.apply----------------------------------------------
rl_plant_IDs = function(rlkey, path){
  
  # get IDs (all taxa on Red List) in pages of 10,000 until page has no more species  
  i=1
  testcount = 1
  rl = rl_sp(0, key = rlkey)
  rl.all = rl$result
  
  while ((testcount)>'0'){
    test = rl_sp(i, key = rlkey)
    testcount = test$count
    rl.all = rbind(rl.all,test$result)
    i = i+1
  }
  # filter on plants 'PLANTAE'
  plants <- rl.all[ which(rl.all$kingdom_name=='PLANTAE'),] 
  
  # filter out the first column 'taxon ID'
  plants.id = plants[,1]
  
  # run through all IDs using lapply
  apply.rl = lapply(plants.id,rl.apply)
  rl_df = as.data.frame(do.call(rbind,apply.rl))
  
  # get RL version number
  version = rl_version(key = rlkey)
  
  # get date
  today = Sys.Date()
  
  # print version number and date so this can be assigned to the output
  print(paste0("PLANTAE_RL_version_",version,"_run_on_",today))
  
  # return the results
  return(rl_df)
  
}

#testing new rl_sp all parameter

rl_all = function(key){
rl = rl_sp(all = TRUE,  key = rlkey, parse = TRUE)
length(rl)
vapply(rl, "[[", 1, "count")
all_df = do.call(rbind, lapply(rl, "[[", "result"))
return(all_df)
}

str(rl)
