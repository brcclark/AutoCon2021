
VAR CONSTANT      
	Rest : McPointType := (Pos:=(X:=0, Y:=0, Z:=-990));
	PlaceApproach : McPointType := (Pos:=(X:=0, Y:=-150, Z:=-1000));
	Place : McPointType := (Pos:=(X:=0, Y:=-150, Z:=-1100));
	PickApproach : McPointType := (Pos:=(X:=0, Y:=150, Z:=-1000));
	Pick : McPointType := (Pos:=(X:=0, Y:=150, Z:=-1050));
	
END_VAR

PROGRAM _MAIN          
	Feedrate(100000);
	MoveL(Rest);
	RoundingEdges(50);
	MoveL(PickApproach);
	MoveLR(Pick);
	WaitTime(0.5);
	RoundingEdges(50);
	MoveL(PickApproach);
	MoveL(PlaceApproach);
	MoveL(Place);
	WaitTime(0.5);
	MoveL(PlaceApproach);
	MoveL(Rest);
END_PROGRAM