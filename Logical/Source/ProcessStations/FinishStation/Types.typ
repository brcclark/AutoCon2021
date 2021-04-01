
TYPE
	FinishStationStateEnum : 
		(
		FINISH_OFF, (*Finish station is currently disabled*)
		FINISH_INIT, (*Finish station is initalizing*)
		FINISH_WAIT_FOR_SHUTTLE, (*Finish station is waiting for a shuttle to be present*)
		FINISH_CHECK_BUFFER, (*Finish station is Checking on the buffer status *)
		FINISH_FINISHING, (*Finish station is preforming the batch finishing process on the shuttles*)
		FINISH_DONE, (*Finish station is done with the finish process*)
		FINISH_ERROR (*Finish station had an error*)
		);
	FinishStationFbTyp : 	STRUCT 
		BatchProcessFb : BatchProcess6DFb;
	END_STRUCT;
END_TYPE
