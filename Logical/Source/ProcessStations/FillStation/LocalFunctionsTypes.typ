
TYPE
	AngledMovementInternalTyp : 	STRUCT 
		state : AngledMovementInternalStateEnum;
		Fbs : AngledMovementInternalFbsTyp;
		ShPos : ARRAY[0..5]OF REAL;
		MovementNum : USINT;
	END_STRUCT;
	AngledMovementInternalFbsTyp : 	STRUCT 
		Move6DFb : MC_BR_Move6D_Acp6D;
	END_STRUCT;
	AngledMovementInternalStateEnum : 
		(
		ANG_INT_OFF,
		ANG_INT_MOV_WAIT,
		ANG_INT_MOV_1,
		ANG_INT_MOV_2,
		ANG_INT_MOV_3,
		ANG_INT_MOV_4,
		ANG_INT_MOV_5,
		ANG_INT_DONE,
		ANG_INT_ERROR
		);
END_TYPE
