                                       _            
  __ _ _ ____  __      ___ _ __   __ _(_)_ __   ___ 
 / _` | '_ \ \/ /____ / _ \ '_ \ / _` | | '_ \ / _ \
| (_| | |_) >  <_____|  __/ | | | (_| | | | | |  __/
 \__, | .__/_/\_\     \___|_| |_|\__, |_|_| |_|\___|
 |___/|_|                        |___/              


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