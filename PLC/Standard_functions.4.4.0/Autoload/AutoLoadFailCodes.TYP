[IEC_IEC_NORM]
TYPE
	AutoLoadFailCodes_T:
		STRUCT
			FailCode_OK						: word	:= 16#0000;
			FailCode_AGV_HalfLoad			: word	:= 16#0001;		(* Load is on the forks, but not fully. Manual handling and reset required! *)
			FailCode_OPNoSupport 			: word	:= 16#0002;
			FailCode_OpCancel 				: word	:= 16#0004;
			FailCode_InvalidOP 				: word	:= 16#0008;
			FailCode_AGVIsLoaded 			: word	:= 16#0010;		
			FailCode_STNIsEmpty 			: word	:= 16#0020;
			FailCode_AGVIsNotLoaded			: word	:= 16#0040;		
			FailCode_STNIsFull 				: word	:= 16#0080;
			FailCode_FirstPalletTooHigh		: word	:= 16#0100;
			FailCode_NoSecondPallet			: word	:= 16#0200;
			FailCode_SecondPalletTooLow		: word	:= 16#0400;
			FailCode_PalletOnInitialLift	: word	:= 16#0800;
			FailCode_NoPalletOnInitialLift	: word	:= 16#1000;
			FailCode_BatteryCharge			: word	:= 16#2000;
		END_STRUCT;	
END_TYPE


