

PROGRAM _INIT
	gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	//Define station configuration values
	gBufferAreaIf.Cfg.StationPos.X := 0.54; 
	gBufferAreaIf.Cfg.StationPos.Y := 0.00; //Y value isn't used really for the buffer area
	
	gSysPars.BufferArea.MinBufferSize := 8;
END_PROGRAM