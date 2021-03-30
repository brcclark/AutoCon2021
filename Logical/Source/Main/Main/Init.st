

PROGRAM _INIT
	gMainIf.Cfg.ShuttleCount := 4;
	
	//Used to initialize the shuttle indecies.
	FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		gShuttleIf[i].Cfg.ShuttleId := i + 1;
	END_FOR;
	
	FOR i:=0 TO MAX_FILL_STATIONS - 1 DO
		gSysPars.FillStations[i].Vel := 1.0;
		gSysPars.FillStations[i].Accel := 1.0;
		gSysPars.FillStations[i].FillRate := 1.0;
		gSysPars.FillStations[i].FillTime := T#2s;
	END_FOR
	
	gSysPars.TraversalVel := 1.0;
	gSysPars.TraversalAccel := 1.0;
	
END_PROGRAM