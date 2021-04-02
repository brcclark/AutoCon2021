
TYPE
	UnloadStationFbTyp : 	STRUCT 
		BatchProcessFb : BatchProcess6DFb;
	END_STRUCT;
	UnloadStationStateEnum : 
		(
		UNLOAD_OFF, (*Unload station is currently disabled*)
		UNLOAD_INIT, (*Unload station is initalizing*)
		UNLOAD_WAIT_FOR_SHUTTLE, (*Unload station is waiting for a shuttle to be present*)
		UNLOAD_CHECK_BUFFER, (*Unload station is Checking on the buffer status *)
		UNLOAD_UNLOADING, (*Unload station is unloading product onto a shuttle*)
		UNLOAD_DONE, (*Unload station is done with the unload process*)
		UNLOAD_ERROR (*Unload station had an error*)
		);
END_TYPE
