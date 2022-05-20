PROGRAM MAIN
VAR_EXTERNAL
	NDC8:NDC8_T;
	
	
(* Function blocks available from all programs. *)
	DisplayStopString : DisplayStopString_FB;
	EventQueue : EventQueue_FB;
	
END_VAR

VAR
(* Standard functions *)
	Indicators : Indicators_FB;
	Mode : ModeControl_FB ;
	Navigation : Navigation_FB;
	StopWordFB : StopWord_FB;
	TX_Status : TX_Status_FB;
	EventHandler : EVENTHANDLER_FB;
	AutoLoad : AutoLoad_FB;
	CarrierControl:CarrierControl_FB;
	Display : Display_FB;
	OPTX2  : OPTX2_FB;
	LS2000 : LS2000_FB;
	DebugFB : Debug_FB;
	
	PLC_Communication : PLC_Communication_FB;
	
	F_SteerSupervision : DRIVERSUPERVISION_FB;
	F_DriveSupervision : DRIVERSUPERVISION_FB;
	R_SteerSupervision : DRIVERSUPERVISION_FB;
	R_DriveSupervision : DRIVERSUPERVISION_FB;
	
	BMS_CHG : BMS_CHG_FB;
	
	VehicleMovingFlag : BOOL;


(* Error Trigger BlackBox *)
	Error_Set_Trig : BOOL;
	Error_BB_TrigR : R_Trig;
	Error_Trig : BOOL;
	
(* OM-PLC Trigger BlackBox *)
	OMPLC_BB_TrigR : R_Trig;
	OMPLC_Trig : BOOL;
	
	BlackBox : BlackBox_FB;
(* Master Link *)
	MasterLinkR : R_Trig;
	
(* Vehicle specific functions *)
	InputMap : InputMap_fb;
	OutputMap : OutputMap_fb;
	
(* PLC Communication Check *)
	LastCommCheckFlag : BOOL;
	
	CommCheckTimeUp : TON;

	iVar1 : INT;
	
	
(* Blocking Power Off Check *)
	BlockPowOffTm : TON;
	BlockPowOffTmValue : TIME;
	
(* Lost Power Off Check *)
	LostPosPowOffTm : TON;
	LostPosPowOffTmValue : TIME;

	
(* Display Error String *)
	FailCodeDint : dint;
	
	BbxTrig_FT : F_trig;
	ExecDriveCommand_RT : R_Trig;
	FailTimerTON : TON;
	
	PreviousMainState,
	PreviousLoadState,
	PreviousUnLoadState,
	PreviousTravelDir,
	PreviousFailCode,
	PreviousForkHeight,
	

	PreviousExecDriveCommand,
	PreviousCancelOperation,
	bbxtrigger			:bool;
	
(* All OK Motor Find Z-phase *)
	AllOK_R :R_Trig;
	AllOK_Delay : TON;
	
	FindSyncDelay : TON;
	
	FindSyncStep : INT := 0;
	
	CurPnt : DINT := 0;
	CurSeg : DINT := 0;
	
(* Navigation Down Timer Check *)
	NavLevelDown_Start : BOOL;
	NavLevelDown_TM : TON;
	NavLevelDown_TmUp	 : BOOL;
	


(* LS2000 Attached Timer *)
	LS2000_Attached_M : TON;
	
(* AGV Travel Distance Sampling Timer *)
	LastEncoderDistance : UINT := 0;
	CurrentEncoderDistance : UINT := 0;
	TravelDistanceSamplingTimer : TON;
	
	
(* Black Box Trigger *)
	BootUpDelay : TON;
	NoErrorDelay : TON;
	
	ErrorFlag : bool;
	ErrorTrigFlag : bool;
	ErrorTrigR : R_Trig;
	
	ErrorCodeString : string;
	BBMessage : string;
	
(* Update Data *)
	DataUpdate : DataUpload_FB;
	
(* DD <-> SD Mode Change Check Delay *)
	SteerModeChangeDelay : TON;
	SteerModeChange_SD_DD_Flag : BOOL;
	SteerModeChange_DD_SD_Flag : BOOL;
	SteerModeChange_Rrig : R_Trig;
	SteerModeChange_Flag : BOOL;
	LastSteerMode : DINT;
	
	SteerModeChangeErr_SD_DD : BOOL;
	SteerModeChangeErr_DD_SD : BOOL;
	
	Steer_F_ABS_Angle : INT;
	Steer_R_ABS_Angle : INT;
	
(* MAX Speed Detect *)
	EncSpeed_ABS_DCD5 : INT;
	EncSpeed_ABS_DCD7 : INT;
	EncSpeed_MAX : INT;
	EncOverSpeedFlag : BOOL;
	EncOverSpeedTm : TON;
	
	
(* Navi Monitor Start Check *)
	PositionValidDelay : TON;
	InSystemDelay : TON;
	
	
	
	OurSystemDelay : TON;
	
	
(* SOC Cal *)
 FindSyncFlag_Rrig : R_TRIG;
 FullBattery_Cap : Real;
 Battery_Cap : Real;
 
 Current_Idel : Real;
 Current_Moving : Real;
 Current_Transfer : Real;
 Current_Charge : Real;
 
 CurrentUsing : Real;
 
 ChargeDoneR : R_TRIG;
 
 LowVoltageR : R_TRIG;
 
 BatCheckTimer : TON;
	 
END_VAR
(*

MAIN
--------

These function blocks are a minimum to run a typical Steer/drive fork truck. 

*)


AllOK_R(CLK:=NDC8.SDIO.AllOK_DigitalOutput1);

if AllOK_R.Q and NDC8.SDIO.DigitalInput2_BTN_RST = FALSE then
	g_StartFindSync:= TRUE;
	StopFindSync := TRUE;
elsif AllOK_R.Q and NDC8.SDIO.DigitalInput2_BTN_RST = TRUE then
	g_StartFindSync := FALSE;
	g_FindSyncFlag := TRUE;
	StopFindSync := FALSE;
end_if;

AllOK_Delay(IN:=g_StartFindSync, PT:=t#1s);

if AllOK_Delay.Q and g_FindSyncFlag = FALSE and NDC8.SDIO.DigitalInput2_BTN_RST = FALSE then
	case FindSyncStep of
	
	0:
	NDC8.FrontWheel.MaxAngularSpeed := 60;
	NDC8.RearWheel.MaxAngularSpeed := 60;
	NDC8.Manual.PlcSelect := true;
	NDC8.Manual.PLCAngle := 0;
	NDC8.Manual.PlcSetOperationMode := 1;
	NDC8.Manual.PLCSteerMode := 0;
	NDC8.Manual.PlcSelectMask 		:= 2#10101;
	
	FindSyncDelay(IN:=TRUE, PT:=t#4s);
	if FindSyncDelay.Q then
		FindSyncStep := 1;
		FindSyncDelay(IN:=FALSE);
	end_if;
	
	1:
	(* Steer Turn to 18000 *)
	NDC8.FrontWheel.MaxAngularSpeed := 60;
	NDC8.RearWheel.MaxAngularSpeed := 60;
	NDC8.Manual.PlcSelect := true;
	NDC8.Manual.PLCAngle := 9000;
	NDC8.Manual.PlcSetOperationMode := 1;
	NDC8.Manual.PLCSteerMode := 0;
	NDC8.Manual.PlcSelectMask 		:= 2#10101;
	
	FindSyncDelay(IN:=TRUE, PT:=t#4s);
	if FindSyncDelay.Q then
		FindSyncStep := 2;
		FindSyncDelay(IN:=FALSE);
	end_if;
	
	2:
	(* Steer Turn to -2000 *)
	NDC8.FrontWheel.MaxAngularSpeed := 60;
	NDC8.RearWheel.MaxAngularSpeed := 60;
	NDC8.Manual.PlcSelect := true;
	NDC8.Manual.PLCAngle := -9000;
	NDC8.Manual.PlcSetOperationMode := 1;
	NDC8.Manual.PLCSteerMode := 0;
	NDC8.Manual.PlcSelectMask 		:= 2#10101;
	
	FindSyncDelay(IN:=TRUE, PT:=t#4s);
	if FindSyncDelay.Q then
		FindSyncStep := 3;
		FindSyncDelay(IN:=FALSE);
	end_if;
	
	3:
	(* Steer Turn to 0 *)
	NDC8.FrontWheel.MaxAngularSpeed := 120;
	NDC8.RearWheel.MaxAngularSpeed := 120;
	NDC8.Manual.PlcSelect := true;
	NDC8.Manual.PLCAngle := 0;
	NDC8.Manual.PlcSetOperationMode := 0;
	NDC8.Manual.PLCSteerMode := 0;
	NDC8.Manual.PlcSelectMask 		:= 2#10101;
	
	FindSyncDelay(IN:=TRUE, PT:=t#2s);
	if FindSyncDelay.Q then
		FindSyncStep := 4;
		FindSyncDelay(IN:=FALSE);
		g_FindSyncFlag := TRUE;
		NDC8.Manual.PlcSelectMask := 0;
		g_StartFindSync := FALSE;
		StopFindSync := FALSE;
	end_if;
	
	4:
	;
	end_case;
	
end_if;



if NDC8.CanOpenMaster.NMTState = 5 and NDC8.CanOpenMaster.State = 0 then

(* INPUTS *)
	InputMap();					(* Mapping inputs on devices to generic names *)

(*Decisionmaking PLC:s*)


	Autoload();
		 (* Load handling 		*)		
	
	LS2000();
	
	CarrierControl(	LS2000Slowdown := LS2000.Slowdown);				
	
	if g_StartFindSync = FALSE then
		Mode();												(* Selects vehicle mode *)
	end_if;

(* OUTPUTS *)
	OutputMap();				(* Mapping outputs on devices to generic names *)
	
(* BMS Charger *)
	BMS_CHG();

	PLC_Communication();
	
end_if;

(* These FB can be run also during startup and in safe state *)

	(* Information *)
Timer();						(* Square wave timers 										*)

Navigation(AutoInsertNotInsideTargetSafety := CarrierControl.AutoInsertNotInsideTargetSafety);					(* Info regarding navigation 								*)

StopWordFB();					(* Stop reasons 											*)

DisplayStopString();			(* Displays user defined stop reasons on the display 		*)

TX_Status();					(* Sends status bits to Master Controller 					*)

EventHandler();					(* Transmits events from the queue							*)

debugFB();

Indicators(	AutoInsertNotInsideTargetSafety := CarrierControl.AutoInsertNotInsideTargetSafety,
			AutoinsertInProgress 	:= CarrierControl.AutoinsertInProgress,
			StartDelayStartWarning 	:= CarrierControl.StartDelayStartWarning,
			LS2000SlowDown 			:= false);						(* Controls lamps and buzzers 								*)

(*System Brake Signal*)
if NDC8.UserDefined.Braker_Signal = FALSE or (INPUT.Manual = TRUE and NDC8.SDIO.DigitalInput5_BTN_BRK = TRUE) or (INPUT.Auto = TRUE and NDC8.SDIO.DigitalInput5_BTN_BRK = TRUE) then
	(*Brake Release*)
	NDC8.DCD_5.DigitalOutput2_Braker := TRUE;
	NDC8.DCD_7.DigitalOutput2_Braker := TRUE;
else
	(*Brake Lock*)
	NDC8.DCD_5.DigitalOutput2_Braker := FALSE;
	NDC8.DCD_7.DigitalOutput2_Braker := FALSE;
end_if;

if INPUT.Auto = TRUE and NDC8.SDIO.DigitalInput5_BTN_BRK = TRUE and NDC8.Mcd.Button8 = FALSE then
	StopAutoBrakeRelease := TRUE;
else
	StopAutoBrakeRelease := FALSE;
end_if;

(* Encoder Supervision *)
VehicleMovingFlag := NDC8.VehicleControl.Moving and not NDC8.PLC_Application.TxStatusBit9_EStop and StopWord = 0 and StopWord2 = 0;

F_SteerSupervision(Command:= NDC8.DCD_6.SetAngle,FeedBack:= NDC8.DCD_6.WheelAngle,Range:= 1000,Timeout:= t#30s,Moving:= VehicleMovingFlag);
R_SteerSupervision(Command:= NDC8.DCD_8.SetAngle,FeedBack:= NDC8.DCD_8.WheelAngle,Range:= 1000,Timeout:= t#30s,Moving:= VehicleMovingFlag);

F_DriveSupervision(Command:= NDC8.DCD_5.SetSpeed,FeedBack:= NDC8.DCD_5.DriveEncSpeed,Range:= 100,Timeout:= t#30s,Moving:= VehicleMovingFlag);
R_DriveSupervision(Command:= NDC8.DCD_7.SetSpeed,FeedBack:= NDC8.DCD_7.DriveEncSpeed,Range:= 100,Timeout:= t#30s,Moving:= VehicleMovingFlag);

	


(* OM-PLC Bit*)

	(*OM_PLC_W1_Bit_WaitCharge		:= FALSE;*)
	(*OM_PLC_W1_Bit_WaitOrder			:= FALSE;*)
	
	
	OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM); 
	OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
 
	StopByOM_PLC := OM_PLC_W2_Bit_SetEmgStop;
	
	(*OM_PLC_W2_Bit_BCD_setReq		:= FALSE;*)
	(*OM_PLC_W2_Bit_BCD_setOK			:= FALSE;*)
	(*OM_PLC_W2_Bit_BCD_Init			:= FALSE;*)
	(*OM_PLC_W2_Bit_BCD_NoRead		:= FALSE;*)
	(*OM_PLC_W2_Bit_Set_Result		:= FALSE;*)
	(*OM_PLC_W2_Bit_Err_Comp			:= FALSE;*)
	(*OM_PLC_W2_Bit_Err_BCR			:= FALSE;*)
	(*OM_PLC_W2_Bit_SetT10Terr		:= FALSE;*)

	g_UnloadPointArrived_OMPLC := OM_PLC_W2_Bit_Unload_PT;

	(*OM_PLC_W2_Bit_SetCondErr		:= FALSE;*)
	(*OM_PLC_W2_Bit_SetT30TErr		:= FALSE;*)
	
	OMPLC_BB_TrigR(CLK:= OM_PLC_W2_Bit_BB_setReq);
	
	if OMPLC_BB_TrigR.Q = TRUE then
		OMPLC_Trig := TRUE;
	end_if;
	
	
	if OMPLC_Trig = TRUE then
		NDC8.BlackBox.TrigReason:= 'OM_PLC';
		BlackBox();
		if BlackBox.Finished then
			OMPLC_Trig := FALSE;
		end_if;
	end_if;
	
	(*OM_PLC_W2_Bit_Set_LowTS			:= FALSE;*)
	(*OM_PLC_W2_Bit_SetHOErr			:= FALSE;*)


	(* OM-PLC Word*)
	NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);

	if NDC8.LayoutPosition.Point <> 0 then
		CurPnt := NDC8.LayoutPosition.Point;
	end_if;
	
	if NDC8.LayoutPosition.Segment <> 0 then
		CurSeg := NDC8.LayoutPosition.Segment;
	end_if;
	
	NDC8.OMPLC.Cur_Pnt := DINT_TO_INT(CurPnt);
	NDC8.OMPLC.Cur_Seg := DINT_TO_INT(CurSeg);

(* Alarm code *)

if LastCommCheckFlag = PLC_RX01_Bit_ChkCom_RX then
	CommCheckTimeUp(IN:= TRUE, PT:= t#10s);
	if CommCheckTimeUp.Q then
		g_PlcComLinkUp := FALSE;
	end_if;
else
	LastCommCheckFlag := PLC_RX01_Bit_ChkCom_RX;
	CommCheckTimeUp(IN:= FALSE);
	g_PlcComLinkUp := TRUE;
end_if;



(* Navi Error Monitor Start check *)
PositionValidDelay(IN := NDC8.Position.Valid, PT:= t#2s);
InSystemDelay(IN := NDC8.LayoutPosition.InSystem, PT:= t#2s);

if PositionValidDelay.Q = TRUE then
	g_PositionValidMonitorStart := TRUE;
end_if;

if InSystemDelay.Q = TRUE then
	g_InSystemMonitorStart := TRUE;
end_if;




g_PlcComLinkUp := TRUE;

if g_FindSyncFlag = TRUE then

OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);


	MasterLinkR(CLK:= NDC8.Master.MasterLinkUp);
	

	if MasterLinkR.Q or g_AGV_ErrorReset or (NDC8.Mcd.Button8 = TRUE and INPUT.Manual = TRUE) then (* When Master Link up, Error Status need to be update again *)
		g_ErrorCode := 0;
		PLC_TX_Word13_STr_Err := 0;
		OM_PLC_W2_Bit_SetEmgStop := FALSE;
	elsif PLC_RX_Word4_PLC_ErrD <> 0 and g_ErrorCode = 0 then 
		g_ErrorCode := PLC_RX_Word4_PLC_ErrD;
	elsif NDC8.SDIO.GroundFaultActive = TRUE then
		g_ErrorCode := 118;
	elsif F_DriveSupervision.NotMovingFail = TRUE or StopSpinningWheel then
		g_ErrorCode := 122;
	elsif R_DriveSupervision.NotMovingFail = TRUE or StopSpinningWheel then
		g_ErrorCode := 123;
	elsif F_SteerSupervision.NotMovingFail = TRUE or R_SteerSupervision.NotMovingFail = TRUE or (NDC8.DCD_6.EncoderStatus = 0 or NDC8.DCD_8.EncoderStatus = 0)then
		g_ErrorCode := 124;
	elsif PLC_TX_Word10_STr_BatV < 190 or g_BattLim_NG then
		g_ErrorCode := 127;
	elsif not NDC8.DCD_5.DigitalInput2_OverRelayFS or not NDC8.DCD_5.DigitalInput3_OverRelayFD or not NDC8.DCD_7.DigitalInput2_OverRelayRS or not NDC8.DCD_7.DigitalInput3_OverRelayRD then
		g_ErrorCode := 131;
	elsif NDC8.SDIO.DigitalInput3_BMP_O1 = TRUE or NDC8.SDIO.DigitalInput4_BMP_O2 = TRUE or NDC8.SDIO.DigitalInput8_BMP_E = FALSE then
		g_ErrorCode := 132;
	elsif NDC8.SDIO.DigitalInput12_EMO = FALSE then
		g_ErrorCode := 133;
	elsif NDC8.Position.Valid = FALSE and (PLC_TX01_Bit_HostMode = TRUE or PLC_TX01_Bit_LocalMode = TRUE) and CarrierControl.AutoinsertInProgress = false and g_PositionValidMonitorStart = TRUE then
		g_ErrorCode := 136;
		g_PositionValidMonitorStart := FALSE;
	elsif NDC8.LayoutPosition.InSystem = FALSE and (PLC_TX01_Bit_HostMode = TRUE or PLC_TX01_Bit_LocalMode = TRUE) and CarrierControl.AutoinsertInProgress = false and g_InSystemMonitorStart = TRUE then
		g_ErrorCode := 137;
		g_InSystemMonitorStart := FALSE;
	elsif NDC8.Guidance.OutsideSafetyZone = TRUE then
		g_ErrorCode := 138;
	elsif NDC8.LS2000.Connected = FALSE or NDC8.LS2000.Attached = FALSE or NDC8.LS2000.NavActive = FALSE then
		g_ErrorCode := 139;
	elsif NavLevelDown_TmUp = TRUE then
		g_ErrorCode := 140;
	elsif OM_PLC_W2_Bit_SetEmgStop = TRUE then
		g_ErrorCode := 145;
	elsif NDC8.CAN_IO_3.DigitalInput1_SteerLimitF_L or NDC8.CAN_IO_3.DigitalInput2_SteerLimitF_R or NDC8.CAN_IO_3.DigitalInput3_SteerLimitR_L or NDC8.CAN_IO_3.DigitalInput4_SteerLimitR_R then
		g_ErrorCode := 161;
	elsif PLC_RX01_Bit_ChrgEmg or g_ChargeTempErr then
		g_ErrorCode := 174;
	elsif SteerModeChangeErr_SD_DD = TRUE then
		g_ErrorCode := 175;
	elsif SteerModeChangeErr_DD_SD = TRUE then
		g_ErrorCode := 176;
	elsif EncOverSpeedTm.Q then
		g_ErrorCode := 181;
	elsif F_DriveSupervision.OverRangeFail = TRUE then
		g_ErrorCode := 182;
	elsif R_DriveSupervision.OverRangeFail = TRUE then
		g_ErrorCode := 183;
	elsif g_ChargeOverTime = TRUE then
		g_ErrorCode := 185;
	elsif NDC8.Automatic.ExecDriveCommand = TRUE and NDC8.VehicleControl.Moving = TRUE and NDC8.VehicleControl.Stop = FALSE and PLC_RX01_Bit_EnableLD_i = FALSE then
		g_ErrorCode := 190;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 2 then
		g_ErrorCode := 194;
		StopByCanErr_Node2 := TRUE;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 3 then
		g_ErrorCode := 195;
		StopByCanErr_Node3 := TRUE;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 5 then
		g_ErrorCode := 197;
		StopByCanErr_Node5 := TRUE;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 6 then
		g_ErrorCode := 198;
		StopByCanErr_Node6 := TRUE;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 7 then
		g_ErrorCode := 199;
		StopByCanErr_Node7 := TRUE;
	elsif NDC8.CanOpenMaster.State = 1 and NDC8.CanOpenMaster.EMCY_BusID = 1 and NDC8.CanOpenMaster.EMCY_NodeID = 8 then
		g_ErrorCode := 200;
		StopByCanErr_Node8 := TRUE;
	elsif CommCheckTimeUp.Q = TRUE then
		g_ErrorCode := 383;
	elsif Autoload.Fail = TRUE then
		;
		(*When Autoload Fail, ErrorCode Set by AutoLoad_FB, Here do nothing *)
		(*After Report event code in AutoLoad, "Fail" will reset in Step 1000*)
	else
		(*_ErrorCode := 0;*)
		(* only use Reset PB to Clear Error Code *)
		;
	end_if;
	
	if g_ErrorCode > 100 and g_ErrorCode < 201 then
		PLC_TX_Word13_STr_Err := g_ErrorCode;
	end_if;
	
	NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);

end_if;

(* Error Trigger Black Box *)
if PLC_TX01_Bit_HostMode and (g_ErrorCode = 131 or g_ErrorCode = 132 or g_ErrorCode = 133 or g_ErrorCode = 138 or g_ErrorCode = 137 or g_ErrorCode = 140 or g_ErrorCode = 161) then
	Error_Set_Trig := true;
else
	Error_Set_Trig := false;
end_if;	

Error_BB_TrigR(CLK:= Error_Set_Trig);
	
if Error_BB_TrigR.Q = TRUE then
	Error_Trig := TRUE;
end_if;


if Error_Trig = TRUE then
	ErrorCodeString := WORD_TO_STRING(g_ErrorCode);
	BBMessage := CONCAT('AGV_Error_', ErrorCodeString);
	NDC8.BlackBox.TrigReason := BBMessage;
	BlackBox();
	if BlackBox.Finished then
		Error_Trig := FALSE;
	end_if;
end_if;


if g_ErrorCode <> 0 then
	StopByErrorCode := TRUE;
else
	StopByErrorCode := FALSE;
end_if;

if (PLC_RX01_Bit_EnableLD_i = FALSE or INPUT.StartMode = FALSE) and Input.Auto then
	StopRobotNotIdle := TRUE;
else
	StopRobotNotIdle := FALSE;
end_if;

(* Blocking Power Off Check *)
BlockPowOffTmValue := DINT_TO_TIME(NDC8.UserDefined.Integer32_52_PowOffTm);
LostPosPowOffTmValue := DINT_TO_TIME(NDC8.UserDefined.Integer32_52_PowOffTm);

BlockPowOffTm(IN := NDC8.PLC_Application.TxStatusBit10_Blocked, PT := BlockPowOffTmValue);
if NDC8.UserDefined.Boolean_10_BlockPowOffEn = TRUE and PLC_TX01_Bit_HostMode = TRUE then
	if BlockPowOffTm.Q = TRUE then
		g_PowerOffFlag_Block := TRUE;
	else
		g_PowerOffFlag_Block := FALSE;
	end_if;
else
	g_PowerOffFlag_Block := FALSE;
end_if;

(* Navigation Level Down Check *)
if NDC8.Position.NavLevel < 45 and INPUT.Auto = TRUE then
	NavLevelDown_Start := TRUE;
else
	NavLevelDown_Start := FALSE;
	NavLevelDown_TmUp := FALSE;
end_if;

NavLevelDown_TM(IN := NavLevelDown_Start, PT := t#60s);

if NavLevelDown_TM.Q = TRUE then
	NavLevelDown_TmUp := TRUE;
end_if;
 

(* Lost Power Off Check *)
LostPosPowOffTm(IN := NDC8.PLC_Application.TxStatusBit12_LostP, PT := LostPosPowOffTmValue);
if NDC8.UserDefined.Boolean_11_LostPosPowOffEn = TRUE and PLC_TX01_Bit_HostMode = TRUE then
	if LostPosPowOffTm.Q = TRUE then
		g_PowerOffFlag_Lost := TRUE;
	else
		g_PowerOffFlag_Lost := FALSE;
	end_if;
else
	g_PowerOffFlag_Lost := FALSE;
end_if;


g_PowerOffFlag := (g_BattLim_NG or g_PowerOffFlag_Block or g_PowerOffFlag_Lost or g_PowerOffFlag_PLC or g_PowerOffFlag_OP);

(* Display Stop String update *)
InStatus 			:= g_ErrorCode<>0;
FailCodeDint		:= WORD_TO_DINT(g_ErrorCode);
DisplayStopString(INStatus:=InStatus, StopString:=49, StopValue:=FailCodeDint);		(* Failcode *)

(* IR Sensor switch always on *)
NDC8.CAN_IO_3.DigitalOutput9_AreaF_SW1 := TRUE;
NDC8.CAN_IO_3.DigitalOutput10_AreaF_SW2 := TRUE;
NDC8.CAN_IO_3.DigitalOutput13_AreaR_SW1 := TRUE;
NDC8.CAN_IO_3.DigitalOutput14_AreaR_SW2 := TRUE;

(* IR Speed Control *)

if NDC8.SegmentTrigger.Bit15_DisIrStop = FALSE and (NDC8.SegmentTrigger.Bit14_DisIrSlow = FALSE and PLC_TX01_Bit_ManMode = FALSE) then

	if ((NDC8.CAN_IO_3.DigitalInput9_AreaF_IN1 = FALSE and NDC8.VehicleControl.TravelDir = 1)
		or (NDC8.CAN_IO_3.DigitalInput13_AreaR_IN1 = FALSE and NDC8.VehicleControl.TravelDir = 0) )
		and NDC8.Automatic.ExecDriveCommand and StopAutoBrakeRelease = FALSE then
		Input.SafetyScannerSlowDown := TRUE;
	else
		Input.SafetyScannerSlowDown := FALSE;
	end_if;
	
else
	Input.SafetyScannerSlowDown := FALSE;
	
end_if;

if NDC8.SegmentTrigger.Bit15_DisIrStop = FALSE and PLC_TX01_Bit_ManMode = FALSE then
	
	if ((NDC8.CAN_IO_3.DigitalInput10_AreaF_IN2 = FALSE and NDC8.VehicleControl.TravelDir = 1)
		or (NDC8.CAN_IO_3.DigitalInput14_AreaR_IN2 = FALSE and NDC8.VehicleControl.TravelDir = 0))
		and NDC8.Automatic.ExecDriveCommand and StopAutoBrakeRelease = FALSE then
		StopObstacle := TRUE;
	else
		StopObstacle := FALSE;
	end_if;
	
	if StopObstacle = TRUE and NDC8.Mcd.Button7 = TRUE then
		StopObstacle := FALSE;
	end_if;
	
else
	StopObstacle := FALSE;

end_if;


	
if NDC8.LS2000.Attached = true then
	LS2000_Attached_M(IN:=TRUE, PT:=t#60s);
else
	LS2000_Attached_M(IN:=FALSE);	
end_if;

if LS2000_Attached_M.Q = TRUE then
	LS2000_Attached_M(IN:=FALSE);	
	NDC8.UserDefined.Integer32_60_LS2000_Attached_M := NDC8.UserDefined.Integer32_60_LS2000_Attached_M + 1;
end_if;


if NDC8.UserDefined.Integer32_60_LS2000_Attached_M > 60 then
	NDC8.UserDefined.Integer32_59_LS2000_Attached_H := NDC8.UserDefined.Integer32_59_LS2000_Attached_H + 1;
	NDC8.UserDefined.Integer32_60_LS2000_Attached_M := 0;
end_if;

if NDC8.UserDefined.Integer32_59_LS2000_Attached_H > 24 then
	NDC8.UserDefined.Integer32_58_LS2000_Attached_D := NDC8.UserDefined.Integer32_58_LS2000_Attached_D + 1;
	NDC8.UserDefined.Integer32_59_LS2000_Attached_H := 0;
end_if;

TravelDistanceSamplingTimer(IN:= TRUE, PT:=t#5s);

if TravelDistanceSamplingTimer.Q then
	if abs(NDC8.DCD_5.DriveEncDist - LastEncoderDistance) > 60000 then
		CurrentEncoderDistance := 65530 - abs(NDC8.DCD_5.DriveEncDist - LastEncoderDistance);
	else
		CurrentEncoderDistance := abs(NDC8.DCD_5.DriveEncDist - LastEncoderDistance);
	end_if;
	
	CurrentEncoderDistance := CurrentEncoderDistance / 10;
	
	
	NDC8.UserDefined.Integer32_55_TravelDistance := NDC8.UserDefined.Integer32_55_TravelDistance + UINT_TO_DINT(CurrentEncoderDistance);
	
	if NDC8.UserDefined.Integer32_55_TravelDistance > 2100000000 then
		NDC8.UserDefined.Integer32_55_TravelDistance := 0;
	end_if;
	
	LastEncoderDistance := NDC8.DCD_5.DriveEncDist;
	TravelDistanceSamplingTimer(IN:= FALSE);
end_if;


(* Black Box Trigger
if g_FindSyncFlag = TRUE Then
	BootUpDelay(IN:= TRUE, PT:=t#180s);
End_if;

if g_ErrorCode <> 0 and NoErrorDelay.Q = TRUE then
	ErrorFlag := TRUE;
end_if;

ErrorTrigR(CLK:= ErrorFlag);

if ErrorTrigR.Q = TRUE then
	ErrorTrigFlag := TRUE;
end_if;

if BootUpDelay.Q = TRUE then
	if ErrorTrigFlag then
		NDC8.BlackBox.TrigReason:= 'Error Trigger';
		BlackBox();
		if BlackBox.Finished then
			ErrorTrigFlag := FALSE;
		end_if;
	end_if;
End_if;


if g_ErrorCode = 0 then
	NoErrorDelay(IN:= TRUE, PT:=t#60s);
else
	NoErrorDelay(IN:= FALSE);
end_if;
 *)
 
Display();

(*if HMI Set "Force Output" signal will overwrite in OPTX2*)
OPTX2();

DataUpdate();


(* Steer Mode Err Detect *)

if LastSteerMode = 1 and NDC8.Manual.PLCSteerMode = 2 then
	SteerModeChange_SD_DD_Flag := TRUE;
end_if;

if LastSteerMode = 2 and NDC8.Manual.PLCSteerMode = 1 then
	SteerModeChange_DD_SD_Flag := TRUE;
end_if;

if LastSteerMode = NDC8.Manual.PLCSteerMode then
	SteerModeChange_SD_DD_Flag := FALSE;
	SteerModeChange_DD_SD_Flag := FALSE;
end_if;

if SteerModeChange_SD_DD_Flag or SteerModeChange_DD_SD_Flag then
	SteerModeChange_Flag := TRUE;
end_if;

if SteerModeChange_Flag then
	SteerModeChangeDelay(IN := TRUE, PT := t#5s);
end_if;

Steer_F_ABS_Angle := ABS(NDC8.DCD_6.WheelAngle);
Steer_R_ABS_Angle := ABS(NDC8.DCD_8.WheelAngle);

if SteerModeChangeDelay.Q then
	if NDC8.Manual.PLCSteerMode = 2
		and ((Steer_F_ABS_Angle < 8500 or Steer_F_ABS_Angle > 9500)
		or (Steer_R_ABS_Angle < 8500 or Steer_R_ABS_Angle > 9500)) then
	 	SteerModeChangeErr_SD_DD := TRUE;
	else
		SteerModeChangeErr_SD_DD := FALSE;
	end_if;
	
	if NDC8.Manual.PLCSteerMode = 1
		and ((NDC8.DCD_6.WheelAngle < (NDC8.DCD_6.SetAngle - 500) or NDC8.DCD_6.WheelAngle > (NDC8.DCD_6.SetAngle + 500))
		or (NDC8.DCD_8.WheelAngle < (NDC8.DCD_8.SetAngle - 500) or NDC8.DCD_8.WheelAngle > (NDC8.DCD_8.SetAngle + 500)))then
	 	SteerModeChangeErr_DD_SD := TRUE;
	else
		SteerModeChangeErr_DD_SD := FALSE;
	end_if;
	SteerModeChangeDelay(IN := FALSE);
	SteerModeChange_Flag := FALSE;
end_if;

LastSteerMode := NDC8.Manual.PLCSteerMode;


(* Max Speed Detect*)
EncSpeed_ABS_DCD5 := ABS(NDC8.DCD_5.DriveEncSpeed);
EncSpeed_ABS_DCD7 := ABS(NDC8.DCD_7.DriveEncSpeed);
EncSpeed_MAX := REAL_TO_INT(DINT_TO_REAL(NDC8.Vehicle.MaxSpeed) * 1.2);


EncOverSpeedFlag := EncSpeed_ABS_DCD5 >= EncSpeed_MAX or EncSpeed_ABS_DCD7 >= EncSpeed_MAX;

if EncOverSpeedFlag = TRUE then
	EncOverSpeedTm(IN := TRUE, PT := t#2s);
else
	EncOverSpeedTm(IN := FALSE);
end_if;

(* SOC Cal *)

(* AGV IDEL *)

FullBattery_Cap := DINT_TO_REAL(NDC8.UserDefined.Integer32_35_Battery_Cap) * 60.0 * 60.0;

Current_Idel := DINT_TO_REAL(NDC8.UserDefined.Integer32_45_Current_Idel);
Current_Moving := DINT_TO_REAL(NDC8.UserDefined.Integer32_43_Current_Moving);
Current_Transfer := DINT_TO_REAL(NDC8.UserDefined.Integer32_44_Current_Transfer);

Current_Charge := DINT_TO_REAL(NDC8.UserDefined.Integer32_46_Current_Charge);


FindSyncFlag_Rrig(CLK := g_FindSyncFlag);

if FindSyncFlag_Rrig.Q then
	Battery_Cap := DINT_TO_REAL(NDC8.UserDefined.Integer32_39_CurrentBatCap) / 1000.0 * FullBattery_Cap;
end_if;

if NDC8.UserDefined.Integer32_39_CurrentBatCap <= 0 and g_FindSyncFlag = TRUE then
	NDC8.UserDefined.Integer32_39_CurrentBatCap := NDC8.UserDefined.Integer32_36_Battery_IniCap;
	Battery_Cap := DINT_TO_REAL(NDC8.UserDefined.Integer32_39_CurrentBatCap) / 1000.0 * FullBattery_Cap;
end_if;

	



(* Charge Done Check *)
ChargeDoneR(CLK := g_ChargeDone);

if ChargeDoneR.Q and g_FindSyncFlag = TRUE then
	NDC8.UserDefined.Integer32_39_CurrentBatCap := 800;
	Battery_Cap := FullBattery_Cap * 0.8;
end_if;


(* Low Voltage Check *)
LowVoltageR(CLK := INPUT.LowBattery);

if LowVoltageR.Q and g_FindSyncFlag = TRUE then
	NDC8.UserDefined.Integer32_39_CurrentBatCap := 650;
	Battery_Cap := FullBattery_Cap * 0.65;
end_if;

CurrentUsing := 0.0;

BatCheckTimer(IN := TRUE, PT := t#1s);


if BatCheckTimer.Q and g_FindSyncFlag = TRUE then

	BatCheckTimer(IN := FALSE);
	

	if NDC8.VehicleControl.Moving then
		CurrentUsing := CurrentUsing - Current_Moving;
	elsif AutoLoad.StartLoad or AutoLoad.StartUnload then
		CurrentUsing := CurrentUsing - Current_Transfer;
	else
		CurrentUsing := CurrentUsing - Current_Idel;
	end_if;


	if NDC8.PLC_Application.TxStatusBit6_Charge then
		CurrentUsing := CurrentUsing + 150.0;
	end_if;
	
	Battery_Cap := Battery_Cap + CurrentUsing;
	
	NDC8.UserDefined.Integer32_39_CurrentBatCap := REAL_TO_DINT(Battery_Cap / FullBattery_Cap  * 1000.0);
	
	PLC_TX_Word12_STr_BatD := DINT_TO_WORD(NDC8.UserDefined.Integer32_39_CurrentBatCap);
	
end_if;





















END_PROGRAM