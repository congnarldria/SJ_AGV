FUNCTION_BLOCK Timer_FB
VAR_OUTPUT
	Error : bool;
	Warning : bool;
	Info : bool;
	Display : bool;
	SlowBeep : bool;

END_VAR


VAR
	TimerError 		: blink;
	TimerWarning 	: blink;
	TimerInfo 		: blink;
	TimerDisplay	: blink;
	TimerSlowBeep	: blink;
END_VAR
(*
------------------------------------------------------------------------------------   
 FREERUN
 -------
 
                     
 Description:                     
 Creates different outputs that will look like a freerunning timer. 
 Outputs will toggle with different timebase.
 They are all defined globally.
------------------------------------------------------------------------------------   *)

TimerError	(CYCLE :=t#240ms,RUN:=true);
TimerWarning(CYCLE :=t#480ms,RUN:=true);
TimerInfo	(CYCLE :=t#960ms,RUN:=true);
TimerDisplay(CYCLE :=t#2s,RUN:=true);
TimerSlowBeep(CYCLE :=t#5s,RUN:=true);

Error		:= TimerError.Q1;
Warning	:= TimerWarning.Q1;
Info		:= TimerInfo.Q1;
Display	:= TimerDisplay.Q1;
SlowBeep	:= TimerSlowBeep.Q1;

END_FUNCTION_BLOCK