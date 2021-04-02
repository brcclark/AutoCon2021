
TYPE
	LoadStationStateEnum : 
		(
		LOAD_OFF, (*Load station is currently disabled*)
		LOAD_INIT, (*Load station is initalizing*)
		LOAD_WAIT_FOR_SHUTTLE, (*Load station is waiting for a shuttle to be present*)
		LOAD_CHECK_BUFFER, (*Load station is Checking on the buffer status *)
		LOAD_LOADING, (*Load station is loading product onto a shuttle*)
		LOAD_DONE, (*Load station is done with the load process*)
		LOAD_ERROR (*Load station had an error*)
		);
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
	LoadStationFbTyp : 	STRUCT 
		BatchProcessFb : BatchProcess6DFb;
	END_STRUCT;
END_TYPE
