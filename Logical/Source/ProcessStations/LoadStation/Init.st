

PROGRAM _INIT
	gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gLoadStationIf.Cfg.StationPos.X := 1.02;
	gLoadStationIf.Cfg.StationPos.Y := 0.06;
	
	gSysPars.LoadStation.WaitTime := T#2s;
	
	recipes[0].Fills[0] := 1;
	recipes[0].Fills[1] := 2;
	recipes[0].Fills[2] := 3;
	recipes[0].Fills[3] := 4;
	
	recipes[1].Fills[0] := 1;
	recipes[1].Fills[1] := 3;
	recipes[1].Fills[2] := 4;
	recipes[1].Fills[3] := 0;
	
	recipes[2].Fills[0] := 1;
	recipes[2].Fills[1] := 2;
	recipes[2].Fills[2] := 4;
	recipes[2].Fills[3] := 0;
END_PROGRAM