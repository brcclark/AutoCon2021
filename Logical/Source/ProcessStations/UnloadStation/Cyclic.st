
PROGRAM _CYCLIC
	
	IF NOT gUnloadStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.UnloadStation;
	END_IF
	
	CASE state OF
		UNLOAD_OFF: //********************************************************************************Unload station is currently disabled
			IF gUnloadStationIf.Cmd.Enable THEN
				state := UNLOAD_INIT;
			END_IF
		UNLOAD_INIT: //********************************************************************************Unload station is initalizing
			gUnloadStationIf.Sts.ReadyForNewShuttle := TRUE;
			gUnloadStationIf.Sts.Enabled := TRUE;
			state := UNLOAD_WAIT_FOR_SHUTTLE;
		UNLOAD_WAIT_FOR_SHUTTLE: //********************************************************************************Unload station is waiting for a shuttle to be present
			IF NOT gUnloadStationIf.Cmd.Enable THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gUnloadStationIf.Sts.Enabled := FALSE;
				state := UNLOAD_OFF;
			ELSIF gUnloadStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gUnloadStationIf.Cmd.Process THEN
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				gUnloadStationIf.Sts.Processing := TRUE;
				
				UnloadStationFbs.UnloadTimerFb.IN := TRUE;
				UnloadStationFbs.UnloadTimerFb.PT := stationPars.WaitTime;
				
				state := UNLOAD_UNLOADING;
			END_IF
		UNLOAD_UNLOADING: //********************************************************************************Unload station is loading product onto a shuttle
			IF UnloadStationFbs.UnloadTimerFb.Q THEN
				UnloadStationFbs.UnloadTimerFb.IN := FALSE;
				
				gUnloadStationIf.Sts.Processing := FALSE;
				gShuttleIf[gUnloadStationIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				gUnloadStationIf.Sts.Done := TRUE;
								
				state := UNLOAD_DONE;
			END_IF
		UNLOAD_DONE: //********************************************************************************Unload station is done with the load process
			IF NOT gUnloadStationIf.Cmd.Enable THEN
				gUnloadStationIf.Sts.Done := FALSE;
				gUnloadStationIf.Sts.Enabled := FALSE;
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
				state := UNLOAD_OFF;
			ELSIF NOT gUnloadStationIf.Cmd.Process THEN
				gUnloadStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gUnloadStationIf.Sts.Done := FALSE;
				gUnloadStationIf.Sts.ReadyForNewShuttle := FALSE;
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
		
	 UnloadStationFbs.UnloadTimerFb();
END_PROGRAM
