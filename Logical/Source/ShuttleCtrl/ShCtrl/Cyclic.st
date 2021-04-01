
PROGRAM _CYCLIC
	FOR i:= 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		IF gShuttleIf[i].Cmd.Stop THEN
			shFbs[i].ShStop.Controller := ADR(gMcAcp6DController);
			shFbs[i].ShStop.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
			shFbs[i].ShStop.Execute := TRUE;
			
			shState[i] := SH_STOPPING;
		END_IF
		
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
					gShuttleIf[i].Sts.CurrentStation := gShuttleIf[i].Par.Recipe.Fills[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep];
					
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Cfg.EnterPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Cfg.EnterPos.Y;
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
				ELSIF shFbs[i].ShMoveInPlaneFb.Done AND (gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Par.ShuttleIdx = STATION_IS_EMPTY AND gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Cfg.EnterPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Par.ShuttleIdx := i;
					gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Cmd.Process := TRUE;
					
					LogDebug(gAuditTrail,i,"Arrived at Fill");
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shState[i] := SH_FILLING;
				END_IF
				
			SH_FILLING:  //******************************************************************************** Shuttle is currently being filled
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gFillStationsIf[gShuttleIf[i].Sts.CurrentStation - 1].Cmd.Process := FALSE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					
					gShuttleIf[i].Sts.ProductInfo.CurrentFillStep := gShuttleIf[i].Sts.ProductInfo.CurrentFillStep + 1;
					IF gShuttleIf[i].Sts.ProductInfo.CurrentFillStep > MAX_FILL_STEPS - 1 THEN
						shState[i] := SH_ERROR;
					ELSE
						gShuttleIf[i].Sts.NextStation := gShuttleIf[i].Par.Recipe.Fills[gShuttleIf[i].Sts.ProductInfo.CurrentFillStep];
						shState[i] := SH_FILLING_EVAL;
					END_IF
				END_IF
				
			SH_FILLING_EVAL:  //******************************************************************************** Shuttle is deciding which filling station to move next to
				//Look at next station - current station to see if we need to move into the bypass lane
				nextStationCalc := gShuttleIf[i].Sts.NextStation - gShuttleIf[i].Sts.CurrentStation;
				
				shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
				shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
				shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
				shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
				
				IF gShuttleIf[i].Sts.NextStation = 0 THEN
					//This will likely need to be some macro eventually instead
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.PositionX := fillExit.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := fillExit.Y;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					
					LogDebug(gAuditTrail,i,"Sent To Fill Exit");
					shState[i] := SH_MOVE_FILL_EXIT;
				ELSIF nextStationCalc = 1 OR nextStationCalc = -3 THEN
					//We don't need to bypass the lane, we proceed directly to the station
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_DIRECT;
					shFbs[i].ShMoveInPlaneFb.PositionX := gFillStationsIf[gShuttleIf[i].Sts.NextStation - 1].Cfg.EnterPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gFillStationsIf[gShuttleIf[i].Sts.NextStation - 1].Cfg.EnterPos.Y;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					gShuttleIf[i].Sts.CurrentStation := gShuttleIf[i].Sts.NextStation;
					LogDebug(gAuditTrail,i,"Moving to Fill");
					shState[i] := SH_MOVE_FILL;
				ELSE
					//Need to enter the bypass lane
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := DINT_TO_USINT(MACRO_FILL_1_ENTER_BYPASS) + gShuttleIf[i].Sts.CurrentStation - 1;//Current Station is the current station 1-4, shifting by - 1 for the macro
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					gShuttleIf[i].Sts.ProductInfo.Bypassing := TRUE;
					LogDebug(gAuditTrail,i,"Moving to Fill");
					shState[i] := SH_BYPASS_ENTER;
				END_IF
			SH_BYPASS_ENTER:
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done THEN
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					
					shState[i] := SH_BYPASS_CHECK;
				END_IF
			SH_BYPASS_MOVE:
				IF shFbs[i].ShRunMacroFb.Error OR shFbs[i].ShMoveInPlaneFb.Error THEN 
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					shState[i] := SH_ERROR;
				ELSIF (shFbs[i].ShRunMacroFb.Done AND shFbs[i].ShRunMacroFb.Execute) 
					OR (shFbs[i].ShMoveInPlaneFb.Done AND shFbs[i].ShMoveInPlaneFb.Execute) THEN
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					
					IF gShuttleIf[i].Sts.ProductInfo.Bypassing THEN
						//We're now "at" the next station (at least in the motion buffer we are)
						gShuttleIf[i].Sts.CurrentStation := gShuttleIf[i].Sts.CurrentStation + 1;
						IF gShuttleIf[i].Sts.CurrentStation > 4 THEN
							gShuttleIf[i].Sts.CurrentStation := 1;
						END_IF
						shState[i] := SH_BYPASS_CHECK;
					ELSE 
						shState[i] := SH_FILLING_EVAL;
					END_IF
				END_IF
			SH_BYPASS_CHECK:
				nextStationCalc := gShuttleIf[i].Sts.NextStation - gShuttleIf[i].Sts.CurrentStation;
				IF nextStationCalc = 1 OR nextStationCalc = -3 THEN
					//Need to exit the bypass lane
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := DINT_TO_USINT(MACRO_FILL_1_EXIT_BYPASS) + gShuttleIf[i].Sts.CurrentStation - 1;//Current Station Calc is the current station 1-4, shifting by - 1 for the macro
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					gShuttleIf[i].Sts.ProductInfo.Bypassing := FALSE;
					
					LogDebug(gAuditTrail,i,"Exiting Bypass");
				ELSE
					//Continue along the bypass lane
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_DIRECT;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_RELATIVE;
					shFbs[i].ShMoveInPlaneFb.PositionX := 0.24 * ((gShuttleIf[i].Sts.CurrentStation MOD 2) <> 0);
					shFbs[i].ShMoveInPlaneFb.PositionY := 0.24 * ((gShuttleIf[i].Sts.CurrentStation MOD 2) = 0);
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					
					LogDebug(gAuditTrail,i,"Traversing Bypass");
				END_IF
				shState[i] := SH_BYPASS_MOVE;
			SH_MOVE_FILL_EXIT:
				IF shFbs[i].ShMoveInPlaneFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShMoveInPlaneFb.Acknowledge THEN
										
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := DINT_TO_USINT(MACRO_FILL_EXIT_TO_WEIGH_1) + currentWeighStation;
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					
					gShuttleIf[i].Sts.ProductInfo.WeighStation := currentWeighStation;
					currentWeighStation := currentWeighStation + 1;
					IF currentWeighStation >= MAX_WEIGH_STATIONS THEN
						currentWeighStation := 0;
					END_IF
					LogDebug(gAuditTrail,i,"Sent To Weigh Station");
					
					shState[i] := SH_MOVE_TO_WEIGH;
				END_IF
			SH_MOVE_TO_WEIGH:  //******************************************************************************** Shuttle is moving to a weigh station
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Par.ShuttleIdx = STATION_IS_EMPTY AND gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Par.ShuttleIdx := i;
					gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Weigh Station");
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_WEIGHING;
				END_IF
			SH_WEIGHING:  //******************************************************************************** Shuttle is currently being weighed/inspected
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gWeighStationIf[gShuttleIf[i].Sts.ProductInfo.WeighStation].Cmd.Process := FALSE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := gUnloadStationIf.Cfg.StationPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gUnloadStationIf.Cfg.StationPos.Y;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
					
					LogDebug(gAuditTrail,i,"Sent to Unload");
					
					shState[i] := SH_MOVE_TO_UNLOAD;
				END_IF
			SH_MOVE_TO_CAP:  //******************************************************************************** Shuttle is moving to a cap station
				
			SH_CAPPING:  //******************************************************************************** Shuttle is currently being capped
				//Station has control on the shuttle during this section
			
			SH_MOVE_TO_BUFFER:  //******************************************************************************** Shuttle is moving to a buffer lane
			
			SH_BUFFERED:  //******************************************************************************** Shuttle is currently being buffered
				//Station has control on the shuttle during this section
				
			SH_MOVE_TO_UNLOAD: //********************************************************************************  Shuttle is moving to an unload	
				shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
				IF shFbs[i].ShMoveInPlaneFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShMoveInPlaneFb.Done AND (gUnloadStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gUnloadStationIf.Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gUnloadStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gUnloadStationIf.Par.ShuttleIdx := i;
					gUnloadStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Unload");
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shState[i] := SH_UNLOADING;
				END_IF
			SH_UNLOADING: //********************************************************************************  Shuttle is currently being unloaded	
				IF gShuttleIf[i].Cmd.NextStep THEN
					gUnloadStationIf.Cmd.Process := FALSE; //Respond to the Unoad station we're done
					gShuttleIf[i].Cmd.NextStep := FALSE;
					
					gShuttleIf[i].Cmd.ResetProductInfo := TRUE;
					gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
				
					shFbs[i].ShMoveInPlaneFb.Path := mcACP6D_PATH_Y_THEN_X;
					shFbs[i].ShMoveInPlaneFb.Mode := mcACP6D_MOVE_ABSOLUTE;
					shFbs[i].ShMoveInPlaneFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShMoveInPlaneFb.PositionX := gLoadStationIf.Cfg.StationPos.X;
					shFbs[i].ShMoveInPlaneFb.PositionY := gLoadStationIf.Cfg.StationPos.Y;
					shFbs[i].ShMoveInPlaneFb.Velocity := gSysPars.TraversalVel;
					shFbs[i].ShMoveInPlaneFb.Acceleration := gSysPars.TraversalAccel;
					shFbs[i].ShMoveInPlaneFb.Execute := TRUE;
			
					LogDebug(gAuditTrail,i,"Sent To Load");
					
					shState[i] := SH_MOVE_TO_LOAD;
					
				END_IF
			SH_MOVE_TO_REJECT: //********************************************************************************  Shuttle is moving to a reject station	
			SH_REJECTING: //********************************************************************************  Shuttle is currently being rejected
			SH_STOPPING:
				IF shFbs[i].ShStop.Error THEN
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShStop.Done THEN
					gShuttleIf[i].Cmd.Stop := FALSE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
					shFbs[i].ShStop.Execute := FALSE;
					gShuttleIf[i].Cmd.ResetProductInfo := TRUE;
					
					shFbs[i].ShMoveInPlaneFb.Execute := FALSE;
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					
					shState[i] := SH_OFF;
				END_IF
			SH_ERROR: //******************************************************************************** Shuttle is in the error state
		
		END_CASE;
		shFbs[i].ShRunMacroFb();
		shFbs[i].ShMoveInPlaneFb();
		shFbs[i].ShStop();
		
		IF gShuttleIf[i].Cmd.ResetProductInfo THEN
			brsmemset(ADR(gShuttleIf[i].Sts.ProductInfo),0,SIZEOF(gShuttleIf[i].Sts.ProductInfo));
			gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
			gShuttleIf[i].Sts.Error := FALSE;
			gShuttleIf[i].Sts.ErrorState := 0;
			gShuttleIf[i].Sts.ProductInfo.Bypassing := FALSE;
			gShuttleIf[i].Cmd.ResetProductInfo := FALSE;
		END_IF
	END_FOR;
	pDebugIf ACCESS ADR(gShuttleIf[debugIdx]);
	pDebugState ACCESS ADR(shState[debugIdx]);
	pDebugFbs ACCESS ADR(shFbs[debugIdx]);
	
END_PROGRAM
