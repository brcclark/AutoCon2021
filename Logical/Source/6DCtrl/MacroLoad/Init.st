

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
	
	//Fill Station 4 Macro
	gMacroLoadIf.Par.MacroList[4].Load := TRUE;
	gMacroLoadIf.Par.MacroList[4].MacroFileName := '143_FillStation4.xml';
	gMacroLoadIf.Par.MacroList[4].MacroID := 143;
	
	
	//Bypass Enter
	//Fill1 Enter
	gMacroLoadIf.Par.MacroList[5].Load := TRUE;
	gMacroLoadIf.Par.MacroList[5].MacroFileName := '130_Fill1EnterBypass.xml';
	gMacroLoadIf.Par.MacroList[5].MacroID := 130;
	
	//Fill2 Enter
	gMacroLoadIf.Par.MacroList[6].Load := TRUE;
	gMacroLoadIf.Par.MacroList[6].MacroFileName := '131_Fill2EnterBypass.xml';
	gMacroLoadIf.Par.MacroList[6].MacroID := 131;
	
	//Fill3 Enter
	gMacroLoadIf.Par.MacroList[7].Load := TRUE;
	gMacroLoadIf.Par.MacroList[7].MacroFileName := '132_Fill3EnterBypass.xml';
	gMacroLoadIf.Par.MacroList[7].MacroID := 132;
	
	//Fill4 Enter
	gMacroLoadIf.Par.MacroList[8].Load := TRUE;
	gMacroLoadIf.Par.MacroList[8].MacroFileName := '133_Fill4EnterBypass.xml';
	gMacroLoadIf.Par.MacroList[8].MacroID := 133;
	
	//Bypass Exit
	//Fill1 Exit
	gMacroLoadIf.Par.MacroList[9].Load := TRUE;
	gMacroLoadIf.Par.MacroList[9].MacroFileName := '134_Fill1ExitBypass.xml';
	gMacroLoadIf.Par.MacroList[9].MacroID := 134;
	//Fill2 Exit
	gMacroLoadIf.Par.MacroList[10].Load := TRUE;
	gMacroLoadIf.Par.MacroList[10].MacroFileName := '135_Fill2ExitBypass.xml';
	gMacroLoadIf.Par.MacroList[10].MacroID := 135;
	//Fill3 Exit
	gMacroLoadIf.Par.MacroList[11].Load := TRUE;
	gMacroLoadIf.Par.MacroList[11].MacroFileName := '136_Fill3ExitBypass.xml';
	gMacroLoadIf.Par.MacroList[11].MacroID := 136;
	//Fill4 Exit
	gMacroLoadIf.Par.MacroList[12].Load := TRUE;
	gMacroLoadIf.Par.MacroList[12].MacroFileName := '137_Fill4ExitBypass.xml';
	gMacroLoadIf.Par.MacroList[12].MacroID := 137;
	
	//Fill Exit to Weigh 1
	gMacroLoadIf.Par.MacroList[13].Load := TRUE;
	gMacroLoadIf.Par.MacroList[13].MacroFileName := '150_FillExitToWeigh1.xml';
	gMacroLoadIf.Par.MacroList[13].MacroID := 150;
	
	gMacroLoadIf.Par.MacroList[14].Load := TRUE;
	gMacroLoadIf.Par.MacroList[14].MacroFileName := '151_FillExitToWeigh2.xml';
	gMacroLoadIf.Par.MacroList[14].MacroID := 151;
	
	//Finish to Buffer areas
	gMacroLoadIf.Par.MacroList[15].Load := TRUE;
	gMacroLoadIf.Par.MacroList[15].MacroFileName := '152_FinishToBuffer1.xml';
	gMacroLoadIf.Par.MacroList[15].MacroID := 152;
	
	gMacroLoadIf.Par.MacroList[16].Load := TRUE;
	gMacroLoadIf.Par.MacroList[16].MacroFileName := '153_FinishToBuffer2.xml';
	gMacroLoadIf.Par.MacroList[16].MacroID := 153;
	
	gMacroLoadIf.Par.MacroList[17].Load := TRUE;
	gMacroLoadIf.Par.MacroList[17].MacroFileName := '154_FinishToBuffer3.xml';
	gMacroLoadIf.Par.MacroList[17].MacroID := 154;
	
	//Buffer to Unload Area
	gMacroLoadIf.Par.MacroList[18].Load := TRUE;
	gMacroLoadIf.Par.MacroList[18].MacroFileName := '155_Buffer1ToUnload.xml';
	gMacroLoadIf.Par.MacroList[18].MacroID := 155;
	
	gMacroLoadIf.Par.MacroList[19].Load := TRUE;
	gMacroLoadIf.Par.MacroList[19].MacroFileName := '156_Buffer2ToUnload.xml';
	gMacroLoadIf.Par.MacroList[19].MacroID := 156;
	
	gMacroLoadIf.Par.MacroList[20].Load := TRUE;
	gMacroLoadIf.Par.MacroList[20].MacroFileName := '157_Buffer3ToUnload.xml';
	gMacroLoadIf.Par.MacroList[20].MacroID := 157;
	
	//Load to Fill Enter
	gMacroLoadIf.Par.MacroList[21].Load := TRUE;
	gMacroLoadIf.Par.MacroList[21].MacroFileName := '144_LoadToFillEnter.xml';
	gMacroLoadIf.Par.MacroList[21].MacroID := 144;
	
	//Define the parameters for the macro load IF
	gMacroLoadIf.Par.FileDevice := '6DMacro';
END_PROGRAM