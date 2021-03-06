
PROGRAM _CYCLIC
	
	IF((Fbs.SysReadStateFb.Valid AND Fbs.SysReadStateFb.State = mcACP6D_STATE_ERROR) AND (state <> ACP6D_ERROR))THEN
		state := ACP6D_ERROR;
	END_IF;
		

	CASE state OF
		ACP6D_RESET: 	//******************************************************************************** 6D Reset State
			IF(Fbs.SysReadStateFb.Valid AND (Fbs.SysReadStateFb.State = mcACP6D_STATE_INACTIVE))THEN
				state := ACP6D_INACTIVE;
			ELSIF(Fbs.SysReadStateFb.State = mcACP6D_STATE_OPERATION)THEN
				state := ACP6D_POWER_OFF;
			END_IF;
					
		ACP6D_POWER_OFF: 	//******************************************************************************** 6D Power off commanding State
			Fbs.PowerOffFb.Execute := TRUE;
			IF(Fbs.PowerOffFb.Acknowledge AND (Fbs.SysReadStateFb.Valid AND Fbs.SysReadStateFb.State = mcACP6D_STATE_INACTIVE))THEN
				gAcp6DCtrlIf.Sts.PowerOn := FALSE;
				Fbs.PowerOffFb.Execute 	:= FALSE;
				state := ACP6D_INACTIVE;
			ELSIF(Fbs.PowerOffFb.Error)THEN
				Fbs.PowerOffFb.Execute 	:= FALSE;
				gAcp6DCtrlIf.Sts.ErrorID := Fbs.PowerOffFb.ErrorID;
				state := ACP6D_ERROR;
			END_IF;
		
		ACP6D_INACTIVE:	 	//******************************************************************************** 6D Inactive/Power Off state
			IF(gAcp6DCtrlIf.Cmd.Power)THEN
				Fbs.PowerOnFb.Execute := TRUE;
				//MpAuditCustomEvent(gAuditTrail,"INFO","Acp6DSys","Power On Command Issued");
				state := ACP6D_POWER_ON;
			END_IF;
		
		ACP6D_POWER_ON: 	//******************************************************************************** 6D Power on Commanding State
			IF Fbs.PowerOnFb.Error THEN
				gAcp6DCtrlIf.Sts.ErrorID := Fbs.PowerOnFb.ErrorID;
				state := ACP6D_ERROR;
			ELSIF(Fbs.PowerOnFb.Acknowledge AND (Fbs.SysReadStateFb.Valid AND (Fbs.SysReadStateFb.State > mcACP6D_STATE_INACTIVE)))THEN
				//MpAuditCustomEvent(gAuditTrail,"INFO","Acp6DSys","Powered On");
				Fbs.PowerOnFb.Execute := FALSE;
				state := ACP6D_WAIT_ACTIVATION;
			END_IF;
				
			//Necessary state when using Absolute ID.
		ACP6D_WAIT_ACTIVATION: 	//******************************************************************************** 6D Waiting for Activation of Shuttles State
			IF(Fbs.SysReadStateFb.Valid)THEN
				IF(Fbs.SysReadStateFb.State = mcACP6D_STATE_OPERATION)THEN
					gAcp6DCtrlIf.Sts.PowerOn := TRUE;
					state := ACP6D_INIT_MACRO;
				ELSIF(Fbs.SysReadStateFb.State = mcACP6D_STATE_INACTIVE)THEN
					state := ACP6D_INACTIVE; // Error during Activating state; Can happen in Absolute ID mode.
					gAcp6DCtrlIf.Cmd.Power := FALSE;
				END_IF;
			END_IF;
		ACP6D_INIT_MACRO: 	//******************************************************************************** 6D Wait for Macro initilization State
			IF gMacroLoadIf.Sts.AllMacrosLoaded THEN
				gMacroLoadIf.Cmd.LoadAll := FALSE;
				state := ACP6D_READY;
			ELSE
				gMacroLoadIf.Cmd.LoadAll := TRUE;
			END_IF
			
		ACP6D_READY: 	//******************************************************************************** 6D Ready/Running State
			IF(NOT gAcp6DCtrlIf.Cmd.Power)THEN
				gMacroLoadIf.Cmd.Reset := TRUE;
				state := ACP6D_POWER_OFF;
			END_IF;

		ACP6D_ERROR: 	//******************************************************************************** 6D Error State
			gAcp6DCtrlIf.Sts.PowerOn := FALSE;
			IF(gAcp6DCtrlIf.Cmd.ErrorReset)THEN
				IF(Fbs.SysReadStateFb.State<>mcACP6D_STATE_ERROR)THEN
					gAcp6DCtrlIf.Cmd.ErrorReset := FALSE;
					state := ACP6D_RESET;
				ELSE
					Fbs.PowerOffFb.Execute := TRUE;	 // Reset error with power off. 
					IF(Fbs.PowerOffFb.Acknowledge)THEN
						gMacroLoadIf.Cmd.Reset := TRUE;
						Fbs.PowerOffFb.Execute 	:= FALSE;
					ELSIF(Fbs.PowerOffFb.Error)THEN
						gAcp6DCtrlIf.Cmd.ErrorReset := FALSE;
						Fbs.PowerOffFb.Execute 	:= FALSE;
						gAcp6DCtrlIf.Sts.ErrorID := Fbs.PowerOffFb.ErrorID;
						state := ACP6D_ERROR;
					END_IF;
				END_IF;
			END_IF;		
	END_CASE;

	FOR i:=0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		Fbs.ShReadPositionFb[i].Controller := ADR(gMcAcp6DController);
		Fbs.ShReadPositionFb[i].Enable := TRUE;
		Fbs.ShReadPositionFb[i].ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
		Fbs.ShReadPositionFb[i]();
		
		Fbs.ShReadForceFb[i].Controller := ADR(gMcAcp6DController);
		Fbs.ShReadForceFb[i].Enable := TRUE;
		Fbs.ShReadForceFb[i].ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
		Fbs.ShReadForceFb[i]();
		
		Fbs.ShReadState[i].Controller := ADR(gMcAcp6DController);
		Fbs.ShReadState[i].Enable := TRUE;
		Fbs.ShReadState[i].ShuttleID := gShuttleIf[i].Cfg.ShuttleId;
		Fbs.ShReadState[i]();
		
		gShuttleIf[i].Sts.ShuttleInfo.Force.Value := Fbs.ShReadForceFb[i].ForceInfo;
		gShuttleIf[i].Sts.ShuttleInfo.Force.Valid := Fbs.ShReadForceFb[i].Valid;
		gShuttleIf[i].Sts.ShuttleInfo.Position.Value := Fbs.ShReadPositionFb[i].PositionInfo;
		gShuttleIf[i].Sts.ShuttleInfo.Position.Valid := Fbs.ShReadPositionFb[i].Valid;
		gShuttleIf[i].Sts.ShuttleInfo.State.Value := Fbs.ShReadState[i].State;
		gShuttleIf[i].Sts.ShuttleInfo.State.Valid := Fbs.ShReadState[i].Valid;
	END_FOR;
	
	IF gAcp6DCtrlIf.Cmd.GetErrorInfo THEN
		Fbs.GetErrorCodesFb.Controller := ADR(gMcAcp6DController);
		Fbs.GetErrorCodesFb.Execute := TRUE;
		
		IF Fbs.GetErrorCodesFb.Valid OR Fbs.GetErrorCodesFb.Error THEN
			gAcp6DCtrlIf.Sts.ErrorCodes := Fbs.GetErrorCodesFb.ErrorCodes;
			Fbs.GetErrorCodesFb.Execute := FALSE;
			gAcp6DCtrlIf.Cmd.GetErrorInfo := FALSE;
		END_IF
		
	END_IF
	
	Fbs.GetErrorCodesFb();
	Fbs.SysReadStateFb();
	Fbs.PowerOffFb();
	Fbs.PowerOnFb();
	Fbs.AutoRefreshFB();
	
	gAcp6DCtrlIf.Sts.Ready := state = ACP6D_READY;
	gAcp6DCtrlIf.Sts.Error := state = ACP6D_ERROR;
	gAcp6DCtrlIf.Sts.ReadyToPowerOn := Fbs.SysReadStateFb.Valid AND Fbs.SysReadStateFb.State = mcACP6D_STATE_INACTIVE;

END_PROGRAM
