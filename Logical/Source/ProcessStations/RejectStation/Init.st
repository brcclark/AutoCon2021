

PROGRAM _INIT
	gRejectStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	
	gRejectStationIf.Cfg.StationPos.X := 0.78;
	gRejectStationIf.Cfg.StationPos.Y := 0.54;
	//Define station configuration values
	gSysPars.RejectStation.WaitTime := T#2s;
	
	gSysPars.RejectStation.FailPercentage := 101;
END_PROGRAM