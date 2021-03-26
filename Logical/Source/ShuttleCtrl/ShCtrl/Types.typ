
TYPE
	ShFbsTyp : 	STRUCT 
		ShRunMacroFb : MC_BR_MacroRun_Acp6D; (*Execute a macro on the current shuttle*)
	END_STRUCT;
	ShCycleIfs : {REDUND_UNREPLICABLE} 	STRUCT 
		Dose : REFERENCE TO DoseStationIfTyp;
	END_STRUCT;
END_TYPE
