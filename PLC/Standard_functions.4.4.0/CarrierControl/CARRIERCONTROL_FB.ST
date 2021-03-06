FUNCTION_BLOCK CARRIERCONTROL_FB
VAR_EXTERNAL
	(** IN **)
	NDC8 : NDC8_T;
	
END_VAR

VAR_INPUT
	FlexSlowdown,
	LS2000Slowdown	: bool;
END_VAR

VAR_OUTPUT
	AutoInsertNotInsideTargetSafety : bool;
	AutoinsertInProgress			: bool;
	StartDelayStartWarning			: bool;
END_VAR

VAR
	
	AutoInsert : AutoInsert_FB;
	SlowDown : Slowdown_FB;
	StartDelay : StartDelay_FB;
	EStopFB : EStop_FB;
	ResetButtonFB : ResetButton_FB;

	MasterLink_TOF	: TOF;
	
	MasterLinkUp_RT,
	BbxDone_RT,
	NDC8LibFail_RT,
	StandardFBFail_RT		: R_Trig;
	
	MasterLink_FT		: F_Trig;
	
	to_bytes : NDC8_STRING_TO_BYTES; 
	to_dec : ASCII_TO_DEC;
	AccessPointB5,
	AccessPointB6,
	AccessPointB5b1A,
	AccessPointB5b2A,
	AccessPointB6b1A,
	AccessPointB6b2A,
	AccessPointB5b1,
	AccessPointB6b1,
	AccessPointB5b2,
	AccessPointB6b2,
	MasterLink		 : dint;
	NDC8LibFail,
	StandardFBFail : bool;

	BlackboxFB : Blackbox_FB;

END_VAR
(*
------------------------------------------------------------------------------------                              
 CARRIER_CONTROL_FB                    
 ------------------      
             
 Description:                     
 Handles symbols essential for driving the vehicle
 -------------------------------------------------------------------------------------*)

(**************************************************************************************)

AutoInsert();	
Slowdown(	FlexSlowdown := FlexSlowdown,
			LS2000Slowdown := LS2000Slowdown); 			(* Slow down vehicle *)
StartDelay();			(* Start delay after estop *)
EStopFB();
ResetButtonFB();


(**************************************************************************************)




(* Version verification  *)


(**************************************************************************************)
(* ALTRENATIVE CREEP DISTANCE  *)
if NDC8.UserDefined.NormalCreepDistance = 0 then
	NDC8.UserDefined.NormalCreepDistance := NDC8.Vehicle.CreepDistance;
end_if;


(**************************************************************************************)
(* Do not allow download from Application Designer while vehicle is moving *)
NDC8.VehicleControl.PreventAppDownload := NDC8.VehicleControl.Moving;


(**************************************************************************************)
(* Events 		 *)

(* Convert Access points MAC adress xx.xx.xx.xx.b1.b2 from ASCII to dint *)

to_bytes(str:= NDC8.Wlan.AccessPoint);					(* Converts string to bytes *)
AccessPointB5b1A := byte_to_dint(to_bytes.bytes[13]);
AccessPointB5b2A := byte_to_dint(to_bytes.bytes[14]);
AccessPointB6b1A := byte_to_dint(to_bytes.bytes[16]);
AccessPointB6b2A := byte_to_dint(to_bytes.bytes[17]);

to_dec(ASCII:= AccessPointB5b1A);						(* Convert from ASCII to decimal *)
AccessPointB5b1  := to_dec.dec;
to_dec(ASCII:= AccessPointB5b2A);
AccessPointB5b2  := to_dec.dec;
to_dec(ASCII:= AccessPointB6b1A);
AccessPointB6b1  := to_dec.dec;
to_dec(ASCII:= AccessPointB6b2A);
AccessPointB6b2  := to_dec.dec;


MasterLink_TOF(IN:=NDC8.Master.MasterLinkUp, PT:=t#10s);(* Connection is down for more than 10 seconds. *)	
MasterLink_FT(CLK:= MasterLink_TOF.q); 					(* Only generate event when connection is lost, not during boot. *)
Case MasterLink of 
	0: 	if NDC8.Master.MasterLinkUp then
		(* Found connection to system manager. *)
			MasterLink := 10;
		end_if;
	10: if MasterLink_FT.q then									(* Lost connection to system manager. *)
		BbxTrig := (NDC8.VehicleControl.OperationMode=0);		(* Create blackbox if vehicle is in Automatic Mode. *)
		a:=TRACE_bool('BbxTrig',BbxTrig);
		a:=TRACE_string('MasterLink down');
		NDC8.Blackbox.TrigReason:='MasterLink down';
		MasterLink := 0;
	end_if;
end_case;

(**************************************************************************************)
(* Stop while master controller is minimizes the segments allocated, during detouring. TS40 in NDC demo. *)

if NDC8.VehicleControl.HaltRequest and not StopHalt then 
    StopHalt:= True; 
    NDC8.VehicleControl.HaltRequestDone:=True; 
elsif not NDC8.VehicleControl.HaltRequest and StopHalt then 
    NDC8.VehicleControl.HaltRequestDone:=False; 
    StopHalt:= False; 
end_if;



(**************************************************************************************)
(* 			DEBUG handling *)

if BbxTrig then
	BlackboxFB();
end_if;

BbxDone_RT(CLK:=BlackboxFB.finished);
if BbxDone_RT.q then
	BbxTrig := false;
	a:=TRACE_bool('BbxTrig',BbxTrig);
	NDC8.Blackbox.TrigReason:='Default';
end_if;


(**************************************************************************************)
(* 			Outputs *)
AutoinsertInProgress			:= Autoinsert.InProgress;
AutoInsertNotInsideTargetSafety := AutoInsert.NotInsideTargetSafety;
StartDelayStartWarning			:= StartDelay.StartWarning;





END_FUNCTION_BLOCK