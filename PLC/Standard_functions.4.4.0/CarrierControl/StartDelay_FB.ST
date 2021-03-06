FUNCTION_BLOCK StartDelay_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
END_VAR

VAR_INPUT
END_VAR

VAR_OUTPUT
	StartWarning : BOOL;
	StartDelayState : DINT;	
END_VAR

VAR
	StartDelayShortTOF,
	StartDelayWarningTOF,
	StartDelayLongTOF 		: TOF;
	StartDelayWarningOn,
	StartDelayInactivity,
	StartDelayShort,
	StartDelay,
	StartDelayLong 			: BOOL;
	StartDelayInactivityTON : TON;
	
END_VAR
(****************************************************************************************)
(* START DELAY  - hold the vehicle for a little while before starting to drive. 		*)

StartDelayInactivity	:= 	NDC8.VehicleControl.OperationMode = 0		(* If standing still on a home position. *)
							and not NDC8.Automatic.ExecDriveCommand
							and not NDC8.Vehicle.Blocked;

StartDelayShortTOF(IN:=StartDelayInactivity, PT:=t#2s);							
StartDelayInactivityTON(IN:=StartDelayInactivity, PT:=t#15s);		
	
if NDC8.VehicleControl.OperationMode > 0 then							(* If not ín automatic mode, then start over. *)
	StartDelayState := 0;
end_if;

case StartDelayState of
0: 	(* When stand still on the home for more than 15 seconds. *)
	StopStartDelay 	:= false;
	if StartDelayInactivityTON.q then 
		StartDelayState := 10;
		StopStartDelay 	:= true;
	end_if;
	
10: if not StartDelayInactivity then		(* Wait for a new order. *)
		StartWarning 	:= true;
		StartDelayState := 20;
	end_if;
	
20: 	(* Hold the vehicle, and beep, for two seconds before starting to drive. *)
	if not StartDelayShortTOF.Q then								(* Stop bit set while on the home station and during the delay. *)
		StartWarning 	:= false;
		StopStartDelay 	:= false;
		StartDelayState := 0;
	end_if;
		
end_case;
		
(* Indicate start delay is active when a drive command is recieved. *)
DisplayStopString(INStatus:=StartWarning, StopString:=93, StopValue:=0);
END_FUNCTION_BLOCK