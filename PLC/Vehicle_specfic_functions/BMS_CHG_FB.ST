FUNCTION_BLOCK BMS_CHG_FB
VAR_EXTERNAL

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR
	StepDelay : TON;
	ManualStepDelay : TON;
	CheckChargeDoneStepDelay : TON;
	
	 ChageTimer : TON;
	 ChargeFullFlag : BOOL;
	 
	 AutoChargeStep : INT := 0;
	 ChargePnt : DINT := 0;
	 
	 FastChargeFlag : BOOL;
	 FastChargeTimer : TON;
	 FastChargeTimeOver : BOOL;
	 	 
END_VAR
(* Check Manual Charge *)

if PLC_RX03_Bit_ChrgReqL_A = TRUE and PLC_TX01_Bit_ManMode = TRUE and PLC_RX03_Bit_Charging_L = FALSE then
	NDC8.SDIO.DigitalOutput16_Charger := TRUE;
	PLC_TX01_Bit_ChrgSelL_A := TRUE;
	StopCharge := TRUE;
	
	
	(* Full Charge Point check *)
	if NDC8.PointTrigger.Bit14_Full_Chrg = FALSE then
		PLC_TX01_Bit_TRChg_Pnt := TRUE;
	else
		PLC_TX01_Bit_TRChg_Pnt := FALSE;
	end_if;
	
	g_BattLim_NG := FALSE;
	INPUT.LowBattery := FALSE;
	NDC8.Userdefined.LowBatSim := FALSE;
	OM_PLC_W1_Bit_SetLowBatt := FALSE;
	
	ManualStepDelay(IN := TRUE, PT := t#1s);
	
	if ManualStepDelay.Q Then
		PLC_TX04_Bit_ChrgCmdL_A := TRUE;
		ManualStepDelay(IN := FALSE);
	end_if;
		
elsif PLC_RX03_Bit_ChrgReqR_A = TRUE and PLC_TX01_Bit_ManMode = TRUE and PLC_RX03_Bit_Charging_R = FALSE then
	NDC8.SDIO.DigitalOutput16_Charger := TRUE;
	PLC_TX01_Bit_ChrgSelR_A := TRUE;
	StopCharge := TRUE;
	
	(* Full Charge Point check *)
	if NDC8.PointTrigger.Bit14_Full_Chrg = FALSE then
		PLC_TX01_Bit_TRChg_Pnt := TRUE;
	else
		PLC_TX01_Bit_TRChg_Pnt := FALSE;
	end_if;
	
	g_BattLim_NG := FALSE;
	INPUT.LowBattery := FALSE;
	NDC8.Userdefined.LowBatSim := FALSE;
	OM_PLC_W1_Bit_SetLowBatt := FALSE;
	
	ManualStepDelay(IN := TRUE, PT := t#1s);
	
	if ManualStepDelay.Q Then
		PLC_TX04_Bit_ChrgCmdR_A := TRUE;
		ManualStepDelay(IN := FALSE);
	end_if;
		
elsif (PLC_RX03_Bit_ChrgReqL_A = FALSE and PLC_RX03_Bit_ChrgReqR_A = FALSE) and PLC_TX01_Bit_ManMode = TRUE then
	NDC8.SDIO.DigitalOutput16_Charger := FALSE;

	PLC_TX04_Bit_ChrgCmdL_A := FALSE;
	PLC_TX04_Bit_ChrgCmdR_A := FALSE;
	
	PLC_TX01_Bit_TRChg_Pnt := FALSE;
	
	ManualStepDelay(IN := TRUE, PT := t#1s);
	
	if ManualStepDelay.Q Then
		PLC_TX01_Bit_ChrgSelL_A := FALSE;
		PLC_TX01_Bit_ChrgSelR_A := FALSE;
		StopCharge := FALSE;
		ManualStepDelay(IN := FALSE);
		INPUT.LowBattery := FALSE;
	end_if;
	
end_if;


case AutoChargeStep of

	0:
		
		if (INPUT.Auto = TRUE and NDC8.Automatic.ExecDriveCommand = FALSE ) and 
			((NDC8.PointTrigger.Bit9_Chrg_Right = TRUE and NDC8.PointTrigger.Bit10_Chrg_Left = FALSE) or (NDC8.PointTrigger.Bit9_Chrg_Right = FALSE and NDC8.PointTrigger.Bit10_Chrg_Left = TRUE)) and
			(PLC_RX01_Bit_ChrgEmg = FALSE) then
			AutoChargeStep := 70;
			g_ChargeDone := FALSE;
			ChargePnt := NDC8.LayoutPosition.Point;
		end_if;
		
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		OM_PLC_W9_Bit_ChgP_Err := FALSE;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
(* Charge the battery Host Order *)
	70:	
	
		if NDC8.PointTrigger.Bit9_Chrg_Right = TRUE and NDC8.PointTrigger.Bit10_Chrg_Left = FALSE then
			PLC_TX01_Bit_ChrgSelR_A := TRUE;
		elsif NDC8.PointTrigger.Bit9_Chrg_Right = FALSE and NDC8.PointTrigger.Bit10_Chrg_Left = TRUE then
			PLC_TX01_Bit_ChrgSelL_A := TRUE;
		end_if;
		
		(* Full Charge Point check *)
		if NDC8.PointTrigger.Bit14_Full_Chrg = FALSE then
			PLC_TX01_Bit_TRChg_Pnt := TRUE;
		else
			PLC_TX01_Bit_TRChg_Pnt := FALSE;
		end_if;
		
		
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		OM_PLC_W9_Bit_ChgP_Err := FALSE;
		
		
		if NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then
			AutoChargeStep := 999;
		elsif PLC_RX01_Bit_ChrgEmg = TRUE then
			AutoChargeStep := 999;
		elsif PLC_RX03_Bit_Round_ChgP = TRUE then
			OM_PLC_W9_Bit_ChgP_Err := TRUE;
			AutoChargeStep := 72;
		elsif PLC_RX01_Bit_ChrgBrk = TRUE then
			AutoChargeStep := 72;
		elsif INPUT.Auto = FALSE then
			AutoChargeStep := 72;
		end_if;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
		StopCharge := TRUE;
		
		
		
		(* Check Charge Idle*)
		if PLC_RX03_Bit_CP_HP = TRUE then
			StepDelay(IN:=TRUE, PT:=t#2s);
			if StepDelay.Q then
				StepDelay(IN:=FALSE);
				AutoChargeStep := 71;
			end_if;
		
		end_if;
		
		
	71:
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		
		OM_PLC_W9_Bit_ChgP_Err := FALSE;
		
		if NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then
			AutoChargeStep := 999;
		elsif PLC_RX01_Bit_ChrgEmg = TRUE then
			AutoChargeStep := 999;
		elsif PLC_RX03_Bit_Round_ChgP = TRUE then
			OM_PLC_W9_Bit_ChgP_Err := TRUE;
			AutoChargeStep := 72;
		elsif PLC_RX01_Bit_ChrgBrk = TRUE then
			AutoChargeStep := 72;
		elsif INPUT.Auto = FALSE then
			AutoChargeStep := 72;
		end_if;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
		PLC_TX04_Bit_ChrgCmdL_A := NDC8.PointTrigger.Bit10_Chrg_Left;
		PLC_TX04_Bit_ChrgCmdR_A := NDC8.PointTrigger.Bit9_Chrg_Right;
		
		NDC8.SDIO.DigitalOutput16_Charger := TRUE;
		
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
		
		
		g_BattLim_NG := FALSE;
		INPUT.LowBattery := FALSE;
		NDC8.Userdefined.LowBatSim := FALSE;
		OM_PLC_W1_Bit_SetLowBatt := FALSE;
		

		if NDC8.PointTrigger.Bit14_Full_Chrg = TRUE then
			if (g_ChargeDone or PLC_RX01_Bit_ChrgEmg) then
				AutoChargeStep := 72;
			end_if;
		else
			if (NDC8.Automatic.ExecDriveCommand = TRUE or PLC_RX01_Bit_ChrgEmg) or g_ChargeDone or FastChargeTimeOver then
				AutoChargeStep := 72;
			end_if;
		end_if;
		
	72:
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
		if PLC_RX01_Bit_ChrgEmg = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		if NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
		
			
		NDC8.SDIO.DigitalOutput16_Charger := FALSE;
	
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);

		OM_PLC_W1_Bit_SetLowBatt := FALSE;

		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	
		StepDelay(IN:=TRUE, PT:=t#5s);
		if StepDelay.Q then
			StepDelay(IN:=FALSE);
			AutoChargeStep := 73;
		end_if;
		
	73:
		
		PLC_TX01_Bit_ChrgSelL_A := FALSE;
		PLC_TX01_Bit_ChrgSelR_A := FALSE;
		
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
	
		if PLC_RX01_Bit_ChrgEmg = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		if NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		if PLC_RX03_Bit_CP_HP then 
			StepDelay(IN:=TRUE, PT:=t#1s);
			if StepDelay.Q then
				StepDelay(IN:=FALSE);
				StopCharge := FALSE;
				AutoChargeStep := 74;
			end_if;
		end_if;
		
	74:
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
		if PLC_RX01_Bit_ChrgEmg = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		if NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then
			AutoChargeStep := 999;
		end_if;
		
		if INPUT.Auto = FALSE then
			AutoChargeStep := 0;
		end_if;
		
		if NDC8.LayoutPosition.Point <> ChargePnt or NDC8.PLC_Application.TxStatusBit4_LowBatt = TRUE then
			AutoChargeStep := 0;
		end_if;
		
		
	999:
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
		
		PLC_TX01_Bit_TRChg_Pnt := FALSE;
		
		StepDelay(IN:=TRUE, PT:=t#1s);
		if StepDelay.Q then
			StepDelay(IN:=FALSE);
			PLC_TX01_Bit_ChrgSelL_A := FALSE;
			PLC_TX01_Bit_ChrgSelR_A := FALSE;
			AutoChargeStep := 0;
			INPUT.LowBattery := FALSE;
		end_if;
		
			
		NDC8.SDIO.DigitalOutput16_Charger := FALSE;
	
		OM_PLC_Word1 := INT_TO_WORD(NDC8.OMPLC.ChargeOM);

		OM_PLC_W1_Bit_SetLowBatt := FALSE;

		NDC8.OMPLC.ChargeOM := WORD_TO_INT(OM_PLC_Word1);
	
		StopCharge := FALSE;
		

end_case;

(* Charge Complete Check *)
if (NDC8.PointTrigger.Bit9_Chrg_Right = TRUE or NDC8.PointTrigger.Bit10_Chrg_Left = TRUE) or PLC_TX01_Bit_ManMode = TRUE then 
	if(NDC8.CAN_IO_3.DigitalInput5_BatTmp25_i = TRUE and 
		NDC8.CAN_IO_3.DigitalInput6_BatTmp40_i = TRUE and
		NDC8.CAN_IO_3.DigitalInput7_BatTmp55_i = TRUE and 
		g_BatteryVoltage >= NDC8.UserDefined.Integer32_40_ChgComV1) then
		g_ChargeDone := TRUE;
		g_ChargeTempErr := FALSE;
	elsif (NDC8.CAN_IO_3.DigitalInput5_BatTmp25_i = FALSE and 
		NDC8.CAN_IO_3.DigitalInput6_BatTmp40_i = TRUE and
		NDC8.CAN_IO_3.DigitalInput7_BatTmp55_i = TRUE and 
		g_BatteryVoltage >= NDC8.UserDefined.Integer32_41_ChgComV2) then
		g_ChargeDone := TRUE;
		g_ChargeTempErr := FALSE;
	elsif (NDC8.CAN_IO_3.DigitalInput5_BatTmp25_i = FALSE and 
		NDC8.CAN_IO_3.DigitalInput6_BatTmp40_i = FALSE and
		NDC8.CAN_IO_3.DigitalInput7_BatTmp55_i = TRUE and 
		g_BatteryVoltage >= NDC8.UserDefined.Integer32_42_ChgComV3) then
		g_ChargeDone := TRUE;
		g_ChargeTempErr := FALSE;
	elsif (NDC8.CAN_IO_3.DigitalInput5_BatTmp25_i = FALSE and 
		NDC8.CAN_IO_3.DigitalInput6_BatTmp40_i = FALSE and
		NDC8.CAN_IO_3.DigitalInput7_BatTmp55_i = FALSE) then
		g_ChargeDone := FALSE;
		g_ChargeTempErr := TRUE;
	else
		g_ChargeDone := FALSE;
		g_ChargeTempErr := FALSE;
	end_if;
	
elsif (NDC8.CAN_IO_3.DigitalInput5_BatTmp25_i = FALSE and 
		NDC8.CAN_IO_3.DigitalInput6_BatTmp40_i = FALSE and
		NDC8.CAN_IO_3.DigitalInput7_BatTmp55_i = FALSE) then

	g_ChargeDone := FALSE;
	g_ChargeTempErr := TRUE;	
else
	g_ChargeDone := FALSE;
	g_ChargeTempErr := FALSE;
end_if;
		

(* Charge Over Time Check *)

	ChargeFullFlag  := NDC8.SDIO.DigitalOutput16_Charger = TRUE and NDC8.PointTrigger.Bit14_Full_Chrg = TRUE;
	
	ChageTimer(IN:= ChargeFullFlag, PT:=t#1800s);
	
	if ChageTimer.Q then
		g_ChargeOverTime := TRUE;
	end_if;
	
	if ChargeFullFlag = FALSE then
		g_ChargeOverTime := FALSE;
	end_if;
	
(* Fast Charge Time Check *)

	FastChargeFlag := NDC8.SDIO.DigitalOutput16_Charger = TRUE and NDC8.PointTrigger.Bit14_Full_Chrg = FALSE;
	
	FastChargeTimer(IN:= FastChargeFlag, PT:=t#600s);
	
	
	if FastChargeTimer.Q then
		FastChargeTimeOver := TRUE;
	end_if;
	
	if FastChargeFlag = FALSE then
		FastChargeTimeOver := FALSE;
	end_if;
	
(* Check BMS Error Status *)
if NDC8.SDIO.DigitalInput2_BTN_RST = FALSE and
	(PLC_RX01_Bit_ChrgEmg = TRUE
	or g_ChargeDone = TRUE 
	or g_ChargeOverTime = TRUE
	or g_ChargeTempErr = TRUE) then
	
		PLC_TX04_Bit_ChrgCmdL_A := FALSE;
		PLC_TX04_Bit_ChrgCmdR_A := FALSE;
	
		NDC8.SDIO.DigitalOutput16_Charger := FALSE;
		
		CheckChargeDoneStepDelay(IN := TRUE, PT := t#1s);
		
		if CheckChargeDoneStepDelay.Q then
			CheckChargeDoneStepDelay(IN := FALSE);
			PLC_TX01_Bit_ChrgSelL_A := FALSE;
			PLC_TX01_Bit_ChrgSelR_A := FALSE;
		end_if;
		
		
end_if;


(* Let Vehicle Stop *)
if PLC_TX04_Bit_ChrgCmdL_A = TRUE or PLC_TX04_Bit_ChrgCmdR_A = TRUE or 
	PLC_RX03_Bit_CP_HP = FALSE or 
	AutoChargeStep = 70 or AutoChargeStep = 71 or AutoChargeStep = 72 or AutoChargeStep = 73 then
	StopCharge := TRUE;
end_if;




















END_FUNCTION_BLOCK