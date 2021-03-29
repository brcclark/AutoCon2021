
TYPE
	FillStationStateEnum : 
		(
		FILL_OFF, (*Fill station is currently disabled*)
		FILL_INIT, (*Fill station is initalizing*)
		FILL_WAIT_FOR_SHUTTLE, (*Fill station is waiting for a shuttle to be present*)
		FILL_ENTER_SHUTTLE, (*Shuttle is entering the filling station*)
		FILL_FILLING, (*Fill station is preforming the filling process*)
		FILL_EXIT_SHUTTLE, (*Fill station is preforming the exit movement*)
		FILL_DONE, (*Fill station is done with the filling process*)
		FILL_ERROR (*Fill station had an error*)
		);
	FillStationFbTyp : 	STRUCT 
		FillMoveFb : MC_BR_MoveInPlane_Acp6D;
		WaitTimer : TON;
		St1Fb : AngledMovementFb;
		St2Fb : MC_BR_MacroRun_Acp6D;
		St3Fb : WobbleMovementFb;
	END_STRUCT;
	FillStationEnum : 
		(
		ST_UNDEF,
		ST1,
		ST2,
		ST3,
		ST4
		);
END_TYPE
