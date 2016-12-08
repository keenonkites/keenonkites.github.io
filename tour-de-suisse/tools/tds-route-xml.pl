use strict;
use warnings;
use XML::Simple;
use IO::File;
use Data::Dumper;


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
my %wptFinder = ();
my %yearlyDistance = ();
my %yearlyPositions = ();
my $totalDistance;
my $totalPositions;

# Needed for the distance calculation subs
my $pi = atan2(1,1) * 4;

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
	if ( $logText =~ /(4[567])\D+(\d\d?)\D+(\d\d\d)\D+0?0?(5|6|7|8|9|10)\D+(\d\d?)\D+(\d\d\d)/u ) {
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

    # Calculate Distance from last Coordinates
    if ( $logCoordCounter == "1" ) {  
      $trkptDist{ $logKey } = "0";
      $logCoordLatLast = $logCoordLat;
      $logCoordLonLast = $logCoordLon;
    }
    else {
      #Calculate the distance
      $trkptDist { $logKey } = distance( $logCoordLat, $logCoordLon, $logCoordLatLast, $logCoordLonLast, "K" );
    }
    $logCoordLatLast = $logCoordLat;
    $logCoordLonLast = $logCoordLon;
    
    # Create the output in the text file
    # ----------------------------------
    printf { $fh_dst_txt } ( "%04d  %6.3f km  %25s  %-40s  %-20s\n", $logCoordCounter, $trkptDist { $logKey }, $logDate, $logFinder, $logCoordinates);
	
	  # Save the finder for later re-use when creating the wpt files
	  # ------------------------------------------------------------
	  $wptFinder{ $logKey } = $logFinder;

	}
  else {
 
    # No coordinates found, nothing to do right now

  }
 
}

# Put an empty line into the text file
printf { $fh_dst_txt } ( "\n" );


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
  
  # Sum and count
  $yearlyDistance{ $logYear } += $trkptDist{$logKey};
  $yearlyPositions{ $logYear } += 1;
  
  # Grand Total
  $totalDistance += $trkptDist{$logKey};
  $totalPositions += 1;
  
}

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
    printf { $fh_dst_gpx } ( '  <trkseg>' . "\n" );
    
    # Do some printout to console and into the text file
    printf { *STDERR }     ( "%s  %4d Positionen  %8.3f km\n", $logYear, $yearlyPositions{ $logYear }, $yearlyDistance{ $logYear });
    printf { $fh_dst_txt } ( "%s  %4d Positionen  %8.3f km\n", $logYear, $yearlyPositions{ $logYear }, $yearlyDistance{ $logYear });

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


# Output of a summary
# -------------------
printf { *STDERR }     ( "\nTotal Positions:    %s\nTotal Kilometer:   %.3f\n\n", $totalPositions, $totalDistance);
printf { $fh_dst_txt } ( "\nTotal Positions:    %s\nTotal Kilometer:   %.3f\n\n", $totalPositions, $totalDistance);
printf { *STDERR }     ( "logs:    %s\nCoords:   %s\n", $logCounter, $logCoordCounter);
printf { $fh_dst_txt } ( "logs:    %s\nCoords:   %s\n", $logCounter, $logCoordCounter);


# Close all files
# ---------------
$fh_dst_txt->close;
$fh_dst_gpx->close;
$fh_dst_wpt->close;
$fh_dst_position->close;
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
