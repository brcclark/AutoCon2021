
PROGRAM _CYCLIC
	DeltaFb.Override := 100;
	DeltaFb.Parameters := ADR(DeltaPars);
	 
	CASE state OF
		RBT_OFF:
			IF pRobotIf.Cmd.Enable THEN
				state := RBT_INIT;
			END_IF
		RBT_INIT:
			DeltaFb.Home := TRUE;
			state := RBT_HOME;
		RBT_HOME:
			IF DeltaFb.IsHomed THEN
				DeltaFb.Home := FALSE;
				DeltaFb.Power := TRUE;
				state := RBT_POWER;
			END_IF
		RBT_POWER:
			IF DeltaFb.PowerOn THEN
				pRobotIf.Sts.Powered := TRUE;
				pRobotIf.Sts.Ready := TRUE;
				state := RBT_IDLE;
			END_IF
		RBT_IDLE:
			IF NOT pRobotIf.Cmd.Enable THEN
				DeltaFb.Power := FALSE;
				state := RBT_OFF;
			ELSIF pRobotIf.Cmd.Run THEN
				DeltaFb.MoveProgram := TRUE;
				pRobotIf.Sts.Running := TRUE;
				state := RBT_RUN_PROGRAM;
			END_IF
		RBT_RUN_PROGRAM:
			IF setProduct THEN
				setProduct := FALSE;
				FOR i:=0 TO 3 DO
					pRobotIf.Par.Products[i].Present := TRUE;
				END_FOR;
			END_IF
			IF resetProduct THEN
				resetProduct := FALSE;
				FOR i:=0 TO 3 DO
					pRobotIf.Par.Products[i].Present := FALSE;
				END_FOR;
			END_IF
			IF DeltaFb.MoveDone THEN
				DeltaFb.MoveProgram := FALSE;
				pRobotIf.Sts.Running := FALSE;
				pRobotIf.Sts.Done := TRUE;
				
				state := RBT_DONE;
			END_IF
		RBT_DONE:
			IF NOT pRobotIf.Cmd.Run THEN
				pRobotIf.Sts.Done := FALSE;
				state := RBT_IDLE;
			END_IF
		RBT_ERROR:
			IF pRobotIf.Cmd.Reset THEN
				DeltaFb.ErrorReset := TRUE;
				IF NOT DeltaFb.Error THEN
					DeltaFb.ErrorReset := FALSE;
					pRobotIf.Cmd.Reset := FALSE;	
					state := RBT_OFF;
				END_IF
			END_IF
	END_CASE;
	DeltaFb();
END_PROGRAM
