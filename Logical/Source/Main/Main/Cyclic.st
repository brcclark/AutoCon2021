
PROGRAM _CYCLIC
	IF gAcp6DCtrlIf.Sts.Error THEN
		state := MAIN_ERROR;
	END_IF

	CASE state OF
		MAIN_OFF: //******************************************************************************** Main Off State
			IF gMainIf.Cmd.Power THEN
				gAcp6DCtrlIf.Cmd.Power := TRUE;
				
				state := MAIN_INIT;
			END_IF
		MAIN_INIT: //******************************************************************************** Main Initializing State
			IF gAcp6DCtrlIf.Sts.PowerOn AND gAcp6DCtrlIf.Sts.Ready THEN
				gMainIf.Sts.PowerOn := TRUE;
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
				gProcessInfoIf.Cmd.Enable := TRUE;
				gFillStationsIf[0].Cmd.Enable := TRUE;
				gFillStationsIf[1].Cmd.Enable := TRUE;
				gFillStationsIf[2].Cmd.Enable := TRUE;
				gFillStationsIf[3].Cmd.Enable := TRUE;
				gWeighStationIf[0].Cmd.Enable := TRUE;
				gWeighStationIf[1].Cmd.Enable := TRUE;
				gRobotIf[Load_Robot].Cmd.Enable := TRUE;
				gRobotIf[Unload_Robot].Cmd.Enable := TRUE;
				gFinishStationIf.Cmd.Enable := TRUE;
				gBufferAreaIf.Cmd.Enable := TRUE;
				gUnloadStationIf.Cmd.Enable := TRUE;
				
				CmdShEnable(TRUE, ADR(gShuttleIf), gMainIf.Cfg.ShuttleCount);
				
				state := MAIN_STARTING;
			ELSIF NOT gMainIf.Cmd.Power THEN
				gMainIf.Sts.PowerOn := FALSE;
				gAcp6DCtrlIf.Cmd.Power := FALSE;
				state := MAIN_OFF;
			END_IF
		MAIN_STARTING://******************************************************************************** Main Starting State
			IF gLoadStationIf.Sts.Enabled 
				AND gFillStationsIf[0].Sts.Enabled 
				AND gFillStationsIf[1].Sts.Enabled 
				AND gFillStationsIf[2].Sts.Enabled 
				AND gFillStationsIf[3].Sts.Enabled 
				AND gWeighStationIf[0].Sts.Enabled 
				AND gWeighStationIf[0].Sts.Enabled 
				AND gFinishStationIf.Sts.Enabled
				AND gRobotIf[Load_Robot].Sts.Ready 
				AND gRobotIf[Unload_Robot].Sts.Ready 
				AND gBufferAreaIf.Sts.Enabled 
				AND gProcessInfoIf.Sts.Enabled 
				AND gUnloadStationIf.Sts.Enabled THEN
				
				gMainIf.Cmd.Start := FALSE;
				state := MAIN_RUNNING;
			END_IF
			
		MAIN_RUNNING: //******************************************************************************** Main Running State
			IF gMainIf.Cmd.Stop THEN
				gLoadStationIf.Cmd.Enable := FALSE;
				gFillStationsIf[0].Cmd.Enable := FALSE;
				gFillStationsIf[1].Cmd.Enable := FALSE;
				gFillStationsIf[2].Cmd.Enable := FALSE;
				gFillStationsIf[3].Cmd.Enable := FALSE;
				gWeighStationIf[0].Cmd.Enable := FALSE;
				gWeighStationIf[1].Cmd.Enable := FALSE;
				gFinishStationIf.Cmd.Enable := FALSE;
				gRobotIf[Load_Robot].Cmd.Enable := FALSE;
				gRobotIf[Unload_Robot].Cmd.Enable := FALSE;
				gBufferAreaIf.Cmd.Enable := FALSE;
				gProcessInfoIf.Cmd.Enable := FALSE;
				gUnloadStationIf.Cmd.Enable := FALSE;
				CmdShStop(ADR(gShuttleIf),gMainIf.Cfg.ShuttleCount);
				
				state := MAIN_STOPPING;
			END_IF
		MAIN_STOPPING: //******************************************************************************** Main Stopping State
			IF NOT gLoadStationIf.Sts.Enabled 
				AND NOT gFillStationsIf[0].Sts.Enabled 
				AND NOT gFillStationsIf[1].Sts.Enabled 
				AND NOT gFillStationsIf[2].Sts.Enabled 
				AND NOT gFillStationsIf[3].Sts.Enabled 
				AND NOT gWeighStationIf[0].Sts.Enabled
				AND NOT gWeighStationIf[1].Sts.Enabled
				AND NOT gFinishStationIf.Sts.Enabled
				AND NOT gBufferAreaIf.Sts.Enabled
				AND NOT gProcessInfoIf.Sts.Enabled 
				AND NOT gUnloadStationIf.Sts.Enabled THEN
				
				gMainIf.Cmd.Stop := FALSE;
				CmdShEnable(FALSE, ADR(gShuttleIf), gMainIf.Cfg.ShuttleCount);
				
				FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
					gShuttleIf[i].Sts.Recovered := FALSE;
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
