FUNCTION_BLOCK NAVIGATION_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
END_VAR

VAR_INPUT
	AutoInsertNotInsideTargetSafety : bool;
	ModePPA : bool;
END_VAR

VAR_OUTPUT

END_VAR

VAR
	NavMethod : NavMethod_FB;
	PreviousSegmentID,
	NavMethodState: DINT;
	SegmentChange,
	WheelSpinning,
	NavlevelTrigger : Bool;
	NavlevelTrigger_RT,
	PositionKnown_RT : F_trig;
	PositionKnown_FT : F_trig;
	
	WheelSpinningTimer,
	SegmentChangeTimer : TON;
	
	
END_VAR
(*
if ndc8.SegmentTrigger.Value > 0 then
	NDC8.VehicleNavigator.SetNavMethod := ndc8.SegmentTrigger.Value;
end_if;

Case NavMethodState of
0: if ndc8.SegmentTrigger.Value <> NDC8.VehicleNavigator.NavMethod then
		NavMethodState := 10;
	end_if;
10:	NavMethod();
	if NavMethod.Finished or NavMethod.ErrorCode > 0 or NDC8.SegmentTrigger.Value = 0 then
		NavMethodState := 0;
	end_if;
end_case;
*)

InStatus:=NavMethod.ErrorCode > 0;
DisplayStopString(INStatus:=InStatus, StopString:=53, StopValue:=0);							(* Undefined mode. *)




(* NAVIGATION init.				NOTE! Error codes > 5 is not supported in VMC500. *)

InStatus	:=	AutoInsertNotInsideTargetSafety
				and not NDC8.VehicleControl.Moving; ;
DisplayStopString(INStatus:=InStatus, StopString:=43, StopValue:=0);							(* Autoinsert *)

InStatus 	:= (NDC8.NavInit.Error = 1); 
DisplayStopString(INStatus:=InStatus, StopString:=53, StopValue:=0);							(* Invalid init method *)

InStatus 	:= (NDC8.NavInit.Error = 3); 
DisplayStopString(INStatus:=InStatus, StopString:=54, StopValue:=0);							(* Target don't exist *)

InStatus 	:= (NDC8.NavInit.Error = 4); 
DisplayStopString(INStatus:=InStatus, StopString:=166, StopValue:=0);							(* Not supported *)

InStatus 	:= (NDC8.NavInit.Error = 5); 
DisplayStopString(INStatus:=InStatus, StopString:=66, StopValue:=0);							(* not in manual mode or semi manual *)

InStatus 	:= (NDC8.NavInit.Error = 6); 
DisplayStopString(INStatus:=InStatus, StopString:=168, StopValue:=0);							(* too few reflector bearings *)

InStatus 	:= (NDC8.NavInit.Error = 7); 
DisplayStopString(INStatus:=InStatus, StopString:=144, StopValue:=0);							(* bad distribution of bearings *)

InStatus 	:= (NDC8.NavInit.Error = 8); 
DisplayStopString(INStatus:=InStatus, StopString:=145, StopValue:=0);							(* reflector init failed in current search area *)

InStatus 	:= (NDC8.NavInit.Error = 9); 
DisplayStopString(INStatus:=InStatus, StopString:=169, StopValue:=0);							(* ambiguous position (more than one valid position in current search area) *)

InStatus 	:= (NDC8.NavInit.Error = 10); 
DisplayStopString(INStatus:=InStatus, StopString:=170, StopValue:=0);							(* init calculation aborted *)

InStatus 	:= (NDC8.NavInit.Error = 11); 
DisplayStopString(INStatus:=InStatus, StopString:=171, StopValue:=0);							(* agv is moving *)

InStatus 	:= (NDC8.NavInit.Error = 12); 
DisplayStopString(INStatus:=InStatus, StopString:=172, StopValue:=0);							(* position outside search area *)

InStatus 	:= (NDC8.NavInit.Error = 15); 
DisplayStopString(INStatus:=InStatus, StopString:=173, StopValue:=0);							(* no range measurements *)

InStatus 	:= (NDC8.NavInit.Error = 16); 
DisplayStopString(INStatus:=InStatus, StopString:=174, StopValue:=0);							(* bad range match *)

InStatus 	:= (NDC8.NavInit.Error = 17); 
DisplayStopString(INStatus:=InStatus, StopString:=191, StopValue:=0);							(* empty init area *)

InStatus 	:= (NDC8.NavInit.Error = 18); 
DisplayStopString(INStatus:=InStatus, StopString:=192, StopValue:=0);							(* multi oriented point *)



(* DETECT A VEHICLE WHICH IS STUCK 
With the NDC8 2.7 release introduced new parameters, which can be used for detecting a spinning wheel from the PLC. *)

WheelSpinning := ABS(NDC8.VehicleNavigator.CorrectionX) > 100;			(* If correcting above this value, for more than 10 seconds, *)	
WheelSpinningTimer(IN:=WheelSpinning, PT:= t#10s);

SegmentChange := PreviousSegmentID <> NDC8.LayoutPosition.Segment;		(* ...or does not change segment ID after two minutes *)
SegmentChangeTimer(IN:=SegmentChange, PT:= t#120s);
PreviousSegmentID := NDC8.LayoutPosition.Segment;

if NDC8.LayoutPosition.InSystem											(* ...when driving in automatic mode. *)
	and NDC8.Automatic.ExecDriveCommand
	and NDC8.VehicleControl.OperationMode = 0
	and NDC8.VehicleControl.SetSpeed <> 0
	and NDC8.VehicleControl.Moving
	and (WheelSpinningTimer.q or SegmentChangeTimer.q) then
      			StopSpinningWheel := true;								(* ...then stop the vehicle to avoid burning the motor and the wheel! *)
elsif Input.Reset_PB then                    (* Reset of the stop *)
    StopSpinningWheel := false;
end_if;

(* Display update *)
DisplayStopString(INStatus:=StopSpinningWheel, StopString:=86, StopValue:=0);





END_FUNCTION_BLOCK