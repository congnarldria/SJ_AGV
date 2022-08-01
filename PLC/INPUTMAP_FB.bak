FUNCTION_BLOCK INPUTMAP_FB
VAR_EXTERNAL
NDC8:NDC8_T;
Input : Input_T;

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR
	StartSwitchRise : R_Trig;
	StartSwitchFlag : BOOL;
	StartDelay : TON;
	McdAutoR : R_Trig;
	McdAutoFlag : BOOL;
	OrderMode:OrderMode_FB;
END_VAR
(*
------------------------------------------------------------------------------------                              
 Input_Map_FB                    
 -----------                  
                             
 Description:                     
	 Used to map actual inputs to generic variables.

-------------------------------------------------------------------------------------*)


(* Minimum required inputs * )
INPUT.ForkEncSyncValid		:= NDC8.. ;		
								:= TRUE; 									if using CAN encoder or analog input.
								
INPUT.SteerEncSyncValid		:= NDC8.. ;             
								:= (NDC8.DCD_5.EncoderStatus = 1);			for DCD
								:= TRUE ;									for ACD with CAN encoder
								:= NDC8.SDIO.Enc1SyncValid ;				for ACD with incremental encoder


( * Frequently used inputs  * )
INPUT.Reset_PB				:= NDC8.. ;
INPUT.SafetyScannerStop1	:= NDC8.. ;
INPUT.SafetyScannerStop2	:= NDC8.. ;
INPUT.LoadOnBoard			:= NDC8.. ;
INPUT.TractionSpeed			:= NDC8.. ;		( * DINT * )
INPUT.TractionDistance		:= NDC8.. ;		( * INT * )
INPUT.SafetyScannerSlowDown	:= NDC8.. ;

Input.ManualForkUp_PB 		:= NDC8.MCD.Button8;	( * MCD Load up.	Move the fork up. * )
Input.ManualForkDown_PB 	:= NDC8.MCD.Button9;	( * MCD Load down.	Move the fork down. * )
Input.ZeroSteerAngle_PB		:= NDC8.MCD.Button11;   ( * MCD Load right. Set the steerangle to zero in manual mode * )
Input.ChangeSteerMode_PB	:= NDC8.MCD.Button10;	( * MCD Load left. 	Switch steer modes in manual or semi (QUAD) * )

Input.LowBattery			:= NDC8.SDIO.B_Plus < 2200 ;			( * Simple example of battery level supervision. 
								Normally CVC600 is connected via filter or DC/DC Battery+, so this value is not valid. * )
Input.BatteryLevel			:=    ( * INT * )

Input.SteerEncAngle			:= NDC8.. ;		( * DINT * )
								:= INT_to_DINT(NDC8.DCD_6.WheelAngle) ;  	for DCD
								:= NDC8.CAN_Enc_x.SteerEncAngle ;			for ACD with CAN encoder
								:= INT_TO_DINT(NDC8.SDIO.Enc1Angle) ;		for ACD with incremental encoder
NDC8.xCD_x.SyncGate			:= NDC..										for ACD or DCD with multi turn incremental steer encoder.
											
Input.ForkSpeed					:= NDC8.. ;		( * DINT * )
INPUT.ForkHeight				:= NDC8.. ;		( * DINT * )
INPUT.ForkTipSensorLeft			:= NDC8.. ;
INPUT.ForkTipSensorRight		:= NDC8.. ;
INPUT.ForkTipCentreLeft			:= NDC8.. ;
INPUT.ForkTipCentreRight		:= NDC8.. ;
INPUT.SideSensorRightBackward	:= NDC8.. ;
INPUT.SideSensorRightForward	:= NDC8.. ;
INPUT.SideSensorLeftBackward	:= NDC8.. ;
INPUT.SideSensorLeftForward		:= NDC8.. ;

*)

(* In the vehicle documentation, and the INPUTS.TYP, more examples of InputMap_FB is found. *)
;
(* Button *)

Input.ZeroSteerAngle_PB			:= 	NDC8.MCD.Button7;

INPUT.TractionSpeed := NDC8.VehicleControl.SetSpeed;

Input.ChangeSteerMode_PB	:= NDC8.MCD.Button10;
Input.ChangeSteerMode_PB2	:= NDC8.Mcd.Button11;

if NDC8.SDIO.DigitalInput3_BMP_O1 = TRUE or NDC8.SDIO.DigitalInput4_BMP_O2 = TRUE then
	StopSafety := TRUE;
else
	StopSafety := FALSE;
end_if;

StartSwitchRise(CLK:= NDC8.SDIO.DigitalInput1_BTN_STR);

if INPUT.StartMode = FALSE and StartSwitchRise.Q then
	INPUT.StartMode := TRUE;
elsif g_ErrorCode <> 0 and g_ErrorCode <> 155 and g_ErrorCode <> 156 then
	INPUT.StartMode := FALSE;
end_if;

if INPUT.Manual = TRUE then
	INPUT.StartMode := FALSE;
end_if;

McdAutoR(CLK := NDC8.Mcd.Button1);

if McdAutoR.Q then 
	Input.BuzzerByPass := FALSE;
end_if;
	

if NDC8.DCD_6.EncoderStatus = 1 and NDC8.DCD_8.EncoderStatus = 1 then
	INPUT.SteerEncSyncValid := TRUE;
else
	INPUT.SteerEncSyncValid := FALSE;
end_if;

if NOT NDC8.CAN_IO_3.DigitalInput3_SteerLimitR_L = TRUE or NOT NDC8.CAN_IO_3.DigitalInput4_SteerLimitR_R = TRUE then
	NDC8.DCD_8.EndLimitSwitchPolarity := 1;
else
	NDC8.DCD_8.EndLimitSwitchPolarity := 0;
end_if;

if NOT NDC8.CAN_IO_3.DigitalInput1_SteerLimitF_L = TRUE or NOT NDC8.CAN_IO_3.DigitalInput2_SteerLimitF_R = TRUE then
	NDC8.DCD_6.EndLimitSwitchPolarity := 1;
else
	NDC8.DCD_6.EndLimitSwitchPolarity := 0;
end_if;
	

Input.CreepOn := abs(NDC8.VehicleControl.SetSpeed) = NDC8.Vehicle.CreepSpeed;

if  (NDC8.DCD_6.SetAngle > 500 and NDC8.DCD_6.SetAngle <= 8500 and NDC8.DCD_8.SetAngle > 500 and NDC8.DCD_8.SetAngle <= 8500) or 
	(NDC8.DCD_6.SetAngle < -500 and NDC8.DCD_6.SetAngle >= -8500 and NDC8.DCD_8.SetAngle < -500 and NDC8.DCD_8.SetAngle >= -8500) then 
	Input.SteerMode := 1;
elsif abs(NDC8.DCD_6.SetAngle) > 8500 and abs(NDC8.DCD_6.SetAngle) < 9500 
	and abs(NDC8.DCD_8.SetAngle) > 8500 and abs(NDC8.DCD_8.SetAngle) < 9500 then
	Input.SteerMode := 2;
else
	Input.SteerMode := 0;
end_if;

Input.SD_Right := ((NDC8.SegmentTrigger.Bit13_TurnRght_A and NDC8.VehicleControl.Moving)
					or (Input.SteerMode = 0 and NDC8.DCD_6.SetAngle <= -500) (* SD Mode and Right, Just Check Front Wheel *)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.DCD_6.SetAngle < 0) (* 2*SD Parallel Mode and Right, Just Check Front Wheel  *)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.DCD_6.SetAngle > 0)) (* 2*SD Parallel Mode and Right, Just Check Front Wheel  *)
					and NDC8.VehicleControl.Moving;
			
Input.SD_Left :=  ((NDC8.SegmentTrigger.Bit12_TurnLeft_A and NDC8.VehicleControl.Moving)
					or (Input.SteerMode = 0 and NDC8.DCD_6.SetAngle >= 500) (* SD Mode and Left, Just Check Front Wheel *)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.DCD_6.SetAngle > 0) (* 2*SD Parallel Mode and Left, Just Check Front Wheel  *)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.DCD_6.SetAngle < 0)) (* 2*SD Parallel Mode and Left, Just Check Front Wheel  *)
					and NDC8.VehicleControl.Moving;


Input.DD_Right := ((Input.SteerMode = 2 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.DCD_6.SetAngle < 0) (* Diff Parallel Mode and Right, Just Check Front Wheel  *)
					or (Input.SteerMode = 2 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.DCD_6.SetAngle > 0)); (* Diff Parallel Mode and Right, Just Check Front Wheel  *)
				
				
Input.DD_Left :=  ((Input.SteerMode = 2 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.DCD_6.SetAngle > 0) (* Diff Parallel Mode and Right, Just Check Front Wheel  *)
					or (Input.SteerMode = 2 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.DCD_6.SetAngle < 0)); (* Diff Parallel Mode and Right, Just Check Front Wheel  *)
		
		
Input.SD_Forward := ((Input.SteerMode = 0 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.VehicleControl.Moving = TRUE)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed > 0 and NDC8.VehicleControl.Moving = TRUE))
					and (Input.SD_Right = FALSE and Input.SD_Left = FALSE and Input.DD_Right = FALSE and Input.DD_Left = FALSE);
				
				
Input.SD_Backward := ((Input.SteerMode = 0 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.VehicleControl.Moving = TRUE)
					or (Input.SteerMode = 1 and NDC8.VehicleControl.SetSpeed < 0 and NDC8.VehicleControl.Moving = TRUE))
					and (Input.SD_Right = FALSE and Input.SD_Left = FALSE and Input.DD_Right = FALSE and Input.DD_Left = FALSE);
		
		
INPUT.LoadOnBoard := PLC_RX01_Bit_Load_i;


StopEstopButton := NDC8.SDIO.DigitalInput12_EMO;


















END_FUNCTION_BLOCK