FUNCTION_BLOCK AutoInsert_FB
VAR_EXTERNAL
	NDC8 : NDC8_T;
	INPUT : INPUT_T;
	
END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT
		InProgress : BOOL;
		NotInsideTargetSafety : BOOL;
		Failed : BOOL;

END_VAR

VAR
	
END_VAR
(*************************************************************************************
 		Automatic insert of vehicle into system 
**************************************************************************************)


(**************************************************************************************)
(* Make readable/understandable signals 

	OUTPUTS	*)
InProgress				:= (NDC8.Autoinsert.Target>0) and not NDC8.LayoutPosition.InSystem;
NotInsideTargetSafety 	:= InProgress and not NDC8.Autoinsert.OnSegment;
Failed					:= (InProgress and NDC8.Guidance.OutsideSafetyZone)
														   or 
														   (
																NDC8.Opt.VehicleStatusID = 5
																or NDC8.Opt.VehicleStatusID = 11
														   );
											   
											   
case NDC8.VehicleControl.OperationMode of
	0: 												(* In automatic mode 							*)
		if INPUT.Reset_PB then		(* if reset button pressed 						*)
			NDC8.Manual.PlcSpeed := 100;			(* Set autoinsert speed to 100mm/s 				*)
		else
			NDC8.Manual.PlcSpeed := 0;				
		end_if;
	
	2:	
		if ndc8.mcd.Button4 and ndc8.mcd.Button5 then	(* forward slow *)
			ndc8.manual.PlcSpeed := 300 ;
		else
			ndc8.manual.PlcSpeed := 0 ;
		end_if;	
else 
	;												(* Don't override MCD in semi mode. 			*)
end_case;
	

END_FUNCTION_BLOCK