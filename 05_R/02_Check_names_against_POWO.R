###
### Query binomials against POWO to see taxonomic status according to POWO
### POWO = Plants of the World Online

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



