FUNCTION_BLOCK DISPLAY_FB
VAR_EXTERNAL
	NDC8: NDC8_T;
END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR

END_VAR

(*   INFORMATION UPDATE FOR ALL TYPES OF DISPLAYS   *)


(*****************************************************************************************)
(* No Traffic Manager *) 
InStatus := NDC8.Automatic.CurrentOrderMode = 2;
DisplayStopString(INStatus:=InStatus, StopString:=175, StopValue:=0);				(* No Traffic Manager! *) 
DisplayStopString(INStatus:=InStatus, StopString:=176, StopValue:=0);			 	(* COLLISION RISK ! *)




(*****************************************************************************************)
(* SAFESTATE *)
INStatus := (NDC8.CanOpenMaster.State = 1) and (NDC8.CanOpenMaster.NMTState = 5);

DisplayStopString(INStatus:=INStatus, StopString:=112, StopValue:=0);
DisplayStopString(INStatus:=INStatus, StopString:=113, StopValue:=NDC8.CanOpenMaster.EMCY_NodeID);
DisplayStopString(INStatus:=INStatus, StopString:=114, StopValue:=NDC8.CanOpenMaster.EMCY_Code);
DisplayStopString(INStatus:=INStatus, StopString:=115, StopValue:=NDC8.CanOpenMaster.EMCY_ErrReg);
DisplayStopString(INStatus:=INStatus, StopString:=116, StopValue:=NDC8.CanOpenMaster.EMCY_Byte1);
DisplayStopString(INStatus:=INStatus, StopString:=117, StopValue:=NDC8.CanOpenMaster.EMCY_Byte2);
DisplayStopString(INStatus:=INStatus, StopString:=118, StopValue:=NDC8.CanOpenMaster.EMCY_Byte3);
DisplayStopString(INStatus:=INStatus, StopString:=119, StopValue:=NDC8.CanOpenMaster.EMCY_Byte4);
DisplayStopString(INStatus:=INStatus, StopString:=120, StopValue:=NDC8.CanOpenMaster.EMCY_Byte5);

DisplayStopString(INStatus:=INStatus, StopString:=130, StopValue:=0);



(*****************************************************************************************)
(* BLOCKED STATUS *)

INStatus 	:= (NDC8.Vehicle.Blocked and NDC8.BlockedInfo.BlockedById = 2);			(* SSIO *)
DisplayStopString(INStatus:=INStatus, StopString:=110, StopValue:=NDC8.BlockedInfo.IoId);

INStatus 	:= (NDC8.Vehicle.Blocked and NDC8.BlockedInfo.BlockedById = 3);			(* AGV *)

DisplayStopString(INStatus:=INStatus, StopString:=67, StopValue:=NDC8.BlockedInfo.Vehicle1);
(* No comm. with stationary system *)

InStatus 	:= not NDC8.Master.MasterLinkUp and NDC8.Automatic.CurrentOrderMode <> 2 ; 
DisplayStopString(INStatus:=InStatus, StopString:=104, StopValue:=0);			

(* Simulation Mode *)

InStatus 	:= (NDC8.Vehicle.SimulationMode); 
DisplayStopString(INStatus:=InStatus, StopString:=63, StopValue:=0);				




(*****************************************************************************************)
(* Tiller arm lower position *)

DisplayStopString(INStatus:=INPUT.TillerArmLowerPos, StopString:=82, StopValue:=0);

(*****************************************************************************************)
(* PLATFORM *)

InStatus := INPUT.PlatformNotUpperPos and not Input.TillerArmDown;
DisplayStopString(INStatus:=InStatus, StopString:=92, StopValue:=0);

(*****************************************************************************************)
(* GATE *)

InStatus := INPUT.GateOpen and not Input.TillerArmDown;
DisplayStopString(INStatus:=InStatus, StopString:=91, StopValue:=0);

(*****************************************************************************************)
(* Waiting for flexible distance information *)
InStatus := NDC8.LoadDocking.RequestDistance and not NDC8.VehicleControl.Moving;
DisplayStopString(INStatus:=InStatus, StopString:=182, StopValue:=0);

(*************************************************************************************)
(* WLAN signal below -75dB or no System Manager link. *)
InStatus := ndc8.wlan.SignalLevel < -75	and NDC8.Master.Mastercom = 'WLAN';
DisplayStopString(INStatus:=InStatus, StopString:=185, StopValue:=ndc8.wlan.SignalLevel);

(*************************************************************************************)
(* System Manager options *)(* Unknown *)(* Invalid options *)

InStatus := (ndc8.VehicleOptions.StatusID = 1 and NDC8.Automatic.CurrentOrderMode <> 2);		
DisplayStopString(INStatus:=InStatus, StopString:=186, StopValue:=0);

InStatus := (ndc8.VehicleOptions.StatusID = 2 and NDC8.Automatic.CurrentOrderMode <> 2);		
DisplayStopString(INStatus:=InStatus, StopString:=187, StopValue:=ndc8.vehicle.OptionClass);





END_FUNCTION_BLOCK