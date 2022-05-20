FUNCTION_BLOCK INDICATORS_FB
VAR_EXTERNAL
	(** IN **)
	NDC8 : NDC8_T;
	INPUT : INPUT_T;
	Output : OUTPUT_T;
	
END_VAR

VAR_INPUT
	SetHeight						: dint;
	ForkTarget,
	AutoInsertNotInsideTargetSafety,
	AutoinsertInProgress,
	SensorsBuzzerTest,
	StartDelayStartWarning,
	LS2000SlowDown					: bool;

END_VAR
	
VAR_OUTPUT

END_VAR

VAR
	FlashError,
	FlashWarning,
	FlashRight,
	FlashLeft,
	FlashForward,
	FlashBackward,
	FlashSegment : Bool;
	FlashBrakeRel : BOOL;
	ModeAutoTON :TON;
	
	Display : bool;
	SlowBeep : bool;

END_VAR
(*
------------------------------------------------------------------------------------                              
 INDICATORS_FB                    
 ------------------ 
                      
 Description:                     
 This PLC controls the flashing of the lights and the sounding of the buzzer.
 The lights and buzzer functionality is made according to safety regulations EN-1525.


-------------------------------------------------------------------------------------*)

(* make default *)
Output.PositionKnownLamp 	:= false;
Output.EmergencyStopLamp 	:= false;
Output.LoadOnBoardLamp	 	:= false;
Output.InSystemLamp			:= false;
Output.FrontLeftLamp 		:= false;
Output.FrontRightLamp 		:= false;
Output.RearLeftLamp 		:= false;
Output.RearRightLamp 		:= false;
Output.WarningBuzzerTop		:= false;
Output.WarningLightTop		:= false;
Output.Buzzer 				:= false;
Output.OPTBuzzer			:= false;

(***************************************************************************************
	Evaluate which signals to set 
****************************************************************************************)
(*Emergency stop or any stop flags*)
FlashError	:=	NDC8.VehicleControl.Estop
				or StopRear
				or StopSide
				or StopObstacle
				or StopLift
				or StopLoadChange
				or StopReset
				or StopSteerSync
				or StopForkFarTooHigh
				or StopForkTooHigh
				or StopForkTooLow
				or NDC8.Opt.VehicleStatusID = 11;		
				
				
FlashBrakeRel := INPUT.Auto = TRUE and NDC8.SDIO.DigitalInput5_BTN_BRK = TRUE;		

(*Segment trigger flash*)
FlashSegment := NDC8.VehicleControl.Moving;



(*Segment trigger or Vehical right turn*)
FlashRight 	:= 	Input.SD_Right or Input.DD_Right;

						
(*Segment trigger or Vehical right turn*)
FlashLeft 	:=	Input.SD_Left or Input.DD_Left;

				
(*Segment trigger or Vehical Forward*)
FlashForward := Input.SD_Forward;
				
(*Segment trigger or Vehical Backward*)
FlashBackward := Input.SD_Backward;

				
(* Special case for when we want to flash both right _and_left *)
(*If FlashRight and FlashLeft then
	  FlashRight	:= NDC8.TurnSignal.RightTurnDistance < NDC8.TurnSignal.LeftTurnDistance;
	  FlashLeft		:= NDC8.TurnSignal.LeftTurnDistance < NDC8.TurnSignal.RightTurnDistance;
End_if;*)

		
(*Vehicle moving backwards, forks are moving or before starting to drive *)
FlashWarning := (SetHeight > 0 and not ForkTarget )
				or (NDC8.VehicleControl.Moving and NDC8.VehicleControl.TravelDir = 0)
				or INPUT.SafetyScannerSlowDown
				or StartDelayStartWarning
				or (NDC8.Guidance.StopReason = 1
  					and NDC8.Guidance.DistanceToStop < 1500
  					and NDC8.VehicleControl.TravelDir = 1);		(* Vehicle will stop and change travel directions and reverse. *)





(***************************************************************************************)
(*			LAMPS 					*)
(***************************************************************************************)
(* GREEN lamp;	Position known *)
if 	NDC8.Position.Valid then
	if NDC8.VehicleControl.OperationMode = 0 then			
		Output.PositionKnownLamp := true;										(* Automatic mode: 		ON 		*)
	else
	 	Output.PositionKnownLamp := Timer.Info;								(* Semi/manual mode: 	BLINK 	*)
	end_if;
end_if;


(***************************************************************************************)
(* WHITE lamp; reset button *)

Output.ResetButtonLamp	:= (StopReset or												(* need reset	*)
					   		StopManual or
					   		AutoInsertNotInsideTargetSafety 								(* vehicle need assistance during autoinsert *)
							) 
							and Timer.Info;


(***************************************************************************************)
(* YELLOW lamp; Load on board*)
Output.LoadOnBoardLamp := INPUT.LoadOnBoard and Timer.Info;

				
(***************************************************************************************)
(* RED lamp; S100 stop *)
Output.EmergencyStopLamp := NDC8.VehicleControl.OperationMode = 0 and StopObstacle and Timer.Error;								(* S100 stop *)



(***************************************************************************************)
(* BLUE lamp; In system *)

if NDC8.VehicleControl.OperationMode = 0 then
	Output.InSystemLamp :=	NDC8.LayoutPosition.InSystem 							(* in system *)
				or (AutoinsertInProgress and NDC8.VehicleControl.Moving and Timer.Warning)
				
				or (INPUT.Reset_PB  								(*	 on when pressed and outside safety	*)
					and AutoInsertNotInsideTargetSafety
					)
				or (AutoinsertInProgress				(* 	 need more RESET help 	*)			
					and not NDC8.VehicleControl.Moving 
					and Timer.Info);
end_if;


(***************************************************************************************)
(* SIDE ORANGE lamp; warning/turn indicators *)
InStatus := NDC8.VehicleControl.OperationMode = 0;
ModeAutoTON(IN:=InStatus,PT:=t#2s);	(* Wait 2 sec before flashing when entering auto*)
if TRUE then
	if FlashError then
		Output.RearLeftLamp 	:= Timer.Error;
		Output.RearRightLamp	:= Timer.Error;
		Output.FrontLeftLamp 	:= Timer.Error;
		Output.FrontRightLamp	:= Timer.Error;
		(* vehicle moving or vehicle error both flash *)
		(*
	elsif FlashWarning or FlashSegment then				
		Output.RearLeftLamp 	:= Timer.Warning;
		Output.RearRightLamp	:= Timer.Warning;
		Output.FrontLeftLamp 	:= Timer.Warning;
		Output.FrontRightLamp	:= Timer.Warning;*)
	elsif FlashBrakeRel then
		Output.FrontLeftLamp 	:= TRUE;
		Output.RearLeftLamp 	:= TRUE;
		Output.FrontRightLamp 	:= TRUE;
		Output.RearRightLamp 	:= TRUE;
	elsif FlashForward then								(* vehicle turning to the left *)
		Output.FrontLeftLamp 	:= Timer.Warning;
		Output.RearLeftLamp 	:= Timer.Warning;
		Output.FrontRightLamp 	:= Timer.Warning;
		Output.RearRightLamp 	:= Timer.Warning;
	elsif FlashBackward then								(* vehicle turning to the left *)
		Output.FrontLeftLamp 	:= Timer.Warning;
		Output.RearLeftLamp 	:= Timer.Warning;
		Output.FrontRightLamp 	:= Timer.Warning;
		Output.RearRightLamp 	:= Timer.Warning;
	elsif FlashRight then								(* vehicle turning to the right *)
		Output.FrontLeftLamp 	:= false;
		Output.RearLeftLamp 	:= false;
		Output.FrontRightLamp 	:= Timer.Warning;
		Output.RearRightLamp 	:= Timer.Warning;
	elsif FlashLeft then								(* vehicle turning to the left *)
		Output.FrontLeftLamp 	:= Timer.Warning;
		Output.RearLeftLamp 	:= Timer.Warning;
		Output.FrontRightLamp 	:= false;
		Output.RearRightLamp 	:= false;
	elsif NDC8.VehicleControl.Moving = FALSE then
		Output.FrontLeftLamp 	:= TRUE;
		Output.RearLeftLamp 	:= TRUE;
		Output.FrontRightLamp 	:= TRUE;
		Output.RearRightLamp 	:= TRUE;
	end_if;
elsif StopReset then									(* Reset required *)
		Output.FrontLeftLamp 	:= Timer.Info and Timer.Error and Timer.Warning;
		Output.FrontRightLamp 	:= Timer.Info and Timer.Error and Timer.Warning;
		Output.RearLeftLamp 	:= Timer.Info and Timer.Error and Timer.Warning;
		Output.RearRightLamp 	:= Timer.Info and Timer.Error and Timer.Warning;
end_if;


if StopLS2000 or LS2000SlowDown then							(* Vehicle is about to drive into something and hit LS2000! *)
		Output.RearLeftLamp 	:= Timer.Warning;
		Output.RearRightLamp	:= Timer.Warning;
		Output.FrontLeftLamp 	:= Timer.Warning;
		Output.FrontRightLamp	:= Timer.Warning;
end_if;
	



(***************************************************************************************)
(* 					BUZZERS 					*)
(***************************************************************************************)
(* High frequency tone. Sound only when there is a drive command. *) 
InStatus := NDC8.VehicleControl.OperationMode = 0;
ModeAutoTON(IN:=InStatus,PT:=t#3s);	(* Wait 3 sec before buzzing when entering auto *)
Output.Buzzer	:=	(ModeAutoTON.Q and
						NDC8.Automatic.ExecDriveCommand	and
							(FlashError and Timer.Error)				(* Error *)
						 	or						
						 	(FlashWarning and Timer.Warning)					(* Info *)
						)	
					or SensorsBuzzerTest
					or (StopLS2000 or LS2000SlowDown and Timer.Warning);			(* Vehicle is about to drive into something and hit LS2000! *)
			

(* OPT 100 BUZZER Low frequency tone *)
OUTPUT.OPTBuzzer	:= StartDelayStartWarning					(* Sound during start or if reset is required. *)
						or 
							(StopReset or StopLS2000 or LS2000SlowDown) 
							and Timer.Info 
							and Timer.Error
							and Timer.Warning
							and SlowBeep;











END_FUNCTION_BLOCK