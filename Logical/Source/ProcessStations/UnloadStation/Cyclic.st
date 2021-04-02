
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
	
	IF NOT gUnloadStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.UnloadStation;
	END_IF
	
	CASE state OF
		UNLOAD_OFF: //********************************************************************************Unload station is currently disabled
			IF gUnloadStationIf.Cmd.Enable THEN
				stationFbs.BatchProcessFb.Controller := ADR(gMcAcp6DController);
				stationFbs.BatchProcessFb.Enable := TRUE;
												
				state := UNLOAD_INIT;
			END_IF
		UNLOAD_INIT: //********************************************************************************Unload station is initalizing
			IF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := TRUE;
				gUnloadStationIf.Sts.Enabled := TRUE;
				state := UNLOAD_WAIT_FOR_SHUTTLE;
			END_IF			
		UNLOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Unload station is waiting for a shuttle to be present
			stationFbs.BatchProcessFb.ProcessingTime := stationPars.WaitTime;
			IF NOT gUnloadStationIf.Cmd.Enable THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gUnloadStationIf.Sts.Enabled := FALSE;
				state := UNLOAD_OFF;
			ELSIF gUnloadStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gUnloadStationIf.Cmd.Process THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
								
				stationFbs.BatchProcessFb.ShId := gShuttleIf[gUnloadStationIf.Par.ShuttleIdx].Cfg.ShuttleId;
				stationFbs.BatchProcessFb.ProcessShuttle := TRUE;
				
				state := UNLOAD_CHECK_BUFFER;
			END_IF
		UNLOAD_CHECK_BUFFER:
			IF stationFbs.BatchProcessFb.Processsing THEN
				gUnloadStationIf.Sts.Processing := TRUE;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				
				state := UNLOAD_UNLOADING;
			ELSIF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := TRUE;
				gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				
				state := UNLOAD_WAIT_FOR_SHUTTLE;
			END_IF
		UNLOAD_UNLOADING: //********************************************************************************Unload station is loading product onto a shuttle
			IF stationFbs.BatchProcessFb.Error THEN
				gUnloadStationIf.Sts.Error := TRUE;
				state := UNLOAD_ERROR;
			ELSIF stationFbs.BatchProcessFb.BatchComplete THEN
				stationFbs.BatchProcessFb.Reset := TRUE;
				gUnloadStationIf.Cmd.Process := FALSE;
				
				gUnloadStationIf.Sts.Processing := FALSE;
				FOR i:=0 TO MAX_BATCH_SHUTTLE_COUNT -1 DO
					//WARNING WARNING THIS ID - 1 WILL ONLY WORK WITH SEQUENTIAL IDS. IF YOU USE ABSOLUTE ID THIS WILL NOT WORK
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Cmd.NextStep := TRUE; 
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Sts.ProductInfo.Loaded := FALSE;
				END_FOR;
				
				gUnloadStationIf.Sts.Done := TRUE;
				
				state := UNLOAD_DONE;
			END_IF
		UNLOAD_DONE: //********************************************************************************Unload station is done with the load process
			IF NOT gUnloadStationIf.Cmd.Enable THEN
				gUnloadStationIf.Sts.Done := FALSE;
				gUnloadStationIf.Sts.Enabled := FALSE;
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.BatchProcessFb.Enable := FALSE;
				
				gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				state := UNLOAD_OFF;
			ELSIF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gUnloadStationIf.Cmd.Process := FALSE;
				gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gUnloadStationIf.Sts.Done := FALSE;
				gUnloadStationIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := UNLOAD_WAIT_FOR_SHUTTLE;
			END_IF
			
		UNLOAD_ERROR: //********************************************************************************Unload station had an error
			IF gUnloadStationIf.Cmd.Reset THEN
				gUnloadStationIf.Cmd.Reset := FALSE;
				
				gUnloadStationIf.Sts.Done := FALSE;
				gUnloadStationIf.Sts.Enabled := FALSE;
				gUnloadStationIf.Sts.Error := FALSE;
				gUnloadStationIf.Sts.Processing := FALSE;
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				
				gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gUnloadStationIf.Cmd.Enable THEN
					state := UNLOAD_INIT;
				ELSE
					state := UNLOAD_OFF;
				END_IF
			END_IF
	END_CASE;
		
	 stationFbs.BatchProcessFb();
END_PROGRAM
