

PROGRAM _INIT
	//Enable the macros for loading
	gMacroLoadIf.Par.MacroList[0].Load := TRUE;
	gMacroLoadIf.Par.MacroList[0].MacroFileName := '160_RecoveryGroup0.xml';
	gMacroLoadIf.Par.MacroList[0].MacroID := 160;
	
	//Fill Station 2
	gMacroLoadIf.Par.MacroList[1].Load := TRUE;
	gMacroLoadIf.Par.MacroList[1].MacroFileName := '140_FillStation2.xml';
	gMacroLoadIf.Par.MacroList[1].MacroID := 140;
	
	//Fill Station 3
	//XY Macro
	gMacroLoadIf.Par.MacroList[2].Load := TRUE;
	gMacroLoadIf.Par.MacroList[2].MacroFileName := '141_FillStation3XY.xml';
	gMacroLoadIf.Par.MacroList[2].MacroID := 141;
	//Wobble Macro
	gMacroLoadIf.Par.MacroList[3].Load := TRUE;
	gMacroLoadIf.Par.MacroList[3].MacroFileName := '142_FillStation3Wobble.xml';
	gMacroLoadIf.Par.MacroList[3].MacroID := 142;
	
	//Define the parameters for the macro load IF
	gMacroLoadIf.Par.FileDevice := '6DMacro';
END_PROGRAM