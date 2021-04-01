

PROGRAM _INIT
	ST_name(0,ADR(taskName),0);
	
	IF taskName = 'WeighSt1' THEN
		pWeighIf ACCESS ADR(gWeighStationIf[0]);
		stationPars ACCESS ADR(gSysPars.WeighStations[0]);
		
		pWeighIf.Par.ShuttleIdx := STATION_IS_EMPTY;
		pWeighIf.Cfg.StationPos.X := 1.14;
		pWeighIf.Cfg.StationPos.Y := 0.9;
	ELSIF taskName = 'WeighSt2' THEN
		pWeighIf ACCESS ADR(gWeighStationIf[1]);
		stationPars ACCESS ADR(gSysPars.WeighStations[1]);
		
		pWeighIf.Par.ShuttleIdx := STATION_IS_EMPTY;
		pWeighIf.Cfg.StationPos.X := 1.02;
		pWeighIf.Cfg.StationPos.Y := 0.9;
	END_IF
	//Define station configuration values
	
	FOR i:=0 TO MAX_WEIGH_STATIONS - 1 DO
		gSysPars.WeighStations[i].WaitTime := T#300ms;	
		gSysPars.WeighStations[i].MinWeight := 4300;
		gSysPars.WeighStations[i].MaxWeight := 4320;
	END_FOR;
END_PROGRAM