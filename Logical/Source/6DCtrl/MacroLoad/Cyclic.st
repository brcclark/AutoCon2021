
PROGRAM _CYCLIC
	CASE state OF
		MACLOAD_IDLE:	//******************************************************************************** Macro Idle State
			IF gMacroLoadIf.Cmd.LoadAll OR gMacroLoadIf.Cmd.LoadSingle THEN
				gMacroLoadIf.Sts.AllMacrosLoaded := FALSE;
				gMacroLoadIf.Sts.Loading := TRUE;
				gMacroLoadIf.Sts.CurrentMacro := 0;
				
				state := MACLOAD_COUNT_CHECK;
			ELSIF gMacroLoadIf.Cmd.Clear THEN
				MacroFbs.MacroClearFb.Controller := ADR(gMcAcp6DController);
				MacroFbs.MacroClearFb.MacroID := gMacroLoadIf.Par.SingleMacroLoad.MacroID;
				MacroFbs.MacroClearFb.Execute := TRUE;
				
				state := MACLOAD_CLEAR;
			ELSIF gMacroLoadIf.Cmd.Reset THEN
				gMacroLoadIf.Sts.AllMacrosLoaded := FALSE;
				gMacroLoadIf.Cmd.Reset := FALSE;
			END_IF
			
		MACLOAD_LOAD://******************************************************************************** Macro Load State
			IF MacroFbs.MacroLoadFb.Error THEN
				gMacroLoadIf.Sts.Error := TRUE;
				gMacroLoadIf.Sts.MacroIDError := gMacroLoadIf.Sts.CurrentMacro;
				
				state := MACLOAD_ERROR;
			ELSIF MacroFbs.MacroLoadFb.Done THEN
				MacroFbs.MacroLoadFb.Execute := FALSE;
				IF gMacroLoadIf.Cmd.LoadSingle THEN
					gMacroLoadIf.Sts.CmdDone := TRUE;
				ELSE //Means we commanded a "LOAD ALL"
					gMacroLoadIf.Sts.CurrentMacro := gMacroLoadIf.Sts.CurrentMacro + 1;
					
					state := MACLOAD_COUNT_CHECK;
				END_IF
			END_IF
			
		MACLOAD_COUNT_CHECK: //******************************************************************************** Macro Count check State
			IF gMacroLoadIf.Par.MacroList[gMacroLoadIf.Sts.CurrentMacro].Load THEN
				MacroFbs.MacroLoadFb.Controller := ADR(gMcAcp6DController);
				MacroFbs.MacroLoadFb.FileDevice := gMacroLoadIf.Par.FileDevice;
				IF gMacroLoadIf.Cmd.LoadAll THEN
					MacroFbs.MacroLoadFb.MacroID := gMacroLoadIf.Par.MacroList[gMacroLoadIf.Sts.CurrentMacro].MacroID;
					MacroFbs.MacroLoadFb.FileName := gMacroLoadIf.Par.MacroList[gMacroLoadIf.Sts.CurrentMacro].MacroFileName;
					
				ELSIF gMacroLoadIf.Cmd.LoadSingle THEN
					MacroFbs.MacroLoadFb.MacroID := gMacroLoadIf.Par.SingleMacroLoad.MacroID;
					MacroFbs.MacroLoadFb.FileName := gMacroLoadIf.Par.SingleMacroLoad.MacroFileName;
				END_IF
				MacroFbs.MacroLoadFb.Execute := TRUE;
				state := MACLOAD_LOAD;
			ELSE
				gMacroLoadIf.Sts.CurrentMacro := gMacroLoadIf.Sts.CurrentMacro + 1;
				IF gMacroLoadIf.Sts.CurrentMacro >= MAX_MACRO_COUNT THEN
					gMacroLoadIf.Sts.AllMacrosLoaded := TRUE;
					gMacroLoadIf.Sts.CmdDone := TRUE;
						
					state := MACLOAD_DONE;
				END_IF	
			END_IF
		MACLOAD_CLEAR: //******************************************************************************** Macro Clear state 
			IF MacroFbs.MacroClearFb.Error THEN
				gMacroLoadIf.Sts.Error := TRUE;
				
				state := MACLOAD_ERROR;
			ELSIF MacroFbs.MacroClearFb.Done THEN
				MacroFbs.MacroClearFb.Execute := FALSE;
				gMacroLoadIf.Sts.CmdDone := TRUE;
				
				state := MACLOAD_DONE;
			END_IF
		MACLOAD_DONE: //******************************************************************************** Load Done State
			gMacroLoadIf.Sts.Loading := FALSE;
			IF NOT gMacroLoadIf.Cmd.Clear AND NOT gMacroLoadIf.Cmd.LoadAll AND NOT gMacroLoadIf.Cmd.LoadSingle THEN
				gMacroLoadIf.Sts.CmdDone := FALSE;
				state := MACLOAD_IDLE;
			END_IF
		MACLOAD_ERROR: //******************************************************************************** Macro load error State
			IF gMacroLoadIf.Cmd.Reset THEN
				MacroFbs.MacroClearFb.Execute := FALSE;
				MacroFbs.MacroLoadFb.Execute := FALSE;
				
				gMacroLoadIf.Cmd.Reset := FALSE;
				
				gMacroLoadIf.Sts.Loading := FALSE;
				gMacroLoadIf.Sts.AllMacrosLoaded := FALSE;
				gMacroLoadIf.Sts.Error := FALSE;
				gMacroLoadIf.Sts.MacroIDError := 0;
				state := MACLOAD_IDLE;
			END_IF
	END_CASE;
	
	//FB Calls
	MacroFbs.MacroLoadFb();
	MacroFbs.MacroClearFb();
END_PROGRAM


