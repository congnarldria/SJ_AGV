FUNCTION_BLOCK STOPWORD_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
END_VAR

VAR_INPUT
END_VAR

VAR_OUTPUT
END_VAR

VAR
	WaitingForSteerWheelTurn : bool;
	Stop_RT : R_Trig;
	Stop_FT : F_Trig;
	TempValue : dint ; 
	StopTON : ton;	
END_VAR
(**************************************************************************************)
(* LOAD OPERATION STOP *)
(* Do not enter station w/o OP code *)
(*StopNoOPCode := NDC8.LoadOperation.OperationCode = 0 
				and NDC8.Automatic.ExecDriveCommand;
DisplayStopString(InStatus:=StopNoOPCode, StopString:=94, StopValue:=0);

*)

(**************************************************************************************)
(* Waiting for steering wheel to turn *)
(* If no other errors, it's most likely the steer wheel which is not within NDC8.Vehicle.WaitForWheelTurnMaxAngle. *)

WaitingForSteerWheelTurn := NDC8.Automatic.ExecDriveCommand
							and NDC8.CanOpenMaster.NMTState = 5
							and NDC8.CanOpenMaster.State = 0
							and NDC8.Position.Valid
							and not NDC8.Vehicle.Blocked
							and not NDC8.VehicleControl.QuickStop
							and not NDC8.VehicleControl.Stop
							and not NDC8.VehicleControl.EStop
							and not NDC8.VehicleControl.SensorStopEnable
							and NDC8.VehicleControl.SetSpeed = 0
							and abs(Input.SteerEncAngle - Output.SetValueSteer) > NDC8.Vehicle.WaitForWheelTurnMaxAngle;

DisplayStopString(InStatus:=WaitingForSteerWheelTurn, StopString:=138, StopValue:=0);

(*StopSteerSync	:= not INPUT.SteerEncSyncValid;*)
DisplayStopString(InStatus:=StopSteerSync, StopString:=181, StopValue:=0);


DisplayStopString(InStatus:=StopByOM_PLC, StopString:=200, StopValue:=0);
DisplayStopString(InStatus:=StopByErrorCode, StopString:=201, StopValue:=0);
DisplayStopString(InStatus:=StopBatLowOT, StopString:=202, StopValue:=0);
DisplayStopString(InStatus:=StopFindSync, StopString:=203, StopValue:=0);
DisplayStopString(InStatus:=StopRobotNotIdle, StopString:=204, StopValue:=0);
DisplayStopString(InStatus:=StopByBCD, StopString:=205, StopValue:=0);


DisplayStopString(InStatus:=StopLift, 				StopString:=210, StopValue:=0);
DisplayStopString(InStatus:=StopRear,				StopString:=211, StopValue:=0);
DisplayStopString(InStatus:=StopSafety, 			StopString:=212, StopValue:=0);
DisplayStopString(InStatus:=StopFailureCAN, 		StopString:=213, StopValue:=0);
DisplayStopString(InStatus:=StopStartDelay,	 		StopString:=214, StopValue:=0);
DisplayStopString(InStatus:=StopFlex, 				StopString:=215, StopValue:=0);
DisplayStopString(InStatus:=StopSoft, 				StopString:=216, StopValue:=0);
DisplayStopString(InStatus:=StopLoadChange,	 		StopString:=217, StopValue:=0);
DisplayStopString(InStatus:=StopObstacle, 			StopString:=218, StopValue:=0);
DisplayStopString(InStatus:=StopEStopChainError, 	StopString:=219, StopValue:=0);
DisplayStopString(InStatus:=StopSteerSync, 			StopString:=220, StopValue:=0);
DisplayStopString(InStatus:=StopEstopButton, 		StopString:=221, StopValue:=0);
DisplayStopString(InStatus:=StopSide, 				StopString:=222, StopValue:=0);
DisplayStopString(InStatus:=StopReset,				StopString:=223, StopValue:=0);
DisplayStopString(InStatus:=StopNoOpCode, 			StopString:=224, StopValue:=0);
DisplayStopString(InStatus:=StopManual, 			StopString:=225, StopValue:=0);
DisplayStopString(InStatus:=StopCharge, 			StopString:=226, StopValue:=0);
DisplayStopString(InStatus:=StopClamp, 				StopString:=227, StopValue:=0);
DisplayStopString(InStatus:=StopFailCode, 			StopString:=228, StopValue:=0);
DisplayStopString(InStatus:=StopResetButton, 		StopString:=229, StopValue:=0);
DisplayStopString(InStatus:=StopLoadOP, 			StopString:=230, StopValue:=0);
DisplayStopString(InStatus:=StopBumperFault, 		StopString:=231, StopValue:=0);
DisplayStopString(InStatus:=StopObstacleFault, 		StopString:=232, StopValue:=0);
DisplayStopString(InStatus:=StopTruckDriveSafeState,StopString:=233, StopValue:=0);
DisplayStopString(InStatus:=StopLS2000, 			StopString:=234, StopValue:=0);
DisplayStopString(InStatus:=StopHalt, 				StopString:=235, StopValue:=0);
DisplayStopString(InStatus:=StopLoadDroppedWhileUnloading, StopString:=236, StopValue:=0);
DisplayStopString(InStatus:=StopSpinningWheel, 		StopString:=237, StopValue:=0);
DisplayStopString(InStatus:=StopForkTooLow, 		StopString:=238, StopValue:=0);
DisplayStopString(InStatus:=StopForkTooHigh, 		StopString:=239, StopValue:=0);
DisplayStopString(InStatus:=StopForkFarTooHigh, 	StopString:=240, StopValue:=0);
DisplayStopString(InStatus:=StopChargeStationMissing, StopString:=241, StopValue:=0);

DisplayStopString(InStatus:=StopByCanErr_Node1, StopString:=244, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node2, StopString:=245, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node3, StopString:=246, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node4, StopString:=247, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node5, StopString:=248, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node6, StopString:=249, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node7, StopString:=250, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node8, StopString:=251, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node9, StopString:=252, StopValue:=0);
DisplayStopString(InStatus:=StopByCanErr_Node10, StopString:=253, StopValue:=0);

(**************************************************************************************)
(* QUICK STOP  (Stop with emergency deceleration ramp) 								  *)
(*NDC8.VehicleControl.QuickStop := StopFlex or StopObstacle or StopSafety;
*)
DisplayStopString(INStatus:=NDC8.VehicleControl.QuickStop, StopString:=179, StopValue:=0);  		


(**************************************************************************************)
(* STOP WORD sets stop signal 														  *)
NDC8.VehicleControl.Stop 	:= 	(Input.Auto and (DWORD_TO_BOOL(StopWord) or DWORD_TO_BOOL(StopWord2))) or
								(Input.Manual and NDC8.Mcd.Button8 = FALSE and (DWORD_TO_BOOL(StopWord) or DWORD_TO_BOOL(StopWord2)));
								(*NDC8.Mcd.Button8 = FALSE and ((DWORD_TO_BOOL(StopWord) or DWORD_TO_BOOL(StopWord2)));*)
NDC8.UserDefined.StopWord	:=	DWORD_TO_DINT(StopWord);
NDC8.OMPLC.StopWord			:=	DWORD_TO_INT(StopWord);

StopTON(IN:=NDC8.VehicleControl.Stop,PT:=t#10s);
Stop_RT(CLK:=StopTON.q);
if Stop_RT.Q and not StopStartDelay then
	TempValue:=DWord_To_DINT(StopWord);
end_if;

(* Send event that stopword has been cleared. * )
Stop_FT(CLK:=NDC8.VehicleControl.Stop);
if Stop_FT.q then
	EventQueue(EventCode:=101,Par1:=NDC8.Vehicle.VehicleID,Par2:=0,Par3:=0,Par4:=0);
end_if;
*)



















END_FUNCTION_BLOCK