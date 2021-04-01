

PROGRAM _INIT
	gFinishStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gFinishStationIf.Cfg.StationPos.X := 0.9;
	gFinishStationIf.Cfg.StationPos.Y := 0.9;
		
	stationFbs.BatchProcessFb.Positions[0].X := 0.9;
	stationFbs.BatchProcessFb.Positions[0].Y := 1.26;
	stationFbs.BatchProcessFb.Positions[1].X := 0.9;
	stationFbs.BatchProcessFb.Positions[1].Y := 1.14;
	
	gSysPars.FinishStation.WaitTime := T#1s;
END_PROGRAM