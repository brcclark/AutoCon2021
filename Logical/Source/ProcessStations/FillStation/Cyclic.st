
PROGRAM _CYCLIC
	CASE state OF
		FILL_OFF: //********************************************************************************Fill station is currently disabled
			IF pFillIf.Cmd.Enable THEN
				state := FILL_INIT;
			END_IF
		FILL_INIT: //********************************************************************************Fill station is initalizing
			pFillIf.Sts.ReadyForNewShuttle := TRUE;
			pFillIf.Sts.Enabled := TRUE;
			state := FILL_WAIT_FOR_SHUTTLE;
		FILL_WAIT_FOR_SHUTTLE: //********************************************************************************Fill station is waiting for a shuttle to be present
			IF NOT pFillIf.Cmd.Enable THEN
				pFillIf.Sts.ReadyForNewShuttle := FALSE;
				pFillIf.Sts.Enabled := FALSE;
				state := FILL_OFF;
			ELSIF pFillIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND pFillIf.Cmd.Process THEN
				pFillIf.Sts.ReadyForNewShuttle := FALSE;
				pFillIf.Sts.Processing := TRUE;
				
				FillStationFbs.FillMoveFb.Controller := ADR(gMcAcp6DController);
				FillStationFbs.FillMoveFb.ShuttleID := gShuttleIf[pFillIf.Par.ShuttleIdx].Cfg.ShuttleId;
				FillStationFbs.FillMoveFb.Mode := mcACP6D_MOVE_ABSOLUTE;
				FillStationFbs.FillMoveFb.Path := mcACP6D_PATH_Y_THEN_X;
				FillStationFbs.FillMoveFb.Velocity := stationPars.Vel;
				FillStationFbs.FillMoveFb.EndVelocity := 0;
				FillStationFbs.FillMoveFb.Acceleration := stationPars.Accel;
				FillStationFbs.FillMoveFb.PositionX := pFillIf.Cfg.StationPos.X;
				FillStationFbs.FillMoveFb.PositionY := pFillIf.Cfg.StationPos.Y;
				FillStationFbs.FillMoveFb.Execute := TRUE;
			
				state := FILL_ENTER_SHUTTLE;
			END_IF
		FILL_ENTER_SHUTTLE: //******************************************************************************** Fill station is moving to the filling position
			IF FillStationFbs.FillMoveFb.Error THEN
				pFillIf.Sts.Error := TRUE;
				
				state := FILL_ERROR;
			ELSIF FillStationFbs.FillMoveFb.Done THEN
				FillStationFbs.FillMoveFb.Execute:= FALSE;
				
				FillStationFbs.WaitTimer.IN := TRUE;
				FillStationFbs.WaitTimer.PT := stationPars.FillTime;
				
				state := FILL_FILLING;
			END_IF
		FILL_FILLING: //********************************************************************************Fill station is preforming the filling process
			IF FillStationFbs.WaitTimer.Q THEN
				FillStationFbs.WaitTimer.IN := FALSE;
				
				FillStationFbs.FillMoveFb.Mode := mcACP6D_MOVE_ABSOLUTE;
				FillStationFbs.FillMoveFb.Path := mcACP6D_PATH_X_THEN_Y;
				FillStationFbs.FillMoveFb.Velocity := stationPars.Vel;
				FillStationFbs.FillMoveFb.EndVelocity := 0;
				FillStationFbs.FillMoveFb.Acceleration := stationPars.Accel;
				FillStationFbs.FillMoveFb.PositionX := pFillIf.Cfg.ExitPos.X;
				FillStationFbs.FillMoveFb.PositionY := pFillIf.Cfg.ExitPos.Y;
				FillStationFbs.FillMoveFb.Execute := TRUE;
			
				state := FILL_EXIT_SHUTTLE;
			END_IF
		FILL_EXIT_SHUTTLE:
			IF FillStationFbs.FillMoveFb.Error THEN
				pFillIf.Sts.Error := TRUE;
				
				state := FILL_ERROR;
			ELSIF FillStationFbs.FillMoveFb.Acknowledge THEN
				gShuttleIf[pFillIf.Par.ShuttleIdx].Cmd.NextStep := TRUE;
				pFillIf.Sts.Done := TRUE;
				pFillIf.Sts.Processing := FALSE;
					
				state := FILL_DONE;
			END_IF
		FILL_DONE: //********************************************************************************Fill station is done with the load process
			IF NOT pFillIf.Cmd.Enable THEN
				pFillIf.Sts.Enabled := FALSE;
				pFillIf.Sts.ReadyForNewShuttle := FALSE;
				
				state := FILL_OFF;
			ELSIF NOT pFillIf.Cmd.Process THEN
				pFillIf.Sts.Done := FALSE;
				
				pFillIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				pFillIf.Sts.ReadyForNewShuttle := FALSE;
				pFillIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := FILL_WAIT_FOR_SHUTTLE;
			END_IF
		FILL_ERROR: //********************************************************************************Fill station had an error
			IF pFillIf.Cmd.Reset THEN
				pFillIf.Cmd.Reset := FALSE;
				
				pFillIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				
				pFillIf.Sts.Done := FALSE;
				pFillIf.Sts.Error := FALSE;
				pFillIf.Sts.Processing := FALSE;
				pFillIf.Sts.ReadyForNewShuttle := FALSE;
				pFillIf.Sts.Enabled := FALSE;
				
				FillStationFbs.FillMoveFb.Execute := FALSE;
				FillStationFbs.WaitTimer.IN := FALSE;
				
				IF pFillIf.Cmd.Enable THEN
					state := FILL_INIT;
				ELSE
					state := FILL_OFF;
				END_IF
			END_IF
	END_CASE;
		
	FillStationFbs.FillMoveFb();
	FillStationFbs.WaitTimer();
END_PROGRAM
