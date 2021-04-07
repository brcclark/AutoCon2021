
TYPE
	RejectStationStateEnum : 
		(
		REJECT_OFF, (*Reject station is currently disabled*)
		REJECT_INIT, (*Reject station is initalizing*)
		REJECT_WAIT_FOR_SHUTTLE, (*Reject station is waiting for a shuttle to be present*)
		REJECT_REJECTING, (*Reject station is rejecting product from the shuttle*)
		REJECT_DONE, (*Reject station is done with the weigh process*)
		REJECT_ERROR (*Reject station had an error*)
		);
	RejectStationFbTyp : 	STRUCT 
		RejectTimerFb : TON;
	END_STRUCT;
END_TYPE
