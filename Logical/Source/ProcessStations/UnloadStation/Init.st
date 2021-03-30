

PROGRAM _INIT
	gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gUnloadStationIf.Cfg.StationPos.X := 0.54;
	gUnloadStationIf.Cfg.StationPos.Y := 0.06;
	
	gSysPars.UnloadStation.WaitTime := T#2s;
END_PROGRAM