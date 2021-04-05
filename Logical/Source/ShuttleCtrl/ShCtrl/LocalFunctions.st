
(* Validates if a shuttle is in the defined position *)
FUNCTION PositionValidation
	IF CurrentInfo.Valid THEN
		IF CurrentInfo.Value.X >= DestinationPosition.X - 0.00001 
			AND CurrentInfo.Value.X <= DestinationPosition.X + 0.00001 
			AND CurrentInfo.Value.Y >= DestinationPosition.Y - 0.00001 
			AND CurrentInfo.Value.Y <= DestinationPosition.Y + 0.00001 THEN
			PositionValidation := TRUE;
		ELSE
			PositionValidation := FALSE;
		END_IF
		
	ELSE
		PositionValidation := FALSE;
	END_IF
END_FUNCTION

FUNCTION LogDebug
	msg := "";
	typ := "Sh ";
	typ := USINT_TO_WSTRING(Idx);
	MpAuditCustomEvent(MpLink,"DEBUG",typ,Msg);
END_FUNCTION

FUNCTION BufferCount
	LaneCounts[0] := 0;
	LaneCounts[1] := 0;
	LaneCounts[2] := 0;
	FOR i:=0 TO ShuttleCnt - 1 DO
		IF Shuttles[i].Sts.ProductInfo.Buffer THEN
			LaneCounts[Shuttles[i].Sts.ProductInfo.BufferLane] := LaneCounts[Shuttles[i].Sts.ProductInfo.BufferLane] + 1;
		END_IF
	END_FOR;
END_FUNCTION

FUNCTION GetNextLane
	lowestCount := 255;
	FOR i := 0 TO 2 DO
		IF LaneCounts[i] < lowestCount THEN
			lowestCount := LaneCounts[i];
			curLane := i;
		END_IF
	END_FOR
	GetNextLane := curLane;
END_FUNCTION