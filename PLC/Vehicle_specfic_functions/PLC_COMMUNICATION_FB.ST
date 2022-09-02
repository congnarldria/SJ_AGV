FUNCTION_BLOCK PLC_COMMUNICATION_FB
VAR_EXTERNAL
	
END_VAR

VAR_INPUT
	ComStart : bool := TRUE; 
END_VAR

VAR_OUTPUT

END_VAR

VAR
	BMS_BatLowSel : INT;
	BMS_BatLow : BOOL;
	BAT50LOWVOL : WORD;
	TP_PB_NoSelTimer : TON;
	
	Debug_PB_Cont : BOOL := FALSE;
	Debug_PB_Finish : BOOL := FALSE;
	Debug_PB_Cancel : BOOL := FALSE;
	Debug_PB_Change : BOOL := FALSE;
	
	RST_Flag : BOOL;
	RST_R : R_Trig;
	
	RST_Keep : BOOL;
	RST_Keep_Timer : TON;
	LTDelay : TOF;
	BatLow : BOOL;
	
	
	TempInt : int;
	TempWord : word;
	WordL :int;
	WordH :int;
	
	FinalPnt : DINT;
	
	SwitchHostFlag : BOOL;
	Host_R : R_Trig;
	Host_R_Flag : BOOL;
	
	Host_R_Delay : TON;
	
	init  : bool := false;
	ComStep : int := 0;
	
	serial_read : NDC8_SERIAL_READ;
	serial_write : NDC8_SERIAL_WRITE;
	
	to_bytes 		: NDC8_STRING_TO_BYTES;
	to_string		: NDC8_BYTES_TO_STRING; 
	
	PLC_LastHeartBeat : BOOL;
	PLC_HeartBeatNoChange : BOOL;
	
	PLC_HeartBeatTimeout : TON;
	
	LoadDataSendFlag : BOOL;
	UnloadDataSendFlag : BOOL;
	
	TestDataSend : BOOL;
	
	OrderMode:OrderMode_FB;
	LocalOrder : LocalOrder_FB;
	NavInit : NavInit_FB;
	
	STw_NewcmdR : R_Trig;
	STw_Newcmd_Flag : BOOL;
	
	LocalManual : BOOL;
	LocalManual_R : R_Trig;
	SetToLocal : BOOL;
	
	Str_AckT : TON;
	STr_AckR : BOOL;
	
	(*---------Rev Data ----------*)
	Start : int;
	StartOffset : int;
	
	DataIndex1 : Int;
	DataIndex2 : Int;
	DataIndex3 : Int;
	DataIndex4 : Int;
	DataIndex5 : Int;

	
	RevDataLength : int := 0;

	TempString : string;
	
	HeaderString : string;
	DecodeString : string(200);
	DecodeString_RS : string(200);
	DecodeString_WS : string(200);

	TempData : ARRAY[1..32] OF BYTE;	

	SendData_Req : ARRAY[1..32] OF BYTE;
	
	ReceiveData_Status : ARRAY[1..1074] OF BYTE;
	(*--------------------------------------*)
	
	
	(*Send 16 Word Data *)
	EncoderStart : int;
	EncoderStartOffset : int;
	MessageLen : int;
	
	Message : string;
	SendTempString : string;
	
	SendData_Status1 : ARRAY[1..32] OF BYTE;
	SendData_Status2 : ARRAY[1..32] OF BYTE;
	SendData_Status3 : ARRAY[1..32] OF BYTE;
	SendData_Status4 : ARRAY[1..32] OF BYTE;
		
	(*--------------------------------------*)
	
	
	(*Decode WS Data*)
	DecodeStart_WS : int;
	
	DecodeString_WS_Data :string(200);
	SplitString : string;
	
	SplitPos : int;
	SplitPosOffset1 : int;
	
	DecodeDataArray : ARRAY[1..25] of WORD;
	
	(*---------------------------------------*)
	
END_VAR
if init = false then
	serial_read.port := 'COM1';
	serial_write.port := 'COM1';
	
	StartOffset := 1;
	
	SendData_Req[1] := 16#02;
	SendData_Req[2] := 16#30;
	SendData_Req[3] := 16#30;
	SendData_Req[4] := 16#46;
	SendData_Req[5] := 16#30;
	SendData_Req[6] := 16#58;
	SendData_Req[7] := 16#30;
	SendData_Req[8] := 16#30;
	SendData_Req[9] := 16#03;
	SendData_Req[10] := 16#0D;
	SendData_Req[11] := 16#0A;
	
	init := true;
	
end_if;


(*TX Data Proc*)
(*I00800*)

SwitchHostFlag := INPUT.Auto = TRUE and INPUT.StartMode = TRUE and NDC8.LayoutPosition.InSystem and NDC8.Master.MasterLinkUp;

Host_R(CLK:= SwitchHostFlag);

if SwitchHostFlag then

	Host_R_Delay(IN:= PLC_RX01_Bit_EnableLD_i, PT:=t#1s);
	
	
	if Host_R.Q then
		Host_R_Flag := TRUE;
	end_if;
	
	if NDC8.UserDefined.Boolean_20_OnlineOrderMode = FALSE  then
	
		if NDC8.Automatic.CurrentOrderMode = 1 then
			Host_R_Flag := FALSE;
		end_if;
	
		if NDC8.Automatic.CurrentOrderMode <> 1 and Host_R_Flag = TRUE and PLC_RX01_Bit_EnableLD_i = TRUE and Host_R_Delay.Q then
			NDC8.Automatic.SetOrderMode := 1;
			OrderMode();
		elsif NDC8.Automatic.CurrentOrderMode <> 1 and Host_R_Flag = FALSE then
			;
		end_if;
	else
		(*if NDC8.Automatic.CurrentOrderMode = 3 then
			Host_R_Flag := FALSE;
		end_if;*)
			if NDC8.Automatic.CurrentOrderMode <> 1 then
			Host_R_Flag := FALSE;
		end_if;
		(*if NDC8.Automatic.CurrentOrderMode <> 3 and Host_R_Flag = TRUE and PLC_RX01_Bit_EnableLD_i = TRUE and Host_R_Delay.Q then
			NDC8.Automatic.SetOrderMode := 3;
			OrderMode();
		elsif NDC8.Automatic.CurrentOrderMode <> 3 and Host_R_Flag = FALSE then
			;
		end_if;
		*)
		if NDC8.Automatic.CurrentOrderMode = 1 and Host_R_Flag = TRUE and PLC_RX01_Bit_EnableLD_i = TRUE and Host_R_Delay.Q then
			NDC8.Automatic.SetOrderMode := 3;
			OrderMode();
		END_IF;
	end_if;
	
else
	PLC_TX01_Bit_HostMode := false;
end_if;

(*I00801*)

PLC_TX01_Bit_ManMode := NDC8.Mcd.Button3;

if PLC_TX01_Bit_ManMode = TRUE then
	INPUT.StartMode := FALSe;
	OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
		OM_PLC_W2_Bit_SetEmgStop := FALSE;
	NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
end_if;
	
(*I00802*)
if INPUT.Auto = TRUE and (NDC8.Automatic.CurrentOrderMode = 2 or NDC8.Automatic.CurrentOrderMode = 3) then
	PLC_TX01_Bit_HostMode := false;
	PLC_TX01_Bit_LocalMode := true;
	
elsif INPUT.Auto = TRUE and NDC8.Automatic.CurrentOrderMode = 1 then
	PLC_TX01_Bit_HostMode := true;
	PLC_TX01_Bit_LocalMode := false;
else
	PLC_TX01_Bit_HostMode := false;
	PLC_TX01_Bit_LocalMode := false;
end_if;

(* I00803 *)
if INPUT.StartMode and (PLC_TX01_Bit_HostMode = true or PLC_TX01_Bit_LocalMode = true) and PLC_HeartBeatTimeout.Q = FALSE then
	PLC_TX01_Bit_OnLn_ModeP := TRUE;
else
	PLC_TX01_Bit_OnLn_ModeP := FALSE;
end_if;

if NDC8.Automatic.CurrentOrderMode = 2 then
	PLC_TX01_Bit_STr_Mod_NT := TRUE;
	PLC_TX01_Bit_STr_Mod_UT := FALSE;
elsif NDC8.Automatic.CurrentOrderMode = 1 or NDC8.Automatic.CurrentOrderMode = 3 then
	PLC_TX01_Bit_STr_Mod_NT := FALSE;
	PLC_TX01_Bit_STr_Mod_UT := TRUE;
end_if;

(* I00808 *)

if g_PlcComLinkUp = TRUE then
	if INPUT.LowBattery then
		PLC_TX01_Bit_STr_BatLow := TRUE;
	else
		PLC_TX01_Bit_STr_BatLow := FALSE;
	end_if;
end_if;
	
(* I00809 *)
	PLC_TX01_Bit_STr_Home := NDC8.PointTrigger.Bit8_HP_Pnt;

(* I00810 *)

STr_AckT(IN := STr_AckR, PT:= t#10s);

if PLC_TX01_Bit_OnLn_ModeP = TRUE then


	if 	PLC_RX04_Bit_STw_Cont = TRUE
		or PLC_RX04_Bit_STw_Finish = TRUE
		or PLC_RX04_Bit_STw_Cancel = TRUE
		or PLC_RX04_Bit_STw_Change = TRUE then
		
		TP_PB_NoSelTimer(IN:= FALSE);
		
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
		
		OM_PLC_W1_Bit_OM_Cont			:= PLC_RX04_Bit_STw_Cont;
		OM_PLC_W1_Bit_OM_Finish			:= PLC_RX04_Bit_STw_Finish;
		OM_PLC_W1_Bit_OM_Cancel			:= PLC_RX04_Bit_STw_Cancel;
		OM_PLC_W1_Bit_OM_Change			:= PLC_RX04_Bit_STw_Change;
	
		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
		
		STr_AckR := TRUE;
			
		if STr_AckT.Q then
			PLC_TX01_Bit_STr_Ack := TRUE;
		else
			PLC_TX01_Bit_STr_Ack := FALSE;
		end_if;
		
	elsif PLC_RX04_Bit_STw_Cont = FALSE
		or PLC_RX04_Bit_STw_Finish = FALSE
		or PLC_RX04_Bit_STw_Cancel = FALSE
		or PLC_RX04_Bit_STw_Change = FALSE then
		
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
		
		TP_PB_NoSelTimer(IN:=TRUE, PT:= t#10s);
		
		OM_PLC_W1_Bit_OM_Cont			:= FALSE;
		OM_PLC_W1_Bit_OM_Finish			:= FALSE;
		OM_PLC_W1_Bit_OM_Cancel			:= FALSE;
		OM_PLC_W1_Bit_OM_Change			:= FALSE;
		
		
		if TP_PB_NoSelTimer.Q then
			OM_PLC_W1_Bit_OM_Cont := TRUE;
		end_if;
		
		
		if Debug_PB_Cont = TRUE then
			OM_PLC_W1_Bit_OM_Cont := TRUE;
		end_if;
		
		if Debug_PB_Finish = TRUE then
			OM_PLC_W1_Bit_OM_Finish := TRUE;
		end_if;
		
		if Debug_PB_Cancel = TRUE then
			OM_PLC_W1_Bit_OM_Cancel := TRUE;
		end_if;
		
		if Debug_PB_Change = TRUE then
			OM_PLC_W1_Bit_OM_Change := TRUE;
		end_if;
		
		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
		
		PLC_TX01_Bit_STr_Ack := FALSE;
	
	end_if;
	
	
	
else

	TP_PB_NoSelTimer(IN:= FALSE);
	
	OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
	
	OM_PLC_W1_Bit_OM_Cont			:= FALSE;
	OM_PLC_W1_Bit_OM_Finish			:= FALSE;
	OM_PLC_W1_Bit_OM_Cancel			:= FALSE;
	OM_PLC_W1_Bit_OM_Change			:= FALSE;
	
	NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	
end_if;

PLC_TX_Word3 := 0;

(* I00817 *)
PLC_TX03_Bit_STr_SD_F := Input.SD_Forward;

(* I00818 *)
PLC_TX03_Bit_STr_SD_R := Input.SD_Backward;

(* I00819 *)
PLC_TX03_Bit_STr_Rot_L := Input.SD_Left;

(* I00820 *)
PLC_TX03_Bit_STr_Rot_R := Input.SD_Right;

(* I00821 *)
PLC_TX03_Bit_STr_DD_R := Input.SD_Right;

(* I00822 *)
PLC_TX03_Bit_STr_DD_L := Input.SD_Left;


(* I00823 *)
if g_PlcComLinkUp = TRUE then
	if NDC8.SDIO.DigitalOutput12_LEFTMGS = TRUE OR NDC8.SDIO.DigitalOutput16_RIGHTMGS = TRUE then
		PLC_TX03_Bit_STr_Charge := TRUE;
	else
		PLC_TX03_Bit_STr_Charge := FALSE;
	end_if;
end_if;

(* I00824 *)
if NDC8.BlockedInfo.BlockedById <> 1 and NDC8.BlockedInfo.BlockedById <> 0 then
	PLC_TX03_Bit_STr_Block := TRUE;
else
	PLC_TX03_Bit_STr_Block := FALSE;
end_if;

(* I00825 *)
if (NDC8.CAN_IO_3.DigitalInput9_AreaF_IN1 = FALSE or NDC8.CAN_IO_3.DigitalInput10_AreaF_IN2 = FALSE) and StopObstacle = TRUE then
	PLC_TX03_Bit_STr_Ir_F := TRUE;
else
	PLC_TX03_Bit_STr_Ir_F := FALSE;
end_if;

(* I00826 *)
if (NDC8.CAN_IO_3.DigitalInput13_AreaR_IN1 = FALSE or NDC8.CAN_IO_3.DigitalInput14_AreaR_IN2 = FALSE) and StopObstacle = TRUE then
	PLC_TX03_Bit_STr_Ir_R := TRUE;
else
	PLC_TX03_Bit_STr_Ir_R := FALSE;
end_if;
 

(* I00827 *)
	PLC_TX03_Bit_STr_Brake := NDC8.SDIO.DigitalInput5_BTN_BRK;

(* I00828 *)
if NDC8.Autoinsert.StatusID = 1 then
	PLC_TX03_Bit_STr_Search := TRUE;
else
	PLC_TX03_Bit_STr_Search := FALSE;
end_if;


(* I00816 *)
if PLC_TX_Word3 <= 1 then
	PLC_TX03_Bit_STr_Idle := TRUE ;
else
	PLC_TX03_Bit_STr_Idle := FALSE;
end_if;

(* I00832 *)
if NDC8.LayoutPosition.InSystem then
	PLC_TX04_Bit_STr_Ins_dn := TRUE;
else
	PLC_TX04_Bit_STr_Ins_dn := FALSE;
end_if;

(* I00835 *)
(*PLC_TX04_Bit_Cancel_ST := IN_OPCD_Bit_Cmd_EnaEmg;*)
(*InAutoLoad Process*)

(* I00836 *)
RST_Flag := NDC8.SDIO.DigitalInput2_BTN_RST or g_RemoteReset;

RST_R(CLK := RST_Flag);

if RST_R.Q then
	RST_Keep := TRUE;
	RST_Keep_Timer(IN:= FALSE);
end_if;

if RST_Keep = TRUE then
	RST_Keep_Timer(IN:= TRUE, PT := t#5s);
end_if;

if RST_Keep_Timer.Q then
	RST_Keep := FALSE;
	RST_Keep_Timer(IN:= FALSE);
end_if;

if PLC_RX_Word20_PLC_ErrD <> 0 then
	PLC_TX04_Bit_Reset_o := RST_Keep;
else
	PLC_TX04_Bit_Reset_o := FALSE;
end_if;

g_AGV_ErrorReset := RST_Keep;


(* I00837 *)
if PLC_TX_Word13_STr_Err <> 0 then 
	PLC_TX04_Bit_AgvErr_o := TRUE;
else
	PLC_TX04_Bit_AgvErr_o := FALSE;
end_if;

(* I00838 *)

(*  
if StopWord <> 0 then
	PLC_TX04_Bit_AgvErr_o := TRUE;
	PLC_TX_Word13_STr_Err := INT_TO_WORD(DWORD_TO_INT(StopWord));
else
	PLC_TX04_Bit_AgvErr_o := FALSE;
	PLC_TX_Word13_STr_Err := 0;
	
end_if;
*)

(*I00846*)
if PLC_TX04_Bit_ChkCom_Tx <> PLC_LastHeartBeat then
	PLC_HeartBeatNoChange := false;
else
	PLC_HeartBeatNoChange := true;
end_if;

PLC_LastHeartBeat := PLC_TX04_Bit_ChkCom_Tx;

PLC_HeartBeatTimeout(IN:= PLC_HeartBeatNoChange, PT:= t#10s);

(* D507 *)
PLC_TX_Word7_STr_Vecl := DINT_TO_WORD(NDC8.Vehicle.VehicleID);

(* D508 *)
PLC_TX_Word8_STr_Seg := DINT_TO_WORD(NDC8.LayoutPosition.Segment);

(* D509 *)

if PLC_TX01_Bit_LocalMode then
	if NDC8.LocalOrder.DestPoint <> 0 then
		FinalPnt := NDC8.LocalOrder.DestPoint;
	end_if;
elsif PLC_TX01_Bit_HostMode then
	if NDC8.Automatic.DestPoint <> 0 then
		FinalPnt := NDC8.Automatic.DestPoint;
	end_if;
end_if;	

PLC_TX_Word9_STr_Pnt := DINT_TO_WORD(FinalPnt);

(* D510 *)
PLC_TX_Word10_STr_BatV := PLC_RX_Word16_BMS_BatV;

(* D511 *)
PLC_TX_Word11_STr_Temp := PLC_RX_Word17_BMS_BatT;

(* D514 *)
ConvWord := INT_TO_WORD(NDC8.OMPLC.R_BCD3);

WordL := BYTE_TO_INT(ConvByteH);
WordH := BYTE_TO_INT(ConvByteL);
TempInt := WordH * 256 + WordL;
TempWord := INT_TO_WORD(TempInt);

PLC_TX_Word14_STr_BCD3 := TempWord;

(* D515 *)
ConvWord := INT_TO_WORD(NDC8.OMPLC.R_BCD2);

WordL := BYTE_TO_INT(ConvByteH);
WordH := BYTE_TO_INT(ConvByteL);
TempInt := WordH * 256 + WordL;
TempWord := INT_TO_WORD(TempInt);

PLC_TX_Word15_STr_BCD2 := TempWord;

(* D516 *)
ConvWord := INT_TO_WORD(NDC8.OMPLC.R_BCD1);

WordL := BYTE_TO_INT(ConvByteH);
WordH := BYTE_TO_INT(ConvByteL);
TempInt := WordH * 256 + WordL;
TempWord := INT_TO_WORD(TempInt);

PLC_TX_Word16_STr_BCD1 := TempWord;
			
			
(*RX Data Proc*)
(*Set Local order mode*)
if PLC_RX03_Bit_STw_Mod_LT and not PLC_RX03_Bit_STw_Mod_NT and not PLC_RX03_Bit_STw_Mod_UT then
	NDC8.Automatic.SetOrderMode := 3;
	OrderMode();
end_if;

LocalManual := NDC8.Mcd.Button3;

LocalManual_R(CLK:= LocalManual);

if LocalManual_R.Q then
	SetToLocal := TRUE;
end_if;

if SetToLocal then
	NDC8.Automatic.SetOrderMode := 3;
	OrderMode();
	
	if NDC8.Automatic.CurrentOrderMode = 3 then
		SetToLocal := false;
	end_if;
end_if;

(*
if (PLC_RX03_Bit_STw_Mod_LT and PLC_RX03_Bit_STw_Mod_NT) then
	NDC8.Automatic.SetOrderMode := 2;
	OrderMode();
end_if;
*)
LTDelay(IN := PLC_RX03_Bit_STw_Mod_LT , PT := t#1s);
if (LTDelay.Q and PLC_RX03_Bit_STw_Mod_NT) then
	NDC8.Automatic.SetOrderMode := 2;
	OrderMode();
end_if;

(*
if PLC_RX03_Bit_STw_Mod_LT and PLC_RX03_Bit_STw_Mod_UT then
	NDC8.Automatic.SetOrderMode := 3;
	OrderMode();
	
	if OrderMode.Finished then
		PLC_TX01_Bit_STr_Mod_NT := FALSE;
		PLC_TX01_Bit_STr_Mod_UT := TRUE;
	end_if;
end_if;
*)

if NDC8.Automatic.SetOrderMode <> 1 and PLC_RX03_Bit_STw_Mod_UT then
	NDC8.Automatic.SetOrderMode := 3;
	OrderMode();
	
	if OrderMode.Finished then
		PLC_TX01_Bit_STr_Mod_NT := FALSE;
		PLC_TX01_Bit_STr_Mod_UT := TRUE;
	end_if;
end_if;

(*Set Host order mode*)
if PLC_RX03_Bit_STw_Mod_HT then
	NDC8.Automatic.SetOrderMode := 1;
	OrderMode();
end_if;


(* Set Insert Point *)
(*
if NDC8.LayoutPosition.InSystem = FALSE and PLC_RX_Word11_Ins_Pno <> 0 then
	
	NDC8.NavInit.Target := Word_To_DINT(PLC_RX_Word11_Ins_Pno);
	NavInit(Method:= 1);
	if NavInit.Finished and NavInit.ErrorCode <> 0 then
		PLC_TX04_Bit_STr_Ins_dn := TRUE;
		PLC_TX04_Bit_STr_Ins_er := FALSE;
	else
		PLC_TX04_Bit_STr_Ins_dn := FALSE;
		PLC_TX04_Bit_STr_Ins_er := TRUE;
	end_if;
end_if;
*)
(* Set Local Order Data*)

STw_NewcmdR(CLK:= PLC_RX03_Bit_STw_Newcmd);

if STw_NewcmdR.Q then
	STw_Newcmd_Flag := TRUE;
end_if;



if STw_Newcmd_Flag then
	NDC8.LocalOrder.DestPoint := Word_To_DINT(PLC_RX_Word12_STw_Pint);
	NDC8.LocalOrder.OpCode := Word_To_DINT(PLC_RX_Word5);
	PLC_TX04_Bit_STr_Cmd_dn := FALSE;
	
	LocalOrder();
	if LocalOrder.Finished then
		STw_Newcmd_Flag := FALSE;
	end_if;
end_if;

if INPUT.AutoLoadDone then 
	PLC_TX04_Bit_STr_Cmd_dn := TRUE;
else
	PLC_TX04_Bit_STr_Cmd_dn := FALSE;
end_if;

if PLC_RX03_Bit_STw_Newcmd = FALSE then
	PLC_TX04_Bit_STr_Cmd_dn := FALSE;
end_if;

(* Battery Voltage*)
if g_PlcComLinkUp = TRUE then
	Input.Display_BatteryLevel := PLC_RX_Word16_BMS_BatV;
else
	Input.Display_BatteryLevel := 0;
end_if;
 
 
BMS_BatLowSel := DINT_TO_INT(NDC8.UserDefined.Integer32_51_BattLowSel);
 
case BMS_BatLowSel of

3: 
	BMS_BatLow := PLC_RX15_Bit_BMS_ChgRqH;
2:
	BMS_BatLow := PLC_RX15_Bit_BMS_ChgRqM or PLC_RX15_Bit_BMS_ChgRqH;
1:
	BMS_BatLow := PLC_RX15_Bit_BMS_ChgRqL or PLC_RX15_Bit_BMS_ChgRqM or PLC_RX15_Bit_BMS_ChgRqH;
end_case;
BAT50LOWVOL := DINT_TO_WORD(NDC8.UserDefined.Integer32_50_BattLowVol);
if NDC8.UserDefined.Integer32_50_BattLowVol = 0 or NDC8.UserDefined.Integer32_50_BattLowVol < 0 then
	NDC8.UserDefined.Integer32_50_BattLowVol := 420;
end_if;

if PLC_RX_Word16_BMS_BatV < DINT_TO_WORD(NDC8.UserDefined.Integer32_50_BattLowVol) then
	BatLow := TRUE;
else
	BatLow:= FALSE;
end_if;

if BMS_BatLow = TRUE or BatLow = TRUE then
	INPUT.LowBattery := TRUE;
else
	INPUT.LowBattery := FALSE;
end_if;

(* Battery Temperature *)
if g_PlcComLinkUp = TRUE then
	Input.Display_Temperature := PLC_RX_Word17_BMS_BatT;
else
	Input.Display_Temperature := 0;
end_if;

(* Battery Low OT *)
if g_PlcComLinkUp = TRUE then
	g_PowerOffFlag_PLC := PLC_RX04_Bit_STw_LowOT;
end_if;







































































END_FUNCTION_BLOCK