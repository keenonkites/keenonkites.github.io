Tour de Suisse (GCQG54)
=======================
The perl script *tds-route-xml.pl* uses the gpx file containing the complete geocache **Tour de Suisse (GCQG54)** with all logs to create different gpx files used for the online map.

[Geocaching.com Link to the Cache](http://coord.info/GCQG54)

Procedure to create the gpx files for the online map
----------------------------------------------------
### Short description

1.  Import the gpx file containing the cache into GSAK
2.  Use GSAK's Function *Get Recent Logs* to import all logs of the cache into the GSAK DB
    - Type: Custom selection
    - Max logs (per cache): 99999
    - Log number to start at: 1
3.  Export GPX file again containing the Cache and all logs:
    - Filename (fix): tds.gpx
    - Location: same directory as the perl script
    - Number of logs to export: No Limit
    - Place alternate coordinates in log text
4.  run the perl script *tds-route-xml.pl*
    This creates the following files:
    - *tds-route-complete.gpx*: file containing tracks for each year of the cache's journey
    - *tds-wpt-complete.gpx*:  file containing waypoints with the date and finder name where the cache was already
    - *tds-wpt-position.gpx*:  containing the last position of the cache as a waypoint
    - *tds-infoStatistics.js*: Contains the variables used to display the popup on the map with the statistics
    - *tds-route-comlete.txt*: not directly used for the online map: contains a list of all stops of the cache
5.  Copy the following three gpx files into the map directories:
    - *tds-route-complete.gpx*
    - *tds-wpt-complete.gpx*
    - *tds-wpt-position.gpx*
	  - *tds-infoStatistics.js*
