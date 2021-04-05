

PROGRAM _INIT
	ST_name(0,ADR(taskName),0);

	IF taskName = 'FillSt1' THEN
		pFillIf ACCESS ADR(gFillStationsIf[0]);
		stationPars ACCESS ADR(gSysPars.FillStations[0]);
		station := ST1;
	ELSIF taskName = 'FillSt2' THEN
		pFillIf ACCESS ADR(gFillStationsIf[1]);
		stationPars ACCESS ADR(gSysPars.FillStations[1]);
		station := ST2;
	ELSIF taskName = 'FillSt3' THEN
		pFillIf ACCESS ADR(gFillStationsIf[2]);
		stationPars ACCESS ADR(gSysPars.FillStations[2]);
		station := ST3;
	ELSIF taskName = 'FillSt4' THEN
		pFillIf ACCESS ADR(gFillStationsIf[3]);
		stationPars ACCESS ADR(gSysPars.FillStations[3]);
		station := ST4;
	END_IF
	
	//Absolute entrance pos
	gFillStationsIf[0].Cfg.EnterPos.X := 1.50;
	gFillStationsIf[0].Cfg.EnterPos.Y := 0.30;
	//Station center
	gFillStationsIf[0].Cfg.StationPos.X := 1.56;
	gFillStationsIf[0].Cfg.StationPos.Y := 0.12;
	//Absolute exit position
	gFillStationsIf[0].Cfg.ExitPos.X := 1.62;
	gFillStationsIf[0].Cfg.ExitPos.Y := 0.3;
	
	gFillStationsIf[1].Cfg.EnterPos.X := 1.98;
	gFillStationsIf[1].Cfg.EnterPos.Y := 0.3;
	gFillStationsIf[1].Cfg.StationPos.X := 2.04;
	gFillStationsIf[1].Cfg.StationPos.Y := 0.12;
	gFillStationsIf[1].Cfg.ExitPos.X := 2.1;
	gFillStationsIf[1].Cfg.ExitPos.Y := 0.3;
	
	gFillStationsIf[2].Cfg.ExitPos.X := 1.98;
	gFillStationsIf[2].Cfg.ExitPos.Y := 0.9;
	gFillStationsIf[2].Cfg.StationPos.X := 2.04;
	gFillStationsIf[2].Cfg.StationPos.Y := 1.08;
	gFillStationsIf[2].Cfg.EnterPos.X := 2.1;
	gFillStationsIf[2].Cfg.EnterPos.Y := 0.9;
	
	gFillStationsIf[3].Cfg.ExitPos.X := 1.50;
	gFillStationsIf[3].Cfg.ExitPos.Y := 0.9;
	gFillStationsIf[3].Cfg.StationPos.X := 1.56;
	gFillStationsIf[3].Cfg.StationPos.Y := 1.08;
	gFillStationsIf[3].Cfg.EnterPos.X := 1.62;
	gFillStationsIf[3].Cfg.EnterPos.Y := 0.9;
	
	pFillIf.Par.ShuttleIdx := STATION_IS_EMPTY;
	
	stationPars.Vel := 1.0;
	stationPars.Accel := 10.0;
	
	FillStationFbs.St1Fb.LinearVel := 0.5;// m/s
	FillStationFbs.St1Fb.ShortAxisRotVel := 1.0;//rad/s
END_PROGRAM