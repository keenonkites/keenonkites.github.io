use strict;
use warnings;
use XML::Simple;
use IO::File;
use Data::Dumper;

# Customization
# -------------
my $onlineLogbookBaseURL="http://keenonkites.github.io/tour-de-suisse/logbook/logbook.html";

# Some Log and image related manual stuff
my %logidBlackList = (
     "11521252"  => "1",
    "123062768"  => "1",
    "236273602"  => "1",
    "524705545"  => "1",
    ); 
my %logidOverride = (
    "11898722"  => ": 47 : 31.391 : 7 : 34.179 : Find-It :",
    "12316206"  => ": 47 : 18.420 : 7 : 41.472 : MiMa :",
    "18959129"  => ":47:38.147:9:09.270:Jasi+Saba:",
    "258297723" => ": 46 : 15.399 : 009 : 01.818 : PKLM :",
    "289214332" => ": 47 : 08.030 : 007 : 26.640 : Mr.Gross :",

    );
my %imageToLogdate = (
    "img003.jpg" => [ "2013", "2013-05-31" ],
    "img004.jpg" => [ "2013-06-07", "2013-06-09", "2013-06-16" ],
    "img005.jpg" => [ "2013-06-30", "2013-07-01", ],
    "img006.jpg" => [ "2013-06-19", "2013-06-22", "2013-07-02", ],
    "img007.jpg" => [ "2013-07-03", "2013-07-04", ],
    "img008.jpg" => [ "2013-07-05", ],
    "img009.jpg" => [ "2013-07-07", "2013-07-18", ],
    "img010.jpg" => [ "2013-07-20", "2013-07-27", "2013-07-30", "2013-08-04", ],
    "img011.jpg" => [ "2013-08-06", ],
    "img012.jpg" => [ "2013-08-12", "2013-08-13", "2013-08-15", ],
    "img013.jpg" => [ "2013-08-16", "2013-08-17", "2013-08-19", ],
    "img014.jpg" => [ "2013-08-24", ],
    "img015.jpg" => [ "2013-09-01", "2013-09-19", ],
    "img016.jpg" => [ "2013-09-23", "2013-09-24", "2013-09-26", ],
    "img017.jpg" => [ "2013-09-27", ],
    "img018.jpg" => [ "2013-09-29", ],
    "img019.jpg" => [ "2013-10-01", ],
    "img020.jpg" => [ "2013-10-02", "2013-10-03", ],
    "img021.jpg" => [ "2013-10-06", "2013-10-13", "2013-10-18", "2013-10-19", ],
    "img022.jpg" => [ "2013-10-20", "2013-10-22", "2013-10-26", ],
    "img023.jpg" => [ "2013-11-03", "2013-11-10", "2013-11-17", ],
    "img024.jpg" => [ "2013-11-18", "2013-11-19", "2013-11-20", "2013-11-21", ],
    "img025.jpg" => [ "2013-11-23", "2013-11-24", "2013-12-01", "2013-12-02", "2013-12-08", ],
    "img026.jpg" => [ "2013-12-10", "2013-12-15", "2013-12-16", ],
    "img027.jpg" => [ "2014", "2013-12-18", "2013-12-22", "2014-01-13", "2014-01-23", ],
    "img028.jpg" => [ "2014-01-24", "2014-02-05", "2014-02-06", "2014-02-07", ],
    "img029.jpg" => [ "2014-02-11", "2014-02-18", "2014-02-19", "2014-03-06", "2014-03-08", "2014-03-09", ],
    "img030.jpg" => [ "2014-03-16", "2014-03-17", "2014-04-21", ],
    "img031.jpg" => [ "2014-04-21", "2014-04-25", "2014-05-16", "2014-05-26", ],
    "img032.jpg" => [ "2014-05-29", ],
    "img033.jpg" => [ "2014-06-08", ],
    "img034.jpg" => [ "2014-06-19", "2014-06-20", ],
    "img035.jpg" => [ "2014-07-13", "2014-07-15", ],
    "img036.jpg" => [ "2014-07-19", "2014-07-20", "2014-07-23", "2014-07-27", ],
    "img037.jpg" => [ "2014-08-06", "2014-08-08", "2014-08-15", ],
    "img038.jpg" => [ "2014-08-19", "2014-09-14", "2014-09-27", "2014-10-08", ],
    "img039.jpg" => [ "2014-10-12", "2014-12-02", "2014-12-05", "2014-12-06", ],
    "img040.jpg" => [ "2015", "2014-12-20", "2015-01-02", ],
    "img041.jpg" => [ "2015-01-05", "2015-01-10", ],
    "img042.jpg" => [ "2015-01-11", "2015-01-12", ],
    "img043.jpg" => [ "2015-01-13", "2015-01-15", ],
    "img044.jpg" => [ "2015-01-16", "2015-01-18", "2015-01-20", "2015-02-12", ],
    "img045.jpg" => [ "2015-02-22", "2015-02-24", "2015-03-21", "2015-04-21", "2015-04-22", ],
    "img046.jpg" => [ "2015-04-24", "2015-04-26", "2015-04-27", "2015-04-28", ],
    "img047.jpg" => [ "2015-04-29", ],
    "img048.jpg" => [ "2015-04-30", "2015-05-01", "2015-06-29", "2015-07-06", "2015-07-17", ],
    "img049.jpg" => [ "2015-07-19", "2015-07-24", "2015-07-25", "2015-07-27", "2015-07-28", ],
    "img050.jpg" => [ "2015-07-30", "2015-07-31", "2015-08-03", ],
    "img051.jpg" => [ "2016", "2015-08-13", "2015-08-30", "2015-09-19", "2015-09-28", "2015-10-10", "2016-02-03", ],
    "img052.jpg" => [ "2016-02-04", "2016-02-07", "2016-02-08", ],
    "img053.jpg" => [ "2016-02-14", "2016-02-16", "2016-02-20", "2016-03-02", ],
    "img054.jpg" => [ "2016-03-26", "2016-04-10", "2016-07-24", "2016-10-29", "2016-10-31", "2016-11-22", "2016-11-25", "2016-11-26", ],
    "img055.jpg" => [ "2016-12-03", "2016-12-04", ],
    "img056.jpg" => [ "2016-12-05", "2016-12-07", ],
    "img057.jpg" => [ "2016-12-10", "2016-12-11", ],
    "img058.jpg" => [ "2016-12-12", "2016-12-13", ],
    "img059.jpg" => [ "2016-12-17", ],
    
    );
    
# Variable Initialization
# -----------------------
my $logText;
my $logFinder;
my $logDate;
my $logDateLast;
my $logCoordinates;
my $logCoordNDeg;
my $logCoordNMin;
my $logCoordEDeg;
my $logCoordEMin;
my $logCoordLon;
my $logCoordLonLast;
my $logCoordLat;
my $logCoordLatLast;
my $logWptLat;
my $logWptLon;;
my $logCounter = 0;
my $logCoordCounter = 0;
my $currentYear = "XXXX";
my $logYear;
my $logDay;
my $logKey;
my $goodCoordCounter = 0;
my $runningIndex = 0;
my %trkptDate = ();
my %trkptLat = ();
my %trkptLon = ();
my %trkptDist = ();
my %trkptCoords = ();
my %wptFinder = ();
my %yearlyDistance = ();
my %yearlyPositions = ();
my $totalDistance;
my $totalPositions;
my %seenCoordinates = ();
my %logdateToImage = ();

# Needed for the distance calculation subs
my $pi = atan2(1,1) * 4;

# Reverse the imageToLogdate hash
foreach my $imgKey (sort keys( %imageToLogdate)) {
    foreach my $logdateKey (@{$imageToLogdate{$imgKey}}) {
        $logdateToImage{$logdateKey} = $imgKey;
		 
	 }     
}

# Read the exported tds.gpx (XML file) into a variable
# -----------------------------------------------------
my $fh_src = new IO::File('tds.gpx') 
  or die "Can't open tds.gpx: $!\n";
my $XMLgpx = XMLin($fh_src);

# Open the files for writing:
# -----------------------------------------------------
open(my $fh_dst_gpx, ">:encoding(UTF-8)", "tds-route-complete.gpx")
  or die "Couldn't open tds-route-complete.gpx for writing: $!\n";
open(my $fh_dst_txt, ">:encoding(UTF-8)", "tds-route-complete.txt")
  or die "Couldn't open tds-route-complete.txt for writing: $!\n";
open(my $fh_dst_wpt, ">:encoding(UTF-8)", "tds-wpt-complete.gpx")
  or die "Couldn't open tds-wpt-complete.gpx for writing: $!\n";
open(my $fh_dst_position, ">:encoding(UTF-8)", "tds-wpt-position.gpx")
  or die "Couldn't open tds-wpt-position.gpx for writing: $!\n";
open(my $fh_dst_infoStatistics, ">:encoding(UTF-8)", "tds-infoStatistics.js")
  or die "Couldn't open tds-infoStatistics.js for writing: $!\n";
  
# Create the gpx track header
# ---------------------------
printf { $fh_dst_gpx } ( '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>' . "\n" );
printf { $fh_dst_gpx } ( '<gpx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:rmc="urn:net:trekbuddy:1.0:nmea:rmc" creator="QLandkarteGT 1.7.6.post http://www.qlandkarte.org/" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.qlandkarte.org/xmlschemas/v1.1 http://www.qlandkarte.org/xmlschemas/v1.1/ql-extensions.xsd" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:ql="http://www.qlandkarte.org/xmlschemas/v1.1">' . "\n" );
printf { $fh_dst_gpx } ( ' <metadata>' . "\n" );
printf { $fh_dst_gpx } ( '  <time>2014-05-31T16:32:57Z</time>' . "\n" );
printf { $fh_dst_gpx } ( ' </metadata>' . "\n" );

# Create the gpx wpt header
# -------------------------
printf { $fh_dst_wpt } ( '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>' . "\n" );
printf { $fh_dst_wpt } ( '<gpx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:rmc="urn:net:trekbuddy:1.0:nmea:rmc" creator="QLandkarteGT 1.7.6.post http://www.qlandkarte.org/" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.qlandkarte.org/xmlschemas/v1.1 http://www.qlandkarte.org/xmlschemas/v1.1/ql-extensions.xsd" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:ql="http://www.qlandkarte.org/xmlschemas/v1.1">' . "\n" );
printf { $fh_dst_wpt } ( ' <metadata>' . "\n" );
printf { $fh_dst_wpt } ( '  <time>2014-05-31T16:32:57Z</time>' . "\n" );
printf { $fh_dst_wpt } ( ' </metadata>' . "\n" );

# Create the gpx position header
# -------------------------------
printf { $fh_dst_position } ( '<?xml version="1.0" encoding="UTF-8" standalone="no" ?>' . "\n" );
printf { $fh_dst_position } ( '<gpx xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" version="1.1" xmlns:gpxtpx="http://www.garmin.com/xmlschemas/TrackPointExtension/v1" xmlns="http://www.topografix.com/GPX/1/1" xmlns:rmc="urn:net:trekbuddy:1.0:nmea:rmc" creator="QLandkarteGT 1.7.6.post http://www.qlandkarte.org/" xmlns:wptx1="http://www.garmin.com/xmlschemas/WaypointExtension/v1" xsi:schemaLocation="http://www.topografix.com/GPX/1/1 http://www.topografix.com/GPX/1/1/gpx.xsd http://www.garmin.com/xmlschemas/GpxExtensions/v3 http://www.garmin.com/xmlschemas/GpxExtensionsv3.xsd http://www.garmin.com/xmlschemas/TrackPointExtension/v1 http://www.garmin.com/xmlschemas/TrackPointExtensionv1.xsd http://www.garmin.com/xmlschemas/WaypointExtension/v1 http://www.garmin.com/xmlschemas/WaypointExtensionv1.xsd http://www.qlandkarte.org/xmlschemas/v1.1 http://www.qlandkarte.org/xmlschemas/v1.1/ql-extensions.xsd" xmlns:gpxx="http://www.garmin.com/xmlschemas/GpxExtensions/v3" xmlns:ql="http://www.qlandkarte.org/xmlschemas/v1.1">' . "\n" );
printf { $fh_dst_position } ( ' <metadata>' . "\n" );
printf { $fh_dst_position } ( '  <time>2014-05-31T16:32:57Z</time>' . "\n" );
printf { $fh_dst_position } ( ' </metadata>' . "\n" );

# Create the infoStatistics header
# ---------------------------------
printf { $fh_dst_infoStatistics } ( 'var tdsInfoHeader = \'<h2>Tour de Suisse</h2><p>' );
printf { $fh_dst_infoStatistics } ( '<a target=\"_blank\" href=\"https://coord.info/GCQG54\">https://coord.info/GCQG54</a></p>' );
printf { $fh_dst_infoStatistics } ( "<h3>J&auml;hrliche Statistiken</h3>\';\n" );
printf { $fh_dst_infoStatistics } ( 'var tdsInfoStatistics = \'<pre>' );


# Loop through all the log entries, sorted by ID (to ensure chronology ?? which is unfortunately wrong)
# -----------------------------------------------------------------------------------------------------
foreach my $logID (sort {$a <=> $b} keys( %{$XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}})) {

  # Increase the Log Counter
  # ------------------------
  $logCounter += 1;

  # Read some values out of the actual log entry
  # ---------------------------------------------
  $logFinder = $XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}{$logID}->{'groundspeak:finder'}{content};
  $logText = $XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}{$logID}->{'groundspeak:text'}{content};
  $logDate = $XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}{$logID}->{'groundspeak:date'};
  
  # We need to convert the finder name into proper xml encoding
  # -----------------------------------------------------------
  $logFinder =~ s/&/&amp;/g;
  $logFinder =~ s/</&lt;/g;
  $logFinder =~ s/>/&gt;/g;
  $logFinder =~ s/"/&quot;/g;
  $logFinder =~ s/'/&apos;/g;
  
  # Read the eventually set log wpt coordinates
  # -------------------------------------------
  $logWptLat = $XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}{$logID}->{'groundspeak:log_wpt'}{lat};
  $logWptLon = $XMLgpx->{wpt}->{'groundspeak:cache'}->{'groundspeak:logs'}->{'groundspeak:log'}{$logID}->{'groundspeak:log_wpt'}{lon};
  
  # Try to read the coordinates out of the log entry
  # ------------------------------------------------
  $logCoordinates = "";
  
  # Do we have overridden coordinates ?
  if ( exists $logidOverride{$logID} ) {
    $logText =  $logidOverride{$logID};
    printf { *STDERR } ( "Coordinates override : %-22s: Date: %s Finder: %-20s LogID: %s\n", $logID, $logDate, $logFinder, $logDay . "-" . $logID);      
  }
  # Catching proper coordinates with colons first
	if ( $logText =~ /:\D*(4[567])\D*:\D*(\d\d?)\D+(\d\d\d)\D*:\D*0?0?(5|6|7|8|9|10)\D*:\D*(\d\d?)\D+(\d\d\d)\D+/u ) {
    $logCoordNDeg = sprintf ( "%02d", $1);
    $logCoordNMin = sprintf ( "%02d.%03d", $2, $3);
    $logCoordEDeg = sprintf ( "%03d", $4);
    $logCoordEMin = sprintf ( "%02d.%03d", $5, $6);
    $logCoordinates = "N$logCoordNDeg $logCoordNMin E$logCoordEDeg $logCoordEMin" ;
	}  
  # Catching proper coordinates also without colons
	elsif ( $logText =~ /(4[567])\D+(\d\d?)\D+(\d\d\d)\D+0?0?(5|6|7|8|9|10)\D+(\d\d?)\D+(\d\d\d)/u ) {
    $logCoordNDeg = sprintf ( "%02d", $1);
    $logCoordNMin = sprintf ( "%02d.%03d", $2, $3);
    $logCoordEDeg = sprintf ( "%03d", $4);
    $logCoordEMin = sprintf ( "%02d.%03d", $5, $6);
    $logCoordinates = "N$logCoordNDeg $logCoordNMin E$logCoordEDeg $logCoordEMin" ;
	}  
  # : 4 6 : 47 .245 : 007 : 28.067 : Zombi1980 :
	elsif ( $logText =~ /(4) ([567])\D+(\d\d?)\D+(\d\d\d)\D+0?0?(5|6|7|8|9|10)\D+(\d\d?)\D+(\d\d\d)/u ) {
    $logCoordNDeg = sprintf ( "%1d%1d", $1, $2);
    $logCoordNMin = sprintf ( "%02d.%03d", $3, $4);
    $logCoordEDeg = sprintf ( "%03d", $5);
    $logCoordEMin = sprintf ( "%02d.%03d", $6, $7);
    $logCoordinates = "N$logCoordNDeg $logCoordNMin E$logCoordEDeg $logCoordEMin" ;
	}    

  # Do things depending on if we found coordinates or not
  # -----------------------------------------------------
  # Ok, we found coordinates
  # ------------------------
  if ( $logCoordinates ne "" ) {
    
    # did we see this coordinates already ?
    if ( exists $seenCoordinates{$logCoordinates} ) {
      
      # Drop some info about the duplicate Coordinates found
      printf { *STDERR } ( "Duplicate Coordinates: %-22s: Date: %s Finder: %-20s LogID: %s\n", $logCoordinates, $logDate, $logFinder, $logDay . "-" . $logID);
      
    }

    # is this logID on the blacklist ?
    elsif ( exists $logidBlackList{$logID} ) {
      
      # Drop some info about the Blacklisted Log
      printf { *STDERR } ( "Blacklisted Log Entry: %-22s: Date: %s Finder: %-20s LogID: %s\n", $logID, $logDate, $logFinder, $logDay . "-" . $logID);
      
    }
    
    # not seen this coordinates yet and not on blacklist, consider them valid
    else {
      
      # Increase the Coordinate Counter
      # -------------------------------
      $logCoordCounter += 1;
      
      # Calculate the missing Coordinate Values
      # ---------------------------------------
      $logCoordLat = $logCoordNDeg + $logCoordNMin/60;
      $logCoordLon = $logCoordEDeg + $logCoordEMin/60;  
      	
	    # Filter the day out of the logDate
	    # ---------------------------------
	    $logDay = $logDate;
	    $logDay =~ /(\d\d\d\d-\d\d-\d\d)T.*/;
	    $logDay = $1;
      
	    # Let's create a sort key
	    # ----------------------
	    # 2014-06-19T18:59:59Z
 	    # both logid and date are problematic, quite good results with date+logid... but not always
	    # $logKey = $logDate . "-" . $logID;
	    $logKey = $logDay . "-" . $logID;
      
      # Fill the hash by using this sort keyAs we need to sort later on by date we save the stuff with a sortable unique key: date+logid
      # --------------------------------------------------------------------------------------------
      $trkptDate{ $logKey } = $logDate;
      $trkptLat{ $logKey }  = $logCoordLat;
      $trkptLon{ $logKey }  = $logCoordLon;
      $trkptCoords{ $logKey } = $logCoordinates;
      $wptFinder{ $logKey } = $logFinder; 
      
      # Put the coordinate into the seenCoordinates list
      # ------------------------------------------------
      $seenCoordinates{$logCoordinates}=$logCounter;     
      
    }
    

	}
  else {
 
    # No coordinates found, nothing to do right now

  }
 
}


# We need to know how many entries we have
# ----------------------------------------
$goodCoordCounter = keys %wptFinder;

# Loop through to calculate yearly summaries
# --------------------------------------------
$runningIndex = 0;
foreach my $logKey (sort keys( %trkptDate)) {

  # Update the index
  # ----------------
  $runningIndex += 1;

  # Get the log Year (for splitting the tracks up into years)
  # ---------------------------------------------------------
  $logYear = $trkptDate{$logKey};
  $logYear =~ /(\d\d\d\d).*/;
  $logYear = $1;

  # Calculate Distance from last Coordinates
  if ( $runningIndex == "1" ) {  
    $trkptDist{ $logKey } = "0";
  }
  else {
    #Calculate the distance
    $trkptDist { $logKey } = distance( $trkptLat{ $logKey }, $trkptLon{ $logKey }, $logCoordLatLast, $logCoordLonLast, "K" );
  }
  $logCoordLatLast = $trkptLat{ $logKey };
  $logCoordLonLast = $trkptLon{ $logKey };
    
  # Create the output in the text file
  # ----------------------------------
  printf { $fh_dst_txt } ( "%04d  %6.3f km  %25s  %-40s  %-20s\n", $runningIndex, $trkptDist{ $logKey }, $trkptDate{ $logKey }, $wptFinder{ $logKey }, $trkptCoords{ $logKey });

  # Sum and count
  $yearlyDistance{ $logYear } += $trkptDist{$logKey};
  $yearlyPositions{ $logYear } += 1;
  
  # Grand Total
  $totalDistance += $trkptDist{$logKey};
  $totalPositions += 1;
  
}

# Put an empty line into the text file
printf { $fh_dst_txt } ( "\n" );

# Now we have to loop again to sort the stuff correctly for the track
# -------------------------------------------------------------------
$runningIndex = 0;
foreach my $logKey (sort keys( %trkptDate)) {

  # Update the index
  # ----------------
  $runningIndex += 1;

  # Get the log Year (for splitting the tracks up into years)
  # ---------------------------------------------------------
  $logYear = $trkptDate{$logKey};
  $logYear =~ /(\d\d\d\d).*/;
  $logYear = $1;
  
  # Create the date only (no time information), needed for image lookup
  $logDay = $trkptDate{$logKey};
  $logDay =~ /(\d\d\d\d-\d\d-\d\d)T.*/;
  $logDay = $1;

  # Debug only
  #printf { *STDERR } ( "%s\n", $logKey);

  # Create this trackpoint in the gpx file
  # --------------------------------------
  # First let's check if we need to start a new track (changing year)
  if ( $logYear ne $currentYear ) {
    
    if ( $currentYear ne "XXXX" ) {
      # New year but not the first one - we need to finish the existing track first before starting the new one
      printf { $fh_dst_gpx } ( "  </trkseg>\n" );
      printf { $fh_dst_gpx } ( " </trk>\n" );
    }
    
    # Now we can start the new track  
    printf { $fh_dst_gpx } ( ' <trk>' . "\n" );
    printf { $fh_dst_gpx } ( '  <name>Tour de Suisse (GCQG54) - Route ' . $logYear . '</name>' . "\n" );
    printf { $fh_dst_gpx } ( "  <desc>Total Pos.: $yearlyPositions{ $logYear } / Total Dist.: %.3f km</desc>\n", $yearlyDistance{ $logYear } );
     # Do we have an online logbook entry for this date ?
     if ( exists $logdateToImage{$logYear} ) {
	      #printf { $fh_dst_wpt } ( "    <keywords>http://test.whatsoever.com/%s\</keywords>\n", $logdateToImage{$logDay} );		 
	      printf { $fh_dst_gpx } ( "    <link>%s#%s\</link>\n", $onlineLogbookBaseURL,$logdateToImage{$logYear} );		 
		 }
    printf { $fh_dst_gpx } ( '  <trkseg>' . "\n" );
    
    # Do some printout to console and into the text file
    printf { *STDERR }     ( "%s  %4d Positionen  %8.3f km\n", $logYear, $yearlyPositions{ $logYear }, $yearlyDistance{ $logYear });
    printf { $fh_dst_txt } ( "%s  %4d Positionen  %8.3f km\n", $logYear, $yearlyPositions{ $logYear }, $yearlyDistance{ $logYear });

    # Create the output in the infoStatistics file
    # --------------------------------------------
    printf { $fh_dst_infoStatistics } ( "%s  %4d Positionen  %8.3f km<br>", $logYear, $yearlyPositions{ $logYear }, $yearlyDistance{ $logYear });    

    # New year but not the first one - we need to repeat last point again
    if ( $currentYear ne "XXXX" ) {
      printf { $fh_dst_gpx } ( '   <trkpt lon="' . $logCoordLonLast . '" lat="' . $logCoordLatLast . '">' . "\n" );
      printf { $fh_dst_gpx } ( "    <time>$logDateLast</time>\n" );
      printf { $fh_dst_gpx } ( "   </trkpt>\n" );
    }
  }
  
  # Now create the trkpt entry itself
  printf { $fh_dst_gpx } ( '   <trkpt lon="' . $trkptLon{$logKey} . '" lat="' . $trkptLat{$logKey} . '">' . "\n" );
  printf { $fh_dst_gpx } ( "    <time>$trkptDate{$logKey}</time>\n" );
  printf { $fh_dst_gpx } ( "   </trkpt>\n" );
  
  # Let's save this Coordinates and Date in case we need to create new track with next pair
  $logCoordLonLast = $trkptLon{$logKey};
  $logCoordLatLast = $trkptLat{$logKey};
  $logDateLast     = $trkptDate{$logKey};
  $currentYear     = $logYear;
 
    
  # Update either the wpt file or the position file
  # -----------------------------------------------
  if ( $runningIndex == $goodCoordCounter ) {
     # we're handling the last position, therefore it needs to go to the position file
     printf { $fh_dst_position } ( '   <wpt lat="' . $trkptLat{$logKey} . '" lon="' . $trkptLon{$logKey} . '">' . "\n" );
     printf { $fh_dst_position } ( "    <time>$trkptDate{$logKey}</time>\n" );
     printf { $fh_dst_position } ( "    <name>$wptFinder{ $logKey }</name>\n" );
     printf { $fh_dst_position } ( "    <desc>Pos.: $runningIndex / Dist.: %.3f km</desc>\n", $trkptDist{$logKey} );
     printf { $fh_dst_position } ( "    <sym>Pin, Blue</sym>\n" );
     printf { $fh_dst_position } ( "   </wpt>\n" );
  }
  else {
     # not the last position, goes into wpt file
     printf { $fh_dst_wpt } ( '   <wpt lat="' . $trkptLat{$logKey} . '" lon="' . $trkptLon{$logKey} . '">' . "\n" );
     printf { $fh_dst_wpt } ( "    <time>$trkptDate{$logKey}</time>\n" );
     printf { $fh_dst_wpt } ( "    <name>$wptFinder{ $logKey }</name>\n" );
     printf { $fh_dst_wpt } ( "    <desc>Pos.: $runningIndex / Dist.: %.3f km</desc>\n", $trkptDist{$logKey} );
     # Do we have an online logbook entry for this date ?
     if ( exists $logdateToImage{$logDay} ) {
	      #printf { $fh_dst_wpt } ( "    <keywords>http://test.whatsoever.com/%s\</keywords>\n", $logdateToImage{$logDay} );		 
	      printf { $fh_dst_wpt } ( "    <link>%s#%s\</link>\n", $onlineLogbookBaseURL,$logdateToImage{$logDay} );		 
		 }
     printf { $fh_dst_wpt } ( "    <sym>Pin, Blue</sym>\n" );
     printf { $fh_dst_wpt } ( "   </wpt>\n" );
  }
  
}


# Finish the GPX file
# -------------------
printf { $fh_dst_gpx } ( "  </trkseg>\n" );
printf { $fh_dst_gpx } ( " </trk>\n" );
printf { $fh_dst_gpx } ( "</gpx>\n" );

# Finish the wpt file
# -------------------
printf { $fh_dst_wpt } ( "</gpx>\n" );

# Finish the position file
# -------------------------
printf { $fh_dst_position } ( "</gpx>\n" );


# Output of a summary to console
# ------------------------------
printf { *STDERR }     ( "\nTotal Positions:   %s\nTotal Kilometer:   %.3f\n\n", $totalPositions, $totalDistance);
printf { *STDERR }     ( "logs:    %s\nCoords:   %s\n", $logCounter, $logCoordCounter);

# Output of a summary to txt file
# -------------------------------
printf { $fh_dst_txt } ( "\nTotal Positions:   %s\nTotal Kilometer:   %.3f\n\n", $totalPositions, $totalDistance);
printf { $fh_dst_txt } ( "logs:    %s\nCoords:   %s\n", $logCounter, $logCoordCounter);

# Output of a summary to infoStatistics file
# ------------------------------------------
printf { $fh_dst_infoStatistics } ( "<br>Total Positionen:  %s<br>Total Kilometer:   %.3f<br></pre>\';", $totalPositions, $totalDistance);



# Close all files
# ---------------
$fh_dst_txt->close;
$fh_dst_gpx->close;
$fh_dst_wpt->close;
$fh_dst_position->close;
$fh_dst_infoStatistics->close;
$fh_src->close;





#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:::                                                                         :::
#:::  This routine calculates the distance between two points (given the     :::
#:::  latitude/longitude of those points). It is being used to calculate     :::
#:::  the distance between two locations using GeoDataSource(TM) products    :::
#:::                                                                         :::
#:::  Definitions:                                                           :::
#:::    South latitudes are negative, east longitudes are positive           :::
#:::                                                                         :::
#:::  Passed to function:                                                    :::
#:::    lat1, lon1 = Latitude and Longitude of point 1 (in decimal degrees)  :::
#:::    lat2, lon2 = Latitude and Longitude of point 2 (in decimal degrees)  :::
#:::    unit = the unit you desire for results                               :::
#:::           where: 'M' is statute miles (default)                         :::
#:::                  'K' is kilometers                                      :::
#:::                  'N' is nautical miles                                  :::
#:::                                                                         :::
#:::  Worldwide cities and other features databases with latitude longitude  :::
#:::  are available at http://www.geodatasource.com	                         :::
#:::                                                                         :::
#:::  For enquiries, please contact sales@geodatasource.com                  :::
#:::                                                                         :::
#:::  Official Web site: http://www.geodatasource.com                        :::
#:::                                                                         :::
#:::            GeoDataSource.com (C) All Rights Reserved 2015               :::
#:::                                                                         :::
#:::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sub distance {
	my ($lat1, $lon1, $lat2, $lon2, $unit) = @_;
	my $theta = $lon1 - $lon2;
	my $dist = sin(deg2rad($lat1)) * sin(deg2rad($lat2)) + cos(deg2rad($lat1)) * cos(deg2rad($lat2)) * cos(deg2rad($theta));
  $dist  = acos($dist);
  $dist = rad2deg($dist);
  $dist = $dist * 60 * 1.1515;
  if ($unit eq "K") {
  	$dist = $dist * 1.609344;
  } elsif ($unit eq "N") {
  	$dist = $dist * 0.8684;
		}
	return ($dist);
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:::  This function get the arccos function using arctan function   :::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sub acos {
	my ($rad) = @_;
	my $ret = atan2(sqrt(1 - $rad**2), $rad);
	return $ret;
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:::  This function converts decimal degrees to radians             :::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sub deg2rad {
	my ($deg) = @_;
	return ($deg * $pi / 180);
}

#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
#:::  This function converts radians to decimal degrees             :::
#::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
sub rad2deg {
	my ($rad) = @_;
	return ($rad * 180 / $pi);
}
