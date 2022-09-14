FUNCTION_BLOCK SLOWDOWN_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
	INPUT : INPUT_T;

END_VAR

VAR_INPUT
	FlexSlowdown,
	LS2000Slowdown	: bool;
END_VAR

VAR_OUTPUT

END_VAR

VAR
	SlowDownSpeed : DINT;
	CurrentVehicleSpeed : DINT; 
	VehicleSlowDownSpeed : DINT;
	SlowDownTOF : TOF;
	SlowDownKeep : BOOL;	
END_VAR
(*************************************************************************************
 		SLOW DOWN 
**************************************************************************************)
SlowDownSpeed := NDC8.Vehicle.MaxSpeed / 2;


if abs(NDC8.VehicleControl.SetSpeed) < SlowDownSpeed then
	SlowDownSpeed := abs(NDC8.VehicleControl.SetSpeed);
end_if;

CurrentVehicleSpeed := SlowDownSpeed;

if CurrentVehicleSpeed < 100 then
	CurrentVehicleSpeed := 100;
end_if;

if FlexSlowDown then									(* Load handling, when entering a pallet *)
	NDC8.VehicleControl.SlowDownSpeed	:= 150;
elsif LS2000Slowdown  then
	NDC8.VehicleControl.SlowDownSpeed:= CurrentVehicleSpeed;
elsif INPUT.SafetyScannerSlowDown then					(* When SlowDown input is set, ramp down in steps *)
	NDC8.VehicleControl.SlowDownSpeed:= CurrentVehicleSpeed;
else 
	NDC8.VehicleControl.SlowDownSpeed:= CurrentVehicleSpeed;			(*  speed is 290 to give room for a little variation of current speed, 
																		to avoid going over 300 mm/s. *)
end_if;
	

(* Keep Slowdown bit a little while, after the slow down is released. *)
SlowDownKeep := (INPUT.SafetyScannerSlowDown
					or FlexSlowDown 										(* Load handling, when entering a pallet *)
					or LS2000Slowdown
					or StopReset)											(* Slow start after reset stop *)
				and NDC8.UserDefined.SlowDownDisable <> 2;				(* And SlowDown not disabled from user terminal/display. *)	 							
	
SlowDownTOF(IN := SlowDownKeep, Pt := t#3s);
NDC8.VehicleControl.SlowDown := SlowDownTOF.Q;



(* Generate events here for System Statistics KPI, to find places with frequent slow downs. *)









END_FUNCTION_BLOCK