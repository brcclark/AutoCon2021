

PROGRAM _INIT
	FOR i:=0 TO MAX_SHUTTLE_COUNT-1 DO
		gShuttleIf[i].Par.MacroIDs.LoadToPrintMacroID := MACRO_LOAD_TO_PRINT;
		gShuttleIf[i].Par.MacroIDs.PrintToTampMacroID := MACRO_PRINT_TO_TAMP;
		gShuttleIf[i].Par.MacroIDs.PrintToDoseMacroID := MACRO_PRINT_TO_DOSE2; //Hard coding this for now
		gShuttleIf[i].Par.MacroIDs.DoseToPrintMacroID:= MACRO_DOSE_TO_PRINT;
		gShuttleIf[i].Par.MacroIDs.TampToUnloadMacroID := MACRO_TAMP_TO_UNLOAD;
		gShuttleIf[i].Par.MacroIDs.UnloadToLoadMacroID := MACRO_UNLOAD_TO_LOAD;
		//The print to dose is defined in the shuttle decide dose task
	
		gShuttleIf[i].Par.NumLayers := 4;	
	END_FOR;
	
	NextDoseStation := DEST_DOSE1;
END_PROGRAM