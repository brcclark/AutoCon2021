
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
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.LoadToPrintMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					gShuttleIf[i].Sts.CurrentDestination := DEST_LOAD;
					LogDebug(gAuditTrail,i,"Sent to Load");
					//MpAuditCustomEvent(gAuditTrail,"INFO","Sh","Powered On");
				
					shState[i] := SH_MOVE_TO_LOAD;
				END_IF
			SH_MOVE_TO_LOAD:  //******************************************************************************** Shuttle is moving to the load position
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Sts.Error := TRUE;
					gShuttleIf[i].Sts.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gLoadStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gLoadStationIf.Sts.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gLoadStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Sts.ShuttleInfo.Position)) THEN
					gLoadStationIf.Par.ShuttleIdx := i;
					gLoadStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Load");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_LOADING;
				END_IF
			SH_LOADING:  //******************************************************************************** Shuttle is currently being loaded
				//Station has control on the shuttle during this section
				
			SH_MOVE_FILL:  //******************************************************************************** Shuttle is moving to a fill station
				
				
			SH_FILLING:  //******************************************************************************** Shuttle is currently being filled
				//Station has control on the shuttle during this section
				
			SH_FILLING_EVAL:  //******************************************************************************** Shuttle is deciding which filling station to move next to
				
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
	
		IF gShuttleIf[i].Cmd.ResetProductInfo THEN
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
