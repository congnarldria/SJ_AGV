FUNCTION_BLOCK DisplayStopString_FB
VAR_EXTERNAL
	NDC8: NDC8_T;
	
END_VAR

VAR_INPUT
	INStatus:BOOL;
	StopString:DINT;
	StopValue:DINT:=0;

END_VAR

VAR_OUTPUT
	CurrentString : DINT;
	CurrentValue : DINT	:= 0;
	Count : DINT := 0;
END_VAR

VAR

	DisplayStopStringIx : DINT;
	DisplayStopStringNextIx : DINT;
	DisplayStopStringA:ARRAY[0..300,0..1] of DINT;
	DisplayStopStringUpdateRT : R_Trig;

END_VAR

(* update if new status *)
if INStatus XOR (DisplayStopStringA[StopString,0]<>0) then

	if INStatus then
		DisplayStopStringA[StopString,0]	:= StopString;
		DisplayStopStringA[StopString,1]	:= StopValue;
		Count								:= Count+1;
	else
		DisplayStopStringA[StopString,0]	:= 0;
		DisplayStopStringA[StopString,1]	:= 0;
		Count								:= Count-1;
	end_if;

end_if;




(* Select Stop String *)
DisplayStopStringUpdateRT(CLK:=Timer.Display);
if 	DisplayStopStringUpdateRT.Q 
	and DisplayStopStringA[DisplayStopStringNextIx,0] <> 0
then
	DisplayStopStringIx 	:= DisplayStopStringNextIx;
	DisplayStopStringNextIx := (DisplayStopStringIx+1) MOD 255;
end_if;


(* preselect next value *)
if DisplayStopStringA[DisplayStopStringNextIx,0] = 0  then
	DisplayStopStringNextIx	:= (DisplayStopStringNextIx+1) MOD 255;
end_if;


(* setup return *)
CurrentString	:= DisplayStopStringA[DisplayStopStringIx,0];
CurrentValue	:= DisplayStopStringA[DisplayStopStringIx,1];


END_FUNCTION_BLOCK