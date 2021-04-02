
(* TODO: Add your comment here *)
FUNCTION_BLOCK BatchProcess6DFb
	CASE Internal.State OF
		BATCH_OFF://******************************************************************************** Batch FB disabled
			IF Enable THEN
				Internal.State := BATCH_INIT;
			END_IF
		BATCH_INIT://******************************************************************************** Batch FB Initialization state
			Internal.Fbs.MoveInPlaneFb.Controller := ADR(Controller);
			ReadyForShuttle := TRUE;
			
			Internal.State := BATCH_WAIT_SHUTTLE;
		BATCH_WAIT_SHUTTLE://******************************************************************************** Batch FB Waiting for a shuttle to arrive
			IF ProcessShuttle THEN
				Internal.currentShuttleCount := Internal.currentShuttleCount + 1;
				ReadyForShuttle := FALSE;
				IF ShId = 0 THEN
					Error := TRUE;
					Internal.State := BATCH_ERROR;
				ELSE
					ProcessShuttle := FALSE;
					
					ShuttleIds[Internal.currentShuttleCount - 1] := ShId;
					Internal.Fbs.MoveInPlaneFb.ShuttleID := ShId;
					Internal.Fbs.MoveInPlaneFb.Velocity := 1.0;
					Internal.Fbs.MoveInPlaneFb.Acceleration := 10.0;
					Internal.Fbs.MoveInPlaneFb.PositionX := Positions[Internal.currentShuttleCount - 1].X;
					Internal.Fbs.MoveInPlaneFb.PositionY := Positions[Internal.currentShuttleCount - 1].Y;
					Internal.Fbs.MoveInPlaneFb.Path := mcACP6D_PATH_X_THEN_Y;
					
					Internal.Fbs.MoveInPlaneFb.Execute := TRUE;
					
					Internal.State := BATCH_MOVE_SHUTTLE;
				END_IF	
			END_IF
		BATCH_MOVE_SHUTTLE://******************************************************************************** Batch FB Move Shuttle State
			IF Internal.Fbs.MoveInPlaneFb.Error THEN
				Error := TRUE;
				StatusID := Internal.Fbs.MoveInPlaneFb.ErrorID;
				Internal.State := BATCH_ERROR;
			ELSIF (Internal.currentShuttleCount <> MAX_BATCH_SHUTTLE_COUNT AND Internal.Fbs.MoveInPlaneFb.Acknowledge) THEN
				Internal.Fbs.MoveInPlaneFb.Execute := FALSE;
				
				//The command has been added to the buffer but we're stil need more shuttles
				ReadyForShuttle := TRUE;
				
				Internal.State := BATCH_WAIT_SHUTTLE;
			ELSIF Internal.Fbs.MoveInPlaneFb.Done THEN
				//We are now going to start preforming the actual operation
				Internal.Fbs.MoveInPlaneFb.Execute := FALSE;
				Processsing := TRUE;
				Internal.Fbs.WaitTimer.IN := TRUE;
				Internal.Fbs.WaitTimer.PT := ProcessingTime;
				
				Internal.State := BATCH_PREFORM_OPERATION;
			END_IF
		BATCH_PREFORM_OPERATION://******************************************************************************** Batch FB Preforming the operation
			IF Internal.Fbs.WaitTimer.Q THEN
				Internal.Fbs.WaitTimer.IN := FALSE;
				
				Processsing := FALSE;
				BatchComplete := TRUE;
				
				Internal.State := BATCH_DONE;
		
			END_IF
		BATCH_DONE://******************************************************************************** Batch FB Done state
			IF Reset THEN
				Internal.State := BATCH_RESET;
			END_IF
		BATCH_RESET://******************************************************************************** Batch Reset all data state
			Reset := FALSE;
			
			BatchComplete := FALSE;
			Processsing := FALSE;
			ReadyForShuttle := FALSE;
			Error := FALSE;
			StatusID := FALSE;
			brsmemset(ADR(ShuttleIds),0,SIZEOF(ShuttleIds));
			
			Internal.currentShuttleCount := 0;
			
			Internal.Fbs.MoveInPlaneFb.Execute := FALSE;
			Internal.Fbs.WaitTimer.IN := FALSE;
		
			IF Enable THEN
				Internal.State := BATCH_INIT;
			ELSE
				Internal.State := BATCH_OFF;
			END_IF
		BATCH_ERROR://******************************************************************************** Batch FB Error state
			IF Reset THEN
				Internal.State := BATCH_RESET;
			END_IF
	END_CASE;
	Internal.Fbs.MoveInPlaneFb();
	Internal.Fbs.WaitTimer();
END_FUNCTION_BLOCK
