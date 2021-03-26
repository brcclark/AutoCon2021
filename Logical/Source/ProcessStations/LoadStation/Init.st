

PROGRAM _INIT
	gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gLoadStationIf.Cfg.StationPos.X := 1.02;
	gLoadStationIf.Cfg.StationPos.Y := 0.06;
	
	gSysPars.LoadStation.WaitTime := T#2s;
	
	recipes.Fills[0] := 1;
	recipes.Fills[1] := 2;
	recipes.Fills[2] := 3;
	recipes.Fills[3] := 4;
END_PROGRAM