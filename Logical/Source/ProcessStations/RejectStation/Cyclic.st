
PROGRAM _CYCLIC
	IF NOT gRejectStationIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.RejectStation;
	END_IF
	CASE state OF
		REJECT_OFF: //********************************************************************************Reject station is currently disabled
			IF gRejectStationIf.Cmd.Enable THEN
				state := REJECT_INIT;
			END_IF
		REJECT_INIT: //********************************************************************************Reject station is initalizing
			gRejectStationIf.Sts.ReadyForNewShuttle := TRUE;
			gRejectStationIf.Sts.Enabled := TRUE;
			state := REJECT_WAIT_FOR_SHUTTLE;
		REJECT_WAIT_FOR_SHUTTLE: //********************************************************************************Reject station is waiting for a shuttle to be present
			IF NOT gRejectStationIf.Cmd.Enable THEN
				gRejectStationIf.Sts.ReadyForNewShuttle := FALSE;
				gRejectStationIf.Sts.Enabled := FALSE;
				state := REJECT_OFF;
			ELSIF gRejectStationIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gRejectStationIf.Cmd.Process THEN
				gRejectStationIf.Sts.ReadyForNewShuttle := FALSE;
				gRejectStationIf.Sts.Processing := TRUE;
				
				stFbs.RejectTimerFb.IN := TRUE;
				stFbs.RejectTimerFb.PT := stationPars.WaitTime;
				
				state := REJECT_REJECTING;
			END_IF
		REJECT_REJECTING: //********************************************************************************Reject station is weighing product onto a shuttle
			IF stFbs.RejectTimerFb.Q THEN
				stFbs.RejectTimerFb.IN := FALSE;
				
				gRejectStationIf.Sts.Processing := FALSE;
				gShuttleIf[gRejectStationIf.Par.ShuttleIdx].Sts.ProductInfo.Loaded := FALSE;
				gShuttleIf[gRejectStationIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				gRejectStationIf.Sts.Done := TRUE;
				
				state := REJECT_DONE;
			END_IF
		REJECT_DONE: //********************************************************************************Reject station is done with the weigh process
			IF NOT gRejectStationIf.Cmd.Enable THEN
				gRejectStationIf.Sts.Done := FALSE;
				gRejectStationIf.Sts.Enabled := FALSE;
				gRejectStationIf.Sts.ReadyForNewShuttle := FALSE;
				state := REJECT_OFF;
			ELSIF NOT gRejectStationIf.Cmd.Process THEN
				gRejectStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gRejectStationIf.Sts.Done := FALSE;
				gRejectStationIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := REJECT_WAIT_FOR_SHUTTLE;
			END_IF
			
		REJECT_ERROR: //********************************************************************************Reject station had an error
			IF gRejectStationIf.Cmd.Reset THEN
				gRejectStationIf.Cmd.Reset := FALSE;
				
				gRejectStationIf.Sts.Done := FALSE;
				gRejectStationIf.Sts.Enabled := FALSE;
				gRejectStationIf.Sts.Error := FALSE;
				gRejectStationIf.Sts.Processing := FALSE;
				gRejectStationIf.Sts.ReadyForNewShuttle := FALSE;
				
				stFbs.RejectTimerFb.IN := FALSE;
				
				gRejectStationIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gRejectStationIf.Cmd.Enable THEN
					state := REJECT_INIT;
				ELSE
					state := REJECT_OFF;
				END_IF
			END_IF
	END_CASE;
		
	stFbs.RejectTimerFb();
	
END_PROGRAM
