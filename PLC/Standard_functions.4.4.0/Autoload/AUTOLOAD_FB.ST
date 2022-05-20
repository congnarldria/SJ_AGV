FUNCTION_BLOCK AUTOLOAD_FB
VAR_EXTERNAL   
	(* IN *)    
	NDC8: NDC8_T;  
END_VAR  

VAR_INPUT
	ForkMoving	: bool;
	ForkTarget	: bool;
END_VAR

VAR    
	(* ADJ ERR Code *)
	ADJ_ErrCode : DINT;
	
	(* BCD Process *)
	BCDProcState : dint;
	BCDRetryTimes : int := 5;
	BCDReCompTimes : int := 5;
	BCDReadTimes : int;
	BCDCompTimes : int;
	
	TempBCD1_Int : Int;
	TempBCD1 : Word;
	

	(* Load/Unload Process *)
	LoadOpDone : LoadOpDone_FB;
	OperationFail : OperationFail_FB;

	AutoLoadFailCodes : AutoLoadFailCodes_T;
	OperationCode	: word;
	
	AutoLoadMainState : dint;
	
	BbxTrig_FT : F_trig;
	ExecDriveCommand_RT : R_Trig;
	FailTimerTON : TON;

	PreviousMainState,
	PreviousLoadState,
	PreviousUnLoadState,
	PreviousTravelDir,
	PreviousFailCode,
	PreviousForkHeight,
	FailCodeDint : dint;

	PreviousExecDriveCommand,
	PreviousCancelOperation,
	bbxtrigger			:bool;
	
	
	StepDelay : TON;
	BCDStepDelay : TON;
	
	TempErrorCode : DINT;
	
	BCD_ReadReq : BOOL;
	
	
	DebugBCD_1000_F : BOOL := FALSE;
	DebugBCD_1000_B : BOOL := FALSE;
	
	
	Debug_1000_F : BOOL := FALSE;
	Debug_1000_B : BOOL:= FALSE;
	Debug_2000_F : BOOL:= FALSE;
	Debug_2000_B : BOOL:= FALSE;
		
	CancelFlag : BOOL;
	
	ChargeDelay : TON;
END_VAR


VAR_OUTPUT
	StartLoad : bool;
	StartUnload : bool;
	StartCharge	: bool;
	Fail : bool;
END_VAR
(*
------------------------------------------------------------------------------------                              
 AUTOLOAD_SD                    
 -----------          
                

 Description:                     
 Handles load operations. Output is 'Fork height'.
 If there is a cancel, LoadOpDone will be sent to the host with a failcode.
 
-------------------------------------------------------------------------------------*)


(* Set up variables to be used from NDC8 sources *)
OperationCode 		:= dint_to_word(NDC8.LoadOperation.OperationCode);				(* Value is decimal in vehicle, but hex in Layout designer! *)



if (NDC8.Automatic.CurrentOrderMode = 2 or NDC8.Automatic.CurrentOrderMode = 3) and AutoloadMainState <> 2000 then (*in Local mode Operation code need to calcuate for PLC*)
		IN_OPCD_Bit_LT_Ang0		:= word_to_bool(OperationCode and 1);
		IN_OPCD_Bit_LT_Ang90	:= word_to_bool(OperationCode and 2);
		IN_OPCD_Bit_LT_Ang180	:= word_to_bool(OperationCode and 8);
		IN_OPCD_Bit_LT_AngN90	:= word_to_bool(OperationCode and 4);

		IN_OPCD_Bit_LT_Right	:= word_to_bool(OperationCode and 16);
		IN_OPCD_Bit_LT_Left		:= word_to_bool(OperationCode and 32);

		IN_OPCD_Bit_LT_Load 	:= word_to_bool(OperationCode and 256);
		IN_OPCD_Bit_LT_Unload	:= word_to_bool(OperationCode and 512);	
		
		IN_OPCD_Bit_LT_PowOff	:= word_to_bool(OperationCode and 1024);
		IN_OPCD_Bit_LT_Charge	:= word_to_bool(OperationCode and 4096);			
			
elsif NDC8.Automatic.CurrentOrderMode = 1 and AutoloadMainState <> 2000 then (*in Host mode Operation code need to calcuate for PLC*)
		IN_OPCD_Bit_LT_Ang0		:= word_to_bool(OperationCode and 16);
		IN_OPCD_Bit_LT_Ang90	:= word_to_bool(OperationCode and 32);
		IN_OPCD_Bit_LT_Ang180	:= word_to_bool(OperationCode and 64);
		IN_OPCD_Bit_LT_AngN90	:= word_to_bool(OperationCode and 128);

		IN_OPCD_Bit_LT_Right	:= word_to_bool(OperationCode and 1);
		IN_OPCD_Bit_LT_Left		:= word_to_bool(OperationCode and 2);

		IN_OPCD_Bit_LT_Load 	:= word_to_bool(OperationCode and 4096);
		IN_OPCD_Bit_LT_Unload	:= word_to_bool(OperationCode and 8192);
		
		IN_OPCD_Bit_Cmd_EnaEmg	:= word_to_bool(OperationCode and 256);
		
		IN_OPCD_Bit_LT_PowOff	:= word_to_bool(OperationCode and 16384);
		
		IN_OPCD_Bit_LT_Charge	:= word_to_bool(OperationCode and 32768);
		
else
		OperationCode := 0;
		InProc_OperationCode := 0;
end_if;

(* BCD Process *)
if NDC8.Automatic.CurrentOrderMode = 1 and PLC_RX01_Bit_Load_i = TRUE then

	case BCDProcState of 
	0: (* Check BCD Req *)
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
		
		BCDReadTimes := 0;
		BCDCompTimes := 0;
		
		if BCD_ReadReq = TRUE and OM_PLC_W2_Bit_BCD_NoRead = FALSE then
			BCDProcState := 1;
		elsif BCD_ReadReq = TRUE and OM_PLC_W2_Bit_BCD_NoRead = TRUE then
			BCD_ReadReq := FALSE;
		elsif OM_PLC_W2_Bit_BCD_NoRead = TRUE then
			BCDProcState := 0;
		elsif OM_PLC_W2_Bit_BCD_Init = TRUE and OM_PLC_W2_Bit_BCD_NoRead = FALSE then
			BCDProcState := 1;
		elsif OM_PLC_W2_Bit_BCD_setReq = TRUE and OM_PLC_W2_Bit_BCD_NoRead = FALSE then
			BCDProcState := 1;
		end_if;
	
		NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
		
	1: (*Clear BCD Req*)
		StopByBCD := TRUE;
		PLC_TX04_Bit_BCD_Clr := true;
		PLC_TX04_Bit_BCD_Req := false;
	
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			OM_PLC_W2_Bit_BCD_setOK := FALSE;
			OM_PLC_W2_Bit_Set_Result := FALSE;
			OM_PLC_W2_Bit_Err_Comp := FALSE;
			OM_PLC_W2_Bit_Err_BCR := FALSE;
		NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);

		if	not PLC_RX06_Bit_BCD_OK
			and not PLC_RX06_Bit_NoRead_NG
			and not PLC_RX06_Bit_BCRHard_NG
			and not PLC_RX06_Bit_BCRData_NG
			and not PLC_RX06_Bit_BCRInit_NG
			and not PLC_RX06_Bit_BCRComm_NG then
		
			BCDProcState := 2;
		end_if;
	
	
	2: (*Set BCD Req*)
		PLC_TX04_Bit_BCD_Clr := false;
		PLC_TX04_Bit_BCD_Req := true;

		BCDReadTimes := BCDReadTimes + 1;
	
		if PLC_RX06_Bit_BCD_OK 
			and not PLC_RX06_Bit_NoRead_NG
			and not PLC_RX06_Bit_BCRHard_NG
			and not PLC_RX06_Bit_BCRData_NG
			and not PLC_RX06_Bit_BCRInit_NG
			and not PLC_RX06_Bit_BCRComm_NG then
			
			BCDReadTimes := 0;
			
			BCDProcState := 3;
		
		elsif 	PLC_RX06_Bit_NoRead_NG
				or PLC_RX06_Bit_BCRHard_NG
				or PLC_RX06_Bit_BCRData_NG
				or PLC_RX06_Bit_BCRInit_NG
				or PLC_RX06_Bit_BCRComm_NG then
			
			if BCDReadTimes >= BCDRetryTimes then
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
					OM_PLC_W2_Bit_Err_BCR := TRUE;
					OM_PLC_W2_Bit_Set_Result := TRUE;
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				BCDProcState := 1000;
			else
				BCDProcState := 1;
			end_if;
		end_if;
	
	
	
	3: (*BCD Compare*)
		BCDCompTimes := BCDCompTimes + 1;
		
		if 	PLC_TX_Word14_STr_BCD3 = PLC_RX_Word7_STw_BCD3
			and PLC_TX_Word15_STr_BCD2 = PLC_RX_Word8_STw_BCD2
			and PLC_TX_Word16_STr_BCD1 = PLC_RX_Word9_STw_BCD1 then
			BCDProcState := 4; (* Compare Complete *)
			BCDCompTimes := 0;
		elsif PLC_RX06_Bit_CompDisabl = true then
			BCDProcState := 4; (* Compare Complete *)
			BCDCompTimes := 0;
		else
		
			if BCDCompTimes >= BCDReCompTimes then
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
					OM_PLC_W2_Bit_Err_Comp := TRUE;
					OM_PLC_W2_Bit_Set_Result := TRUE;
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				BCDProcState := 1000;
			else
				BCDProcState := 1;
			end_if;
		
		end_if;
		
	
	4:
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			OM_PLC_W2_Bit_BCD_setOK := TRUE;
			OM_PLC_W2_Bit_Set_Result := TRUE;
		NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
		BCDProcState := 1000;

		
	1000: (*Reset*)
	
		if DebugBCD_1000_F = FALSE then
			if DebugBCD_1000_B = FALSE then
				BCDProcState := 0;
			end_if;
			BCDReadTimes := 0;
			BCDCompTimes := 0;
	
			BCD_ReadReq := FALSE;
			StopByBCD := FALSE;
			BCDStepDelay(IN:= FALSE);
		
			OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
				OM_PLC_W2_Bit_BCD_setReq := FALSE;
				OM_PLC_W2_Bit_BCD_Init := FALSE;
			NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
		end_if;
		
	end_case;
end_if;

		
Case AutoloadMainState of


(**** Wait for AutoLoad Start Flag - Operation Code > 0 ****)
	0: 
	
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);

		PLC_TX_Word2 := 0;
		
		PLC_TX02_Bit_STr_DepoST := FALSE;
		PLC_TX04_Bit_Cancel_ST := FALSE;
		PLC_TX01_Bit_Cancel_ST2 := FALSE;
		StepDelay(IN := FALSE);
		if g_ErrorCode = 0 and PLC_RX01_Bit_EnableLD_i = TRUE then
			if OperationCode > 0 then
				AutoloadMainState := 10;
			elsif NDC8.LocalOrder.OrderEN then
				AutoloadMainState := 10;
			end_if;
		end_if;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);

(**** Load operations ****)
	10: 
		BCD_ReadReq := FALSE;
		INPUT.AutoLoadDone := FALSE;
		if 	IN_OPCD_Bit_LT_Load then	(* Load *)
			AutoloadMainState := 20;
		elsif 	IN_OPCD_Bit_LT_Unload then	(* Unload *)
			AutoloadMainState := 30;		
		elsif 	IN_OPCD_Bit_LT_Charge then	(* Charge battery *)
			AutoloadMainState := 40;
		elsif	IN_OPCD_Bit_LT_PowOff then	(* Power off *)		
			AutoloadMainState := 50;
		elsif NDC8.LocalOrder.OpCode = 0 then
			AutoloadMainState := 60;		(* Move no OP Code *)
		end_if;
		

(* Pick up load *)
	20:	(*Check Vehicle on Target Station*)
			
		ADJ_ErrCode := 0;
		
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
			OM_PLC_W2_Bit_SetOpCanc := FALSE;
			OM_PLC_W2_Bit_SetCondErr := FALSE;
			
					
		NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
		
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);

			OM_PLC_W9_Bit_Adj_Err := FALSE;
			OM_PLC_W9_Bit_ChgP_Err := FALSE;
			OM_PLC_W9_Bit_Enable_Err := FALSE;

		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
					
					
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			StartLoad := true;
			if NDC8.LoadDocking.OnTarget = TRUE and PLC_RX01_Bit_EnableLD_i = TRUE then
				AutoloadMainState := 21;
			elsif NDC8.LoadDocking.OnTarget = TRUE and PLC_RX01_Bit_EnableLD_i = FALSE then
				AutoloadMainState := 148;
			elsif PLC_RX01_Bit_Load_i = true then
				AutoloadMainState := 148;
			elsif InProc_OperationCode = 0 then
				AutoloadMainState := 145;
			end_if;
		end_if;
		
	21:(*Check Robot Load status*)	
		StopLoadOP := TRUE;
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			if PLC_RX01_Bit_Load_i = true then
				AutoloadMainState := 148;
			elsif NDC8.SDIO.DigitalInput12_EMO = FALSE then
				AutoloadMainState := 133;
			else
				AutoloadMainState := 22;
			end_if;
		end_if;
		
	22:(*Set OpCode to PLC*)
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		elsif PLC_RX01_Bit_Load_i = true then
				AutoloadMainState := 148;
		else
			PLC_TX02_Bit_STr_Ang0	:= IN_OPCD_Bit_LT_Ang0;
			PLC_TX02_Bit_STr_Ang90	:= IN_OPCD_Bit_LT_Ang90;
			PLC_TX02_Bit_STr_Ang180	:= IN_OPCD_Bit_LT_Ang180;
			PLC_TX02_Bit_STr_AngN90	:= IN_OPCD_Bit_LT_AngN90;

			PLC_TX02_Bit_STr_Right	:= IN_OPCD_Bit_LT_Right;
			PLC_TX02_Bit_STr_Left	:= IN_OPCD_Bit_LT_Left;

			PLC_TX02_Bit_STr_Load 	:= IN_OPCD_Bit_LT_Load;
			PLC_TX02_Bit_STr_Unload	:= IN_OPCD_Bit_LT_Unload;
		
			PLC_TX02_Bit_STr_DepoST := NDC8.PointTrigger.Bit0_DepoST_Att;
			PLC_TX04_Bit_Cancel_ST := not IN_OPCD_Bit_Cmd_EnaEmg;
			PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err;
		
			if (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_Ang90 = TRUE)
				or (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_Ang180 = TRUE) 
				or (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE) 
				or (PLC_TX02_Bit_STr_Ang90 = TRUE and PLC_TX02_Bit_STr_Ang180 = TRUE)
				or (PLC_TX02_Bit_STr_Ang90 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE)
				or (PLC_TX02_Bit_STr_Ang180 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE)
				or (PLC_TX02_Bit_STr_Right = TRUE and PLC_TX02_Bit_STr_Left = TRUE)
				or (PLC_TX02_Bit_STr_Load = TRUE and PLC_TX02_Bit_STr_Unload = TRUE) then
			
				if NDC8.Automatic.CurrentOrderMode = 1 then
					AutoloadMainState := 150;
				elsif NDC8.Automatic.CurrentOrderMode = 2 or NDC8.Automatic.CurrentOrderMode = 3 then
					AutoloadMainState := 152;
				end_if;
				
			elsif 	PLC_TX02_Bit_STr_Ang0 = FALSE 
					and PLC_TX02_Bit_STr_Ang90 = FALSE
					and PLC_TX02_Bit_STr_Ang180 = FALSE
					and PLC_TX02_Bit_STr_AngN90 = FALSE then
					AutoloadMainState := 145;
				
			elsif	PLC_TX02_Bit_STr_Right = FALSE 
					and PLC_TX02_Bit_STr_Left = FALSE then
					AutoloadMainState := 145;
				
			elsif	PLC_TX02_Bit_STr_Load = FALSE 
					and PLC_TX02_Bit_STr_Unload = FALSE then
					AutoloadMainState := 145;
			
			else
				AutoloadMainState := 23;
			end_if;
		end_if;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
	23:(*Wait PLC Processing*)
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			if INPUT.Auto = FALSE then
				AutoloadMainState := 998;
			elsif NDC8.SDIO.DigitalInput12_EMO = FALSE then
				AutoloadMainState := 133;
			elsif PLC_RX01_Bit_LDErr_i then 
				AutoloadMainState := 148;
			elsif PLC_RX01_Bit_LD_Canc_i = TRUE then
				
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
				OM_PLC_W2_Bit_SetOpCanc := TRUE;
				AutoloadMainState := 930;
			
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				
			elsif PLC_RX01_Bit_LD_Cond_i = true then (* Interlock (8I/8O) Proc *)
			
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
				OM_PLC_W2_Bit_SetCondErr := TRUE;
				AutoloadMainState := 900;
			
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				
			elsif PLC_RX_Word10_Round <> 0 then
			
				OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
			
				OM_PLC_W9_Bit_Adj_Err := TRUE;
				
				if PLC_RX10_Bit_Round_Y1 = TRUE then
					ADJ_ErrCode := 251;
				elsif PLC_RX10_Bit_Round_Y2 = TRUE then
					ADJ_ErrCode := 252;
				elsif PLC_RX10_Bit_Round_X = TRUE then
					ADJ_ErrCode := 253;
				elsif PLC_RX10_Bit_Round_RT = TRUE then
					ADJ_ErrCode := 254;
				elsif PLC_RX10_Bit_Round_FK = TRUE then
					ADJ_ErrCode := 255;
				elsif PLC_RX10_Bit_Round_Y = TRUE then
					ADJ_ErrCode := 256;
				elsif PLC_RX10_Bit_Round_RT2 = TRUE then
					ADJ_ErrCode := 221;
				end_if;
				
				AutoloadMainState := 910;
			
			NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
			
			elsif PLC_RX03_Bit_Round_ChgP = true then
			
				OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
			
				OM_PLC_W9_Bit_ChgP_Err := TRUE;
				AutoloadMainState := 920;
			
				NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
			
			elsif PLC_RX01_Bit_LDDone_i then 
			
				if PLC_RX01_Bit_Load_i = TRUE then
					PLC_TX_Word2 := 0;
					PLC_TX02_Bit_STr_DepoST := FALSE;
					PLC_TX04_Bit_Cancel_ST := FALSE;
					PLC_TX01_Bit_Cancel_ST2 := FALSE;
					StopByBCD := TRUE;
					BCD_ReadReq := TRUE;
				
					AutoloadMainState := 1000;
				else
					AutoloadMainState := 147;
				end_if;
			end_if;
		end_if;
		
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
(* Drop off load *)
	30:	(*Check Vehicle on Target Station*)
	
		ADJ_ErrCode := 0;
		
		OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
			OM_PLC_W2_Bit_SetOpCanc := FALSE;
			OM_PLC_W2_Bit_SetCondErr := FALSE;
			
					
		NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
					
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);

			OM_PLC_W9_Bit_Adj_Err := FALSE;
			OM_PLC_W9_Bit_ChgP_Err := FALSE;
			OM_PLC_W9_Bit_Enable_Err := FALSE;

		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
					
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			StartUnload := true;
	
			if NDC8.LoadDocking.OnTarget = TRUE and PLC_RX01_Bit_EnableLD_i = TRUE then
				AutoloadMainState := 31;
			elsif NDC8.LoadDocking.OnTarget = TRUE and PLC_RX01_Bit_EnableLD_i = FALSE then
				AutoloadMainState := 149;
			elsif PLC_RX01_Bit_Load_i = false then
				AutoloadMainState := 149;
			elsif InProc_OperationCode = 0 then
				AutoloadMainState := 145;
			end_if;
		end_if;
		
	31:(*Check Robot Load status*)
		StopLoadOP := TRUE;
		
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			if PLC_RX01_Bit_Load_i = false then
				AutoloadMainState := 149;
			elsif NDC8.SDIO.DigitalInput12_EMO = FALSE then
				AutoloadMainState := 133;
			elsif PLC_RX01_Bit_Load_i = false then
				AutoloadMainState := 149;
			else
				AutoloadMainState := 32;
			end_if;
		end_if;
		
	32: (*Set OpCode to PLC*)
		
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
		
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		elsif PLC_RX01_Bit_Load_i = false then
				AutoloadMainState := 149;
		else
			PLC_TX02_Bit_STr_Ang0	:= IN_OPCD_Bit_LT_Ang0;
			PLC_TX02_Bit_STr_Ang90	:= IN_OPCD_Bit_LT_Ang90;
			PLC_TX02_Bit_STr_Ang180	:= IN_OPCD_Bit_LT_Ang180;
			PLC_TX02_Bit_STr_AngN90	:= IN_OPCD_Bit_LT_AngN90;

			PLC_TX02_Bit_STr_Right	:= IN_OPCD_Bit_LT_Right;
			PLC_TX02_Bit_STr_Left	:= IN_OPCD_Bit_LT_Left;

			PLC_TX02_Bit_STr_Load 	:= IN_OPCD_Bit_LT_Load;
			PLC_TX02_Bit_STr_Unload	:= IN_OPCD_Bit_LT_Unload;
		
			PLC_TX02_Bit_STr_DepoST := NDC8.PointTrigger.Bit0_DepoST_Att;
		
			PLC_TX04_Bit_Cancel_ST := not IN_OPCD_Bit_Cmd_EnaEmg;
			
			PLC_TX01_Bit_Cancel_ST2 := not OM_PLC_W9_Bit_Enable_Err ;
		
			if (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_Ang90 = TRUE)
				or (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_Ang180 = TRUE) 
				or (PLC_TX02_Bit_STr_Ang0 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE) 
				or (PLC_TX02_Bit_STr_Ang90 = TRUE and PLC_TX02_Bit_STr_Ang180 = TRUE)
				or (PLC_TX02_Bit_STr_Ang90 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE)
				or (PLC_TX02_Bit_STr_Ang180 = TRUE and PLC_TX02_Bit_STr_AngN90 = TRUE)
				or (PLC_TX02_Bit_STr_Right = TRUE and PLC_TX02_Bit_STr_Left = TRUE)
				or (PLC_TX02_Bit_STr_Load = TRUE and PLC_TX02_Bit_STr_Unload = TRUE) then
			
				if NDC8.Automatic.CurrentOrderMode = 1 then
					AutoloadMainState := 150;
				elsif NDC8.Automatic.CurrentOrderMode = 2 or NDC8.Automatic.CurrentOrderMode = 3 then
					AutoloadMainState := 152;
				end_if;
				
			elsif 	PLC_TX02_Bit_STr_Ang0 = FALSE 
					and PLC_TX02_Bit_STr_Ang90 = FALSE
					and PLC_TX02_Bit_STr_Ang180 = FALSE
					and PLC_TX02_Bit_STr_AngN90 = FALSE then
					AutoloadMainState := 145;
				
			elsif	PLC_TX02_Bit_STr_Right = FALSE 
					and PLC_TX02_Bit_STr_Left = FALSE then
					AutoloadMainState := 145;
				
			elsif	PLC_TX02_Bit_STr_Load = FALSE 
					and PLC_TX02_Bit_STr_Unload = FALSE then
					AutoloadMainState := 145;
				
			else
				AutoloadMainState := 33;
			end_if;	
		end_if;
			
		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
		
	33: (*Wait PLC Processing*)
	
		OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
	
		if g_ErrorCode <> 0 then
				AutoloadMainState := 999;
		else
			if INPUT.Auto = FALSE then
				AutoloadMainState := 998;
			elsif NDC8.SDIO.DigitalInput12_EMO = FALSE then
				AutoloadMainState := 133;
			elsif PLC_RX01_Bit_LDErr_i then 
				AutoloadMainState := 149;
			elsif PLC_RX01_Bit_LD_Canc_i = TRUE then
				
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
				OM_PLC_W2_Bit_SetOpCanc := TRUE;
				AutoloadMainState := 930;
			
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				
			elsif PLC_RX01_Bit_LD_Cond_i = true then (* Interlock (8I/8O) Proc *)
			
				OM_PLC_Word2 := INT_TO_WORD(NDC8.OMPLC.Stop_OM);
			
				OM_PLC_W2_Bit_SetCondErr := TRUE;
				AutoloadMainState := 900;
			
				NDC8.OMPLC.Stop_OM := WORD_TO_INT(OM_PLC_Word2);
				
			elsif PLC_RX_Word10_Round <> 0 then
			
				OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
			
				OM_PLC_W9_Bit_Adj_Err := TRUE;
				
				if PLC_RX10_Bit_Round_Y1 = TRUE then
					ADJ_ErrCode := 251;
				elsif PLC_RX10_Bit_Round_Y2 = TRUE then
					ADJ_ErrCode := 252;
				elsif PLC_RX10_Bit_Round_X = TRUE then
					ADJ_ErrCode := 253;
				elsif PLC_RX10_Bit_Round_RT = TRUE then
					ADJ_ErrCode := 254;
				elsif PLC_RX10_Bit_Round_FK = TRUE then
					ADJ_ErrCode := 255;
				elsif PLC_RX10_Bit_Round_Y = TRUE then
					ADJ_ErrCode := 256;
				elsif PLC_RX10_Bit_Round_RT2 = TRUE then
					ADJ_ErrCode := 221;
				end_if;
				
				AutoloadMainState := 910;
			
				NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
				
			elsif PLC_RX03_Bit_Round_ChgP = true then
			
				OM_PLC_Word9 := INT_TO_WORD(NDC8.OMPLC.Round_om);
			
				OM_PLC_W9_Bit_ChgP_Err := TRUE;
				AutoloadMainState := 920;
			
				NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
			
			elsif PLC_RX01_Bit_LDDone_i then 
			
				if PLC_RX01_Bit_Load_i = false then
					AutoloadMainState := 149;
					PLC_TX_Word2 := 0;
					PLC_TX02_Bit_STr_DepoST := FALSE;
					PLC_TX04_Bit_Cancel_ST := FALSE;
					PLC_TX01_Bit_Cancel_ST2 := FALSE;
					AutoloadMainState := 1000;
				else
					AutoloadMainState := 147;
				end_if;
				
			end_if;
		end_if;

		NDC8.OMPLC.Round_om := WORD_TO_INT(OM_PLC_Word9);
	
(* Charge the battery Local Order *)
	40:	
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			if NDC8.LoadDocking.OnTarget = TRUE then
				(* Wait Charger InPosition *)
					AutoloadMainState := 41;
			end_if;
		end_if;
		
		
	41:(*  Wait 10sec *)
	
		if g_ErrorCode <> 0 then
			AutoloadMainState := 49;
		else
			if INPUT.Auto = FALSE then
				AutoloadMainState := 49;
			end_if;
		
			ChargeDelay( IN:= TRUE, PT := t#10s);
			
			if ChargeDelay.Q then
				ChargeDelay( IN:= FALSE);
				AutoloadMainState := 42;
			end_if;
					
		end_if;
		
	42: (* Wait Charge Done or any Error *)
	
		if g_ErrorCode <> 0 then
			AutoloadMainState := 49;
		else
			if INPUT.Auto = FALSE then
				AutoloadMainState := 49;
			end_if;
		
			if g_ChargeDone = TRUE then 
				ChargeDelay( IN:= TRUE, PT := t#1s);
			
				if ChargeDelay.Q then
					ChargeDelay( IN:= FALSE);
					AutoloadMainState := 49;
				end_if;
			end_if; 
		end_if;
		
	49:
	
		
		if PLC_RX03_Bit_CP_HP then 
			StepDelay(IN:=TRUE, PT:=t#1s);
			if StepDelay.Q then
				StepDelay(IN:=FALSE);
			
				if g_ErrorCode <> 0 then
					AutoloadMainState := 999;
				end_if;
				
				if INPUT.Auto = FALSE then
					AutoloadMainState := 998;
				end_if;
				
			end_if;
		end_if;			
			
		
		
(* Power Off *)
	50:
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			(* Send Event *)
			if NDC8.LoadDocking.OnTarget = TRUE then
				g_PowerOffFlag_OP := TRUE;
				if NDC8.SDIO.DigitalOutput13_PWR_OFF = TRUE then
					AutoloadMainState := 1000;
				end_if;
			end_if;
		end_if;
		
(* Move no OP Code *)
	60:
		if g_ErrorCode <> 0 then
			AutoloadMainState := 999;
		else
			StepDelay(IN := TRUE, PT := t#5s);
		
			if StepDelay.Q then
				if NDC8.LayoutPosition.Point = NDC8.LocalOrder.DestPoint then
					AutoloadMainState := 1000;
					StepDelay(IN := FALSE);
				end_if;
			
			end_if;
		end_if;

(* EMO *)
	133:
		g_ErrorCode := 133;
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			if NDC8.SDIO.DigitalInput12_EMO = TRUE then
				AutoloadMainState := 2000;
			end_if;
			StepDelay(IN := FALSE);
		end_if;

(* Transfer Schedule Error *)
	145:
		g_ErrorCode := 145;
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Load Condition Error *)
	147:
		
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Loading Condition Error *)
	148:
		g_ErrorCode := 148;
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
		
		
(* Unloading Condition Error *)
	149:

		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Command Error *)
	150:
		g_ErrorCode := 150;
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Local Command Error *)
	152:
		g_ErrorCode := 152;
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Ir Error Need to Error Stop Order  *)
	900:
		Fail := TRUE;
					
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			LoadOpDone(ErrorCode:=242, Result:=NDC8.LayoutPosition.Distance);
			if LoadOpDone.Finished then
				INPUT.AutoLoadDone := TRUE;
				StopLoadOP := FALSE;
				AutoloadMainState:= 2000;	(* End autoload *)
			end_if;
		end_if;
(* Round Try Don't Stop Order *)
	910:
		Fail := TRUE;
					
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			LoadOpDone(ErrorCode:=ADJ_ErrCode, Result:=NDC8.LayoutPosition.Distance);
			if LoadOpDone.Finished then
				INPUT.AutoLoadDone := TRUE;
				StopLoadOP := FALSE;
				AutoloadMainState:= 2000;	(* End autoload *)
			end_if;
		end_if;	
		
(* Charge Position Error Don't Stop Order *)
	920:
		Fail := TRUE;
					
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			LoadOpDone(ErrorCode:=265, Result:=NDC8.LayoutPosition.Distance);
			if LoadOpDone.Finished then
				INPUT.AutoLoadDone := TRUE;
				StopLoadOP := FALSE;
				AutoloadMainState:= 2000;	(* End autoload *)
			end_if;
		end_if;	

(* Op Cancel Stop Order *)
	930:
		Fail := TRUE;
					
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			LoadOpDone(ErrorCode:=243, Result:=NDC8.LayoutPosition.Distance);
			if LoadOpDone.Finished then
				INPUT.AutoLoadDone := TRUE;
				StopLoadOP := FALSE;
				AutoloadMainState:= 2000;	(* End autoload *)
			end_if;
		end_if;	
(* Change Mode to Manual don't stop Order *)
	998:
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;
		
(* Other Error Code Ocuur  don't stop Order *)
	999:
		
		Fail := TRUE;
		
		StepDelay(IN := TRUE, PT := t#1s);
		
		if StepDelay.Q then
			AutoloadMainState := 2000;
			StepDelay(IN := FALSE);
		end_if;


(**** Check if Operation Done OK ****)
	1000:	
	
		if Debug_1000_F = FALSE then
			LoadOpDone(ErrorCode:=0, Result:=NDC8.LayoutPosition.Distance);	(* Operation OK Error=0 *)
			if LoadOpDone.Finished then
				Fail := FALSE;
				INPUT.AutoLoadDone := TRUE;
				StopLoadOP := FALSE;
				
				if Debug_1000_B = FALSE then
					AutoloadMainState:= 2000;	(* End autoload *)
				end_if;
			end_if;
		end_if;
					
					
(* Operation Complete *)
	2000:
	
		if Debug_2000_F = FALSE then
			if INPUT.AutoLoadDone = TRUE then
				StartLoad 						:= false;
				StartUnLoad 					:= false;
				StartCharge						:= false;
	
				InProc_OperationCode			:= 0;
				PLC_TX_Word2 := 0;
		
				StepDelay(IN := TRUE, PT := t#1s);
		
				if StepDelay.Q then
					AutoloadMainState := 2000;
					
					if Debug_2000_B = FALSE then
						AutoloadMainState				:= 0;
					end_if;
				
					StepDelay(IN := FALSE);
				end_if;
		
				
			else
				if Input.Manual = TRUE or g_AGV_ErrorReset = TRUE then
					INPUT.AutoLoadDone := TRUE;
					StopLoadOP := FALSE;
				end_if;
			end_if;
		end_if;
end_case;

(*===============================================*)
(* 		DEBUG #0x1  	Event 801				 *)

if word_to_bool(int_to_word(ndc8.omplc.DebugLevel) and 16#01) then
	if  debug or
		(PreviousMainState 						<> AutoLoadMainState) or
		(PreviousExecDriveCommand 				<> NDC8.Automatic.ExecDriveCommand) or
		(PreviousFailCode 						<> FailCodeDint) or
		(PreviousCancelOperation 				<> NDC8.LoadOperation.CancelOperation) or
		(PreviousTravelDir					 	<> NDC8.VehicleControl.TravelDir)
			then
				a:= TRACE_DINT('ALState',AutoLoadMainState);
				a:= TRACE_DINT('FailCodeDint',FailCodeDint);
				
				debug := true;
	end_if;
	PreviousExecDriveCommand 				:= NDC8.Automatic.ExecDriveCommand;
	PreviousTravelDir					 	:= NDC8.VehicleControl.TravelDir;
	PreviousMainState 						:= AutoloadMainState;
	PreviousFailCode						:= FailCodeDint;
	PreviousCancelOperation					:= NDC8.LoadOperation.CancelOperation;
	bbxtrigger:= AutoloadMainState=99 ;
	BbxTrig_FT(CLK:=bbxtrigger);
end_if;

	
(* If trigger do a blackbox and log event*)
if BbxTrig_FT.q then
	a:=TRACE_string('Bbx_Autoload');
	a:=TRACE_bool('BbxTrig',BbxTrig);
	NDC8.BlackBox.TrigReason:= 'Autoload';
	BbxTrig:=true;
end_if;


(* Cancel Check *)


(* OUTPUT *)


































































END_FUNCTION_BLOCK