
PROGRAM _CYCLIC
	IF NOT gBufferAreaIf.Cmd.LocalOverride THEN
		stationPars := gSysPars.BufferArea;
	END_IF
	
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
				
				IF bufferArea.CurrentLength >= stationPars.MinBufferSize THEN
					state := BUFFER_CALL_OFF_SHUTTLES;
				ELSE
					gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
					gBufferAreaIf.Sts.ReadyForNewShuttle := TRUE;
					
					state := BUFFER_WAIT_FOR_SHUTTLE;	
				END_IF
			END_IF//********************************************************************************Buffer station is calling off shuttles to be removed from the buffer area
		BUFFER_CALL_OFF_SHUTTLES:
			//This is a little dangerous of a process
			(*
				Get a random shuttle number from 1 to the current length
				Remove that ID from the list to get the value at that index
				Use that value as the index for the gShuttle interface to command off the buffer
			*)
			WHILE bufferArea.CurrentLength > stationPars.MinBufferSize - 4 DO
				serveShuttleId := DINT_TO_USINT(RandValueDINT(1,bufferArea.CurrentLength));
				shId := blRemoveItem(ADR(bufferArea),serveShuttleId);
				gShuttleIf[SINT_TO_USINT(shId)].Cmd.NextStep := TRUE;
				
			END_WHILE;
			gBufferAreaIf.Par.ShuttleIdx := STATION_IS_EMPTY;
			gBufferAreaIf.Sts.ReadyForNewShuttle := TRUE;
			
			state := BUFFER_WAIT_FOR_SHUTTLE;
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
