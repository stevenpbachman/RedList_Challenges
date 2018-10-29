###
### Query down the Red List for plants using the IUCN API http://apiv3.iucnredlist.org/api/v3/docs
### http://apiv3.iucnredlist.org/api/v3/docs

# RL key needed for download. ***change this to your own key- get from iucn.org 
rlkey <- "cf3cf316d5dd72945456d42a633ac92357f6b8039bf1d512cc58e26d6169a8f3"

# Make dataframe with top level data for all plants on the IUCN Red List
plants.id = rl_all(rlkey)

# remove duplicate species - this may be fixed later so not necessar, but check!
plant_red_list = plants.id[-c(3663,4243,16695,16573,16639,16667,16433,16711),]

# filter on plants 'PLANTAE'
plant_red_list <- plant_red_list[ which(plant_red_list$kingdom_name=='PLANTAE'),] 

# remove errat columns, they are causing problems with csv file, and not needed
plant_red_list = red_list[,-c(25,26,27,28)]

# keep red_list in memory, but save as hard copy for later use if necessary
version = rl_version(key = rlkey) #get RL version number
today = Sys.Date() #get date
path = path ="C:/Users/sb42kg/OneDrive - The Royal Botanic Gardens, Kew/02_Publications/PhD/Major_Corrections/RedList_challenges/05_R/"
respath = paste0(path,"PLANTAE_RL_version_",version,"_run_on_",today,".csv")
write.table(red_list, respath,row.names = FALSE, na="", sep = ",")

