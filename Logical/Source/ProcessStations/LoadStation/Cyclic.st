
PROGRAM _CYCLIC
	
	IF NOT gLoadStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.LoadStation;
	END_IF
	
	CASE state OF
		LOAD_OFF: //********************************************************************************Load station is currently disabled
			IF gLoadStationIf.Cmd.Enable THEN
				state := LOAD_INIT;
			END_IF
		LOAD_INIT: //********************************************************************************Load station is initalizing
			gLoadStationIf.Sts.ReadyForNewShuttle := TRUE;
			gLoadStationIf.Sts.Enabled := TRUE;
			state := LOAD_WAIT_FOR_SHUTTLE;
		LOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			IF NOT gLoadStationIf.Cmd.Enable THEN
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStationIf.Sts.Enabled := FALSE;
				state := LOAD_OFF;
			ELSIF gLoadStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gLoadStationIf.Cmd.Process THEN
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStationIf.Sts.Processing := TRUE;
				
				LoadStationFbs.LoadTimerFb.IN := TRUE;
				LoadStationFbs.LoadTimerFb.PT := stationPars.WaitTime;
				
				state := LOAD_LOADING;
			END_IF
		LOAD_LOADING: //********************************************************************************Load station is loading product onto a shuttle
			IF LoadStationFbs.LoadTimerFb.Q THEN
				LoadStationFbs.LoadTimerFb.IN := FALSE;
				
				gLoadStationIf.Sts.Processing := FALSE;
				gShuttleIf[gLoadStationIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				gLoadStationIf.Sts.Done := TRUE;
				
				//Assign the shuttle a recipe
				gShuttleIf[gLoadStationIf.Par.ShuttleIdx].Par.Recipe := recipes;
				gShuttleIf[gLoadStationIf.Par.ShuttleIdx].Sts.ProductInfo.Loaded := TRUE;
				
				state := LOAD_DONE;
			END_IF
		LOAD_DONE: //********************************************************************************Load station is done with the load process
			IF NOT gLoadStationIf.Cmd.Enable THEN
				gLoadStationIf.Sts.Done := FALSE;
				gLoadStationIf.Sts.Enabled := FALSE;
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				state := LOAD_OFF;
			ELSIF NOT gLoadStationIf.Cmd.Process THEN
				gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gLoadStationIf.Sts.Done := FALSE;
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStationIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := LOAD_WAIT_FOR_SHUTTLE;
			END_IF
			
		LOAD_ERROR: //********************************************************************************Load station had an error
			IF gLoadStationIf.Cmd.Reset THEN
				gLoadStationIf.Cmd.Reset := FALSE;
				
				gLoadStationIf.Sts.Done := FALSE;
				gLoadStationIf.Sts.Enabled := FALSE;
				gLoadStationIf.Sts.Error := FALSE;
				gLoadStationIf.Sts.Processing := FALSE;
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				
				gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gLoadStationIf.Cmd.Enable THEN
					state := LOAD_INIT;
				ELSE
					state := LOAD_OFF;
				END_IF
			END_IF
	END_CASE;
		
	 LoadStationFbs.LoadTimerFb();
END_PROGRAM
