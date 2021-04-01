
{REDUND_ERROR} FUNCTION_BLOCK BatchProcess6DFb (*TODO: Add your comment here*) (*$GROUP=User,$CAT=User,$GROUPICON=User.png,$CATICON=User.png*)
	VAR_INPUT
		Controller : REFERENCE TO McAcp6DControllerType;
		Enable : BOOL;
		Reset : BOOL;
		ProcessingTime : TIME;
		Positions : {REDUND_UNREPLICABLE} ARRAY[0..MAX_BATCH_SHUTTLE_COUNT_ARRAY] OF StationPositionTyp;
		ProcessShuttle : BOOL;
		ShId : USINT;
	END_VAR
	VAR_OUTPUT
		Error : BOOL;
		StatusID : DINT;
		ReadyForShuttle : BOOL;
		Processsing : BOOL;
		BatchComplete : BOOL;
		ShuttleIds : ARRAY[0..MAX_BATCH_SHUTTLE_COUNT_ARRAY] OF USINT;
	END_VAR
	VAR
		Internal : BatchProcess6DInternalTyp;
	END_VAR
END_FUNCTION_BLOCK
