

PROGRAM _INIT
	FOR i:=0 TO MAX_SHUTTLE_COUNT-1 DO
		gShuttleIf[i].Par.MacroIDs.Fill4ToFill1 := MACR_FILL_4_TO_FILL_1;
	END_FOR;
	fillEntry.X := 1.5;
	fillEntry.Y := 0.540;
	fillExit.X := 1.5;
	fillExit.Y := 0.660;
END_PROGRAM