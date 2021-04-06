

PROGRAM _INIT
	gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gUnloadStationIf.Cfg.StationPos.X := 0.18;
	gUnloadStationIf.Cfg.StationPos.Y := 0.18;
		
	stationFbs.BatchProcessFb.Positions[0].X := 0.66;
	stationFbs.BatchProcessFb.Positions[0].Y := 0.06;
	stationFbs.BatchProcessFb.Positions[1].X := 0.54;
	stationFbs.BatchProcessFb.Positions[1].Y := 0.06;
	stationFbs.BatchProcessFb.Positions[2].X := 0.42;
	stationFbs.BatchProcessFb.Positions[2].Y := 0.06;
	stationFbs.BatchProcessFb.Positions[3].X := 0.30;
	stationFbs.BatchProcessFb.Positions[3].Y := 0.06;
	
	//gSysPars.UnloadStation.WaitTime := T#2s;
	
END_PROGRAM