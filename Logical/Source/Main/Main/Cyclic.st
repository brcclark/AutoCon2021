
PROGRAM _CYCLIC
	IF gAcp6DCtrlIf.Status.Error THEN
		state := MAIN_ERROR;
	END_IF
	
	CASE state OF
		MAIN_OFF: //******************************************************************************** Main Off State
			IF gMainIf.Cmd.Power THEN
				gAcp6DCtrlIf.Cmd.Power := TRUE;
				
				state := MAIN_INIT;
			END_IF
		MAIN_INIT: //******************************************************************************** Main Initializing State
			IF gAcp6DCtrlIf.Status.PowerOn AND gAcp6DCtrlIf.Status.Ready THEN
				gMainIf.Status.PowerOn := TRUE;
				g6DRecoveryIf.Cmd.Recover := TRUE;
				
				state := MAIN_RECOVERING;
			ELSIF NOT gMainIf.Cmd.Power THEN
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				state := MAIN_OFF;
			END_IF
		MAIN_RECOVERING: //******************************************************************************** Main Recovery State
			IF g6DRecoveryIf.Sts.ReadyToStartProc THEN
				g6DRecoveryIf.Cmd.Recover := FALSE;
				
				state := MAIN_READY;
			END_IF	
		MAIN_READY://******************************************************************************** Main Ready State
			IF gMainIf.Cmd.Start THEN
				gLoadStationIf.Cmd.Enable := TRUE;
				gUnloadStationIf.Cmd.Enable := TRUE;
				gPrintStationIf.Cmd.Enable := TRUE;
				gDoseStationsIf[0].Cmd.Enable := TRUE;
				gDoseStationsIf[1].Cmd.Enable := TRUE;
				gTampStationIf.Cmd.Enable := TRUE;
				gProcessInfoIf.Cmd.Enable := TRUE;
				CmdShEnable(TRUE, ADR(gShuttleIf), gMainIf.Cfg.ShuttleCount);
				
				state := MAIN_STARTING;
			ELSIF NOT gMainIf.Cmd.Power THEN
				gMainIf.Status.PowerOn := FALSE;
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				state := MAIN_OFF;
			END_IF
		MAIN_STARTING://******************************************************************************** Main Starting State
			IF gLoadStationIf.Status.Enabled 
				AND gUnloadStationIf.Status.Enabled 
				AND gPrintStationIf.Status.Enabled 
				AND gDoseStationsIf[0].Status.Enabled 
				AND gDoseStationsIf[1].Status.Enabled 
				AND gTampStationIf.Status.Enabled 
				AND gProcessInfoIf.Sts.Enabled THEN
				
				gMainIf.Cmd.Start := FALSE;
				state := MAIN_RUNNING;
			END_IF
			
		MAIN_RUNNING: //******************************************************************************** Main Running State
			IF gMainIf.Cmd.Stop THEN
				gLoadStationIf.Cmd.Enable := FALSE;
				gUnloadStationIf.Cmd.Enable := FALSE;
				gPrintStationIf.Cmd.Enable := FALSE;
				gDoseStationsIf[0].Cmd.Enable := FALSE;
				gDoseStationsIf[1].Cmd.Enable := FALSE;
				gTampStationIf.Cmd.Enable := FALSE;
				gProcessInfoIf.Cmd.Enable := FALSE;
				
				state := MAIN_STOPPING;
			END_IF
		MAIN_STOPPING: //******************************************************************************** Main Stopping State
			IF NOT gLoadStationIf.Status.Enabled 
				AND NOT gUnloadStationIf.Status.Enabled 
				AND NOT gPrintStationIf.Status.Enabled 
				AND NOT gDoseStationsIf[0].Status.Enabled 
				AND NOT gDoseStationsIf[1].Status.Enabled 
				AND NOT gTampStationIf.Status.Enabled 
				AND NOT gProcessInfoIf.Sts.Enabled THEN
				
				gMainIf.Cmd.Stop := FALSE;
				
				FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
					gShuttleIf[i].Status.Recovered := FALSE;
				END_FOR;
				
				state := MAIN_READY;
			END_IF
			
		MAIN_ERROR: //******************************************************************************** Main Error State
			IF gMainIf.Cmd.Reset THEN
				gMainIf.Cmd.Reset := FALSE;
				gAcp6DCtrlIf.Cmd.ErrorReset := TRUE;
				
				state := MAIN_OFF;
			END_IF	
	END_CASE; 
	 
END_PROGRAM
