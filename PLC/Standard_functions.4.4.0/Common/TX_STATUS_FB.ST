FUNCTION_BLOCK TX_STATUS_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
	Input : Input_T;

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR

	Load_F : F_Trig;
	Load_F_FLAG : BOOL;
	
	Load_F_Timer : TON;
	
	BCD_Compare_R : F_Trig;
	BCD_Fail_R : F_Trig;
	
	BatLowR : R_Trig;
	BatLowF : F_Trig;

	ErrorCodeD : DINT;
	LastErrorCode : Word := 0;
	ErrorTrigFlag : bool;
	ErrorTrigR : R_Trig;
	ErrorTrigF : F_Trig;
	
	InsertDone : BOOL;
	InsertDoneR : R_Trig;
	
	PowerOffR	: R_Trig;
	
	WaitChargeR	: R_Trig;
	WaitChargeF	: F_Trig;
	
	ChargingR : R_Trig;
	ChargingF : F_Trig;
	
	ChargeDoneR : R_Trig;
	
	
	LoadStatusR :R_Trig;
	LoadStatusF :F_Trig;
	
	ManualModeR :R_Trig;
	ManualModeF :F_Trig;
	
	LostR :R_Trig;
	LostF :F_Trig;
	
	LocalModeR :R_Trig;
	LocalModeF :F_Trig;
	
	LocalInterlockFailCodeD : DINT;
	LocalInterlockFailFlag : bool;
	LocalInterlockFailR :R_Trig; 
	
	DriveOutR : R_Trig;
	
	BrakeReleaseR : R_Trig;
	BrakeReleaseF : F_Trig;
	
	BeamStop_R : R_Trig;
	BeamStop_F : F_Trig;
	
	BlockFlagR : R_Trig;
	BlockFlagF : F_Trig;
	BlockModeFlag : BOOL;
	
	
	
	BCDReadFailR :R_Trig;

	ILErr_ev :R_Trig;
	ILErr_ev_Flag : BOOL;
	ILErr_D : DINT;
	
	(* Battery *)
	ChrgFlag_R_L : BOOL;
	TX_LowBatt_R : R_Trig;
	TX_ChgComp_R : R_Trig;
	Chrg_Right_Left_R : R_Trig;
	TX_Load_R : R_Trig;
	
	
	DINT_BMS2 : DINT;
	DINT_BMS3 : DINT;
	DINT_BMS_BatV : DINT;
	DINT_BMS_BatT : DINT;
	DINT_BMS_BatC : DINT;
	DINT_BMS_BatA : DINT;
	DINT_BMS_Main : DINT;
	DINT_BMS_Chan : DINT;
	DINT_BMS_ID4L : DINT;
	DINT_BMS_ID4H : DINT;
	
	Blink_1_Hz : BLINK;
	
	
END_VAR
(*
------------------------------------------------------------------------------------                              
 TX_status
 ------------------      
             
 Description:                     
 Sends status bits to master controller.
 
-------------------------------------------------------------------------------------*)
(*TxStatus bits*)

OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);

NDC8.PLC_Application.TxStatusBit0_Load := INPUT.LoadOnBoard;
NDC8.PLC_Application.TxStatusBit1_EaLD := PLC_RX01_Bit_EnableLD_i;

if NDC8.LoadOperation.OperationCode <> 0 then 
	NDC8.PLC_Application.TxStatusBit2_HaveCmd := true;	(*Operation Code OK*)
else
	NDC8.PLC_Application.TxStatusBit2_HaveCmd := false;	(*Operation Code OK*)
end_if;

NDC8.PLC_Application.TxStatusBit3_RelBRK := NDC8.SDIO.DigitalInput5_BTN_BRK; (*Brake release*)

Load_F(CLK:=PLC_RX01_Bit_Load_i);

if Load_F.Q then
	Load_F_FLAG := TRUE;
end_if;

Load_F_Timer(IN:=Load_F_FLAG, PT:=t#1s);


if Load_F_Timer.Q then
	Load_F_FLAG := FALSE;
end_if;


if (OM_PLC_W1_Bit_WaitCharge = TRUE and OM_PLC_W1_Bit_SetLowBatt = FALSE) or OM_PLC_W1_Bit_WaitOrder = TRUE then
	
	if NDC8.PLC_Application.TxStatusBit5_WaitLow = FALSE then
		NDC8.PLC_Application.TxStatusBit5_WaitLow := TRUE; (*Charge Wait*)
	end_if;
else
	NDC8.PLC_Application.TxStatusBit5_WaitLow := FALSE; (*Charge Wait*)
end_if;

NDC8.PLC_Application.TxStatusBit4_LowBatt := (INPUT.LowBattery or NDC8.Userdefined.LowBatSim or OM_PLC_W1_Bit_SetLowBatt)and NDC8.PLC_Application.TxStatusBit5_WaitLow = FALSE ; (*Battery Low*)

NDC8.PLC_Application.TxStatusBit6_Charge := (PLC_TX01_Bit_ChrgSelL_A = TRUE or PLC_TX01_Bit_ChrgSelR_A = TRUE) and PLC_RX03_Bit_CP_HP = FALSE; (*Charging*)

if g_ChargeDone = TRUE and NDC8.PLC_Application.TxStatusBit4_LowBatt = FALSE then
	NDC8.PLC_Application.TxStatusBit7_ChgComp := TRUE;
elsif NDC8.Automatic.ExecDriveCommand = TRUE or NDC8.PLC_Application.TxStatusBit4_LowBatt = TRUE then
	NDC8.PLC_Application.TxStatusBit7_ChgComp := FALSE;
end_if;

NDC8.PLC_Application.TxStatusBit8_Manual := PLC_TX01_Bit_ManMode; (*Manual Mode*)
NDC8.PLC_Application.TxStatusBit9_EStop := NDC8.VehicleControl.Estop or StopEstopButton or g_ErrorCode <> 0; (*Emergency Stop*)
NDC8.PLC_Application.TxStatusBit10_Blocked := PLC_TX03_Bit_STr_Block;  (*Blocked*)

NDC8.PLC_Application.TxStatusBit11_IrStop := StopObstacle; (*Obstacle sensor Stop*)


if g_ErrorCode = 137 then
	NDC8.PLC_Application.TxStatusBit12_LostP :=  TRUE; (*Lost Position*)
else
	NDC8.PLC_Application.TxStatusBit12_LostP :=  FALSE;
end_if;
NDC8.PLC_Application.TxStatusBit13 := false;
NDC8.PLC_Application.TxStatusBit14 := false;

Blink_1_Hz(RUN := TRUE, CYCLE := t#0.5s);
NDC8.PLC_Application.TxStatusBit15_ON_OFF := Blink_1_Hz.Q1;


(*Tx Event*)
(*---------------------------------------------------------------------------*)

(* User Event 3: Battery ON *)
BatLowR(CLK:= NDC8.PLC_Application.TxStatusBit4_LowBatt);
if BatLowR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=3,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 33: Battery OFF *)
BatLowF(CLK:= NDC8.PLC_Application.TxStatusBit4_LowBatt);
if BatLowF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=33,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;


(* User Event 2: Load Status ON *)
LoadStatusR(CLK:= PLC_RX01_Bit_Load_i);
if LoadStatusR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=2,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 32: Load Status OFF *)
LoadStatusF(CLK:= PLC_RX01_Bit_Load_i);
if LoadStatusF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=32,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 1: Error ON ErrorCode *)
(* User Event 91: Error ON Current Segment*)
(* User Event 92: Error ON Mode 0:Auto 1:Manual*)

if g_ErrorCode = 0 then
	ErrorTrigFlag := FALSE;
	LastErrorCode := 0;
elsif LastErrorCode <> g_ErrorCode then
	ErrorTrigFlag := TRUE;
end_if;

ErrorTrigR(CLK:= ErrorTrigFlag);

if ErrorTrigR.Q and NDC8.Master.MasterLinkUp then

	LastErrorCode := g_ErrorCode;
	ErrorCodeD := WORD_TO_DINT(LastErrorCode);
	
	EventQueue(EventCode:=1,
			Par1:=ErrorCodeD,
			Par2:=0,
			Par3:=0,
			Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	
	EventQueue(EventCode:=91,
			Par1:=NDC8.LayoutPosition.Segment,
			Par2:=0,
			Par3:=0,
			Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	
	if INPUT.Auto then
		EventQueue(EventCode:=92,
			Par1:=0,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	else
		EventQueue(EventCode:=92,
			Par1:=1,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	LastErrorCode := g_ErrorCode;
	
end_if;	

(* User Event 31: Error OFF *)

(*PLC*)
ErrorTrigF(CLK:= ErrorTrigFlag);

if ErrorTrigF.Q and NDC8.Master.MasterLinkUp then

	ErrorCodeD := WORD_TO_DINT(LastErrorCode);
	EventQueue(EventCode:=31,
		Par1:=ErrorCodeD,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 61: Insert ON *)

InsertDone := NDC8.Autoinsert.StatusID = 5;

InsertDoneR(CLK:= InsertDone);
if InsertDoneR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=61,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 93: Auto Power OFF *)
PowerOffR(CLK:= g_PowerOffFlag);
if PowerOffR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=93,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 4: Charge Wait ON *)
WaitChargeR(CLK:= NDC8.PLC_Application.TxStatusBit5_WaitLow);
if WaitChargeR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=4,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 34: Charge Wait OFF *)
WaitChargeF(CLK:= NDC8.PLC_Application.TxStatusBit5_WaitLow);
if WaitChargeF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=34,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 6: Charge Complete *)
ChargeDoneR(CLK:= NDC8.PLC_Application.TxStatusBit7_ChgComp);
if ChargeDoneR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=6,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 5: Charging ON*)
ChargingR(CLK:= NDC8.PLC_Application.TxStatusBit6_Charge);
if ChargingR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=5,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 35: Charging OFF*)
ChargingF(CLK:= NDC8.PLC_Application.TxStatusBit6_Charge);
if ChargingF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=35,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 7: Manual Mode ON*)
ManualModeR(CLK:= PLC_TX01_Bit_ManMode);
if ManualModeR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=7,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 37: Manaul Mode OFF*)
ManualModeF(CLK:= PLC_TX01_Bit_ManMode);
if ManualModeF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=37,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 10: Lost ON*)
LostF(CLK:= NDC8.LayoutPosition.InSystem);
if LostF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=10,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 40: Lost OFF*)
LostR(CLK:= NDC8.LayoutPosition.InSystem);
if LostR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=40,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 11: Local Mode ON*)
LocalModeR(CLK:= PLC_TX01_Bit_LocalMode);
if LocalModeR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=11,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;


(* User Event 41: Local Mode OFF*)
LocalModeF(CLK:= PLC_TX01_Bit_LocalMode);
if LocalModeF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=41,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 12: Brake Release ON *)
BrakeReleaseR(CLK:= NDC8.SDIO.DigitalInput5_BTN_BRK);

if BrakeReleaseR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=12,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;	

(* User Event 42: Brake Release OFF *)
BrakeReleaseF(CLK:= NDC8.SDIO.DigitalInput5_BTN_BRK);

if BrakeReleaseF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=42,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 8: Block ON *)
if NDC8.Automatic.SetOrderMode = 1 or NDC8.Automatic.SetOrderMode = 3 then
	BlockModeFlag := TRUE;
else
	BlockModeFlag := FALSE;
end_if;

BlockFlagR(CLK:=BlockModeFlag);
if BlockFlagR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=8,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 38: Block OFF *)
BlockFlagF(CLK:=BlockModeFlag);
if BlockFlagF.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=38,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;


(* User Event 9: Beam Sensor Stop ON *)
BeamStop_R(CLK:=StopObstacle);
if BeamStop_R.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=9,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 39: Beam Sensor Stop OFF*)
BeamStop_F(CLK:=StopObstacle);
if BeamStop_F.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=39,
		Par1:=NDC8.LayoutPosition.Segment,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

(* User Event 71: Warning*)
BCD_Compare_R(CLK:=OM_PLC_W2_Bit_Err_Comp);

if BCD_Compare_R.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=71,
		Par1:=155,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;


BCDReadFailR(CLK:=OM_PLC_W2_Bit_Err_BCR);

if BCDReadFailR.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=71,
		Par1:=156,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;

OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);


if OM_PLC_W2_Bit_SetOpCanc = FALSE
	and OM_PLC_W2_Bit_SetCondErr = FALSE
	and OM_PLC_W9_Bit_Adj_Err = FALSE
	and OM_PLC_W9_Bit_ChgP_Err = FALSE then
	ILErr_ev_Flag := FALSE;
end_if;

if OM_PLC_W9_Bit_Enable_Err = FALSE then
	if PLC_RX10_Bit_Round_Y1 = TRUE then
		ILErr_D := 251;
	elsif PLC_RX10_Bit_Round_Y2	 = TRUE then
		ILErr_D := 252;
	elsif PLC_RX10_Bit_Round_X = TRUE then
		ILErr_D := 253;
	elsif PLC_RX10_Bit_Round_RT = TRUE then
		ILErr_D := 254;
	elsif PLC_RX10_Bit_Round_FK = TRUE then
		ILErr_D := 255;
	elsif PLC_RX10_Bit_Round_Y = TRUE then
		ILErr_D := 256;
	elsif PLC_RX10_Bit_Round_RT2 = TRUE then
		ILErr_D := 221;
	elsif PLC_RX03_Bit_Round_ChgP = TRUE then
		ILErr_D := 265;
	end_if;
else
	if OM_PLC_W2_Bit_SetCondErr = TRUE then
		ILErr_D := 242;
	elsif OM_PLC_W2_Bit_SetOpCanc = TRUE then
		ILErr_D := 243;
	end_if;
end_if;

if ILErr_D <> 0 then
	ILErr_ev_Flag := TRUE;
end_if;

ILErr_ev(CLK := ILErr_ev_Flag);

if ILErr_ev.Q and NDC8.Master.MasterLinkUp then
	EventQueue(EventCode:=71,
		Par1:=ILErr_D,
		Par2:=0,
		Par3:=0,
		Par4:=0);
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;



(* Bat Event Trig *)
	ChrgFlag_R_L := NDC8.PointTrigger.Bit9_Chrg_Right or NDC8.PointTrigger.Bit10_Chrg_Left;
	TX_LowBatt_R(CLK:= NDC8.PLC_Application.TxStatusBit4_LowBatt);
	TX_ChgComp_R(CLK:= NDC8.PLC_Application.TxStatusBit7_ChgComp);
	Chrg_Right_Left_R(CLK:= ChrgFlag_R_L);
	TX_Load_R(CLK:= NDC8.PLC_Application.TxStatusBit0_Load);

	BMS_EnaEvent := 0;
	
(* Chg_Comp Event *)
	if TX_ChgComp_R.Q and EnaBMSEv01 = TRUE then
		(* BMS_ev21 *)
		EventQueue(EventCode:=81,
			Par1:=DINT_BMS2,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv02 = TRUE then
		(* BMS_ev22 *)
		EventQueue(EventCode:=82,
			Par1:=DINT_BMS3,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv03 = TRUE then
		(* BMS_ev23 *)
		EventQueue(EventCode:=83,
			Par1:=DINT_BMS_BatV,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv04 = TRUE then
		(* BMS_ev24 *)
		EventQueue(EventCode:=84,
			Par1:=DINT_BMS_BatT,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;

	if TX_ChgComp_R.Q and EnaBMSEv05 = TRUE then
		(* BMS_ev25 *)
		EventQueue(EventCode:=85,
			Par1:=DINT_BMS_BatC,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv06 = TRUE then
		(* BMS_ev26 *)
		EventQueue(EventCode:=86,
			Par1:=DINT_BMS_BatA,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv07 = TRUE then
		(* BMS_ev27 *)
		EventQueue(EventCode:=87,
			Par1:=DINT_BMS_Main,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_ChgComp_R.Q and EnaBMSEv08 = TRUE then
		(* BMS_ev28 *)
		EventQueue(EventCode:=88,
			Par1:=DINT_BMS_Chan,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;	
		
(* Chg_Strt Event*)
	if Chrg_Right_Left_R.Q and EnaBMSEv01 = TRUE then
		(* BMS_ev31 *)
		EventQueue(EventCode:=81,
			Par1:=DINT_BMS2,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv02 = TRUE then
		(* BMS_ev32 *)
		EventQueue(EventCode:=82,
			Par1:=DINT_BMS3,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv03 = TRUE then
		(* BMS_ev33 *)
		EventQueue(EventCode:=83,
			Par1:=DINT_BMS_BatV,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv04 = TRUE then
		(* BMS_ev34 *)
		EventQueue(EventCode:=84,
			Par1:=DINT_BMS_BatT,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;

	if Chrg_Right_Left_R.Q and EnaBMSEv05 = TRUE then
		(* BMS_ev35 *)
		EventQueue(EventCode:=85,
			Par1:=DINT_BMS_BatC,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv06 = TRUE then
		(* BMS_ev36 *)
		EventQueue(EventCode:=86,
			Par1:=DINT_BMS_BatA,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv07 = TRUE then
		(* BMS_ev37 *)
		EventQueue(EventCode:=87,
			Par1:=DINT_BMS_Main,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if Chrg_Right_Left_R.Q and EnaBMSEv08 = TRUE then
		(* BMS_ev38 *)
		EventQueue(EventCode:=88,
			Par1:=DINT_BMS_Chan,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;	
	
	if Chrg_Right_Left_R.Q and EnaBMSEv09 = TRUE then
		(* BMS_ev39 *)
		EventQueue(EventCode:=89,
			Par1:=DINT_BMS_ID4L,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;	
	
	if Chrg_Right_Left_R.Q and EnaBMSEv10 = TRUE then
		(* BMS_ev40 *)
		EventQueue(EventCode:=90,
			Par1:=DINT_BMS_ID4H,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;	


(* Load Event *)
	if TX_Load_R.Q and EnaBMSEv01 = TRUE then
		(* BMS_ev41 *)
		EventQueue(EventCode:=81,
			Par1:=DINT_BMS2,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv02 = TRUE then
		(* BMS_ev42 *)
		EventQueue(EventCode:=82,
			Par1:=DINT_BMS3,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv03 = TRUE then
		(* BMS_ev43 *)
		EventQueue(EventCode:=83,
			Par1:=DINT_BMS_BatV,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv04 = TRUE then
		(* BMS_ev44 *)
		EventQueue(EventCode:=84,
			Par1:=DINT_BMS_BatT,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;

	if TX_Load_R.Q and EnaBMSEv05 = TRUE then
		(* BMS_ev45 *)
		EventQueue(EventCode:=85,
			Par1:=DINT_BMS_BatC,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv06 = TRUE then
		(* BMS_ev46 *)
		EventQueue(EventCode:=86,
			Par1:=DINT_BMS_BatA,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv07 = TRUE then
		(* BMS_ev47 *)
		EventQueue(EventCode:=87,
			Par1:=DINT_BMS_Main,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;
	
	if TX_Load_R.Q and EnaBMSEv08 = TRUE then
		(* BMS_ev48 *)
		EventQueue(EventCode:=88,
			Par1:=DINT_BMS_Chan,
			Par2:=0,
			Par3:=0,
			Par4:=0);
		a:=TRACE_DINT('EventCode', EventQueue.EventCode);
	end_if;	

(* Error event *)


NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);


































END_FUNCTION_BLOCK