

PROGRAM _INIT
	FOR idx := 0 TO gMainIf.Cfg.ShuttleCount - 1 DO
		Vis.Shuttles[idx].ID := idx+1;
		Vis.Shuttles[idx].ScnViewer.PathLength := 35;
	END_FOR;
	cameraFlashIntensity := 1;
	
	Vis.Shuttles[0].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[0].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[0].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[1].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[1].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[1].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[2].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[2].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[2].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[3].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[3].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[3].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[4].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[4].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[4].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[5].ScnViewer.PathColor[0] := 0.75;
	Vis.Shuttles[5].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[5].ScnViewer.PathColor[2] := 0.75;
	
	Vis.Shuttles[6].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[6].ScnViewer.PathColor[1] := 1.0;
	Vis.Shuttles[6].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[7].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[7].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[7].ScnViewer.PathColor[2] := 0.5;
	
	Vis.Shuttles[8].ScnViewer.PathColor[0] := 0.5;
	Vis.Shuttles[8].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[8].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[9].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[9].ScnViewer.PathColor[1] := 0.5;
	Vis.Shuttles[9].ScnViewer.PathColor[2] := 0.0;
	
	Vis.Shuttles[10].ScnViewer.PathColor[0] := 0.0;
	Vis.Shuttles[10].ScnViewer.PathColor[1] := 0.5;
	Vis.Shuttles[10].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[11].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[11].ScnViewer.PathColor[1] := 0.5;
	Vis.Shuttles[11].ScnViewer.PathColor[2] := 0.5;
	
	Vis.Shuttles[12].ScnViewer.PathColor[0] := 0.5;
	Vis.Shuttles[12].ScnViewer.PathColor[1] := 0.5;
	Vis.Shuttles[12].ScnViewer.PathColor[2] := 1.0;
	
	Vis.Shuttles[13].ScnViewer.PathColor[0] := 1.0;
	Vis.Shuttles[13].ScnViewer.PathColor[1] := 0.0;
	Vis.Shuttles[13].ScnViewer.PathColor[2] := 1.0;
	turnOnAllPaths := TRUE;
END_PROGRAM