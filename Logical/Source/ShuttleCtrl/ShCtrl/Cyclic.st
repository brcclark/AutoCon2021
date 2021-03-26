
PROGRAM _CYCLIC
	FOR i:= 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		
		CASE shState[i] OF
			SH_OFF:  //******************************************************************************** Shuttle is in the off/idle state
				IF gShuttleIf[i].Cmd.Enable THEN
					shState[i] := SH_INIT;
				ELSE
				
				END_IF
			SH_INIT:  //******************************************************************************** Shuttle is in the initilization state
				//In this state we could make any checks on the current shuttle process perhaps in order to aide in recovery?
			
				shState[i] := SH_IDLE;
			SH_IDLE:  //******************************************************************************** Shuttle is in the idle state
				IF gShuttleIf[i].Cmd.NextStep THEN 
					gShuttleIf[i].Cmd.NextStep := FALSE;
					//Evaluate the current step to determine what the next step should be
					shFbs[i].ShMoveInPlaneFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_DIRECT;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := gLoadStationIf.Cfg.StationPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gLoadStationIf.Cfg.StationPos.Y;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
					LogDebug(gAuditTrail,i,"Sent to Load");
					//MpAuditCustomEvent(gAuditTrail,"INFO","Sh","Powered On");
				
					shState[i] := SH_MOVE_TO_LOAD;
				END_IF
			SH_MOVE_TO_LOAD:  //******************************************************************************** Shuttle is moving to the load position
				IF shFbs[i].ShMoveInPlaneFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShMoveInPlaneFb.Done AND (gLoadStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gLoadStationIf.Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gLoadStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gLoadStationIf.Par.ShuttleIdx := i;
					gLoadStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Load");
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shState[i] := SH_LOADING;
				END_IF
			SH_LOADING:  //******************************************************************************** Shuttle is currently being loaded
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gLoadStationIf.Cmd.Process := FALSE; //Respond to the Load station we're done
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := fillEntry.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := fillEntry.Y;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					
					LogDebug(gAuditTrail,i,"Sent To Fill Enter");
					
					shState[i] := SH_MOVE_FILL_ENTER;
				END_IF
			SH_MOVE_FILL_ENTER:
				IF shFbs[i].ShMoveInPlaneFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShMoveInPlaneFb.Acknowledge THEN
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cfg.EnterPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cfg.EnterPos.Y;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shState[i] := SH_MOVE_FILL;
				END_IF
			SH_MOVE_FILL:  //******************************************************************************** Shuttle is moving to a fill station
				shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
				IF shFbs[i].ShMoveInPlaneFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShMoveInPlaneFb.Done AND (gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Par.ShuttleIdx = STATION_IS_EMPTY AND gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cfg.EnterPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Par.ShuttleIdx := i;
					gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Fill");
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shState[i] := SH_FILLING;
				END_IF
				
			SH_FILLING:  //******************************************************************************** Shuttle is currently being filled
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cmd.Process := FALSE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					gShuttleIf[i].Sts.ProductInfo.CurrentFillStep := gShuttleIf[i].Sts.ProductInfo.CurrentFillStep + 1;
					IF gShuttleIf[i].Sts.ProductInfo.CurrentFillStep > MAX_FILL_STEPS - 1 THEN
						shState[i] := SH_ERROR;
					ELSE
						shState[i] := SH_FILLING_EVAL;
					END_IF
					
					
				END_IF
				
			SH_FILLING_EVAL:  //******************************************************************************** Shuttle is deciding which filling station to move next to
				shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
				shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
				shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
				shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
				shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
				
				IF gShuttleIf[i].Par.Recipe.Fills[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep] = 0 THEN
					//This will likely need to be some macro eventually instead
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].ShMoveInPlaneFb.PositionX := fillExit.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := fillExit.Y;
					shState[i] := SH_MOVE_FILL_EXIT;
				ELSE
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_DIRECT;
					shFbs[i].ShMoveInPlaneFb.PositionX := gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cfg.EnterPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gFillStationsIf[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep].Cfg.EnterPos.Y;
					shState[i] := SH_MOVE_FILL;
				END_IF
			SH_MOVE_FILL_EXIT:
				
			SH_MOVE_TO_WEIGH:  //******************************************************************************** Shuttle is moving to a weigh station
				
			SH_WEIGHING:  //******************************************************************************** Shuttle is currently being weighed/inspected
				//Station has control on the shuttle during this section
				
			SH_MOVE_TO_CAP:  //******************************************************************************** Shuttle is moving to a cap station
				
			SH_CAPPING:  //******************************************************************************** Shuttle is currently being capped
				//Station has control on the shuttle during this section
			
			SH_MOVE_TO_BUFFER:  //******************************************************************************** Shuttle is moving to a buffer lane
			
			SH_BUFFERED:  //******************************************************************************** Shuttle is currently being buffered
				//Station has control on the shuttle during this section
				
			SH_MOVE_TO_UNLOAD: //********************************************************************************  Shuttle is moving to an unload	
			SH_UNLOADING: //********************************************************************************  Shuttle is currently being unloaded	
			SH_MOVE_TO_REJECT: //********************************************************************************  Shuttle is moving to a reject station	
			SH_REJECTING: //********************************************************************************  Shuttle is currently being rejected
				
			SH_ERROR: //******************************************************************************** Shuttle is in the error state
		
		END_CASE;
		shFbs[i].ShRunMacroFb();
		shFbs[i].ShMoveInPlaneFb();
		
		IF gShuttleIf[i].Cmd.ResetProductInfo THEN
			brsmemset(ADR(gShuttleIf[i].Sts.ProductInfo),0,SIZEOF(gShuttleIf[i].Sts.ProductInfo));
			gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
			gShuttleIf[i].Sts.Error := FALSE;
			gShuttleIf[i].Sts.ErrorState := 0;
			gShuttleIf[i].Cmd.ResetProductInfo := FALSE;
		END_IF
	END_FOR;
	pDebugIf ACCESS ADR(gShuttleIf[debugIdx]);
	pDebugState ACCESS ADR(shState[debugIdx]);
	pDebugFbs ACCESS ADR(shFbs[debugIdx]);
	
END_PROGRAM
