

PROGRAM _INIT
	//Enable the macros for loading
	gMacroLoadIf.Par.MacroList[0].Load := TRUE;
	gMacroLoadIf.Par.MacroList[0].MacroFileName := '128_LoadToPrint.xml';
	gMacroLoadIf.Par.MacroList[0].MacroID := 128;
	
	gMacroLoadIf.Par.MacroList[1].Load := TRUE;
	gMacroLoadIf.Par.MacroList[1].MacroFileName := '129_PrintToDose1.xml';
	gMacroLoadIf.Par.MacroList[1].MacroID := 129;
	
	gMacroLoadIf.Par.MacroList[2].Load := TRUE;
	gMacroLoadIf.Par.MacroList[2].MacroFileName := '130_PrintToDose2.xml';
	gMacroLoadIf.Par.MacroList[2].MacroID := 130;
	
	gMacroLoadIf.Par.MacroList[3].Load := TRUE;
	gMacroLoadIf.Par.MacroList[3].MacroFileName := '131_DoseToPrint.xml';
	gMacroLoadIf.Par.MacroList[3].MacroID := 131;
	
	gMacroLoadIf.Par.MacroList[4].Load := TRUE;
	gMacroLoadIf.Par.MacroList[4].MacroFileName := '132_PrintToTamp.xml';
	gMacroLoadIf.Par.MacroList[4].MacroID := 132;
	
	gMacroLoadIf.Par.MacroList[5].Load := TRUE;
	gMacroLoadIf.Par.MacroList[5].MacroFileName := '133_TampToUnload.xml';
	gMacroLoadIf.Par.MacroList[5].MacroID := 133;
	
	gMacroLoadIf.Par.MacroList[6].Load := TRUE;
	gMacroLoadIf.Par.MacroList[6].MacroFileName := '134_UnloadToLoad.xml';
	gMacroLoadIf.Par.MacroList[6].MacroID := 134;
	
	gMacroLoadIf.Par.MacroList[7].Load := TRUE;
	gMacroLoadIf.Par.MacroList[7].MacroFileName := '135_RecoveryGroup0.xml';
	gMacroLoadIf.Par.MacroList[7].MacroID := 135;
	
	gMacroLoadIf.Par.MacroList[8].Load := TRUE;
	gMacroLoadIf.Par.MacroList[8].MacroFileName := '136_RecoveryGroup1.xml';
	gMacroLoadIf.Par.MacroList[8].MacroID := 136;
	
	gMacroLoadIf.Par.MacroList[9].Load := TRUE;
	gMacroLoadIf.Par.MacroList[9].MacroFileName := '137_RecoveryGroup2.xml';
	gMacroLoadIf.Par.MacroList[9].MacroID := 137;
	//Define the parameters for the macro load IF
	gMacroLoadIf.Par.FileDevice := '6DMacro';
END_PROGRAM