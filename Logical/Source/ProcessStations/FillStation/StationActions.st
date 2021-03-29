
ACTION SetupStationActions: 
	CASE station OF
		ST1:
			FillStationFbs.St1Fb.Execute := TRUE;
			FillStationFbs.St1Fb.Controller := ADR(gMcAcp6DController);
			FillStationFbs.St1Fb.ShuttleId := gShuttleIf[pFillIf.Par.ShuttleIdx].Cfg.ShuttleId;
			FillStationFbs.St1Fb.PosStartX := pFillIf.Cfg.StationPos.X;
			FillStationFbs.St1Fb.PosStartY := pFillIf.Cfg.StationPos.Y;
		ST2:
		ST3:
		ST4:

	END_CASE;
END_ACTION

ACTION CallStationFbs: 
	CASE station OF
		ST1:
			FillStationFbs.St1Fb();
		ST2:
		ST3:
		ST4:
	END_CASE;
END_ACTION
