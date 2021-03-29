
ACTION SetupStationActions: 
	CASE station OF
		ST1:
			FillStationFbs.St1Fb.Execute := TRUE;
			FillStationFbs.St1Fb.Controller := ADR(gMcAcp6DController);
			FillStationFbs.St1Fb.ShuttleId := gShuttleIf[pFillIf.Par.ShuttleIdx].Cfg.ShuttleId;
			FillStationFbs.St1Fb.PosStartX := pFillIf.Cfg.StationPos.X;
			FillStationFbs.St1Fb.PosStartY := pFillIf.Cfg.StationPos.Y;
		ST2:
			FillStationFbs.St2Fb.Controller := ADR(gMcAcp6DController);
			FillStationFbs.St2Fb.MacroID := DINT_TO_USINT(MACRO_FILL_STATION_PROC_2);
			FillStationFbs.St2Fb.ShuttleID := gShuttleIf[pFillIf.Par.ShuttleIdx].Cfg.ShuttleId;
			FillStationFbs.St2Fb.Execute := TRUE;
		ST3:
			FillStationFbs.St3Fb.Controller := ADR(gMcAcp6DController);
			FillStationFbs.St3Fb.PosStartX := pFillIf.Cfg.StationPos.X;
			FillStationFbs.St3Fb.PosStartY := pFillIf.Cfg.StationPos.Y;
			FillStationFbs.St3Fb.PlanetMacroID := DINT_TO_USINT(MACRO_FILL_STATION_PROC_3_WOBBLE);
			FillStationFbs.St3Fb.SunMacroID := DINT_TO_USINT(MACRO_FILL_STATION_PROC_3_XY);
			FillStationFbs.St3Fb.ShuttleId := gShuttleIf[pFillIf.Par.ShuttleIdx].Cfg.ShuttleId;
			FillStationFbs.St3Fb.VirtShId := 100;
			FillStationFbs.St3Fb.Execute := TRUE;
		ST4:

	END_CASE;
END_ACTION

ACTION CallStationFbs: 
	CASE station OF
		ST1:
			FillStationFbs.St1Fb();
		ST2:
			FillStationFbs.St2Fb();
		ST3:
			FillStationFbs.St3Fb();
		ST4:
	END_CASE;
END_ACTION