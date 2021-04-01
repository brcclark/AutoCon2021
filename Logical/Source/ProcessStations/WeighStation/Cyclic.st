
PROGRAM _CYCLIC
	
	CASE state OF
		WEIGH_OFF: //********************************************************************************Weigh station is currently disabled
			IF pWeighIf.Cmd.Enable THEN
				state := WEIGH_INIT;
			END_IF
		WEIGH_INIT: //********************************************************************************Weigh station is initalizing
			pWeighIf.Sts.ReadyForNewShuttle := TRUE;
			pWeighIf.Sts.Enabled := TRUE;
			state := WEIGH_WAIT_FOR_SHUTTLE;
		WEIGH_WAIT_FOR_SHUTTLE: //********************************************************************************Weigh station is waiting for a shuttle to be present
			IF NOT pWeighIf.Cmd.Enable THEN
				pWeighIf.Sts.ReadyForNewShuttle := FALSE;
				pWeighIf.Sts.Enabled := FALSE;
				state := WEIGH_OFF;
			ELSIF pWeighIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND pWeighIf.Cmd.Process THEN
				pWeighIf.Sts.ReadyForNewShuttle := FALSE;
				pWeighIf.Sts.Processing := TRUE;
				
				state := WEIGH_LAND;
			END_IF
		WEIGH_LAND: //********************************************************************************Weigh station is landing a shuttle
			stFbs.LevitationCtrlFb.Controller := ADR(gMcAcp6DController);
			stFbs.LevitationCtrlFb.ShuttleID := gShuttleIf[pWeighIf.Par.ShuttleIdx].Cfg.ShuttleId;
			stFbs.LevitationCtrlFb.Level := mcACP6D_LEVEL_LAND;
			stFbs.LevitationCtrlFb.Execute := TRUE;
				
			IF stFbs.LevitationCtrlFb.Error THEN
				state := WEIGH_ERROR;
			ELSIF stFbs.LevitationCtrlFb.Done THEN
				stFbs.LevitationCtrlFb.Execute := FALSE;
				
				state := WEIGH_TAKEOFF;
			END_IF
		WEIGH_TAKEOFF: //********************************************************************************Weigh station is taking off a shuttle
			stFbs.LevitationCtrlFb.Controller := ADR(gMcAcp6DController);
			stFbs.LevitationCtrlFb.ShuttleID := gShuttleIf[pWeighIf.Par.ShuttleIdx].Cfg.ShuttleId;
			stFbs.LevitationCtrlFb.Level := mcACP6D_LEVEL_LEVITATE;
			stFbs.LevitationCtrlFb.Execute := TRUE;
			
			IF stFbs.LevitationCtrlFb.Error THEN
				state := WEIGH_ERROR;
			ELSIF stFbs.LevitationCtrlFb.Done THEN
				stFbs.LevitationCtrlFb.Execute := FALSE;
				
				stFbs.WeighTimerFb.IN := TRUE;
				stFbs.WeighTimerFb.PT := stationPars.WaitTime;
				
				state := WEIGH_WEIGHING;
			END_IF
		WEIGH_WEIGHING: //********************************************************************************Weigh station is weighing product onto a shuttle
			IF stFbs.WeighTimerFb.Q THEN
				stFbs.WeighTimerFb.IN := FALSE;
				
				lastRecordedWeight := RandValueDINT(stationPars.MinWeight,stationPars.MaxWeight);
				lastRecordedWeightHMI := DINT_TO_REAL(lastRecordedWeight) / 10.0;
				gShuttleIf[pWeighIf.Par.ShuttleIdx].Sts.ProductInfo.Weight := DINT_TO_REAL(lastRecordedWeight) / 10.0;
				
				pWeighIf.Sts.Processing := FALSE;
				gShuttleIf[pWeighIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				pWeighIf.Sts.Done := TRUE;
				
				state := WEIGH_DONE;
			END_IF
		WEIGH_DONE: //********************************************************************************Weigh station is done with the weigh process
			IF NOT pWeighIf.Cmd.Enable THEN
				pWeighIf.Sts.Done := FALSE;
				pWeighIf.Sts.Enabled := FALSE;
				pWeighIf.Sts.ReadyForNewShuttle := FALSE;
				state := WEIGH_OFF;
			ELSIF NOT pWeighIf.Cmd.Process THEN
				pWeighIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				pWeighIf.Sts.Done := FALSE;
				pWeighIf.Sts.ReadyForNewShuttle := FALSE;
				pWeighIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := WEIGH_WAIT_FOR_SHUTTLE;
			END_IF
			
		WEIGH_ERROR: //********************************************************************************Weigh station had an error
			IF pWeighIf.Cmd.Reset THEN
				pWeighIf.Cmd.Reset := FALSE;
				
				pWeighIf.Sts.Done := FALSE;
				pWeighIf.Sts.Enabled := FALSE;
				pWeighIf.Sts.Error := FALSE;
				pWeighIf.Sts.Processing := FALSE;
				pWeighIf.Sts.ReadyForNewShuttle := FALSE;
				
				stFbs.WeighTimerFb.IN := FALSE;
				stFbs.LevitationCtrlFb.Execute := FALSE;
				
				pWeighIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF pWeighIf.Cmd.Enable THEN
					state := WEIGH_INIT;
				ELSE
					state := WEIGH_OFF;
				END_IF
			END_IF
	END_CASE;
		
	stFbs.WeighTimerFb();
	stFbs.LevitationCtrlFb();
	
END_PROGRAM
