
FUNCTION_BLOCK AngledMovementFb
	CASE Internal.state OF
		ANG_INT_OFF:
			IF Execute THEN
				Active := TRUE;
				Internal.ShPos[axPosX] := PosStartX - 0.06;
				Internal.ShPos[axPosY] := PosStartY + 0.06;
				Internal.ShPos[axPosZ] := 0.004;
				Internal.ShPos[axPosRX] := 0.025;
				Internal.ShPos[axPosRY] := 0.025;
				
				Internal.Fbs.Move6DFb.Controller := ADR(Controller);
				Internal.Fbs.Move6DFb.ShuttleID := ShuttleId;
				Internal.Fbs.Move6DFb.Position := Internal.ShPos;
				Internal.Fbs.Move6DFb.InPlaneVelocity := 0.24;
				Internal.Fbs.Move6DFb.Acceleration := 10;
				Internal.Fbs.Move6DFb.ShortAxisVelocity[axVel] := 0.24;
				Internal.Fbs.Move6DFb.ShortAxisVelocity[axVelRx] := 0.1;
				Internal.Fbs.Move6DFb.ShortAxisVelocity[axVelRy] := 0.1;
				Internal.Fbs.Move6DFb.ShortAxisVelocity[axVelRz] := 0.1;
				
				Internal.Fbs.Move6DFb.Execute := TRUE;
				
				Internal.state := ANG_INT_MOV_WAIT;
			END_IF
		ANG_INT_MOV_WAIT:
			IF Internal.Fbs.Move6DFb.Done THEN
				Internal.Fbs.Move6DFb.Execute := FALSE;
				Internal.MovementNum := Internal.MovementNum + 1;
				IF Internal.MovementNum >= 6 THEN
					Done := TRUE;
					Internal.state := ANG_INT_DONE;
				ELSE
					Internal.state := ANG_INT_MOV_WAIT + Internal.MovementNum;
				END_IF
				
			END_IF
		ANG_INT_MOV_1:
			Internal.ShPos[axPosX] := Internal.ShPos[axPosX];
			Internal.ShPos[axPosY] := Internal.ShPos[axPosY] - 0.12;
			Internal.ShPos[axPosRX] := -0.025;
			Internal.ShPos[axPosRY] := 0.025;
			
			Internal.Fbs.Move6DFb.Position := Internal.ShPos;
			Internal.Fbs.Move6DFb.Execute := TRUE;
			
			Internal.state := ANG_INT_MOV_WAIT;
		ANG_INT_MOV_2:
			Internal.ShPos[axPosX] := Internal.ShPos[axPosX] + 0.12;
			Internal.ShPos[axPosY] := Internal.ShPos[axPosY];
			Internal.ShPos[axPosRX] := -0.025;
			Internal.ShPos[axPosRY] := -0.025;
			
			Internal.Fbs.Move6DFb.Position := Internal.ShPos;
			Internal.Fbs.Move6DFb.Execute := TRUE;
			
			Internal.state := ANG_INT_MOV_WAIT;
		ANG_INT_MOV_3:
			Internal.ShPos[axPosX] := Internal.ShPos[axPosX];
			Internal.ShPos[axPosY] := Internal.ShPos[axPosY] + 0.12;
			Internal.ShPos[axPosRX] := 0.025;
			Internal.ShPos[axPosRY] := -0.025;
			
			Internal.Fbs.Move6DFb.Position := Internal.ShPos;
			Internal.Fbs.Move6DFb.Execute := TRUE;
			
			Internal.state := ANG_INT_MOV_WAIT;
		ANG_INT_MOV_4:
			Internal.ShPos[axPosX] := Internal.ShPos[axPosX] - 0.12;
			Internal.ShPos[axPosY] := Internal.ShPos[axPosY];
			Internal.ShPos[axPosRX] := 0.025;
			Internal.ShPos[axPosRY] := 0.025;
			
			Internal.Fbs.Move6DFb.Position := Internal.ShPos;
			Internal.Fbs.Move6DFb.Execute := TRUE;
			
			Internal.state := ANG_INT_MOV_WAIT;
		ANG_INT_MOV_5:
			Internal.ShPos[axPosX] := PosStartX;
			Internal.ShPos[axPosY] := PosStartY;
			Internal.ShPos[axPosZ] := 0.002;
			Internal.ShPos[axPosRX] := 0.0;
			Internal.ShPos[axPosRY] := 0.0;
			
			Internal.Fbs.Move6DFb.Position := Internal.ShPos;
			Internal.Fbs.Move6DFb.Execute := TRUE;
			
			Internal.state := ANG_INT_MOV_WAIT;
		ANG_INT_DONE:
			IF NOT Execute THEN
				Internal.Fbs.Move6DFb.Execute := FALSE;
				Internal.MovementNum := 0;
				
				Active := FALSE;
				Done := FALSE;
				Error := FALSE;
				
				Internal.state := ANG_INT_OFF;
			END_IF
		ANG_INT_ERROR:
			IF NOT Execute THEN
				Internal.Fbs.Move6DFb.Execute := FALSE;
				Internal.MovementNum := 0;
				
				Active := FALSE;
				Done := FALSE;
				Error := FALSE;
				
				Internal.state := ANG_INT_OFF;
			END_IF
	END_CASE;
	Internal.Fbs.Move6DFb();
END_FUNCTION_BLOCK
