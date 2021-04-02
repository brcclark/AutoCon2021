
TYPE
	BufferAreaStatesEnum : 
		(
		BUFFER_OFF, (*Buffer station is currently disabled*)
		BUFFER_INIT, (*Buffer station is initalizing*)
		BUFFER_WAIT_FOR_SHUTTLE, (*Buffer station is waiting for a shuttle to be requested to be added*)
		BUFFER_ADDING_SHUTTLE, (*Buffer station is adding a shuttle to the buffer*)
		BUFFER_CALL_OFF_SHUTTLES, (*Buffer station is calling off shuttles to be removed from the buffer area*)
		BUFFER_DONE, (*Buffer station is done with the process*)
		BUFFER_ERROR (*Buffer station had an error*)
		);
END_TYPE
