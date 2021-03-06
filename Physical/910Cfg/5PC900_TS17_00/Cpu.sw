﻿<?xml version="1.0" encoding="utf-8"?>
<?AutomationStudio FileVersion="4.9"?>
<SwConfiguration CpuAddress="SL1" xmlns="http://br-automation.co.at/AS/SwConfiguration">
  <TaskClass Name="Cyclic#1">
    <Task Name="6DCtrl" Source="Source.6DCtrl.6DCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="ShCtrl" Source="Source.ShuttleCtrl.ShCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#2">
    <Task Name="LoadStatio" Source="Source.ProcessStations.LoadStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FillSt1" Source="Source.ProcessStations.FillStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FillSt2" Source="Source.ProcessStations.FillStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FillSt3" Source="Source.ProcessStations.FillStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FillSt4" Source="Source.ProcessStations.FillStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="WeighSt1" Source="Source.ProcessStations.WeighStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="WeighSt2" Source="Source.ProcessStations.WeighStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="FinishStat" Source="Source.ProcessStations.FinishStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="BufferArea" Source="Source.ProcessStations.BufferArea.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="RejectStat" Source="Source.ProcessStations.RejectStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="UnloadStat" Source="Source.ProcessStations.UnloadStation.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="LoadRbt" Source="Source.Robots.RobotCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="UnloadRbt" Source="Source.Robots.RobotCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#3">
    <Task Name="Main" Source="Source.Main.Main.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#4">
    <Task Name="Recovery" Source="Source.ShuttleCtrl.Recovery.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <TaskClass Name="Cyclic#5" />
  <TaskClass Name="Cyclic#6" />
  <TaskClass Name="Cyclic#7" />
  <TaskClass Name="Cyclic#8">
    <Task Name="MacroLoad" Source="Source.6DCtrl.MacroLoad.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="AuditCtrl" Source="Source.Auxil.AuditCtrl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="Vis" Source="Source.Auxil.Vis.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="OeeCalc" Source="Source.Auxil.OeeCalc.prg" Memory="UserROM" Language="IEC" Debugging="true" />
    <Task Name="SVControl" Source="Source.Auxil.SVControl.prg" Memory="UserROM" Language="IEC" Debugging="true" />
  </TaskClass>
  <DataObjects>
    <DataObject Name="McAcpSys" Source="" Memory="UserROM" Language="Binary" />
  </DataObjects>
  <Binaries>
    <BinaryObject Name="FWRules" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TCData" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="TCLang" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="udbdef" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="mvLoader" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arsvcreg" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arflatprv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="mCoWebSc" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arcoal" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McAcpSim" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McAcpDrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="McMechSys" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="OpcUaSrv" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="User" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="iomap" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="TC" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Role" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="arconfig" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="asfw" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwac" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="sysconf" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="ashwd" Source="" Memory="SystemROM" Language="Binary" />
    <BinaryObject Name="Config" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Settings" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Hierarchy" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxGrpUnl_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxUnload_2" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxGrpUldFt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="MechSysUld" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="MechSysLd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxLoad" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxGrpLd" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="AxGrpLdFt" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_1" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_2" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_4" Source="" Memory="UserROM" Language="Binary" />
    <BinaryObject Name="Config_3" Source="" Memory="UserROM" Language="Binary" />
  </Binaries>
  <Libraries>
    <LibraryObject Name="McAcp6D" Source="Libraries.McAcp6D.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="AsIecCon" Source="Libraries.AsIecCon.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="runtime" Source="Libraries.runtime.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="astime" Source="Libraries.astime.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsMath" Source="Libraries.AsMath.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="asstring" Source="Libraries.asstring.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="FileIO" Source="Libraries.FileIO.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsXml" Source="Libraries.AsXml.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="standard" Source="Libraries.standard.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="ArEventLog" Source="Libraries.ArEventLog.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MpAudit" Source="Libraries.MpAudit.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpBase" Source="Libraries.MpBase.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpServer" Source="Libraries.MpServer.lby" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="sys_lib" Source="Libraries.sys_lib.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsBrWStr" Source="Libraries.AsBrWStr.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AdvIecChk" Source="Libraries.AdvIecChk.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="CoTrace" Source="Libraries.CoTrace.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsZip" Source="Libraries.AsZip.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="AsBrStr" Source="Libraries.AsBrStr.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="RandLib" Source="Libraries.RandLib.lby" Memory="UserROM" Language="ANSIC" Debugging="true" />
    <LibraryObject Name="BufferLib" Source="Libraries.BufferLib.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="McBase" Source="Libraries.McBase.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="MpRobotics" Source="Libraries.MpRobotics.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="McAxGroup" Source="Libraries.McAxGroup.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="McPathGen" Source="Libraries.McPathGen.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="McAxis" Source="Libraries.McAxis.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="McProgInt" Source="Libraries.McProgInt.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="McAcpAx" Source="Libraries.McAcpAx.lby" Memory="UserROM" Language="binary" Debugging="true" />
    <LibraryObject Name="SceneView" Source="Libraries.SceneView.lby" Memory="UserROM" Language="IEC" Debugging="true" />
    <LibraryObject Name="arssl" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="aruser" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="dataobj" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="powerlnk" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asarlog" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asarprof" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="brsystem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asmem" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asio" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="asepl" Source="" Memory="UserROM" Language="Binary" Debugging="true" />
    <LibraryObject Name="MpRecipe" Source="Libraries.MpRecipe.lby" Memory="UserROM" Language="Binary" Debugging="true" />
  </Libraries>
</SwConfiguration>