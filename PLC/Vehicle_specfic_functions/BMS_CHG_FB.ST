FUNCTION_BLOCK BMS_CHG_FB
VAR_EXTERNAL

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR
	StepDelay : TON;

	 ChageTimer : TON;
	 AutoChargeStep : INT := 0;
	 ChargePnt : DINT := 0;
	 ChargeOuput : BOOL;
END_VAR
(* Check BMS Error *)

g_BMS_Error := PLC_RX14_Bit_BMS_Short or
				PLC_RX14_Bit_BMS_Over or
				PLC_RX14_Bit_BMS_TempEr or
				PLC_RX14_Bit_BMS_Thermi or
				PLC_RX14_Bit_BMS_CT or
				PLC_RX14_Bit_BMS_Couple or
				PLC_RX14_Bit_BMS_Bat or
				PLC_RX14_Bit_BMS_NG or
				g_ErrorCode <> 0;(*All Error Stop Charge*)

(* Check Manual Charge *)

if PLC_RX03_Bit_ChrgReqL_A = TRUE and PLC_RX03_Bit_ChrgReqR_A = FALSE and PLC_TX01_Bit_ManMode = TRUE then
	PLC_TX04_Bit_ChrgCmdR_A := FALSE;
	NDC8.SDIO.DigitalOutput12_LEFTMGS := TRUE;
	PLC_TX04_Bit_ChrgCmdL_A := TRUE;
	StopCharge := TRUE;
elsif ((PLC_RX03_Bit_ChrgReqL_A = FALSE and PLC_RX03_Bit_ChrgReqR_A = FALSE) or PLC_RX15_Bit_BMS_ChgCmp = TRUE) and PLC_TX01_Bit_ManMode = TRUE then
	NDC8.SDIO.DigitalOutput12_LEFTMGS := FALSE;
	PLC_TX04_Bit_ChrgCmdL_A := FALSE;
	StopCharge := FALSE;
end_if;

if PLC_RX03_Bit_ChrgReqR_A = TRUE and PLC_RX03_Bit_ChrgReqL_A = FALSE and PLC_TX01_Bit_ManMode = TRUE then
	PLC_TX04_Bit_ChrgCmdL_A := FALSE;
	NDC8.SDIO.DigitalOutput16_RIGHTMGS := TRUE;
	PLC_TX04_Bit_ChrgCmdR_A := TRUE;
	StopCharge := TRUE;
elsif ((PLC_RX03_Bit_ChrgReqL_A = FALSE and PLC_RX03_Bit_ChrgReqR_A = FALSE) or PLC_RX15_Bit_BMS_ChgCmp = TRUE) and PLC_TX01_Bit_ManMode = TRUE then
	PLC_TX04_Bit_ChrgCmdL_A := FALSE;
	NDC8.SDIO.DigitalOutput16_RIGHTMGS := FALSE;	
	PLC_TX04_Bit_ChrgCmdR_A := FALSE;
	StopCharge := FALSE;
end_if;

case AutoChargeStep of

	0:
		
		if (INPUT.Auto = TRUE and NDC8.Automatic.CurrentOrderMode = 1 and NDC8.Automatic.ExecDriveCommand = FALSE ) and 			
			(PLC_RX01_Bit_ChrgEmg = FALSE and g_BMS_Error = FALSE) and (NDC8.PointTrigger.Bit9_Chrg_Right = TRUE or NDC8.PointTrigger.Bit10_Chrg_Left = TRUE) and
			not (NDC8.LoadDocking.OnTarget = TRUE and PLC_RX15_Bit_BMS_NoChg = TRUE) THEN
			AutoChargeStep := 70;
			ChargePnt := NDC8.LayoutPosition.Point;
		end_if;

(* Charge the battery Host Order *)
	70:	
		
		if INPUT.Auto = FALSE or NDC8.Automatic.CurrentOrderMode <> 1 then
			AutoChargeStep := 72;
		end_if;
		
		if PLC_RX01_Bit_ChrgEmg = TRUE or g_BMS_Error = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		NDC8.PLC_Application.TxStatusBit7_ChgComp := FALSE;
		StopCharge := TRUE;
		
		(* Check Charge Idle*)
		if PLC_RX01_Bit_ChrgIdle then 
			StepDelay(IN:=TRUE, PT:=t#2s);
			if StepDelay.Q then
				StepDelay(IN:=FALSE);
				AutoChargeStep := 71;
			end_if;		
		end_if;
		
		
	71:
	
		if INPUT.Auto = FALSE or NDC8.Automatic.CurrentOrderMode <> 1 then
			AutoChargeStep := 72;
		end_if;
		
		if PLC_RX01_Bit_ChrgEmg = TRUE or g_BMS_Error = TRUE or g_ChargeOverTime = TRUE then
			AutoChargeStep := 999;
		end_if;
		IF NDC8.PointTrigger.Bit10_Chrg_Left = TRUE THEN
			PLC_TX04_Bit_ChrgCmdL_A := TRUE;
			PLC_TX04_Bit_ChrgCmdR_A := FALSE;
			NDC8.SDIO.DigitalOutput12_LEFTMGS := TRUE;
		END_IF;
		
		IF NDC8.PointTrigger.Bit9_Chrg_Right = TRUE THEN
			PLC_TX04_Bit_ChrgCmdR_A := TRUE;
			PLC_TX04_Bit_ChrgCmdL_A := FALSE;
			NDC8.SDIO.DigitalOutput16_RIGHTMGS := TRUE;
		END_IF;
		
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);


		if NDC8.PointTrigger.Bit14_Full_Chrg = TRUE then
			if (PLC_RX15_Bit_BMS_ChgCmp or PLC_RX01_Bit_ChrgEmg) then
				AutoChargeStep := 72;
			end_if;
		else
			if (NDC8.Automatic.ExecDriveCommand = TRUE or PLC_RX15_Bit_BMS_ChgCmp = TRUE or PLC_RX01_Bit_ChrgEmg) then
				AutoChargeStep := 72;
			end_if;
		end_if;
		
	72:	
		if PLC_RX01_Bit_ChrgEmg = TRUE or g_BMS_Error = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
			
		NDC8.SDIO.DigitalOutput16_RIGHTMGS := FALSE;
		
		NDC8.SDIO.DigitalOutput12_LEFTMGS := FALSE;		
		
		NDC8.PLC_Application.TxStatusBit7_ChgComp := TRUE;
        (*OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
		OM_PLC_W1_Bit_SetLowBatt := FALSE;
		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);*)
		StepDelay(IN:=TRUE, PT:=t#5s);
		if StepDelay.Q then
			StepDelay(IN:=FALSE);
			NDC8.PLC_Application.TxStatusBit7_ChgComp := FALSE;
			AutoChargeStep := 73;
		end_if;
		
	73:
		if PLC_RX01_Bit_ChrgEmg = TRUE or g_BMS_Error = TRUE then
			AutoChargeStep := 999;
		end_if;
		if PLC_RX01_Bit_ChrgIdle then 
			StepDelay(IN:=TRUE, PT:=t#1s);
			if StepDelay.Q then
				StepDelay(IN:=FALSE);
				StopCharge := FALSE;
				AutoChargeStep := 74;
			end_if;
		end_if;
		
	74:		
		if PLC_RX01_Bit_ChrgEmg = TRUE or g_BMS_Error = TRUE then
			AutoChargeStep := 999;
		end_if;
		if INPUT.Auto = FALSE or NDC8.Automatic.CurrentOrderMode <> 1 then
			AutoChargeStep := 0;
		end_if;
		if NDC8.LayoutPosition.Point <> ChargePnt or NDC8.PLC_Application.TxStatusBit4_LowBatt = TRUE then
			AutoChargeStep := 0;	
		end_if;
		
        OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
		OM_PLC_W1_Bit_SetLowBatt := FALSE;
		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);		
		
	999:
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
			
		NDC8.SDIO.DigitalOutput16_RIGHTMGS := FALSE;
		
		NDC8.SDIO.DigitalOutput12_LEFTMGS := FALSE;
		
		NDC8.PLC_Application.TxStatusBit7_ChgComp := TRUE;
	
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);

		OM_PLC_W1_Bit_SetLowBatt := FALSE;

		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	
		StopCharge := FALSE;
		
		AutoChargeStep := 0;
		
	

end_case;

(* Charge Over Time Check *)
	ChargeOuput := NDC8.SDIO.DigitalOutput16_RIGHTMGS or NDC8.SDIO.DigitalOutput12_LEFTMGS;
	ChageTimer(IN:= ChargeOuput , PT:=t#1800s);
	
	if ChageTimer.Q then
		g_ChargeOverTime := TRUE;
	end_if;
	
	if NDC8.SDIO.DigitalOutput16_RIGHTMGS = FALSE AND NDC8.SDIO.DigitalOutput12_LEFTMGS = FALSE then
		g_ChargeOverTime := FALSE;
	end_if;

	
	
(* Check BMS Error Status *)
if NDC8.SDIO.DigitalInput2_BTN_RST = FALSE and
	(PLC_RX01_Bit_ChrgEmg = TRUE
	or g_BMS_Error = TRUE
	or PLC_RX15_Bit_BMS_ChgCmp = TRUE 
	or g_ChargeOverTime) then	
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
		NDC8.SDIO.DigitalOutput12_LEFTMGS := FALSE;
		NDC8.SDIO.DigitalOutput16_RIGHTMGS := FALSE;
end_if;


if PLC_TX04_Bit_ChrgCmdL_A = TRUE OR PLC_TX04_Bit_ChrgCmdR_A then
	StopCharge := TRUE;
end_if;

(* G5 ACC70 CGERRORCNT.NPU  *)

if not NDC8.VehicleControl.Estop then
	if g_ErrorCode <> 174 then
		;
	end_if;
end_if;














END_FUNCTION_BLOCK