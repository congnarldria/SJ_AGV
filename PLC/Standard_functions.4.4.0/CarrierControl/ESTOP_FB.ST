FUNCTION_BLOCK ESTOP_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
	INPUT : INPUT_T;
	
END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR
	EstopRT		 	: R_trig;
	EstopFT		 	: R_trig;
	EstopPBRT	 	: R_trig;
	BlackBox : BlackBox_FB;
END_VAR
(**************************************************************************************)
(* E-STOP BUTTONS: *)

StopEstopButton := INPUT.EstopStop_PB and NDC8.VehicleControl.OperationMode <> 1;	(* Estop push button in all modes except manual *)
StopReset		:= StopReset OR StopEstopButton;									(* This stop signal needs to be reset	*)


(* Display Vehicle E-Stopped *)
DisplayStopString(INStatus:=StopEstopButton, StopString:=8, StopValue:=0);

(* Event  Estop pushbutton ON *)
EStopPBRT(CLK:=StopEstopButton);
if EStopPBRT.Q then
	;
end_if;


(* Event  Estop ON *)


EStopRT(CLK:=NDC8.VehicleControl.Estop);
EStopFT(CLK:=NDC8.VehicleControl.Estop);
if EStopRT.Q then
	EventQueue(EventCode:=100,
			Par1:=NDC8.LayoutPosition.Segment,
			Par2:=0,
			Par3:=0,
			Par4:=0);
	NDC8.BlackBox.TrigReason:= 'E_STOP';
	BlackBox();		
	a:=TRACE_DINT('EventCode', EventQueue.EventCode);
end_if;




END_FUNCTION_BLOCK