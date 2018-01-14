// Variable Initialisation
var stopoverCoords = [];
var stopoverName = [];
var stopoverIndex = 0;
var stopoverFound = 0;
var stringStopover = "Zwischenenziel / Stopover ";

// Stopovers - passed
// ------------------
stopoverCoords[stopoverIndex] = [47.013885, 7.959830];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Änziloch");
stopoverName[stopoverIndex]   = stopoverName[stopoverIndex].concat ( "<br>30/05/2017 icklesidi");
stopoverIndex++;

stopoverCoords[stopoverIndex] = [47.189609, 8.175466];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Blosenbergturm");
stopoverName[stopoverIndex]   = stopoverName[stopoverIndex].concat ( "<br>16/07/2017 w-b-k-r");
stopoverIndex++;

stopoverCoords[stopoverIndex] = [47.352014, 8.509486];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Schützenhaus Albisgüetli");
stopoverName[stopoverIndex]   = stopoverName[stopoverIndex].concat ( "<br>02/12/2017 MCAarau");
stopoverIndex++;

stopoverFound = stopoverIndex;

// Stopovers - future
// ------------------
stopoverCoords[stopoverIndex] = [47.696911, 8.639903];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Munot Schaffhausen");
stopoverIndex++;

stopoverCoords[stopoverIndex] = [47.666637, 8.981765];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Rathaus Steckborn");
stopoverIndex++;

stopoverCoords[stopoverIndex] = [47.559705, 9.377272];
stopoverName[stopoverIndex]   = stringStopover.concat ( stopoverIndex + 1, "<br>Dampflock Locorama Romanshorn");
stopoverIndex++;




