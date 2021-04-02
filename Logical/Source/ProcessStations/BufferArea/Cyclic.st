
PROGRAM _CYCLIC
	
	CASE state OF
		BUFFER_OFF: //********************************************************************************Buffer station is currently disabled
			IF gBufferAreaIf.Cmd.Enable THEN
				state := BUFFER_INIT;
			END_IF
		BUFFER_INIT: //********************************************************************************Buffer station is initalizing
			gBufferAreaIf.Sts.ReadyForNewShuttle := TRUE;
			gBufferAreaIf.Sts.Enabled := TRUE;
			state := BUFFER_WAIT_FOR_SHUTTLE;
		BUFFER_WAIT_FOR_SHUTTLE: //********************************************************************************Buffer station is waiting for a shuttle to be requested to be added
			IF NOT gBufferAreaIf.Cmd.Enable THEN
				gBufferAreaIf.Sts.ReadyForNewShuttle := FALSE;
				gBufferAreaIf.Sts.Enabled := FALSE;
				state := BUFFER_OFF;
			ELSIF gBufferAreaIf.Par.ShuttleIdx <> STATION_IS_EMPTY AND gBufferAreaIf.Cmd.Process THEN
				gBufferAreaIf.Sts.ReadyForNewShuttle := FALSE;
				gBufferAreaIf.Sts.Processing := TRUE;
				
				state := BUFFER_ADDING_SHUTTLE;
			END_IF
		BUFFER_ADDING_SHUTTLE: //********************************************************************************Buffer station is adding a shuttle to the buffer
			returnVal := blAddItem(ADR(bufferArea),gBufferAreaIf.Par.ShuttleIdx);
			IF returnVal <> 0 THEN
				gBufferAreaIf.Sts.Error := TRUE;
				state := BUFFER_ERROR;
			ELSE
				gBufferAreaIf.Sts.Processing := FALSE;
				
				gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gBufferAreaIf.Sts.ReadyForNewShuttle := TRUE;
								
				state := BUFFER_WAIT_FOR_SHUTTLE;
			END_IF//********************************************************************************Buffer station is calling off shuttles to be removed from the buffer area
		BUFFER_CALL_OFF_SHUTTLES:
		BUFFER_DONE: //********************************************************************************Buffer station is done with the process
			
			IF NOT gBufferAreaIf.Cmd.Enable THEN
				gBufferAreaIf.Sts.Done := FALSE;
				gBufferAreaIf.Sts.Enabled := FALSE;
				gBufferAreaIf.Sts.ReadyForNewShuttle := FALSE;
				blResetList(ADR(bufferArea));
				state := BUFFER_OFF;
			ELSIF NOT gBufferAreaIf.Cmd.Process THEN
				gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				gBufferAreaIf.Sts.Done := FALSE;
				gBufferAreaIf.Sts.ReadyForNewShuttle := TRUE;
				
				state := BUFFER_WAIT_FOR_SHUTTLE;
			END_IF
			
		BUFFER_ERROR: //********************************************************************************Load station had an error
			IF gBufferAreaIf.Cmd.Reset THEN
				gBufferAreaIf.Cmd.Reset := FALSE;
				
				blResetList(ADR(bufferArea));
				
				gBufferAreaIf.Sts.Done := FALSE;
				gBufferAreaIf.Sts.Enabled := FALSE;
				gBufferAreaIf.Sts.Error := FALSE;
				gBufferAreaIf.Sts.Processing := FALSE;
				gBufferAreaIf.Sts.ReadyForNewShuttle := FALSE;
				
				gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
				IF gBufferAreaIf.Cmd.Enable THEN
					state := BUFFER_INIT;
				ELSE
					state := BUFFER_OFF;
				END_IF
			END_IF
	END_CASE;
END_PROGRAM
