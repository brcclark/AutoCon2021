
TYPE
	ShVisTyp : 	STRUCT 
		ID : USINT;
		Visible : BOOL;
		Color : INT;
		ProdColor : INT;
		Pos : McAcp6DShPositionInfoType;
		ScnViewer : ScnViewerConnectionTyp;
		UsrData : {REDUND_UNREPLICABLE} CurrentProductInfoTyp;
	END_STRUCT;
	VisTyp : 	STRUCT 
		Shuttles : {REDUND_UNREPLICABLE} ARRAY[0..MAX_SHUTTLE_COUNT_ARRAY]OF ShVisTyp;
		Robots : ARRAY[0..1]OF RobotVisTyp;
		Camera : ARRAY[0..1]OF USINT;
	END_STRUCT;
	VisShuttleStateEnum : 
		(
		VIS_INIT,
		VIS_ACTIVE,
		VIS_ERROR
		);
	ScnViewerConnectionTyp : 	STRUCT 
		EnablePositioner : USINT;
		EnablePath : BOOL;
		ClearPath : BOOL;
		PathColor : ARRAY[0..2]OF REAL; (*0-Red, 1-Green, 2-Blue*)
		PathLength : UDINT;
		PathOffset : PointTyp;
	END_STRUCT;
	ShuttleColorEnum : 
		(
		COLOR_RED := 1,
		COLOR_BLUE_MATTE,
		COLOR_GREY_MATTE,
		COLOR_YELLOW_MATTE,
		COLOR_GREEN_MATTE,
		COLOR_ORANGE_MATTE,
		COLOR_WHITE_MATTE,
		COLOR_BLACK_MATTE
		);
	RobotVisTyp : 	STRUCT 
		Products : ARRAY[0..3]OF RbtIfProductTyp;
	END_STRUCT;
	PointTyp : 	STRUCT 
		X : REAL;
		Y : REAL;
		Z : REAL;
	END_STRUCT;
END_TYPE
