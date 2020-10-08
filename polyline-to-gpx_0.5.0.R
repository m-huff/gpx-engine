#########################################################################
###### GOOGLE ENCODED POLYLINE TO MAP-MATCHING READY GPX CONVERTER ######
############################# MICHAEL HUFF ##############################
#########################################################################

#install.packages("gepaf")
library("gepaf")

#decimals to include in lat/long decoding
DECODING_FACTOR <- 5

#max distance between points before we insert filler points
#0.018 degrees (2km) is the hard-coded max in GraphHopper
#this must be below that, ideally by a wide margin
MAX_GRAPHHOPPER_POINT_DIST <- 0.0125

#max distance between points on BOTH axes to warrant removal
GHOST_POINT_REMOVAL_PRECISION <- 0.0001

years <- c("2015","2016","2017","2018","2019")

for (year in years) {
  
  dat_dir <- "C:/Users/micha/Desktop/"
  excel_sheet <- paste("DATASET/p_",year,"_10.csv", sep= "")
  output_dir <- paste(dat_dir,"GPX_DATA/",year,"/", sep= "")

  #import original data set, then extract the two relevant columns
  raw_data <- read.csv(paste(dat_dir, excel_sheet, sep=""))[,c('user_id','encoded_path')]
  trip_paths = raw_data[,'encoded_path']
  user_ids = raw_data[,'user_id']
  
  #loop through all trip paths in full data set
  for (i in seq(1, length(trip_paths), 1)) {
    
    #use gepaf function 'decodePolyline' to decode the strings into lat/long data frame
    #factor is the number of decimal digits to include (5)
    coord_table <- decodePolyline(enc_polyline = trip_paths[i:i], factor = DECODING_FACTOR)
    
    #run a check to prevent ghost points
    #works backwards through the list for index preservation
    x <- length(coord_table$lat)
    while (x > 1) {
      
      #flag and remove points that are duplicate/ghost points in a line
      if (abs(coord_table$lat[x] - coord_table$lat[x-1]) <= GHOST_POINT_REMOVAL_PRECISION &
          abs(coord_table$lon[x] - coord_table$lon[x-1]) <= GHOST_POINT_REMOVAL_PRECISION) {
        
        coord_table <- coord_table[-c(x),]
      }
      
      x = x - 1
    }
    
    #we want to loop through again checking for distances GraphHopper can't handle
    #these will all be points above 0.015 degrees apart in straight lines
    #this loop checks for NORTH/SOUTH lines that necessitate filler points
    x <- length(coord_table$lat)
    while (x > 1) {
      
      #check if this point and the next are far apart in a north-south line
      if (abs(coord_table$lat[x] - coord_table$lat[x-1]) > MAX_GRAPHHOPPER_POINT_DIST) {

        #generate filler values on the long axis
        filler_lats <- seq(coord_table$lat[x], coord_table$lat[x-1],
                           ifelse(coord_table$lat[x] - coord_table$lat[x-1] > 0,
                           -MAX_GRAPHHOPPER_POINT_DIST, MAX_GRAPHHOPPER_POINT_DIST))
        
        #generate filler values of matching length on the short axis
        step_size <- round(abs(coord_table$lon[x] - coord_table$lon[x-1]) 
                           / length(filler_lats), digits = DECODING_FACTOR)
        
        filler_longs <- coord_table$lon[x]
        for (j in seq(1, length(filler_lats) - 1, 1)) {
          filler_longs <- c(filler_longs,ifelse(coord_table$lon[x] - coord_table$lon[x-1] > 0,
                                                (coord_table$lon[x] - (step_size * j)), 
                                                (coord_table$lon[x] + (step_size * j))))
        }
        
        #insert our filler points into the coord_table
        #reverse filler point order since we're going through the coordinate table backwards
        filler_point_frame <- data.frame(lat = filler_lats, lon = filler_longs)
        coord_table <- rbind(coord_table[1:x-1,], 
                             filler_point_frame[seq(dim(filler_point_frame)[1],1),], 
                             coord_table[-(1:x-1),])
      }
      x = x - 1
    }
    
    #we want to loop through again checking for distances GraphHopper can't handle
    #these will all be points above 0.015 degrees apart in a straight line
    #this loop checks for EAST/WEST lines that necessitate filler points    
    x <- length(coord_table$lat)
    while (x > 1) {
    
      if (abs(coord_table$lon[x] - coord_table$lon[x-1]) > MAX_GRAPHHOPPER_POINT_DIST) {
        
        #generate filler values on the long axis
        filler_longs <- seq(coord_table$lon[x], coord_table$lon[x-1],
                            ifelse(coord_table$lon[x] - coord_table$lon[x-1] > 0,
                            -MAX_GRAPHHOPPER_POINT_DIST, MAX_GRAPHHOPPER_POINT_DIST))
        
        #generate filler values of matching length on the short axis
        step_size <- round(abs(coord_table$lat[x] - coord_table$lat[x-1]) 
                           / length(filler_longs), digits = DECODING_FACTOR)
        
        filler_lats <- coord_table$lat[x]
        for (j in seq(1, length(filler_longs) - 1, 1)) {
          filler_lats <- c(filler_lats,ifelse(coord_table$lat[x] - coord_table$lat[x-1] > 0,
                                              (coord_table$lat[x] - (step_size * j)),
                                              (coord_table$lat[x] + (step_size * j))))
        }
        
        #insert our filler points into the coord_table
        #reverse filler point order since we're going through the coordinate table backwards
        filler_point_frame <- data.frame(lat = filler_lats, lon = filler_longs)
        coord_table <- rbind(coord_table[1:x-1,], 
                             filler_point_frame[seq(dim(filler_point_frame)[1],1),], 
                             coord_table[-(1:x-1),])
      }
      x = x - 1
    }
    
    #append all GPX data to this list, starting with GPX header
    gpx_data <- c('<gpx version="1.1" creator="Mike Huff">','<trk>','<trkseg>') 
  
    #loop through each coordinate pair, add that GPX syntax to our file build
    for (j in seq(1, length(coord_table$lat), 1)) {
  
      gpx_data <- c(gpx_data, paste('<trkpt lat="',coord_table$lat[j],
                                    '" lon="',coord_table$lon[j],'" />', sep='')) 
    }
  
    #add standard footer into GPX file once all points are added
    gpx_data <- c(gpx_data, '</trkseg>', '</trk>', '</gpx>') 
  
    #write the constructed GPX data to a new GPX file at our output directory
    output_file_name <- paste(output_dir,"ID_",user_ids[i:i],"_TRIP_",
                              i,"_",year,".gpx", sep= "")
    file.create(output_file_name)
    cat(gpx_data, file = output_file_name, sep='\n')
    
    #dump single trip variables
    rm(list = c("coord_table","gpx_data"))
  }
  
  #dump year variables
  rm(list = c("excel_sheet","output_dir","raw_data",
              "trip_paths","user_ids","output_file_name"))
}

########################
###### END SCRIPT ######
########################