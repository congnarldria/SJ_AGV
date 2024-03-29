FUNCTION_BLOCK OUTPUTMAP_FB
VAR_EXTERNAL
NDC8:NDC8_T;
Output : Output_T;
g_PowerOffFlag : BOOL;

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR
	LampBlink : BLINK;
	
	(* Power Off *)
	PowerOffEvTm : TON;
	
	BuzzerSyncTm : TON;
	
END_VAR
(*
------------------------------------------------------------------------------------                              
 Output_Map_FB                    
 -----------                  

                              
 Description:                     
 Used to map actual outputs to generic variables.

-------------------------------------------------------------------------------------*)

(* In the vehicle documentation, and the OUTPUTS.TYP, more examples of OutputMap_FB is found. * )

NDC8..	:=	OUTPUT.PositionKnownLamp;	( * Green	* )
NDC8..	:=	OUTPUT.EmergencyStopLamp;	( * Red 	* )
NDC8..	:=	OUTPUT.InSystemLamp;		( * Blue	* )
NDC8..	:=	OUTPUT.ResetButtonLamp		( * White	* )
NDC8..	:=	OUTPUT.LoadOnBoardLamp;
NDC8..	:=	OUTPUT.FrontLeftLamp;
NDC8..	:=	OUTPUT.FrontRightLamp;
NDC8..	:=	OUTPUT.RearLeftLamp;
NDC8..	:=	OUTPUT.RearRightLamp;

NDC8..	:=  OUTPUT.ChargPlatesRelay;
NDC8..	:=	OUTPUT.Buzzer;

NDC8..	:=	OUTPUT.ForkRaise;
NDC8..	:=	OUTPUT.ForkLower;

NDC8..	:=	OUTPUT.SafetyScannerAreaControlA1;
NDC8..	:=	OUTPUT.SafetyScannerAreaControlB1;
NDC8..	:=	OUTPUT.SafetyScannerAreaControlA2;		
NDC8..	:=	OUTPUT.SafetyScannerAreaControlB2;		

OUTPUT.SetValueTraction := NDC8.xCD_x.SetSpeed;      ( * Check FrontWheel.SetSpeedRef and enter it here * )
OUTPUT.SetValueSteer 	:= NDC8.xCD_x.SetAngle;      ( * Check FrontWheel.SetAngleRef and enter it here * )

NDC8.OPT100.Buzzer	:=	OUTPUT.OPTBuzzer;
*)

LampBlink(RUN:= TRUE,  CYCLE:= t#1s);


NDC8.SDIO.DigitalOutput6_LED_INPOS := NDC8.LayoutPosition.InSystem;
	
NDC8.SDIO.DigitalOutput2_LEDF_L	:=	OUTPUT.FrontLeftLamp;
NDC8.SDIO.DigitalOutput3_LEDF_R	:=	OUTPUT.FrontRightLamp;
NDC8.SDIO.DigitalOutput4_LEDR_L	:=	OUTPUT.RearLeftLamp;
NDC8.SDIO.DigitalOutput5_LEDR_R	:=	OUTPUT.RearRightLamp;


if INPUT.StartMode = TRUE then
	NDC8.SDIO.DigitalOutput7_LED_STR := FALSE;
elsif INPUT.StartMode = FALSE and (INPUT.Manual or g_ErrorCode <> 0) then
	NDC8.SDIO.DigitalOutput7_LED_STR := FALSE;
else
	NDC8.SDIO.DigitalOutput7_LED_STR := LampBlink.Q1;
end_if;

if NDC8.SDIO.DigitalInput5_BTN_BRK = TRUE then
	NDC8.SDIO.DigitalOutput14_LED_BRK := TRUE;
else
	NDC8.SDIO.DigitalOutput14_LED_BRK := FALSE;
end_if;

if g_ErrorCode <> 0 or PLC_RX_Word4_PLC_ErrD <> 0 then
	NDC8.SDIO.DigitalOutput8_LED_RST := LampBlink.Q1;
else
	NDC8.SDIO.DigitalOutput8_LED_RST := FALSE;
end_if;

PowerOffEvTm(IN:= g_PowerOffFlag, PT:= t#1s);

if PowerOffEvTm.Q then
	NDC8.SDIO.DigitalOutput13_PWR_OFF := TRUE;
else
	NDC8.SDIO.DigitalOutput13_PWR_OFF := FALSE;
end_if;

BuzzerSyncTm(IN:=TRUE, PT:=t#10s);


if g_FindSyncFlag = TRUE then
	if BuzzerSyncTm.Q = TRUE then
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
		BuzzerSyncTm(IN:= FALSE);
	elsif Input.BuzzerByPass = TRUE then
	 	NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif g_PowerOffFlag = TRUE then (*Ch15*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;
	elsif NDC8.PLC_Application.TxStatusBit9_EStop = TRUE then (*Ch12*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;
	elsif g_ErrorCode <> 0 then (*Ch11*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;
	elsif NDC8.PLC_Application.TxStatusBit12_LostP = TRUE then (*Ch13*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;
	elsif 	NDC8.PLC_Application.TxStatusBit4_LowBatt = TRUE and NDC8.SDIO.DigitalOutput16_Charger = FALSE and 
		NDC8.PointTrigger.Bit9_Chrg_Right = FALSE and
		NDC8.PointTrigger.Bit10_Chrg_Left = FALSE and 
		NDC8.PointTrigger.Bit14_Full_Chrg = FALSE  then (*Ch14*)
		
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;		
	elsif NDC8.SDIO.DigitalInput3_BMP_O1 = TRUE or NDC8.SDIO.DigitalInput4_BMP_O2 then (*Ch10*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;	
	elsif NDC8.PLC_Application.TxStatusBit11_IrStop = TRUE then (*Ch9*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;
	elsif NDC8.PLC_Application.TxStatusBit10_Blocked = TRUE then (*Ch8*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := TRUE;	
	elsif PLC_TX_Word2 <> 0 then (*Ch7*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif Input.SafetyScannerSlowDown = TRUE then (*Ch5*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif Input.SD_Right or Input.DD_Right then (*Ch4*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif Input.SD_Left or Input.DD_Left then (*Ch3*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif Input.SD_Backward then (*Ch2*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif Input.SD_Forward then (*Ch1*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	elsif NDC8.Automatic.ExecDriveCommand = TRUE then (*Ch1*)
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;	
	

	
	(*Ch6*)
	(*
	elsif (StopWord <> 0 and not StopStartDelay and not StopCharge and not StopLoadOP) or (StopWord2 <> 0 and not StopByBCD and not StopRobotNotIdle )then 
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := TRUE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;*)	
	
	else
		NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := FALSE;
		NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := FALSE;
	end_if;
end_if;

















END_FUNCTION_BLOCK