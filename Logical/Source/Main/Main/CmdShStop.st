
(* Provides interface to group enable command for all shuttles *)
FUNCTION CmdShStop
	FOR Internal.i:=0 TO ShCount-1 DO
		ShIfs[Internal.i].Cmd.Stop := TRUE;
	END_FOR;
	CmdShStop := Internal.StopCheck;
END_FUNCTION
