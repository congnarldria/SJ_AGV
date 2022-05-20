[IEC_IEC_NORM]
TYPE

(**** TRUCK ****)
	TRUCK_T :
	STRUCT
		HasClamp			: bool;		
		HasInitialLift		: bool;
	END_STRUCT;
	

(**** ENCODER supervision ****)
	EncDebug_T				:
	STRUCT
		Command:DINT;
		LowLimit:DINT;
		EncVal:DINT;
		WarningTime:DINT;
		WarningTimeMax:DINT;	
	END_STRUCT;

	Enc_T				:
	STRUCT
		DebugStart:EncDebug_T;
		DebugEnd:EncDebug_T;
		Fault : bool ;
	END_STRUCT;
	
END_TYPE


