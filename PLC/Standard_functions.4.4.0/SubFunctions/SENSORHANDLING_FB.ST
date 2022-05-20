FUNCTION_BLOCK SENSORHANDLING_FB
VAR_EXTERNAL

END_VAR

VAR_INPUT
	Input		: bool;
	EventID		: dint;
	StopStringID: dint;
	Enable		: bool;
	OnDelay		: time;
	OffDelay 	: time;
END_VAR

VAR_OUTPUT
	Stop	: bool;
END_VAR

VAR
	OnFilterTON	: TON;
	OffFilterTP: TP;
	StopRT		: R_Trig;
	Off_FT		: F_Trig;
END_VAR
(* filter indata with on delay *)
OnFilterTON(IN:=Input, PT:=OnDelay);

(* Off delay *)
OffFilterTP(IN:=OnFilterTON.q, PT:=OffDelay);

(* Set/reset or disable stop signal. *)
if not Enable then
	Stop:=false;
elsif OnFilterTON.Q then
	Stop:=true;
elsif not OffFilterTP.q then
	Stop:=false;
end_if;

(* generate events *)
StopRT(CLK:=Stop);
if StopRT.Q then
	;
end_if;

(* Display update *)
DisplayStopString(INStatus:=Stop, StopString:=StopStringID, StopValue:=0);


END_FUNCTION_BLOCK