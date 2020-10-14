                                                                              88                       
                                                                              ""                       
                                                                                                       
 ,adPPYb,d8 8b,dPPYba, 8b,     ,d8          ,adPPYba, 8b,dPPYba,   ,adPPYb,d8 88 8b,dPPYba,   ,adPPYba,
a8"    `Y88 88P'    "8a `Y8, ,8P' aaaaaaaa a8P_____88 88P'   `"8a a8"    `Y88 88 88P'   `"8a a8P_____88
8b       88 88       d8   )888(   """""""" 8PP""""""" 88       88 8b       88 88 88       88 8PP"""""""
"8a,   ,d88 88b,   ,a8" ,d8" "8b,          "8b,   ,aa 88       88 "8a,   ,d88 88 88       88 "8b,   ,aa
 `"YbbdP"Y8 88`YbbdP"' 8P'     `Y8          `"Ybbd8"' 88       88  `"YbbdP"Y8 88 88       88  `"Ybbd8"'
 aa,    ,88 88                                                     aa,    ,88                          
  "Y8bbdP"  88                                                      "Y8bbdP"                           


To run the gpx-engine, double-click start.bat in this directory. This will execute the master R script and:

1) read data from the data in tripdata.csv and decode the polylines

2) clean the GPX data that results, removing ghost points, filling in long distances between points,
   and catching trips outside of a set bounding box (the study area) or with corrupt data

3) output the corrupt/excluded trips to the /EXCLUSIONS/ directory, and include a .csv of their data

4) output the cleaned trips to the /OUTPUT/%YEAR% directories, and then attempt to map-match them with
   GraphHopper map matching utilizing OSM maps for Arizona

5) catch any files that fail to match, and generate a .csv for them that is able to be run through
   gpx-engine again straight away


The reset-all.bat file will wipe all files in the /EXCLUSIONS/ and /OUTPUT/ directories and all subdirectories,
allowing the gpx-engine to be run from scratch again.

The match-all.bat file is meant for internal use by the polyline-to-gpx R script, but can be used manually for
files within the OUTPUT/%YEAR% directories.