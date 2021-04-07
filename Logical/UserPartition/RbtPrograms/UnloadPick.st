
VAR CONSTANT      
	Rest : McPointType := (Pos:=(X:=0, Y:=0, Z:=-790));
	PlaceApproach : McPointType := (Pos:=(X:=300, Y:=0, Z:=-800));
	Place : McPointType := (Pos:=(X:=300, Y:=0, Z:=-900));
	PickApproach : McPointType := (Pos:=(X:=-60, Y:=-120, Z:=-800));
	Pick : McPointType := (Pos:=(X:=-60, Y:=-120, Z:=-850));
	
END_VAR
VAR{AT 'UnloadStat'}
	setUnload : BOOL;
	release : BOOL;
END_VAR
VAR{AT 'UnloadRbt'}
	resetProduct : BOOL;
END_VAR
PROGRAM _MAIN          
	Feedrate(100000);
	MoveL(Rest);
	RoundingEdges(50);
	MoveL(PickApproach);
	MoveLR(Pick);
	WaitTime(0.5);
	DO_PATH_SYNCH
		setUnload := TRUE;
		release := TRUE;
	END_PATH_SYNCH
	RoundingEdges(50);
	MoveL(PickApproach);
	MoveL(PlaceApproach);
	MoveL(Place);
	WaitTime(0.5);
	DO_PATH_SYNCH
		resetProduct := TRUE;
	END_PATH_SYNCH
	MoveL(PlaceApproach);
	MoveL(Rest);
END_PROGRAM