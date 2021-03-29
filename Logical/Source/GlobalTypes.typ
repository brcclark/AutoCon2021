(*Main System Interface Types*)

TYPE
	MainIfTyp : 	STRUCT 
		Cmd : MainIfCmdTyp;
		Par : MainIfParTyp;
		Cfg : MainIfCfgTyp;
		Sts : MainIfStsTyp;
	END_STRUCT;
	MainIfCmdTyp : 	STRUCT 
		Power : BOOL;
		Start : BOOL;
		Stop : BOOL;
		Reset : BOOL;
	END_STRUCT;
	MainIfParTyp : 	STRUCT 
		Tmp : USINT;
	END_STRUCT;
	MainIfCfgTyp : 	STRUCT 
		ShuttleCount : USINT;
	END_STRUCT;
	MainIfStsTyp : 	STRUCT 
		PowerOn : BOOL;
		Running : BOOL;
		Error : BOOL;
	END_STRUCT;
END_TYPE

(*Process Info Interface*)

TYPE
	ProcessInfoIfTyp : 	STRUCT 
		Cmd : ProcessInfoIfCmdTyp;
		Par : ProcessInfoIfParTyp;
		Sts : ProcessInfoIfStsTyp;
	END_STRUCT;
	ProcessInfoIfCmdTyp : 	STRUCT 
		Enable : BOOL;
		ResetData : BOOL;
	END_STRUCT;
	ProcessInfoIfParTyp : 	STRUCT 
		CurrentProductCount : UDINT;
		CurrentPowderCount : UDINT;
	END_STRUCT;
	ProcessInfoIfStsTyp : 	STRUCT 
		Enabled : BOOL;
		CurrentPPM : REAL;
		CurrentPPH : REAL;
		CurrentBlistersPerMinute : REAL;
		CurrentLayersPerMinute : REAL;
	END_STRUCT;
	ProductRecipeTyp : 	STRUCT 
		Fills : ARRAY[0..MAX_FILL_STEPS_ARRAY]OF USINT;
	END_STRUCT;
	CurrentProductInfoTyp : 	STRUCT 
		Loaded : BOOL;
		FillData : USINT;
		CurrentFillStep : USINT;
		Weight : REAL;
		Capped : BOOL;
		Buffer : BOOL;
	END_STRUCT;
END_TYPE

(*Shuttle Interface Types*)

TYPE
	ShuttleIfTyp : 	STRUCT  (*Interface for controlling a shuttle*)
		Cmd : ShuttleIfCmdTyp; (*Commands to issue to a shuttle*)
		Par : ShuttleIfParTyp; (*Parameters for the process for this shuttle*)
		Cfg : ShuttleIfCfgTyp; (*Configuration values for this shuttle*)
		Sts : ShuttleIfStsTyp; (*Status information related to this shuttle*)
	END_STRUCT;
	ShuttleIfCmdTyp : 	STRUCT  (*Commands for controlling a shuttle*)
		Enable : BOOL; (*Command for enabling the control of a shuttle in the process*)
		Recover : BOOL; (*Command for a shuttle to start recovery*)
		NextStep : BOOL; (*Command for a shuttle to start the next step in the process*)
		ResetProductInfo : BOOL; (*Command to reset all the product info on a shuttle*)
		Stop : BOOL; (*Command to stop the process for a shuttle*)
	END_STRUCT;
	ShuttleIfParTyp : 	STRUCT  (*Parameters for the shuttle's operation*)
		Recipe : ProductRecipeTyp; (*Number of layers for this defined recipe*)
		MacroIDs : ShuttleIfCfgMacrosTyp; (*Macro's used for routing shuttles*)
	END_STRUCT;
	ShuttleIfCfgMacrosTyp : 	STRUCT  (*Structure of the macro IDs used for operation*)
		LoadToFillEntry : ShuttleIfMacroEnum;
		Fill1ToFill2 : ShuttleIfMacroEnum;
		Fill2ToFill3 : ShuttleIfMacroEnum;
		Fill3ToFill4 : ShuttleIfMacroEnum;
		Fill4ToFill1 : ShuttleIfMacroEnum;
		Fill4ToFillExit : ShuttleIfMacroEnum;
	END_STRUCT;
	ShuttleIfCfgTyp : 	STRUCT  (*Configuration values for a shuttle*)
		ShuttleId : USINT; (*ShuttleID of this shuttle*)
	END_STRUCT;
	ShuttleIfStsTyp : 	STRUCT  (*Status information for the shuttle*)
		CurrentDestination : ShuttleIfDestEnum; (*Destination the shuttle is currently moving towards*)
		Error : BOOL; (*Shuttle is currently in an error state*)
		CurrentLayer : USINT; (*Current Layer being built on the shuttle*)
		ShuttleInfo : Acp6DShuttleInfoTyp; (*CurrentStatus Information about the shuttle*)
		ProductInfo : CurrentProductInfoTyp; (*CurrentProduct Information about the product on the shuttle*)
		ErrorState : ShStateEnum; (*State the shuttle errored at*)
		Recovered : BOOL; (*Shuttle has been recovered*)
	END_STRUCT;
	ShuttleIfMacroEnum : 
		( (*Macro IDs that are used to denote which macro means what*)
		MACRO_LOAD_TO_FILL_ENTRY := 128, (*Macro ID used for sending a shuttle from the load station to the fill entry*)
		MACR_FILL_ENTRY_TO_FILL_1, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACR_FILL_1_TO_FILL_2, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACR_FILL_2_TO_FILL_3, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACR_FILL_3_TO_FILL_4, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACR_FILL_4_TO_FILL_1, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACR_FILL_4_TO_FILL_EXIT, (*Macro ID for moving from the fill entry location to the fill 1 station*)
		MACRO_FILL_STATION_PROC_2 := 140, (*Macro ID used for preforming the fill station 2 process*)
		MACRO_FILL_STATION_PROC_3_XY, (*Macro ID used for preforming the fill station 3 X/Y movement*)
		MACRO_FILL_STATION_PROC_3_WOBBLE, (*Macro ID used for preforming the wobble movment on station 3*)
		MACRO_RECOVERY_GROUP0 := 160, (*Macro ID used for recovering the group 0 shuttles*)
		MACRO_RECOVERY_GROUP1, (*Macro ID used for recovering the group 1 shuttles*)
		MACRO_RECOVERY_GROUP2 (*Macro ID used for recovering the group 2 shuttles*)
		);
	ShuttleIfDestEnum : 
		( (*Destinations for a shuttle to move to*)
		DEST_LOAD,
		DEST_FILL_ENTRY,
		DEST_FILL_1,
		DEST_FILL_2,
		DEST_FILL_3,
		DEST_FILL_4,
		DEST_FILL_EXIT,
		DEST_WEIGH,
		DEST_CAP_1,
		DEST_CAP_2,
		DEST_REJECT,
		DEST_BUFFER,
		DEST_UNLOAD
		);
	ShStateEnum : 
		(
		SH_OFF, (*Shuttle is in the off/idle state*)
		SH_INIT, (*Shuttle is in the initilization state*)
		SH_IDLE, (*Shuttle is in the idle station waiting to start*)
		SH_MOVE_TO_LOAD, (*Shuttle is moving to the load position*)
		SH_LOADING, (*Shuttle is currently being loaded*)
		SH_MOVE_FILL_ENTER, (*Shuttle is moving towards the fill enter station*)
		SH_MOVE_FILL, (*Shuttle is moving to a fill station*)
		SH_FILLING, (*Shuttle is currently being filled*)
		SH_FILLING_EVAL, (*Shuttle is deciding which filling station to move next to*)
		SH_MOVE_FILL_EXIT, (*Shuttle is moving towards the fill exit station*)
		SH_MOVE_TO_WEIGH, (*Shuttle is moving to a weigh station*)
		SH_WEIGHING, (*Shuttle is currently being weighed/inspected*)
		SH_MOVE_TO_CAP, (*Shuttle is moving to a cap station*)
		SH_CAPPING, (*Shuttle is currently being capped*)
		SH_MOVE_TO_BUFFER, (*Shuttle is moving to a buffer lane*)
		SH_BUFFERED, (*Shuttle is currently being buffered*)
		SH_MOVE_TO_UNLOAD, (*Shuttle is moving to an unload*)
		SH_UNLOADING, (*Shuttle is currently being unloaded*)
		SH_MOVE_TO_REJECT, (*Shuttle is moving to a reject station*)
		SH_REJECTING, (*Shuttle is currently being rejected*)
		SH_STOPPING, (*Shuttle is currently being stopped*)
		SH_ERROR := 65535 (*Shuttle is in the error state*)
		);
END_TYPE

(*6D Controller Interface Types*)

TYPE
	Acp6DCmdTyp : 	STRUCT 
		Power : BOOL;
		ErrorReset : BOOL;
		GetErrorInfo : BOOL;
	END_STRUCT;
	Acp6DCtrlTyp : 	STRUCT 
		Cmd : Acp6DCmdTyp;
		Sts : Acp6DStsTyp;
		Par : Acp6DParTyp;
	END_STRUCT;
	Acp6DParTyp : 	STRUCT 
		Mode : McAcp6DMoveModeEnum;
		PathType : McAcp6DInPlaneMovePathEnum;
		Acceleration : REAL;
		EndVelocity : REAL;
		Velocity : REAL;
		ShuttleID : USINT;
		SegmentID : USINT;
		PositionX : REAL;
		PositionY : REAL;
	END_STRUCT;
	Acp6DStsTyp : 	STRUCT 
		Error : BOOL;
		ErrorID : DINT;
		Ready : BOOL;
		PowerOn : BOOL;
		ReadyToPowerOn : BOOL;
		ErrorCodes : ARRAY[0..8]OF DINT;
	END_STRUCT;
	Acp6DShuttleInfoTyp : 	STRUCT 
		State : Acp6DShuttleStateInfoTyp;
		Force : Acp6DShuttleForceInfoTyp;
		Position : Acp6DShuttlePosInfoTyp;
	END_STRUCT;
	Acp6DShuttleStateInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShuttleStateEnum;
	END_STRUCT;
	Acp6DShuttlePosInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShPositionInfoType;
	END_STRUCT;
	Acp6DShuttleForceInfoTyp : 	STRUCT 
		Valid : BOOL;
		Value : McAcp6DShForceInfoType;
	END_STRUCT;
END_TYPE

(*Recovery Interface Type*)

TYPE
	Acp6DRecoveryIfTyp : 	STRUCT 
		Cmd : Acp6DRecoveryCmdTyp;
		Par : Acp6DRecoveryParTyp;
		Sts : Acp6DRecoveryStsTyp;
	END_STRUCT;
	Acp6DRecoveryCmdTyp : 	STRUCT 
		Recover : BOOL;
		Reset : BOOL;
	END_STRUCT;
	Acp6DRecoveryParTyp : 	STRUCT 
		AutoDrivePositions : ARRAY[0..MAX_SHUTTLE_COUNT_ARRAY]OF Acp6DAutoDrivePosTyp;
		Vel : REAL;
		Accel : REAL;
	END_STRUCT;
	Acp6DRecoveryStsTyp : 	STRUCT 
		Recovering : BOOL;
		ReadyToStartProc : BOOL;
		Done : BOOL;
		ShuttlesRecovered : BOOL;
		Error : BOOL;
	END_STRUCT;
	Acp6DAutoDrivePosTyp : 	STRUCT 
		ShIdx : USINT;
		GroupNum : USINT; (*Group ID used for recovery. Lower group, lower priority*)
		X : REAL;
		Y : REAL;
	END_STRUCT;
END_TYPE

(***********************Station Types*)

TYPE
	StationIfTyp : 	STRUCT 
		Cmd : StationIfCmdTyp; (*Commands to a station*)
		Par : {REDUND_UNREPLICABLE} StationIfParTyp; (*Parameters for the station's operation*)
		Cfg : StationIfCfgTyp; (*Configuration values for the station*)
		Sts : StationIfStsTyp; (*Status of the station*)
	END_STRUCT;
	StationIfCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
		LocalOverride : BOOL; (*Denotes that local settings can be overwritten from global*)
	END_STRUCT;
	StationIfCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
		EnterPos : StationPositionTyp; (*Station's enter position relative or absolute*)
		ExitPos : StationPositionTyp; (*Station's exit position relative or absolute*)
	END_STRUCT;
	StationIfParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
	END_STRUCT;
	StationIfStsTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
	StationPositionTyp : 	STRUCT 
		X : REAL; (*Station's Global X position*)
		Y : REAL; (*Station's Global Y position*)
	END_STRUCT;
END_TYPE

(*Station Parameters*)

TYPE
	SysParsTyp : 	STRUCT 
		LoadStation : LoadStationParsTyp;
		FillStations : ARRAY[0..MAX_FILL_STATIONS_ARRAY]OF FillStationParsTyp;
		TraversalVel : REAL;
		TraversalAccel : REAL;
	END_STRUCT;
	LoadStationParsTyp : 	STRUCT 
		WaitTime : TIME;
	END_STRUCT;
	FillStationParsTyp : 	STRUCT 
		Vel : REAL;
		Accel : REAL;
		FillRate : REAL;
		FillTime : TIME;
	END_STRUCT;
END_TYPE
