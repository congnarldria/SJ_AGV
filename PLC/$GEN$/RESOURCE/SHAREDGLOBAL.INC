$INCLUDE_FILE


(* GLOBALE TYPEN *)



(* PROJEKT TYPEN *)

TYPE TRUCK_T :
	STRUCT
		HasClamp			: bool;		
		HasInitialLift		: bool;
	END_STRUCT;
END_TYPE

TYPE OUTPUT_T :
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

TYPE INPUT_T :
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



(* GLOBALE PROTOTYPEN *)



(* PROJEKT PROTOTYPEN *)

$INCLUDE "C:\PROGRAMDATA\INFOTEAM SOFTWARE\OPENPCS2008\OPENPCS.520\LIB\NDC8LIB.1.2.8\$GEN$\EVENTQUEUE_FB.PTT"
$INCLUDE "C:\USERS\USER\DESKTOP\CVC700\SJ_2SD_G5_CVC700\PLC\$GEN$\TIMER_FB.PTT"
$INCLUDE "C:\USERS\USER\DESKTOP\CVC700\SJ_2SD_G5_CVC700\PLC\$GEN$\DISPLAYSTOPSTRING_FB.PTT"


(* EXTERNE POEs *)



$END_INCLUDE_FILE
