if not "%1"=="STDOUT_TO_FILE"  %0 STDOUT_TO_FILE %*  >  OUTPUT/matching-log.txt 2>&1
shift /1
cd C:\Users\micha\Documents\GitHub\graphhopper-map-matching
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar import map-data/arizona-latest.osm.pbf
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar match C:/Users/micha/Desktop/gpx-engine/OUTPUT/2015/*.gpx
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar import map-data/arizona-latest.osm.pbf
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar match C:/Users/micha/Desktop/gpx-engine/OUTPUT/2016/*.gpx
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar import map-data/arizona-latest.osm.pbf
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar match C:/Users/micha/Desktop/gpx-engine/OUTPUT/2017/*.gpx
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar import map-data/arizona-latest.osm.pbf
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar match C:/Users/micha/Desktop/gpx-engine/OUTPUT/2018/*.gpx
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar import map-data/arizona-latest.osm.pbf
java -jar matching-web/target/graphhopper-map-matching-web-0.11-SNAPSHOT.jar match C:/Users/micha/Desktop/gpx-engine/OUTPUT/2019/*.gpx
%SystemRoot%\explorer.exe "C:\Users\micha\Desktop\gpx-engine\OUTPUT"