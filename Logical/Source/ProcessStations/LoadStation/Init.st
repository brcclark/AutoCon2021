

PROGRAM _INIT
	gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gLoadStationIf.Cfg.StationPos.X := 0.9;
	gLoadStationIf.Cfg.StationPos.Y := 0.06;
		
	stationFbs.BatchProcessFb.Positions[0].X := 1.14;
	stationFbs.BatchProcessFb.Positions[0].Y := 0.06;
	stationFbs.BatchProcessFb.Positions[1].X := 1.02;
	stationFbs.BatchProcessFb.Positions[1].Y := 0.06;
	
	gSysPars.LoadStation.WaitTime := T#2s;
	
	//Currently the first station must be 1 and the last station must be 4
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