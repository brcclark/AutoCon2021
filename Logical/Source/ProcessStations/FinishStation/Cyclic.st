
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
	
	IF NOT gFinishStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.FinishStation;
	END_IF
	
	CASE state OF
		FINISH_OFF: //********************************************************************************Finish station is currently disabled
			IF gFinishStationIf.Cmd.Enable THEN
				stationFbs.BatchProcessFb.Controller := ADR(gMcAcp6DController);
				stationFbs.BatchProcessFb.Enable := TRUE;
												
				state := FINISH_INIT;
			END_IF
		FINISH_INIT: //********************************************************************************Finish station is initalizing
			IF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gFinishStationIf.Sts.ReadyForNewShuttle := TRUE;
				gFinishStationIf.Sts.Enabled := TRUE;
				state := FINISH_WAIT_FOR_SHUTTLE;
			END_IF			
		FINISH_WAIT_FOR_SHUTTLE: //********************************************************************************Finish station is waiting for a shuttle to be present
			stationFbs.BatchProcessFb.ProcessingTime := stationPars.WaitTime;
			IF NOT gFinishStationIf.Cmd.Enable THEN
				gFinishStationIf.Sts.ReadyForNewShuttle := FALSE;
				gFinishStationIf.Sts.Enabled := FALSE;
				state := FINISH_OFF;
			ELSIF gFinishStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gFinishStationIf.Cmd.Process THEN
				gFinishStationIf.Sts.ReadyForNewShuttle := FALSE;
								
				stationFbs.BatchProcessFb.ShId := gShuttleIf[gFinishStationIf.Par.ShuttleIdx].Cfg.ShuttleId;
				stationFbs.BatchProcessFb.ProcessShuttle := TRUE;
				
				state := FINISH_CHECK_BUFFER;
			END_IF
		FINISH_CHECK_BUFFER:
			IF stationFbs.BatchProcessFb.Processsing THEN
				gFinishStationIf.Sts.Processing := TRUE;
				gFinishStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				
				state := FINISH_FINISHING;
			ELSIF stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gFinishStationIf.Sts.ReadyForNewShuttle := TRUE;
				gFinishStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				stationFbs.BatchProcessFb.ProcessShuttle := FALSE;
				
				state := FINISH_WAIT_FOR_SHUTTLE;
			END_IF
		FINISH_FINISHING: //********************************************************************************Finish station is loading product onto a shuttle
			IF stationFbs.BatchProcessFb.Error THEN
				gFinishStationIf.Sts.Error := TRUE;
				state := FINISH_ERROR;
			ELSIF stationFbs.BatchProcessFb.BatchComplete THEN
				stationFbs.BatchProcessFb.Reset := TRUE;
				gFinishStationIf.Cmd.Process := FALSE;
				
				gFinishStationIf.Sts.Processing := FALSE;
				FOR i:=0 TO MAX_BATCH_SHUTTLE_COUNT -1 DO
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Cmd.NextStep := TRUE; //WARNING WARNING THIS WILL ONLY WORK WITH SEQUENTIAL IDS. IF YOU USE ABSOLUTE ID THIS WILL NOT WORK
					gShuttleIf[stationFbs.BatchProcessFb.ShuttleIds[i] - 1].Sts.ProductInfo.Finished := TRUE;
				END_FOR;
				
				gFinishStationIf.Sts.Done := TRUE;
				
				state := FINISH_DONE;
			END_IF
		FINISH_DONE: //********************************************************************************Finish station is done with the load process
			IF NOT gFinishStationIf.Cmd.Enable THEN
				gFinishStationIf.Sts.Done := FALSE;
				gFinishStationIf.Sts.Enabled := FALSE;
				gFinishStationIf.Sts.ReadyForNewShuttle := FALSE;
				stationFbs.BatchProcessFb.Enable := FALSE;
				
				state := FINISH_OFF;
			ELSIF NOT gFinishStationIf.Cmd.Process AND stationFbs.BatchProcessFb.ReadyForShuttle THEN
				gFinishStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gFinishStationIf.Sts.Done := FALSE;
				gFinishStationIf.Sts.ReadyForNewShuttle := FALSE;
				gFinishStationIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := FINISH_WAIT_FOR_SHUTTLE;
			END_IF
			
		FINISH_ERROR: //********************************************************************************Finish station had an error
			IF gFinishStationIf.Cmd.Reset THEN
				gFinishStationIf.Cmd.Reset := FALSE;
				
				gFinishStationIf.Sts.Done := FALSE;
				gFinishStationIf.Sts.Enabled := FALSE;
				gFinishStationIf.Sts.Error := FALSE;
				gFinishStationIf.Sts.Processing := FALSE;
				gFinishStationIf.Sts.ReadyForNewShuttle := FALSE;
				
				gFinishStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gFinishStationIf.Cmd.Enable THEN
					state := FINISH_INIT;
				ELSE
					state := FINISH_OFF;
				END_IF
			END_IF
	END_CASE;
		
	 stationFbs.BatchProcessFb();
END_PROGRAM
