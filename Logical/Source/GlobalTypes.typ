(*Main System Interface Types*)

TYPE
	MainIfTyp : 	STRUCT 
		Cmd : MainIfCmdTyp;
		Par : MainIfParTyp;
		Cfg : MainIfCfgTyp;
		Status : MainIfStatusTyp;
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
	MainIfStatusTyp : 	STRUCT 
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
END_TYPE

(*Shuttle Interface Types*)

TYPE
	gShuttleIfTyp : 	STRUCT  (*Interface for controlling a shuttle*)
		Cmd : gShuttleIfCmdTyp; (*Commands to issue to a shuttle*)
		Par : gShuttleIfParTyp; (*Parameters for the process for this shuttle*)
		Cfg : gShuttleIfConfigTyp; (*Configuration values for this shuttle*)
		Flags : USINT;
		Status : gShuttleIfStatusTyp; (*Status information related to this shuttle*)
	END_STRUCT;
	gShuttleIfCmdTyp : 	STRUCT  (*Commands for controlling a shuttle*)
		Enable : BOOL; (*Command for enabling the control of a shuttle in the process*)
		Recover : BOOL; (*Command for a shuttle to start recovery*)
		NextStep : BOOL; (*Command for a shuttle to start the next step in the process*)
		ResetProductInfo : BOOL; (*Command to reset all the product info on a shuttle*)
		Stop : BOOL; (*Command to stop the process for a shuttle*)
	END_STRUCT;
	gShuttleIfParTyp : 	STRUCT  (*Parameters for the shuttle's operation*)
		NumLayers : USINT; (*Number of layers for this defined recipe*)
		MacroIDs : gShuttleIfCfgMacrosTyp; (*Macro's used for routing shuttles*)
	END_STRUCT;
	gShuttleIfCfgMacrosTyp : 	STRUCT  (*Structure of the macro IDs used for operation*)
		LoadToPrintMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the load station to the print station*)
		PrintToDoseMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the print station to the Dose station*)
		DoseToPrintMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the dosing station to the printing station*)
		PrintToTampMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the printing station to the tamping station*)
		TampToUnloadMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the tamping station to the unload station*)
		UnloadToLoadMacroID : gShuttleIfMacroEnum; (*Macro ID used for sending a shuttle from the unloading station to the loading station*)
	END_STRUCT;
	gShuttleIfConfigTyp : 	STRUCT  (*Configuration values for a shuttle*)
		ShuttleId : USINT; (*ShuttleID of this shuttle*)
	END_STRUCT;
	gShuttleIfStatusTyp : 	STRUCT  (*Status information for the shuttle*)
		CurrentDestination : gShuttleIfDestEnum; (*Destination the shuttle is currently moving towards*)
		BlisterPresent : BOOL; (*Status flag to denote that a blister pack has been loaded on the shuttle*)
		ProductTamped : BOOL; (*Status flag to denote that the product has  been tamped*)
		CurrentLayer : USINT; (*Current Layer being built on the shuttle*)
		ShuttleInfo : Acp6DShuttleInfoType; (*CurrentStatus Information about the shuttle*)
		Error : BOOL; (*Shuttle is currently in an error state*)
		ErrorState : ShStateEnum; (*State the shuttle errored at*)
		Recovered : BOOL; (*Shuttle has been recovered*)
	END_STRUCT;
	gShuttleIfMacroEnum : 
		( (*Macro IDs that are used to denote which macro means what*)
		MACRO_LOAD_TO_PRINT := 128, (*Macro ID used for sending a shuttle from the load station to the print station*)
		MACRO_PRINT_TO_DOSE1, (*Macro ID for moving from the print station to the dose 1 station*)
		MACRO_PRINT_TO_DOSE2, (*Macro ID for moving from the print station to the dose 2 station*)
		MACRO_DOSE_TO_PRINT, (*Macro ID used for sending a shuttle from the dosing station to the printing station*)
		MACRO_PRINT_TO_TAMP, (*Macro ID used for sending a shuttle from the printing station to the tamping station*)
		MACRO_TAMP_TO_UNLOAD, (*Macro ID used for sending a shuttle from the tamping station to the unload station*)
		MACRO_UNLOAD_TO_LOAD, (*Macro ID used for sending a shuttle from the unloading station to the loading station*)
		MACRO_RECOVERY_GROUP0, (*Macro ID used for recovering the group 0 shuttles*)
		MACRO_RECOVERY_GROUP1, (*Macro ID used for recovering the group 1 shuttles*)
		MACRO_RECOVERY_GROUP2 (*Macro ID used for recovering the group 2 shuttles*)
		);
	gShuttleIfDestEnum : 
		( (*Destinations for a shuttle to move to*)
		DEST_LOAD, (*Destination Load station*)
		DEST_PRINT, (*Destination Printing station*)
		DEST_DOSE1, (*Destination Dose 1 station*)
		DEST_DOSE2, (*Destination Dose 2 station*)
		DEST_TAMP, (*Destination Tamping station*)
		DEST_UNLOAD (*Destination unload*)
		);
	ShStateEnum : 
		(
		SH_OFF, (*Shuttle is in the off/idle state*)
		SH_INIT, (*Shuttle is in the initilization state*)
		SH_STARTUP, (*Shuttle is in the startup state*)
		SH_IDLE, (*Shuttle is in the idle state after having been recovered*)
		SH_MOVE_TO_LOAD, (*Shuttle is moving to the load position*)
		SH_LOAD, (*Shuttle is currently being loaded*)
		SH_MOVE_TO_PRINT, (*Shuttle is moving to the print position*)
		SH_PRINT, (*Shuttle is currently being printed*)
		SH_DECIDE_DOSE, (*Shuttle is deciding which dose station to send the shuttle to*)
		SH_MOVE_TO_DOSE, (*Shuttle is moving towards the defined dosing station*)
		SH_DOSE, (*Shuttle is currently going through the dosing procedure*)
		SH_MOVE_TO_TAMP, (*Shuttle is moving to the tamping location*)
		SH_TAMP, (*Shuttle is currently being tamped*)
		SH_MOVE_TO_OFFLOAD, (*Shuttle is moving to the offload position*)
		SH_OFFLOAD, (*Shuttle is currently being offloaded*)
		SH_ERROR := 65535 (*Shuttle is in the error state*)
		);
END_TYPE

(*6D Controller Interface Types*)

TYPE
	Acp6DCmdType : 	STRUCT 
		Power : BOOL;
		ErrorReset : BOOL;
		GetErrorInfo : BOOL;
	END_STRUCT;
	Acp6DCtrlType : 	STRUCT 
		Cmd : Acp6DCmdType;
		Status : Acp6DStatusType;
		Par : Acp6DParType;
	END_STRUCT;
	Acp6DParType : 	STRUCT 
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
	Acp6DStatusType : 	STRUCT 
		Error : BOOL;
		ErrorID : DINT;
		Ready : BOOL;
		PowerOn : BOOL;
		ReadyToPowerOn : BOOL;
		ErrorCodes : ARRAY[0..8]OF DINT;
	END_STRUCT;
	Acp6DShuttleInfoType : 	STRUCT 
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
		Par : {REDUND_UNREPLICABLE} UDINT; (*Address of the parameter structure*)
		Cfg : StationIfCfgTyp; (*Configuration values for the station*)
		Sts : StationIfStsTyp; (*Status of the station*)
	END_STRUCT;
	StationIfCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	StationIfCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	StationIfStsTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
END_TYPE

(*Load Station Types*)

TYPE
	LoadStationIfTyp : 	STRUCT 
		Cmd : LoadStationCmdTyp; (*Commands to the station*)
		Par : LoadStationParTyp; (*Paramters for the station's operation*)
		Cfg : LoadStationCfgTyp; (*Configuration values for the station*)
		Status : LoadStationStatusTyp; (*Status of the station*)
	END_STRUCT;
	LoadStationCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	LoadStationParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
		WaitTime : TIME; (*Amount of time to wait for the load process*)
	END_STRUCT;
	LoadStationCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	LoadStationStatusTyp : 	STRUCT 
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

(*Unload Station Types*)

TYPE
	UnloadStationIfTyp : 	STRUCT 
		Cmd : UnloadStationCmdTyp; (*Commands to the station*)
		Par : UnloadStationParTyp; (*Paramters for the station's operation*)
		Cfg : UnloadStationCfgTyp; (*Configuration values for the station*)
		Status : UnloadStationStatusTyp; (*Status of the station*)
	END_STRUCT;
	UnloadStationCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	UnloadStationParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
		WaitTime : TIME; (*Amount of time to wait for the load process*)
	END_STRUCT;
	UnloadStationCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	UnloadStationStatusTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
END_TYPE

(*Print Station Types*)

TYPE
	PrintStationIfTyp : 	STRUCT 
		Cmd : PrintStationCmdTyp; (*Commands to the station*)
		Par : PrintStationParTyp; (*Paramters for the station's operation*)
		Cfg : PrintStationCfgTyp; (*Configuration values for the station*)
		Status : PrintStationStatusTyp; (*Status of the station*)
	END_STRUCT;
	PrintStationCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	PrintStationParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
		PrintVel : REAL; (*Speed at which to complete the print process m/s*)
		PrintEndVel : REAL; (*Speed at which the shuttle should end the print process at m/s*)
		PrintDistanceX : REAL; (*Distance for how far the print movement will go in the X direction (m)*)
		PrintDistanceY : REAL; (*Distance for how far the print movement will go in the Y direction(m)*)
		PrintAccel : REAL; (*Acceleration at which to use for the print process m/s2*)
	END_STRUCT;
	PrintStationCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	PrintStationStatusTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
END_TYPE

(*Dose Station Types*)

TYPE
	DoseStationIfTyp : 	STRUCT 
		Cmd : DoseStationCmdTyp; (*Commands to the station*)
		Par : DoseStationParTyp; (*Paramters for the station's operation*)
		Cfg : DoseStationCfgTyp; (*Configuration values for the station*)
		Status : DoseStationStatusTyp; (*Status of the station*)
	END_STRUCT;
	DoseStationCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	DoseStationParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
		Vel : REAL; (*Velocity to move for the defined index movement*)
		EndVel : REAL; (*Velocity to end the movement at for the defined index movement*)
		Accel : REAL; (*Acceleration to use for the defined index movement*)
		WaitTime : TIME; (*Time needed to preform each dose process*)
		NumRowsOfCavities : USINT; (*Number of rows of the cavities in the blister pack. Will be indexing this many times in the dosing process*)
		SpaceBetweenCavities : DoseIndexMovParsTyp; (*Space between cavities to index through*)
		FirstCavityPosition : DoseIndexMovParsTyp; (*Offset in m for the first cavity*)
	END_STRUCT;
	DoseStationCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	DoseStationStatusTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
	DoseIndexMovParsTyp : 	STRUCT 
		DistX : REAL; (*Relative distance in X to move for a defined index (m)*)
		DistY : REAL; (*Relative distance in Y to move for a defined index (m)*)
	END_STRUCT;
END_TYPE

(*Tamp Station Types*)

TYPE
	TampStationIfTyp : 	STRUCT 
		Cmd : TampStationCmdTyp; (*Commands to the station*)
		Par : TampStationParTyp; (*Paramters for the station's operation*)
		Cfg : TampStationCfgTyp; (*Configuration values for the station*)
		Status : TampStationStatusTyp; (*Status of the station*)
	END_STRUCT;
	TampStationCmdTyp : 	STRUCT 
		Enable : BOOL; (*Enables the process station*)
		Process : BOOL; (*Start a process for the station with the defined shuttle index*)
		Reset : BOOL; (*Resets the process from an any state*)
	END_STRUCT;
	TampStationParTyp : 	STRUCT 
		ShuttleIdx : USINT; (*Index in the gShuttle array for the shuttle in question*)
		EntranceMovement : TampMovementParTyp; (*Relative position to enter the tamp position*)
		ExitMovement : TampMovementParTyp; (*Relative positions to exit the tamp position*)
		TampHeight : REAL; (*Height in which to preform the z movement for the tamp process (m)*)
		Vel : REAL; (*Velocity to move for the defined index movement*)
		EndVel : REAL; (*Velocity to end the movement at for the defined index movement*)
		Accel : REAL; (*Acceleration to use for the defined index movement*)
		WaitTime : TIME; (*Time needed to preform each dose process*)
	END_STRUCT;
	TampStationCfgTyp : 	STRUCT 
		StationPos : StationPositionTyp; (*Station's center world position*)
	END_STRUCT;
	TampStationStatusTyp : 	STRUCT 
		Enabled : BOOL; (*Signal denoting the station is enabled and in an operational state*)
		ReadyForNewShuttle : BOOL; (*Signal denoting the station is ready for a new shuttle*)
		Processing : BOOL; (*Signal denoting the station is currently operating on a shuttle*)
		Done : BOOL; (*Signal denoting the current operation has completed*)
		Error : BOOL; (*Signal denoting the station has an error present*)
	END_STRUCT;
	TampMovementParTyp : 	STRUCT 
		DistX : REAL; (*Relative distance in X to move for a defined movement(m)*)
		DistY : REAL; (*Relative distance in Y to move for a defined movement(m)*)
	END_STRUCT;
END_TYPE
