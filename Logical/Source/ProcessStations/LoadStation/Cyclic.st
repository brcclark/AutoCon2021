
PROGRAM _CYCLIC
	//System operates a batching setup
	//Need two seperate state machines
	//One controls the ouside interface, basically the same as before
	
	//Second is the internal one, communicates to the external interface as well
	//Process
	
	
	//External state machine
	//Waits for a shuttle to be ready
	//When a shuttle is commanded to process
	//Inform the internal state machine a shuttle has arrived
	//Wait for acknowledge, go back to the Wait state
	
	//FB perhaps?
	//Internal state machine
	//Wait for a shuttle command
	//Send that shuttle to the appropriate destination
		// If the shuttle count is = # of stations, wait for the move to be done
			//Preform the process
		//Else 
			//Head back to wait for a more shuttles
	
	IF NOT gLoadStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.LoadStation;
	END_IF
	
	CASE state OF
		LOAD_OFF: //********************************************************************************Load station is currently disabled
			IF gLoadStationIf.Cmd.Enable THEN
				stationFbs.BatchProcessFb.Controller := ADR(gMcAcp6DController);
				stationFbs.BatchProcessFb.Enable := TRUE;
												
				state := LOAD_INIT;
			END_IF
		LOAD_INIT: //********************************************************************************Load station is initalizing
			IF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gLoadStationIf.Sts.ReadyForNewShuttle := TRUE;
				gLoadStationIf.Sts.Enabled := TRUE;
				state := LOAD_WAIT_FOR_SHUTTLE;
			END_IF			
		LOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Load station is waiting for a shuttle to be present
			stationFbs.BatchProcessFb.ProcessingTime := stationPars.WaitTime;
			IF NOT gLoadStationIf.Cmd.Enable THEN
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gLoadStationIf.Sts.Enabled := FALSE;
				state := LOAD_OFF;
			ELSIF gLoadStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gLoadStationIf.Cmd.Process THEN
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
								
				stationFbs.BatchProcessFb.ShId := gShuttleIf[gLoadStationIf.Par.ShuttleIdx].Cfg.ShuttleId;
				stationFbs.BatchProcessFb.ProcessShuttle := TRUE;
				
				state := LOAD_CHECK_BUFFER;
			END_IF
		LOAD_CHECK_BUFFER:
			IF stationFbs.BatchProcessFb.Processsing THEN
				gLoadStationIf.Sts.Processing := TRUE;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				gRobotIf[Load_Robot].Cmd.Run := TRUE;
				
				state := LOAD_LOADING;
			ELSIF stationFbs.BatchProcessFb.ReadyForShuttle THEN
								
				gLoadStationIf.Sts.ReadyForNewShuttle := TRUE;
				gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				
				state := LOAD_WAIT_FOR_SHUTTLE;
			END_IF
		LOAD_LOADING: //********************************************************************************Load station is loading product onto a shuttle
			IF setLoad THEN
				setLoad := FALSE;
				FOR i:=0 TO MAX_BATCH_SHUTTLE_COUNT -1 DO
					//WARNING WARNING THIS ID - 1 WILL ONLY WORK WITH SEQUENTIAL IDS. IF YOU USE ABSOLUTE ID THIS WILL NOT WORK
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Sts.ProductInfo.Loaded := TRUE;
				END_FOR;
			END_IF
			IF stationFbs.BatchProcessFb.Error THEN
				gLoadStationIf.Sts.Error := TRUE;
				state := LOAD_ERROR;
			ELSIF stationFbs.BatchProcessFb.BatchComplete AND gRobotIf[Load_Robot].Sts.Done THEN
				gRobotIf[Load_Robot].Cmd.Run := FALSE;
				
				stationFbs.BatchProcessFb.Reset := TRUE;
				gLoadStationIf.Cmd.Process := FALSE;
				
				gLoadStationIf.Sts.Processing := FALSE;
				FOR i:=0 TO MAX_BATCH_SHUTTLE_COUNT -1 DO
					//WARNING WARNING THIS ID - 1 WILL ONLY WORK WITH SEQUENTIAL IDS. IF YOU USE ABSOLUTE ID THIS WILL NOT WORK
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Cmd.NextStep := TRUE; 
					
					//Assign the shuttle a recipe
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Par.Recipe := recipes[recipeCounter];
					recipeCounter:= recipeCounter + 1;
					IF recipeCounter = 3 THEN
						recipeCounter := 0;
					END_IF
				END_FOR;
				
				gLoadStationIf.Sts.Done := TRUE;
				
				state := LOAD_DONE;
			END_IF
		LOAD_DONE: //********************************************************************************Load station is done with the load process
			IF NOT gLoadStationIf.Cmd.Enable THEN
				gLoadStationIf.Sts.Done := FALSE;
				gLoadStationIf.Sts.Enabled := FALSE;
				gLoadStationIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.BatchProcessFb.Enable := FALSE;
				
				gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := LOAD_OFF;
			ELSIF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gLoadStationIf.Cmd.Process := FALSE;
				gLoadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gLoadStationIf.Sts.Done := FALSE;
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
		
	 stationFbs.BatchProcessFb();
END_PROGRAM
