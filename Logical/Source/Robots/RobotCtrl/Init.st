

PROGRAM _INIT
	ST_name(0,ADR(taskName),0);

	IF taskName = 'LoadRbt' THEN
		pRobotIf ACCESS ADR(gRobotIf[Load_Robot]);
		DeltaPars.ProgramName := 'LoadPick.st';
		DeltaFb.MpLink := ADR(g3AxDeltaLoad);
	ELSIF taskName = 'UnloadRbt' THEN
		pRobotIf ACCESS ADR(gRobotIf[Unload_Robot]);
		DeltaPars.ProgramName := 'UnloadPick.st';
		DeltaFb.MpLink := ADR(g3AxDeltaUnload);
	END_IF
	DeltaFb.Enable := TRUE;
	 
END_PROGRAM