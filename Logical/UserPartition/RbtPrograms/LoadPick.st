
VAR CONSTANT      
	Rest : McPointType := (Pos:=(X:=0, Y:=0, Z:=-790));
	PlaceApproach : McPointType := (Pos:=(X:=60, Y:=0, Z:=-800));
	Place : McPointType := (Pos:=(X:=60, Y:=0, Z:=-850));
	PickApproach : McPointType := (Pos:=(X:=-300, Y:=0, Z:=-800));
	Pick : McPointType := (Pos:=(X:=-300, Y:=0, Z:=-900));
	
END_VAR
VAR{AT 'LoadStatio'}
	setLoad : BOOL;
	release : BOOL;
END_VAR
PROGRAM _MAIN          
	Feedrate(100000);
	MoveL(Rest);
	RoundingEdges(50);
	MoveL(PlaceApproach);
	MoveLR(Place);
	DO_PATH_SYNCH
		setLoad := TRUE;
	END_PATH_SYNCH
	WaitTime(0.2);
	DO_PATH_SYNCH
		release := TRUE;
	END_PATH_SYNCH
	RoundingEdges(50);
	MoveL(PlaceApproach);
	MoveL(PickApproach);
	MoveL(Pick);
	WaitTime(0.2);
	MoveL(PickApproach);
	MoveL(Rest);
END_PROGRAM