#######################################################
#########GRAPHHOPPER MAPMATCH FAILURE FINDER ##########
#######################################################

YEAR <- "2015"

files <- list.files(path = paste("C:/Users/micha/Desktop/GPX_DATA_FILLED/",YEAR,sep=""))
successes <- list.files(path = paste("C:/Users/micha/Desktop/GPX_DATA_FILLED/",YEAR,sep=""),pattern=".gpx.res")
success_originals <- gsub('.{8}$', '', successes)

failures <- setdiff(setdiff(files,success_originals),successes)

data <- read.csv(paste("C:/Users/micha/Desktop/dataset/p_",
                       YEAR,"_10.csv",sep=""))[,c('user_id','encoded_path')]

failure_data <- data.frame(user_id=integer(),encoded_path=character())
failure_ids <- sub(".*TRIP_", "", gsub('.{9}$', '', failures))

for (id in failure_ids) {
  failure_data[nrow(failure_data) + 1,] = data[id,]
}

write.csv(failure_data,paste("C:/Users/micha/Desktop/mm_failure_",YEAR,".csv",sep=""), row.names = FALSE)

rm(list = c("data","failure_data","failure_ids","failures",
            "files","id","success_originals","successes","YEAR"))

