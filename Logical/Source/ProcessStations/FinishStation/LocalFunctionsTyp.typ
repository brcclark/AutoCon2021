
TYPE
	BatchProcess6DInternalTyp : 	STRUCT 
		State : BatchProcess6DStateEnum;
		currentShuttleCount : USINT;
		Fbs : BatchProcess6DFbsTyp;
	END_STRUCT;
	BatchProcess6DStateEnum : 
		(
		BATCH_OFF,
		BATCH_INIT,
		BATCH_WAIT_SHUTTLE,
		BATCH_MOVE_SHUTTLE,
		BATCH_PREFORM_OPERATION,
		BATCH_DONE,
		BATCH_RESET,
		BATCH_ERROR
		);
	BatchProcess6DFbsTyp : 	STRUCT 
		MoveInPlaneFb : MC_BR_MoveInPlane_Acp6D;
		WaitTimer : TON;
	END_STRUCT;
END_TYPE
