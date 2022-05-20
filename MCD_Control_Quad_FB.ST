FUNCTION_BLOCK MCD_Control_Quad_FB
VAR_EXTERNAL
	NDC8:NDC8_T;
	Output : Output_T;
	
END_VAR

VAR_INPUT
END_VAR

VAR_OUTPUT
END_VAR

VAR
	ManSpeed:DINT;
	AutoInsert:BOOL;
	SDMode:Bool :=True;
   	DDMode:BOOL;
	Mode:DINT :=0;
	PlcAngle:DINT;
	

END_VAR

(**************************************************************************************)

(*MCD_CONTROL_QUAD *)
(**************************************************************************************)


(* If Auto insert and outside safety and Low speed button, enable auto insert *)
if (NDC8.VehicleControl.OperationMode=0) and NDC8.Mcd.Button5 and (NDC8.Autoinsert.StatusID=2) THEN
	    		(* Set autoinsert speed to 100mm/s 				*)
        AutoInsert:=TRUE;
else
    	AutoInsert:=False;				
end_if;



(****************** SteerMode ************************)

(* keep the same mode that was use in Auto *)
(* Check if wheels are in DD Mode positiion *)
IF (NDC8.VehicleControl.OperationMode=0) THEN
	IF ( ABS(NDC8.DCD_6.WheelAngle)>8500) and ( ABS(NDC8.DCD_8.WheelAngle)>8500) THEN
	   DDMode:=TRUE;
	   SDMode:=False;
	   Mode:=2;
	Else
	   SDMode:=TRUE;
	   DDMode:=False;
	   Mode:=0;
	END_IF;
END_IF;

IF (NDC8.VehicleControl.OperationMode=1) THEN
	(* select SD or Diff mode *)
	IF NDC8.Mcd.Button8 THEN
	   SDMode:=TRUE;
	   DDMode:=False;
	   Mode:=0;
	End_IF;

	IF NDC8.Mcd.Button9 THEN
	   DDMode:=TRUE;
	   SDMode:=False;
	   Mode:=2;
	End_IF;

	(* select Paralell or Anti Parallel SD mode *)   
	IF SDMODE and NDC8.Mcd.Button10 THEN
	   Mode:=0;
	END_IF;   

	IF SDMODE and NDC8.Mcd.Button11 THEN
	   Mode:=1;
	END_IF;  

END_IF;
 
   NDC8.Manual.PlcSteerMode:=Mode;

(*************** Select Operation Mode ********************)

(* Manual *) 
IF NDC8.Mcd.Button3 and NDC8.Mcd.Valid THEN
	 NDC8.Manual.PlcSelectMask := 23;			(*Set Select mask*)
	 NDC8.Manual.PLCSelect := True;				(*Enable*)
	 NDC8.Manual.PlcSetOperationMode:=1;
	 
ELSIF AUTOInsert THEN
	 NDC8.Manual.PlcSelectMask := 2;			(*Set Select mask*)
	 NDC8.Manual.PLCSelect := True;				(*Enable*)
	 NDC8.Manual.PlcSetOperationMode:=0;

(*AUTO *)
Else NDC8.Manual.PlcSetOperationMode:=0;
     NDC8.Manual.PlcSelectMask := 4;			(*Set Select mask*)
	 NDC8.Manual.PLCSelect := True;
END_IF;

(************************* Manual Steer Angle ************************) 

(* Manual SD Mode Steer Angle / MDC < 5 deg gives 0 deg *)
IF (NDC8.VehicleControl.OperationMode=1) THEN
	IF SDMode  Then
		if ((ABS(NDC8.Mcd.Angle))<500)  then  
			NDC8.Manual.PLCAngle :=0;					(*Set angle to 0*)
		elsif (NDC8.VehicleControl.OperationMode=1) and (NDC8.Mcd.Angle>0) THEN
		    	NDC8.Manual.PLCAngle:=(NDC8.Mcd.Angle-500)/2;
		elsif (NDC8.VehicleControl.OperationMode=1) and (NDC8.Mcd.Angle<0) THEN
		    	NDC8.Manual.PLCAngle:=(NDC8.Mcd.Angle+500)/2;		
		end_if;

	(* Manual DD Mode Steer Angle / MDC < 5 deg gives 0 deg *)
	Elsif DDMode   Then     
	    PlcAngle:=((ABS(NDC8.Mcd.Angle))-500);     (* Angle starts with 0 deg for MCD at 5 deg*) 
	    IF (ABS(NDC8.Mcd.Angle))<500 THEN
	   		 	NDC8.Manual.PlcAngle:=0;					(* +/- 5 deg deadzone on MCD for going straight *)
		Elsif   NDC8.Mcd.Angle>0 THEN						(*Left or Right ? *)
	    		NDC8.Manual.PlcAngle:=Min(PlcAngle,9000);  (* PLCAngle starts with 0 deg for MCD at 5 deg, and goes up to 90 deg for full turn on MCD *)
		ELSE	NDC8.Manual.PlcAngle:=-Min(PlcAngle,9000);
		END_IF;

	END_IF;

Else
    	NDC8.Manual.PLCAngle:=0;	
END_IF;


(************************* Manual Speed ************************)

(* Speed in SD Mode  *)  
IF  (NDC8.VehicleControl.OperationMode=1) THEN

	IF SDMode Then
		IF NDC8.Mcd.Button6 and (NDC8.VehicleControl.OperationMode=1)THEN
				  ManSpeed:=NDC8.Mcd.McdHighSpeed;
		Elsif NDC8.Mcd.Button5 and (NDC8.VehicleControl.OperationMode=1)THEN
				  ManSpeed:=NDC8.Mcd.McdLowSpeed;
		ElsIf     AutoInsert THEN
		          ManSpeed:=100;
		Else	  ManSpeed:=0;	  
		end_if; 

	(* Speed in DD Mode  *)
	ElsIf DDMode THEN
		IF NDC8.Mcd.Button6 and ((ABS(NDC8.Manual.PlcAngle)) < 1500 )THEN
		  	   ManSpeed:=500;
		ElsIF  NDC8.Mcd.Button6 and ((ABS(NDC8.Manual.PlcAngle)) < 3000 )THEN
		  	   ManSpeed:=300;
		ElsIF  (NDC8.Mcd.Button6 or NDC8.Mcd.Button5) and ((ABS(NDC8.Manual.PlcAngle)) < 6000 )THEN
		  	   ManSpeed:=200;
		ElsIF  NDC8.Mcd.Button6 or NDC8.Mcd.Button5 THEN
		  	   ManSpeed:=100;	   
		ElsIf   AutoInsert Then
				ManSpeed:=100;
	    ELSE 	ManSpeed:=0;
		END_IF;
	END_IF;

Else	
			ManSpeed:=0;
END_IF; 

	
(********** Speed and Direction ***********)
IF NDC8.Mcd.Button4 or AutoInsert THEN
   		NDC8.Manual.PlcSpeed:=ManSpeed;
ELSE    NDC8.Manual.PlcSpeed:=-ManSpeed;
END_IF;
   
 
IF (NDC8.VehicleControl.OperationMode=0) and Not AutoInsert or	NDC8.VehicleControl.Estop THEN
    NDC8.Manual.PlcSpeed:=0;
END_IF;	



(****************Emergency ovveride**********************)

IF NDC8.Mcd.Button7 and (NDC8.VehicleControl.OperationMode=1) and NDC8.Mcd.Valid THEN
  		 OUTPUT.MCD_EmergOveride_o:=TRUE;
ELSE	 OUTPUT.MCD_EmergOveride_o:=FALSE;	
END_IF;





 



















END_FUNCTION_BLOCK