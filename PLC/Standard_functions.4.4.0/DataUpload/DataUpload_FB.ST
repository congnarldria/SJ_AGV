FUNCTION_BLOCK DataUpload_FB
VAR_EXTERNAL
ndc8 : NDC8_T;

UploadData_ModBus_ValueWord:ARRAY[1..500] OF Word;
UploadData_ModBus_ValueBOOL:ARRAY[1..400] OF BOOL;

ConvWord:WORD;			(*Sum of the two first bytes*)

ConvByteL:Byte;			(*Low byte*)
ConvByteH:Byte;			(*High byte*)

ConvBit0:BOOL;			(*		 1 	    *)
ConvBit1:BOOL;			(*		 2 		*)
ConvBit2:BOOL;			(*		 4 		*)
ConvBit3:BOOL;			(*		 8 		*)
ConvBit4:BOOL;			(*	    10 		*)
ConvBit5:BOOL;			(*	    20 		*)
ConvBit6:BOOL;			(*	    40 		*)
ConvBit7:BOOL;          (*	    80 		*)
ConvBit8:BOOL;			(*		100     *)
ConvBit9:BOOL;			(*		200 	*)
ConvBit10:BOOL;			(*		400  	*)
ConvBit11:BOOL;			(*		800 	*)
ConvBit12:BOOL;			(*	   1000 	*)
ConvBit13:BOOL;			(*	   2000 	*)
ConvBit14:BOOL;			(*	   4000 	*)
ConvBit15:BOOL;         (*	   8000 	*)

(*BeijerSetParameters:BeijerSetParameters_T;*)

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR



Angle_DINT : DINT;
Angle_REAL : REAL;



DataUpload : DataUpload_ModbusTCPIP_FB;

END_VAR
(****************************************************************************)

(* Update Data *)

(* Scanner_x *)
ConvDINT := NDC8.LS2000.X;
UploadData_ModBus_ValueWord [2]:=ConvWord2;
UploadData_ModBus_ValueWord [1]:=ConvWord;

(* Scanner_y *)
ConvDINT := NDC8.LS2000.Y;
UploadData_ModBus_ValueWord [4]:=ConvWord2;
UploadData_ModBus_ValueWord [3]:=ConvWord;


(* Scanner_t *)
Angle_REAL := NDC8.LS2000.Angle * 100.0;
Angle_DINT := REAL_TO_DINT(Angle_REAL);

ConvDINT := Angle_DINT;
UploadData_ModBus_ValueWord [6]:=ConvWord2;
UploadData_ModBus_ValueWord [5]:=ConvWord;

(* Max Speed *)
ConvDINT := NDC8.Vehicle.MaxSpeed;
UploadData_ModBus_ValueWord [8]:=ConvWord2;
UploadData_ModBus_ValueWord [7]:=ConvWord;


(* Enc1Scal *)
ConvUDINT := NDC8.DCD_6.SteerEncScale;
UploadData_ModBus_ValueWord [10]:=ConvWord2;
UploadData_ModBus_ValueWord [9]:=ConvWord;


(* Enc1Offs *)
ConvDINT := INT_TO_DINT(NDC8.DCD_6.SteerEncOffset);
UploadData_ModBus_ValueWord [12]:=ConvWord2;
UploadData_ModBus_ValueWord [11]:=ConvWord;

(* Enc3Scal *)
ConvUDINT := NDC8.DCD_8.SteerEncScale;
UploadData_ModBus_ValueWord [14]:=ConvWord2;
UploadData_ModBus_ValueWord [13]:=ConvWord;


(* Enc3Offs *)
ConvDINT := INT_TO_DINT(NDC8.DCD_8.SteerEncOffset);
UploadData_ModBus_ValueWord [16]:=ConvWord2;
UploadData_ModBus_ValueWord [15]:=ConvWord;


(* Enc2Scal *)
ConvUDINT := NDC8.DCD_5.DriveEncScale;
UploadData_ModBus_ValueWord [18]:=ConvWord2;
UploadData_ModBus_ValueWord [17]:=ConvWord;


(* Enc4Scal *)
ConvUDINT := NDC8.DCD_7.DriveEncScale;
UploadData_ModBus_ValueWord [20]:=ConvWord2;
UploadData_ModBus_ValueWord [19]:=ConvWord;


(* Batt Low Voltage *)
ConvDINT := NDC8.UserDefined.Integer32_50_BattLowVol;
UploadData_ModBus_ValueWord [22]:=ConvWord2;
UploadData_ModBus_ValueWord [21]:=ConvWord;


(* TravelDistance *)
ConvDINT := NDC8.UserDefined.Integer32_55_TravelDistance;
UploadData_ModBus_ValueWord [28]:=ConvWord2;
UploadData_ModBus_ValueWord [27]:=ConvWord;


(* LS2000 used Time Min *)
ConvDINT := NDC8.UserDefined.Integer32_60_LS2000_Attached_M;
UploadData_ModBus_ValueWord [30]:=ConvWord2;
UploadData_ModBus_ValueWord [29]:=ConvWord;

(* LS2000 used Time Hour *)
ConvDINT := NDC8.UserDefined.Integer32_59_LS2000_Attached_H;
UploadData_ModBus_ValueWord [32]:=ConvWord2;
UploadData_ModBus_ValueWord [31]:=ConvWord;

(* LS2000 used Time Day *)
ConvDINT := NDC8.UserDefined.Integer32_58_LS2000_Attached_D;
UploadData_ModBus_ValueWord [34]:=ConvWord2;
UploadData_ModBus_ValueWord [33]:=ConvWord;


(* Navigation Level *)
ConvDINT := NDC8.Position.NavLevel;
UploadData_ModBus_ValueWord [36]:=ConvWord2;
UploadData_ModBus_ValueWord [35]:=ConvWord;
	
	
(* AGV Drive Mode *)
UploadData_ModBus_ValueWord [41] := DINT_TO_WORD(Input.SteerMode);

(* Front Drive Current *)
UploadData_ModBus_ValueWord [42] := INT_TO_WORD(NDC8.DCD_5.TorqueCurrentReference);

(* Front Steer Current *)
UploadData_ModBus_ValueWord [43] := INT_TO_WORD(NDC8.DCD_6.TorqueCurrentReference);

(* Rear Drive Current *)
UploadData_ModBus_ValueWord [44] := INT_TO_WORD(NDC8.DCD_7.TorqueCurrentReference);

(* Rear Steer Current *)
UploadData_ModBus_ValueWord [45] := INT_TO_WORD(NDC8.DCD_8.TorqueCurrentReference);

(* Drive Current Diff*)
UploadData_ModBus_ValueWord [46] := INT_TO_WORD(NDC8.DCD_5.TorqueCurrentReference - NDC8.DCD_7.TorqueCurrentReference);

(* Steer Current Diff*)
UploadData_ModBus_ValueWord [47] := INT_TO_WORD(NDC8.DCD_6.TorqueCurrentReference - NDC8.DCD_8.TorqueCurrentReference);
	
	
(* Set Parameters *)
if UploadData_ModBus_ValueBOOL [1] = TRUE then
	(* Scanner_x *)
	ConvWord2 := UploadData_ModBus_ValueWord [52];
	ConvWord := UploadData_ModBus_ValueWord [51];

	NDC8.LS2000.X := ConvDINT;
	
	(* Scanner_y *)
	ConvWord2 := UploadData_ModBus_ValueWord [54];
	ConvWord := UploadData_ModBus_ValueWord [53];

	NDC8.LS2000.Y := ConvDINT;
	
	(* Scanner_t *)
	ConvWord2 := UploadData_ModBus_ValueWord [56];
	ConvWord := UploadData_ModBus_ValueWord [55];

	Angle_DINT := ConvDINT;
	
	Angle_REAL := DINT_TO_REAL(Angle_DINT) / 100.0;
	
	NDC8.LS2000.Angle := Angle_REAL;
	
	
	(* Max Speed *)
	ConvWord2 := UploadData_ModBus_ValueWord [58];
	ConvWord := UploadData_ModBus_ValueWord [57];

	NDC8.Vehicle.MaxSpeed := ConvDINT;
	
	
	(* Enc1Scal *)
	ConvWord2 := UploadData_ModBus_ValueWord [60];
	ConvWord := UploadData_ModBus_ValueWord [59];

	NDC8.DCD_6.SteerEncScale := ConvUDINT;
	
	(* Enc1Offs *)
	ConvWord2 := UploadData_ModBus_ValueWord [62];
	ConvWord := UploadData_ModBus_ValueWord [61];

	NDC8.DCD_6.SteerEncOffset := DINT_TO_INT(ConvDINT);
	
	(* Enc3Scal *)
	ConvWord2 := UploadData_ModBus_ValueWord [64];
	ConvWord := UploadData_ModBus_ValueWord [63];

	NDC8.DCD_8.SteerEncScale := ConvUDINT;
	
	(* Enc3Offs *)
	ConvWord2 := UploadData_ModBus_ValueWord [66];
	ConvWord := UploadData_ModBus_ValueWord [65];

	NDC8.DCD_8.SteerEncOffset := DINT_TO_INT(ConvDINT);
	
	(* Enc2Scal *)
	ConvWord2 := UploadData_ModBus_ValueWord [68];
	ConvWord := UploadData_ModBus_ValueWord [67];

	NDC8.DCD_5.DriveEncScale := ConvUDINT;
	
	(* Enc4Scal *)
	ConvWord2 := UploadData_ModBus_ValueWord [70];
	ConvWord := UploadData_ModBus_ValueWord [69];

	NDC8.DCD_7.DriveEncScale := ConvUDINT;
	
	(* Batt Low Voltage *)
	ConvWord2 := UploadData_ModBus_ValueWord [72];
	ConvWord := UploadData_ModBus_ValueWord [71];

	NDC8.UserDefined.Integer32_50_BattLowVol := ConvDINT;
	
	UploadData_ModBus_ValueBOOL [1] := FALSE;
end_if;
	
(****************************************************************************)
(*		Required for sending data to the display							*)

DataUpload();


(****************************************************************************)









END_FUNCTION_BLOCK