[IEC_IEC_NORM]
TYPE
(**** Inputs - Used to create variables to be mapped in Input_Map_FB ****)
	INPUT_T :
	STRUCT

	(* PUSH BUTTONS *)
		EStopReset_PB				: BOOL;
		TSKReset_PB					: BOOL;
		Reset_PB					: BOOL;
		Cancel_PB					: bool;
		Auto_PB						: BOOL;
		EstopStop_PB				: BOOL;
		ManualForkUp_PB				: bool;
		ManualForkDown_PB			: bool;
		ZeroSteerAngle_PB			: bool;
		ChangeSteerMode_PB			: bool;
		ChangeSteerMode_PB2			: bool;
		
	(* Process Mode *)
		StartMode					: bool;
		Auto						: bool; (* 8 *)
		Manual						: bool; (* 1 *)
		Semi						: bool; (* 2 *)
		PPA							: bool; (* 4 *)			
		
		AutoLoadDone				: bool;

	(* TRUCK *)
		BatteryLevel				: INT;
		LowBattery					: BOOL;
		TillerArmDown				: BOOL;
		TillerArmLowerPos			: BOOL;
		GateOpen					: BOOL;
		PlatformNotUpperPos			: BOOL;
		PlatformLowerPos			: BOOL;
		OperatorOnBoard				: bool;

	(* SAFETY *)
		SafetyScannerNoErrors		: BOOL;
		SafetyScannerSlowDown		: BOOL;
		SafetyScannerSlowDownRight	: BOOL;
		SafetyScannerSlowDownLeft	: BOOL;
		SafetyScannerStop1			: BOOL;
		SafetyScannerStop2			: BOOL;
		ObstacleScannerNoErrors		: BOOL;
		ObstacleScannerStop			: BOOL;
		RightWarning				: BOOL;
		LeftWarning					: BOOL;
		VerticalScannerStop1		: bool;
		VerticalScannerStop2		: bool;


	(* LOAD SENSORS *)
		LoadOnBoard					: Bool;
		
	(* OTHER *)
		AllOK						: BOOL;
		EmergencyStop				: BOOL;
		TractionSpeed				: DINT;
		TractionDistance			: INT;
		SteerEncAngle				: DINT;
		SteerEncSyncValid			: bool;
		ChargingDone				: bool;
		
		CreepOn : BOOL;
		SteerMode : DINT;
		
		
		SD_Forward : BOOL;
		SD_Backward : BOOL;
		
		SD_Right : BOOL;
		SD_Left : BOOL;
		
		DD_Right : BOOL;
		DD_Left : BOOL;
		
		BuzzerByPass : BOOL;
		
(* Display *)
		Display_BatteryLevel : WORD;
		Display_Temperature : WORD;
	END_STRUCT;	
END_TYPE


