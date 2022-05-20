[IEC_IEC_NORM]
TYPE
(**** Outputs - Used to create variables to be mapped in Output_Map_FB ****)
	OUTPUT_T :
	STRUCT
(* LAMPS and BUZZERS *)
		PositionKnownLamp				: BOOL;		(* Green	*)
		EmergencyStopLamp				: BOOL;		(* Red 		*)
		LoadOnBoardLamp					: BOOL;		(* Yellow	*)
		FrontLeftLamp					: BOOL;
		FrontRightLamp					: BOOL;
		RearLeftLamp					: BOOL;
		RearRightLamp					: BOOL;
		InSystemLamp					: BOOL;		(* Blue		*)
		ResetButtonLamp					: BOOL;		(* White	*)
		AutoLamp						: BOOL;
		FastBuzzer						: BOOL;
		SlowBuzzer						: BOOL;
		WarningLightTop					: BOOL;
		WarningBuzzerTop				: BOOL;
		OPTBuzzer						: BOOL;
		Buzzer							: BOOL;
		
(* SAFETY *)
		RightBumperA					: BOOL;
		RightBumperB					: BOOL;
		RightBumperC					: BOOL;
		RightBumperD					: BOOL;
		LeftBumperA						: BOOL;
		LeftBumperB						: BOOL;
		LeftBumperC						: BOOL;
		LeftBumperD						: BOOL;
		ObstacleSensorA					: BOOL;
		ObstacleSensorB					: BOOL;
		ObstacleSensorC					: BOOL;
		ObstacleSensorD					: BOOL;
		BumperBypass					: BOOL;
		PalletDetectSensorInputA		: BOOL;
		PalletDetectSensorInputB		: BOOL;
		PalletDetectSensorInputC		: BOOL;
		PalletDetectSensorInputD		: BOOL;
		VerticalScannerAreaControlA 	: bool;
		VerticalScannerAreaControlB 	: bool;
		VerticalScannerAreaControlC 	: bool;
		SafetyScannerAreaControlA1		: bool;
		SafetyScannerAreaControlB1		: bool;
		SafetyScannerAreaControlA2		: bool;
		SafetyScannerAreaControlB2		: bool;
		
(*	FORKS  *)
		InitialLiftDown					: BOOL;
		InitialLiftUp					: BOOL;
		ForkRaise						: BOOL;
		ForkLower						: BOOL;
	
(*	OTHER *)
		TractionForwardControl			: BOOL;
		TractionReverseControl			: BOOL;
		SetValueTraction				: DINT;
		SetValueSteer					: DINT; 
		ChargePlatesRelay				: bool;
		
		MCD_EmergOveride_o				: BOOL;
	END_STRUCT;
END_TYPE


