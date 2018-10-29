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





#as.list(RedList_AcceptedPOWO)

# reduce to non null results
sara_prvi_powo = subset(accepted.result, rank !="") 

# keep accepted red_list in memory, but save as hard copy for later use if necessary
path ="C:/Users/sb42kg/OneDrive - The Royal Botanic Gardens, Kew/02_Publications/spb/Machine learning - big data red list/05_R/01_Prepare_Data/"
respath = paste0(path,"Sara.csv")
write.table(sara_prvi_powo, respath,row.names = FALSE, na="", sep = ",")



