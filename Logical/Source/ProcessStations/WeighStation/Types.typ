
TYPE
	WeighStationStateEnum : 
		(
		WEIGH_OFF, (*Weigh station is currently disabled*)
		WEIGH_INIT, (*Weigh station is initalizing*)
		WEIGH_WAIT_FOR_SHUTTLE, (*Weigh station is waiting for a shuttle to be present*)
		WEIGH_LAND, (*Weigh station is landing a shuttle*)
		WEIGH_TAKEOFF, (*Weigh station is taking off a shuttle*)
		WEIGH_WEIGHING, (*Weigh station is weighing product onto a shuttle*)
		WEIGH_DONE, (*Weigh station is done with the weigh process*)
		WEIGH_ERROR (*Weigh station had an error*)
		);
	WeighStationFbTyp : 	STRUCT 
		WeighTimerFb : TON;
		LevitationCtrlFb : MC_BR_LevitationCtrl_Acp6D;
	END_STRUCT;
END_TYPE
