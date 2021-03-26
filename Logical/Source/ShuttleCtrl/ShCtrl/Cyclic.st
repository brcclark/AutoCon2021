
PROGRAM _CYCLIC
	FOR i:= 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		
		IF gShuttleIf[i].Status.CurrentDestination = DEST_DOSE1 THEN
			pDoseStationIf ACCESS ADR(gDoseStationsIf[0]);
		ELSIF gShuttleIf[i].Status.CurrentDestination = DEST_DOSE2 THEN
			pDoseStationIf ACCESS ADR(gDoseStationsIf[1]);
		END_IF
	
		CASE shState[i] OF
			SH_OFF:  //******************************************************************************** Shuttle is in the off/idle state
				IF gShuttleIf[i].Cmd.Enable THEN
					shState[i] := SH_INIT;
				ELSE
				
				END_IF
			SH_INIT:  //******************************************************************************** Shuttle is in the initilization state
				//In this state we could make any checks on the current shuttle process perhaps in order to aide in recovery?
			
				shState[i] := SH_STARTUP;
			SH_STARTUP:  //******************************************************************************** Shuttle is in the startup state
				//In this state maybe we have triggered recovery and we're waiting for the autodrive to complete
				shState[i] := SH_IDLE;
			SH_IDLE:  //******************************************************************************** Shuttle is in the idle state
				IF gShuttleIf[i].Cmd.NextStep THEN 
					gShuttleIf[i].Cmd.NextStep := FALSE;
					//Evaluate the current step to determine what the next step should be
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.UnloadToLoadMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					gShuttleIf[i].Status.CurrentDestination := DEST_LOAD;
					LogDebug(gAuditTrail,i,"Sent to Load");
					//MpAuditCustomEvent(gAuditTrail,"INFO","Sh","Powered On");
				
					shState[i] := SH_MOVE_TO_LOAD;
				END_IF
			SH_MOVE_TO_LOAD:  //******************************************************************************** Shuttle is moving to the load position
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Status.Error := TRUE;
					gShuttleIf[i].Status.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gLoadStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gLoadStationIf.Status.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gLoadStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Status.ShuttleInfo.Position)) THEN
					gLoadStationIf.Par.ShuttleIdx := i;
					gLoadStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Load");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_LOAD;
				END_IF
			SH_LOAD:  //******************************************************************************** Shuttle is currently being loaded
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gLoadStationIf.Cmd.Process := FALSE; //Respond to the Load station we're done
				
					gShuttleIf[i].Status.BlisterPresent := TRUE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
					gShuttleIf[i].Status.CurrentDestination := DEST_PRINT;
				
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.LoadToPrintMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
					
					LogDebug(gAuditTrail,i,"Sent To Print");
					
					shState[i] := SH_MOVE_TO_PRINT;
				END_IF
			SH_MOVE_TO_PRINT:  //******************************************************************************** Shuttle is moving to the print position
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Status.Error := TRUE;
					gShuttleIf[i].Status.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gPrintStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gPrintStationIf.Status.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gPrintStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Status.ShuttleInfo.Position)) THEN
					gPrintStationIf.Par.ShuttleIdx := i; //Replace with idx when adding the loop
					gPrintStationIf.Cmd.Process := TRUE;
					
					LogDebug(gAuditTrail,i,"Arrived at Print");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_PRINT;
				END_IF
			SH_PRINT:  //******************************************************************************** Shuttle is currently being printed
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gPrintStationIf.Cmd.Process := FALSE; //Respond to the print station we're done
				
					gShuttleIf[i].Status.CurrentLayer :=  gShuttleIf[i].Status.CurrentLayer + 1;
					LogDebug(gAuditTrail,i,"Print complete");
					gShuttleIf[i].Cmd.NextStep := FALSE;
				
					shState[i] := SH_DECIDE_DOSE;
				END_IF
			SH_DECIDE_DOSE:  //******************************************************************************** Shuttle is deciding which dose station to send the shuttle to
				//First check if the layers have finished
				IF gShuttleIf[i].Status.CurrentLayer > gShuttleIf[i].Par.NumLayers THEN
					//We've finished layering move to the tamp state
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.PrintToTampMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
				
					gShuttleIf[i].Status.CurrentDestination := DEST_TAMP;
					LogDebug(gAuditTrail,i,"Sent to Tamp");
					
					shState[i] := SH_MOVE_TO_TAMP;
				ELSE
					//Need to determine which doser is available
					IF NextDoseStation = DEST_DOSE1 THEN
						gShuttleIf[i].Par.MacroIDs.PrintToDoseMacroID := MACRO_PRINT_TO_DOSE1;
						gShuttleIf[i].Status.CurrentDestination := DEST_DOSE1;
						LogDebug(gAuditTrail,i,"Sent To Dose 1");
						NextDoseStation := DEST_DOSE2;
					ELSE
						gShuttleIf[i].Par.MacroIDs.PrintToDoseMacroID := MACRO_PRINT_TO_DOSE2;
						gShuttleIf[i].Status.CurrentDestination := DEST_DOSE2;
						LogDebug(gAuditTrail,i,"Sent To Dose 2");
						NextDoseStation := DEST_DOSE1;	
					END_IF
									
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.PrintToDoseMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
				
					shState[i] := SH_MOVE_TO_DOSE;
				END_IF
			SH_MOVE_TO_DOSE:  //******************************************************************************** Shuttle is moving towards the defined dosing station
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Status.Error := TRUE;
					gShuttleIf[i].Status.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (pDoseStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND pDoseStationIf.Status.ReadyForNewShuttle AND NOT pDoseStationIf.Cmd.Process) 
					AND PositionValidation(ADR(pDoseStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Status.ShuttleInfo.Position)) THEN//Wait for the movement to end and the Station to be ready to accept a new shuttle
					pDoseStationIf.Par.ShuttleIdx := i;
					pDoseStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Dose");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_DOSE;
				END_IF
			SH_DOSE:  //******************************************************************************** Shuttle is currently going through the dosing procedure
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gShuttleIf[i].Cmd.NextStep := FALSE;
					pDoseStationIf.Cmd.Process := FALSE; //Respond to the dose station we're done
				
					gShuttleIf[i].Status.CurrentDestination := DEST_PRINT;
				
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.DoseToPrintMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
				
					LogDebug(gAuditTrail,i,"Sent To Print");
					
					shState[i] := SH_MOVE_TO_PRINT;
				END_IF
			SH_MOVE_TO_TAMP:  //******************************************************************************** Shuttle is moving to the tamping location
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Status.Error := TRUE;
					gShuttleIf[i].Status.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gTampStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gTampStationIf.Status.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gTampStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Status.ShuttleInfo.Position)) THEN
					gTampStationIf.Par.ShuttleIdx := i;
					gTampStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at Tamp");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_TAMP;
				END_IF
			SH_TAMP:  //******************************************************************************** Shuttle is currently being tamped
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gTampStationIf.Cmd.Process := FALSE;//Respond to the unload station we're done
				
					gShuttleIf[i].Status.ProductTamped := TRUE;
					gShuttleIf[i].Cmd.NextStep := FALSE;
				
					gShuttleIf[i].Status.CurrentDestination := DEST_UNLOAD;
				
					shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
					shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
					shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.TampToUnloadMacroID);
					shFbs[i].ShRunMacroFb.Execute := TRUE;
				
					LogDebug(gAuditTrail,i,"Sent To Unload");
					
					shState[i] := SH_MOVE_TO_OFFLOAD;
				END_IF
			SH_MOVE_TO_OFFLOAD:  //******************************************************************************** Shuttle is moving to the offload position
				IF shFbs[i].ShRunMacroFb.Error THEN
					gShuttleIf[i].Status.Error := TRUE;
					gShuttleIf[i].Status.ErrorState := shState[i];
					shState[i] := SH_ERROR;
				ELSIF shFbs[i].ShRunMacroFb.Done AND (gUnloadStationIf.Par.ShuttleIdx = STATION_IS_EMPTY AND gUnloadStationIf.Status.ReadyForNewShuttle) 
					AND PositionValidation(ADR(gUnloadStationIf.Cfg.StationPos),ADR(gShuttleIf[i].Status.ShuttleInfo.Position)) THEN
					gUnloadStationIf.Par.ShuttleIdx := i; 
					gUnloadStationIf.Cmd.Process := TRUE;
				
					LogDebug(gAuditTrail,i,"Arrived at unload");
					
					shFbs[i].ShRunMacroFb.Execute := FALSE;
					shState[i] := SH_OFFLOAD;
				END_IF
			SH_OFFLOAD:  //******************************************************************************** Shuttle is currently being offloaded
				//Station has control on the shuttle during this section
				IF gShuttleIf[i].Cmd.NextStep THEN
					gUnloadStationIf.Cmd.Process := FALSE; //Respond to the unload station we're done
				
					gShuttleIf[i].Cmd.NextStep := FALSE;
					gShuttleIf[i].Cmd.ResetProductInfo := TRUE;
					gShuttleIf[i].Status.CurrentDestination := DEST_LOAD;
					
					//Increment the process counter
					gProcessInfoIf.Par.CurrentProductCount := gProcessInfoIf.Par.CurrentProductCount + 1;
			
					IF gShuttleIf[i].Cmd.Stop THEN
						gShuttleIf[i].Cmd.Stop := FALSE;
						shState[i] := SH_INIT;
					ELSE
						shFbs[i].ShRunMacroFb.Controller := ADR(gMcAcp6DController);
						shFbs[i].ShRunMacroFb.ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
						shFbs[i].ShRunMacroFb.MacroID := UDINT_TO_USINT(gShuttleIf[i].Par.MacroIDs.UnloadToLoadMacroID);
						shFbs[i].ShRunMacroFb.Execute := TRUE;
				
						LogDebug(gAuditTrail,i,"Sent To Load");
						
						shState[i] := SH_MOVE_TO_LOAD;
					END_IF
				
				END_IF
			SH_ERROR: //******************************************************************************** Shuttle is in the error state
		
		END_CASE;
		shFbs[i].ShRunMacroFb();
	
		IF gShuttleIf[i].Cmd.ResetProductInfo THEN
			gShuttleIf[i].Status.CurrentDestination := DEST_LOAD;
			gShuttleIf[i].Status.BlisterPresent := FALSE;
			gShuttleIf[i].Status.CurrentLayer := 0;
			gShuttleIf[i].Status.Error := FALSE;
			gShuttleIf[i].Status.ErrorState := 0;
			gShuttleIf[i].Status.ProductTamped := 0;
			gShuttleIf[i].Cmd.ResetProductInfo := FALSE;
		END_IF
	END_FOR;
	pDebugIf ACCESS ADR(gShuttleIf[debugIdx]);
	pDebugState ACCESS ADR(shState[debugIdx]);
	pDebugFbs ACCESS ADR(shFbs[debugIdx]);
	
END_PROGRAM
