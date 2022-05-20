FUNCTION_BLOCK OPERATIONFAIL_FB
VAR_EXTERNAL   
	(* IN *)    
	NDC8: NDC8_T;  

END_VAR  

VAR    
	Failstate:dINT;
	LoadOpDone:LoadOpDone_FB;
END_VAR

VAR_INPUT
	FailCode:DINT;
END_VAR

VAR_OUTPUT
	Finished:bool:=false;
END_VAR
(*
------------------------------------------------------------------------------------                              
 OPERATION FAIL                    
 -----------          
                

 Description:                     
 	If load operation fails, fail code is sent to the stationary system.
 

-------------------------------------------------------------------------------------*)

case Failstate of
	0:	Failstate := 1;
		Finished:= false;
		
	1: 	(* Cancel and LoadOp Clean-up required *)
		if 	NDC8.LoadDocking.OnTarget				
				or NDC8.VehicleControl.OperationMode <> 0
			then
				Failstate := 2;						

		elsif NDC8.LoadOperation.OperationCode = 0 	then				(* will not reach OnTarget *)
																(* Cancel and LoadOp clean-up NOT required *)
				Failstate := 3;						
		end_if;

	2:	(* Clean up LoadOp for cancel *)
		LoadOpDone(ErrorCode:=FailCode, Result:=NDC8.LayoutPosition.Distance);	(* Send failcode *)
		if LoadOpDone.Finished then 										(* Move on when LoadOp Done	*)
			Failstate := 3;
		end_if;

	3:	(* Cancel Comlpete, run handshake and reset cancel state *)
		Finished:= true;
		Failstate := 0;
end_case;


END_FUNCTION_BLOCK