FUNCTION_BLOCK OPTX2_FB
VAR_EXTERNAL
ndc8 : NDC8_T;

(*CVC->HMI Word 1~100, DWord 101~200*)
(*HMI-> Word 201~300, DWord 301~400*)
(*CVC->External Monitoring Word 401~500*)

(*CVC->HMI bit 1~200*)(*IO bit 41~200*)
(*HMI->CVC bit 201~400*)(*IO bit 301~400*)
ModBus_ValueWord:ARRAY[1..500] OF Word;
ModBus_ValueBOOL:ARRAY[1..400] OF BOOL;

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
(*serial_read : NDC8_SERIAL_READ;
serial_write : NDC8_SERIAL_WRITE;
init : BOOL := TRUE;

tx_header_length : BYTE := 6;
dummy : BOOL;
tr_cmd : DINT;


start_adress : INT;
*)
INTToDisplay,		(*55*)
INTfromDisplay,		(*56*)
DINTfromDisplay,	(*57*)
DINTToDisplay,		(*58*)
(*OPTX2,
ReadCounter,
DebugCounter		: DINT;
StartDelayTOF	: TOF;
StartDelay 		: BOOL;

X: INT;
Y: INT;
Z: INT;
End:INT;
Index:DINT;
debug1 :INT;
debug2 :INT;
tr_len : DINT;
num_words : DINT;
num_Byte : DINT;
num_Bit : DINT;
Extra:DINT;
length : DINT;
tx_length : BYTE;
ENDBIT:DINT;
debugByte :Byte;
*)
(*BlackBox : BlackBox_FB;*)
BBxTrigg: R_trig;
BlackBox : BlackBox_FB;
OrderMode:OrderMode_FB;
LowDINT:DINT;
HighDINT:DINT;
LocalOrder : LocalOrder_FB;
NavInit : NavInit_FB;
NavMethod : NavMethod_FB;
InitMethod : DINT;

OPTX2Communication : OPTX2Communication_FB;

ForceOutput : bool;

Temp : INT;

Angle_DINT : DINT;
Angle_REAL : REAL;


MCD_SPD_L_IN : DINT;
MCD_SPD_H_IN : DINT;

END_VAR

(* Current VehicleStatusInlineValue sent to display *)
ConvDINT := NDC8.Opt.VehicleStatusInlineValue;
ModBus_ValueWord [102]:=ConvWord2;
ModBus_ValueWord [101]:=ConvWord;

(*Current VehicleStatusID sent to display*)
ConvDINT := NDC8.Opt.VehicleStatusID;
ModBus_ValueWord [104]:=ConvWord2;
ModBus_ValueWord [103]:=ConvWord;


(* Current stopstring sent to display *)
ConvDINT := DisplayStopString.CurrentString;
ModBus_ValueWord [106]:=ConvWord2;
ModBus_ValueWord [105]:=ConvWord;



(* Current Stopstring value sent to display *)
ConvDINT := DisplayStopString.CurrentValue;
ModBus_ValueWord [108]:=ConvWord2;
ModBus_ValueWord [107]:=ConvWord;



(*Vehicle ID, sent to Display*)
ConvDINT := NDC8.Vehicle.VehicleID;
ModBus_ValueWord [112]:=ConvWord2;
ModBus_ValueWord [111]:=ConvWord;


(*Current order mode, sent to Display*)
ModBus_ValueWord [1]:=Dint_to_word(NDC8.Automatic.CurrentOrderMode);

(*Current nav mode, sent to Display*)
ModBus_ValueWord [2]:=Dint_to_word(NDC8.VehicleNavigator.NavMethod);


(*CVC600 -> PLC HandShake Data*)
ModBus_ValueWord [51] := PLC_TX_Word1;
ModBus_ValueWord [52] := PLC_TX_Word2;
ModBus_ValueWord [53] := PLC_TX_Word3;
ModBus_ValueWord [54] := PLC_TX_Word4;
ModBus_ValueWord [55] := PLC_TX_Word5;
ModBus_ValueWord [56] := PLC_TX_Word6;
ModBus_ValueWord [57] := PLC_TX_Word7_STr_Vecl;
ModBus_ValueWord [58] := PLC_TX_Word8_STr_Seg;
ModBus_ValueWord [59] := PLC_TX_Word9_STr_Pnt;
ModBus_ValueWord [60] := PLC_TX_Word10_STr_BatV;
ModBus_ValueWord [61] := PLC_TX_Word11_STr_Temp;
ModBus_ValueWord [62] := PLC_TX_Word12_STr_BatD;
ModBus_ValueWord [63] := PLC_TX_Word13_STr_Err;
ModBus_ValueWord [64] := PLC_TX_Word14_STr_BCD3;
ModBus_ValueWord [65] := PLC_TX_Word15_STr_BCD2;
ModBus_ValueWord [66] := PLC_TX_Word16_STr_BCD1;


(*PLC -> CVC600 HandShake Data*)
ModBus_ValueWord [71] := PLC_RX_Word1;
ModBus_ValueWord [72] := PLC_RX_Word2;
ModBus_ValueWord [73] := PLC_RX_Word3;
ModBus_ValueWord [74] := PLC_RX_Word4;
ModBus_ValueWord [75] := PLC_RX_Word5;
ModBus_ValueWord [76] := PLC_RX_Word6;
ModBus_ValueWord [77] := PLC_RX_Word7_STw_BCD3;
ModBus_ValueWord [78] := PLC_RX_Word8_STw_BCD2;
ModBus_ValueWord [79] := PLC_RX_Word9_STw_BCD1;
ModBus_ValueWord [80] := PLC_RX_Word10_STw_ILEr;
ModBus_ValueWord [81] := PLC_RX_Word11_Ins_Pno;
ModBus_ValueWord [82] := PLC_RX_Word12_STw_Pint;
ModBus_ValueWord [83] := PLC_RX_Word13_Ins_Ano;
ModBus_ValueWord [84] := PLC_RX_Word14_BMS_2;
ModBus_ValueWord [85] := PLC_RX_Word15_BMS_3;
ModBus_ValueWord [86] := PLC_RX_Word16_BMS_BatV;
ModBus_ValueWord [87] := PLC_RX_Word17_BMS_BatT;
ModBus_ValueWord [88] := PLC_RX_Word18_BMS_BatC;
ModBus_ValueWord [89] := PLC_RX_Word19_BMS_BatA;
ModBus_ValueWord [90] := PLC_RX_Word20_PLC_ErrD;
ModBus_ValueWord [91] := PLC_RX_Word21_BMS_Main;
ModBus_ValueWord [92] := PLC_RX_Word22_BMS_Chan;
ModBus_ValueWord [93] := PLC_RX_Word23_BMS_ID4L;
ModBus_ValueWord [94] := PLC_RX_Word24_BMS_ID4H;
ModBus_ValueWord [95] := PLC_RX_Word25;

(*Vehicle info, sent to Display *)
ConvDINT := NDC8.Position.X;
ModBus_ValueWord [114]:=ConvWord2;
ModBus_ValueWord [113]:=ConvWord;

ConvDINT := NDC8.Position.Y;
ModBus_ValueWord [116]:=ConvWord2;
ModBus_ValueWord [115]:=ConvWord;

ConvDINT := NDC8.Position.Angle;
ModBus_ValueWord [118]:=ConvWord2;
ModBus_ValueWord [117]:=ConvWord;

ConvDINT := NDC8.LayoutPosition.Point;
ModBus_ValueWord [122]:=ConvWord2;
ModBus_ValueWord [121]:=ConvWord;

ConvDINT := NDC8.LayoutPosition.Segment;
ModBus_ValueWord [124]:=ConvWord;
ModBus_ValueWord [123]:=ConvWord2;

ConvDINT := NDC8.LayoutPosition.Distance;
ModBus_ValueWord [126]:=ConvWord2;
ModBus_ValueWord [125]:=ConvWord;


ConvDINT := DWORD_TO_DINT(StopWord);
ModBus_ValueWord [132] := ConvWord2;
ModBus_ValueWord [131] := ConvWord;

ConvDINT := DWORD_TO_DINT(StopWord2);
ModBus_ValueWord [134] := ConvWord2;
ModBus_ValueWord [133] := ConvWord;

ConvDINT := NDC8.UserDefined.Integer32_60_LS2000_Attached_M;
ModBus_ValueWord [142] := ConvWord2;
ModBus_ValueWord [141] := ConvWord;

ConvDINT := NDC8.UserDefined.Integer32_59_LS2000_Attached_H;
ModBus_ValueWord [144] := ConvWord2;
ModBus_ValueWord [143] := ConvWord;

ConvDINT := NDC8.UserDefined.Integer32_58_LS2000_Attached_D;
ModBus_ValueWord [146] := ConvWord2;
ModBus_ValueWord [145] := ConvWord;

ConvDINT := NDC8.UserDefined.Integer32_55_TravelDistance;
ModBus_ValueWord [148] := ConvWord2;
ModBus_ValueWord [147] := ConvWord;



ModBus_ValueWord [3] := Input.Display_BatteryLevel;
ModBus_ValueWord [4] := Input.Display_Temperature;

Temp := WORD_TO_INT(g_ErrorCode);

ModBus_ValueWord [5] := INT_TO_WORD(Temp);

ModBus_ValueWord [6] := DINT_TO_WORD(NDC8.Manual.PlcSteerMode);


(*System Manager connection, sent to Display*)
ModBus_ValueBOOL [1]:= NDC8.Master.MasterLinkUp;

if NDC8.LayoutPosition.Point <> 0 or NDC8.LayoutPosition.Segment <> 0 then
	ModBus_ValueBOOL [2] := true;
else
	ModBus_ValueBOOL [2] := false;
end_if;
	
if NDC8.LayoutPosition.InSystem = true then
	ModBus_ValueBOOL [3] := true;
else
	ModBus_ValueBOOL [3] := false;
end_if;

if NDC8.Mcd.Button3 = true then
	ModBus_ValueBOOL [4] := true;
else
	ModBus_ValueBOOL [4] := false;
end_if;

ModBus_ValueBOOL [5] := StopFindSync;

if StopWord <> 0 or StopWord2 <> 0 then
	ModBus_ValueBOOL [6] := true;
else
	ModBus_ValueBOOL [6] := false;
end_if;


if g_ErrorCode <> 0 then
	ModBus_ValueBOOL [7] := true;
else
	ModBus_ValueBOOL [7] := false;
end_if;

(*Display IO*)

(*CVC600 Input*)

ModBus_ValueBOOL [101] := NDC8.SDIO.DigitalInput1_BTN_STR;
ModBus_ValueBOOL [102] := NDC8.SDIO.DigitalInput2_BTN_RST;
ModBus_ValueBOOL [103] := NDC8.SDIO.DigitalInput3_BMP_O1;
ModBus_ValueBOOL [104] := NDC8.SDIO.DigitalInput4_BMP_O2;
ModBus_ValueBOOL [105] := NDC8.SDIO.DigitalInput5_BTN_BRK;
ModBus_ValueBOOL [106] := NDC8.SDIO.DigitalInput6;
ModBus_ValueBOOL [107] := NDC8.SDIO.DigitalInput7;
ModBus_ValueBOOL [108] := NDC8.SDIO.DigitalInput8_BMP_E;

ModBus_ValueBOOL [111] := NDC8.SDIO.DigitalInput9;
ModBus_ValueBOOL [112] := NDC8.SDIO.DigitalInput10;
ModBus_ValueBOOL [113] := NDC8.SDIO.DigitalInput11;
ModBus_ValueBOOL [114] := NDC8.SDIO.DigitalInput12_EMO;

(*KL1488*)

ModBus_ValueBOOL [141] := NDC8.CAN_IO_3.DigitalInput1_SteerLimitF_L;
ModBus_ValueBOOL [142] := NDC8.CAN_IO_3.DigitalInput2_SteerLimitF_R;
ModBus_ValueBOOL [143] := NDC8.CAN_IO_3.DigitalInput3_SteerLimitR_L;
ModBus_ValueBOOL [144] := NDC8.CAN_IO_3.DigitalInput4_SteerLimitR_R;
ModBus_ValueBOOL [145] := NDC8.CAN_IO_3.DigitalInput5_LIMF_O;
ModBus_ValueBOOL [146] := NDC8.CAN_IO_3.DigitalInput6_LIMR_O;
ModBus_ValueBOOL [147] := NDC8.CAN_IO_3.DigitalInput7;
ModBus_ValueBOOL [148] := NDC8.CAN_IO_3.DigitalInput8;

ModBus_ValueBOOL [151] := NDC8.CAN_IO_3.DigitalInput9_AreaF_IN1;
ModBus_ValueBOOL [152] := NDC8.CAN_IO_3.DigitalInput10_AreaF_IN2;
ModBus_ValueBOOL [153] := NDC8.CAN_IO_3.DigitalInput11;
ModBus_ValueBOOL [154] := NDC8.CAN_IO_3.DigitalInput12;
ModBus_ValueBOOL [155] := NDC8.CAN_IO_3.DigitalInput13_AreaR_IN1;
ModBus_ValueBOOL [156] := NDC8.CAN_IO_3.DigitalInput14_AreaR_IN2;
ModBus_ValueBOOL [157] := NDC8.CAN_IO_3.DigitalInput15;
ModBus_ValueBOOL [158] := NDC8.CAN_IO_3.DigitalInput16;




(*CVC600 Output*)
if 	INPUT.Auto = TRUE then
	ModBus_ValueBOOL [301] := NDC8.SDIO.AllOK_DigitalOutput1;
	ModBus_ValueBOOL [302] := NDC8.SDIO.DigitalOutput2_LEDF_L;
	ModBus_ValueBOOL [303] := NDC8.SDIO.DigitalOutput3_LEDF_R;
	ModBus_ValueBOOL [304] := NDC8.SDIO.DigitalOutput4_LEDR_L;
	ModBus_ValueBOOL [305] := NDC8.SDIO.DigitalOutput5_LEDR_R;
	ModBus_ValueBOOL [306] := NDC8.SDIO.DigitalOutput6_LED_INPOS;
	ModBus_ValueBOOL [307] := NDC8.SDIO.DigitalOutput7_LED_STR;
	ModBus_ValueBOOL [308] := NDC8.SDIO.DigitalOutput8_LED_RST;



	ModBus_ValueBOOL [314] := NDC8.SDIO.DigitalOutput12;
	ModBus_ValueBOOL [315] := NDC8.SDIO.DigitalOutput13_PWR_OFF;
	ModBus_ValueBOOL [316] := NDC8.SDIO.DigitalOutput14_LED_BRK;
	ModBus_ValueBOOL [317] := NDC8.SDIO.DigitalOutput15;
	ModBus_ValueBOOL [318] := NDC8.SDIO.DigitalOutput16_Charger;

	ModBus_ValueBOOL [330] := NDC8.DCD_5.DigitalOutput2_Braker;
	ModBus_ValueBOOL [331] := NDC8.DCD_7.DigitalOutput2_Braker;
	
elsif ForceOutput = TRUE then
	 NDC8.SDIO.DigitalOutput2_LEDF_L :=  ModBus_ValueBOOL [302];
	 NDC8.SDIO.DigitalOutput3_LEDF_R :=  ModBus_ValueBOOL [303];
	 NDC8.SDIO.DigitalOutput4_LEDR_L :=  ModBus_ValueBOOL [304];
	 NDC8.SDIO.DigitalOutput5_LEDR_R :=  ModBus_ValueBOOL [305];
	 NDC8.SDIO.DigitalOutput6_LED_INPOS :=  ModBus_ValueBOOL [306];
	 NDC8.SDIO.DigitalOutput7_LED_STR :=  ModBus_ValueBOOL [307];
	 NDC8.SDIO.DigitalOutput8_LED_RST :=  ModBus_ValueBOOL [308];
    
    
    
	 NDC8.SDIO.DigitalOutput12 :=  ModBus_ValueBOOL [314];
	 NDC8.SDIO.DigitalOutput13_PWR_OFF :=  ModBus_ValueBOOL [315];
	 NDC8.SDIO.DigitalOutput14_LED_BRK :=  ModBus_ValueBOOL [316];
	 NDC8.SDIO.DigitalOutput15 :=  ModBus_ValueBOOL [317];
	 NDC8.SDIO.DigitalOutput16_Charger :=  ModBus_ValueBOOL [318];
    
	 NDC8.DCD_5.DigitalOutput2_Braker :=  ModBus_ValueBOOL [330];
	 NDC8.DCD_7.DigitalOutput2_Braker :=  ModBus_ValueBOOL [331];

end_if;

(*KL2488 Output*)
if 	INPUT.Auto = TRUE then
	ModBus_ValueBOOL [341] := NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1;
	ModBus_ValueBOOL [342] := NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2;
	ModBus_ValueBOOL [343] := NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3;
	ModBus_ValueBOOL [344] := NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4;
	ModBus_ValueBOOL [345] := NDC8.CAN_IO_3.DigitalOutput5;
	ModBus_ValueBOOL [346] := NDC8.CAN_IO_3.DigitalOutput6;
	ModBus_ValueBOOL [347] := NDC8.CAN_IO_3.DigitalOutput7;
	ModBus_ValueBOOL [348] := NDC8.CAN_IO_3.DigitalOutput8;
	
	ModBus_ValueBOOL [351] := NDC8.CAN_IO_3.DigitalOutput9_AreaF_SW1;
	ModBus_ValueBOOL [352] := NDC8.CAN_IO_3.DigitalOutput10_AreaF_SW2;
	ModBus_ValueBOOL [353] := NDC8.CAN_IO_3.DigitalOutput11;
	ModBus_ValueBOOL [354] := NDC8.CAN_IO_3.DigitalOutput12;
	ModBus_ValueBOOL [355] := NDC8.CAN_IO_3.DigitalOutput13_AreaR_SW1;
	ModBus_ValueBOOL [356] := NDC8.CAN_IO_3.DigitalOutput14_AreaR_SW2;
	ModBus_ValueBOOL [357] := NDC8.CAN_IO_3.DigitalOutput15;
	ModBus_ValueBOOL [358] := NDC8.CAN_IO_3.DigitalOutput16;
elsif ForceOutput = TRUE then
	NDC8.CAN_IO_3.DigitalOutput1_BuzzerCh1 := ModBus_ValueBOOL [341];
	NDC8.CAN_IO_3.DigitalOutput2_BuzzerCh2 := ModBus_ValueBOOL [342];
	NDC8.CAN_IO_3.DigitalOutput3_BuzzerCh3 := ModBus_ValueBOOL [343];
	NDC8.CAN_IO_3.DigitalOutput4_BuzzerCh4 := ModBus_ValueBOOL [344];
	NDC8.CAN_IO_3.DigitalOutput5 := ModBus_ValueBOOL [345];
	NDC8.CAN_IO_3.DigitalOutput6 := ModBus_ValueBOOL [346];
	NDC8.CAN_IO_3.DigitalOutput7 := ModBus_ValueBOOL [347];
	NDC8.CAN_IO_3.DigitalOutput8 := ModBus_ValueBOOL [348];
	
	NDC8.CAN_IO_3.DigitalOutput9_AreaF_SW1 := ModBus_ValueBOOL [351];
	NDC8.CAN_IO_3.DigitalOutput10_AreaF_SW2 := ModBus_ValueBOOL [352];
	NDC8.CAN_IO_3.DigitalOutput11 := ModBus_ValueBOOL [353];
	NDC8.CAN_IO_3.DigitalOutput12 := ModBus_ValueBOOL [354];
	NDC8.CAN_IO_3.DigitalOutput13_AreaR_SW1 := ModBus_ValueBOOL[355] ;
	NDC8.CAN_IO_3.DigitalOutput14_AreaR_SW2 := ModBus_ValueBOOL[356] ;
	NDC8.CAN_IO_3.DigitalOutput15 := ModBus_ValueBOOL [357];
	NDC8.CAN_IO_3.DigitalOutput16 := ModBus_ValueBOOL [358];

end_if;


(*-------------------------------------------------------------------------------------------------*)

(*Set order mode*)
if ModBus_ValueBOOL [201] then
	NDC8.Automatic.SetOrderMode := Word_TO_DINT(ModBus_ValueWord [201]);
	OrderMode();
	if OrderMode.Finished then
		ModBus_ValueBOOL [201] := 0;
	end_if;
end_if;

(*Set Nav method*)
if ModBus_ValueBOOL [202] then
	NDC8.VehicleNavigator.SetNavMethod := Word_TO_DINT(ModBus_ValueWord [202]);
	NavMethod();
	if NavMethod.Finished then
		ModBus_ValueBOOL [202] := 0;
	end_if;
end_if;

(*Trig Blackbox *)
if ModBus_ValueBOOL [203] then
	NDC8.BlackBox.TrigReason:= 'OPTX2';
	BlackBox();
	if BlackBox.Finished then
		ModBus_ValueBOOL [203] := 0;
	end_if;
end_if;

(* Set Parameters *)
if ModBus_ValueBOOL [209] = TRUE then

	ModBus_ValueBOOL [210] := NDC8.UserDefined.Boolean_20_OnlineOrderMode;
	
	(* Scanner_x *)
	ConvDINT := NDC8.LS2000.X;
	ModBus_ValueWord [352]:=ConvWord2;
	ModBus_ValueWord [351]:=ConvWord;
	
	(* Scanner_y *)
	ConvDINT := NDC8.LS2000.Y;
	ModBus_ValueWord [354]:=ConvWord2;
	ModBus_ValueWord [353]:=ConvWord;
	
	
	(* Scanner_t *)
	Angle_REAL := NDC8.LS2000.Angle * 100.0;
	Angle_DINT := REAL_TO_DINT(Angle_REAL);
	
	ConvDINT := Angle_DINT;
	ModBus_ValueWord [356]:=ConvWord2;
	ModBus_ValueWord [355]:=ConvWord;
	
	(* Max Speed *)
	ConvDINT := NDC8.Vehicle.MaxSpeed;
	ModBus_ValueWord [358]:=ConvWord2;
	ModBus_ValueWord [357]:=ConvWord;
	
	
	(* Enc1Scal *)
	ConvUDINT := NDC8.DCD_6.SteerEncScale;
	ModBus_ValueWord [362]:=ConvWord2;
	ModBus_ValueWord [361]:=ConvWord;
	
	
	(* Enc1Offs *)
	ConvDINT := INT_TO_DINT(NDC8.DCD_6.SteerEncOffset);
	ModBus_ValueWord [364]:=ConvWord2;
	ModBus_ValueWord [363]:=ConvWord;
	
	(* Enc3Scal *)
	ConvUDINT := NDC8.DCD_8.SteerEncScale;
	ModBus_ValueWord [366]:=ConvWord2;
	ModBus_ValueWord [365]:=ConvWord;
	
	
	(* Enc3Offs *)
	ConvDINT := INT_TO_DINT(NDC8.DCD_8.SteerEncOffset);
	ModBus_ValueWord [368]:=ConvWord2;
	ModBus_ValueWord [367]:=ConvWord;
	
	
	(* Enc2Scal *)
	ConvUDINT := NDC8.DCD_5.DriveEncScale;
	ModBus_ValueWord [372]:=ConvWord2;
	ModBus_ValueWord [371]:=ConvWord;
	
	
	(* Enc4Scal *)
	ConvUDINT := NDC8.DCD_7.DriveEncScale;
	ModBus_ValueWord [374]:=ConvWord2;
	ModBus_ValueWord [373]:=ConvWord;
	
	
	(* Batt Low Voltage *)
	ConvDINT := NDC8.UserDefined.Integer32_50_BattLowVol;
	ModBus_ValueWord [376]:=ConvWord2;
	ModBus_ValueWord [375]:=ConvWord;
	
	(* Charge StopTolerance*)
	ConvDINT := NDC8.Vehicle.StopTolerance;
	ModBus_ValueWord [398]:=ConvWord2;
	ModBus_ValueWord [397]:=ConvWord;

	ModBus_ValueBOOL [209] := FALSE;
end_if;

if ModBus_ValueBOOL [208] = TRUE then

	NDC8.UserDefined.Boolean_20_OnlineOrderMode := ModBus_ValueBOOL [210];
	
	(* Scanner_x *)
	ConvWord2 := ModBus_ValueWord [352];
	ConvWord := ModBus_ValueWord [351];

	NDC8.LS2000.X := ConvDINT;
	
	(* Scanner_y *)
	ConvWord2 := ModBus_ValueWord [354];
	ConvWord := ModBus_ValueWord [353];

	NDC8.LS2000.Y := ConvDINT;
	
	(* Scanner_t *)
	ConvWord2 := ModBus_ValueWord [356];
	ConvWord := ModBus_ValueWord [355];

	Angle_DINT := ConvDINT;
	
	Angle_REAL := DINT_TO_REAL(Angle_DINT) / 100.0;
	
	NDC8.LS2000.Angle := Angle_REAL;
	
	
	(* Max Speed *)
	ConvWord2 := ModBus_ValueWord [358];
	ConvWord := ModBus_ValueWord [357];

	NDC8.Vehicle.MaxSpeed := ConvDINT;
	
	
	(* Enc1Scal *)
	ConvWord2 := ModBus_ValueWord [362];
	ConvWord := ModBus_ValueWord [361];

	NDC8.DCD_6.SteerEncScale := ConvUDINT;
	
	(* Enc1Offs *)
	ConvWord2 := ModBus_ValueWord [364];
	ConvWord := ModBus_ValueWord [363];

	NDC8.DCD_6.SteerEncOffset := DINT_TO_INT(ConvDINT);
	
	(* Enc3Scal *)
	ConvWord2 := ModBus_ValueWord [366];
	ConvWord := ModBus_ValueWord [365];

	NDC8.DCD_8.SteerEncScale := ConvUDINT;
	
	(* Enc3Offs *)
	ConvWord2 := ModBus_ValueWord [368];
	ConvWord := ModBus_ValueWord [367];

	NDC8.DCD_8.SteerEncOffset := DINT_TO_INT(ConvDINT);
	
	(* Enc2Scal *)
	ConvWord2 := ModBus_ValueWord [372];
	ConvWord := ModBus_ValueWord [371];

	NDC8.DCD_5.DriveEncScale := ConvUDINT;
	
	(* Enc4Scal *)
	ConvWord2 := ModBus_ValueWord [374];
	ConvWord := ModBus_ValueWord [373];

	NDC8.DCD_7.DriveEncScale := ConvUDINT;
	
	(* Batt Low Voltage *)
	ConvWord2 := ModBus_ValueWord [376];
	ConvWord := ModBus_ValueWord [375];

	NDC8.UserDefined.Integer32_50_BattLowVol := ConvDINT;
	
	
	(* Charge StopTolerance*)
	ConvWord2 := ModBus_ValueWord [398];
	ConvWord := ModBus_ValueWord [397];

	NDC8.Vehicle.StopTolerance := ConvDINT;
	
	
	ModBus_ValueBOOL [208] := FALSE;

end_if;

if ModBus_ValueBOOL [211] = TRUE then

	(* MCD Low Speed *)
	ConvWord2 := ModBus_ValueWord [382];
	ConvWord := ModBus_ValueWord [381];

	NDC8.Mcd.McdLowSpeed := ConvDINT;
	
	(* MCD Low Speed *)
	ConvWord2 := ModBus_ValueWord [384];
	ConvWord := ModBus_ValueWord [383];

	NDC8.Mcd.McdHighSpeed := ConvDINT;

	ModBus_ValueBOOL [211] := FALSE;
End_if;

if ModBus_ValueBOOL [212] = TRUE then

	(* MCD Low Speed *)
	ConvDINT := NDC8.Mcd.McdLowSpeed;
	ModBus_ValueWord [382]:=ConvWord2;
	ModBus_ValueWord [381]:=ConvWord;
	
	(* MCD High Speed *)
	ConvDINT := NDC8.Mcd.McdHighSpeed;
	ModBus_ValueWord [384]:=ConvWord2;
	ModBus_ValueWord [383]:=ConvWord;
	
	ModBus_ValueBOOL [212] := FALSE;
End_if;

if ModBus_ValueBOOL [213] = TRUE then

	NDC8.UserDefined.Integer32_55_TravelDistance := 0;
	ModBus_ValueBOOL [213] := FALSE;

End_if;



(*Local Order *)
if ModBus_ValueBOOL [204] then
	
	ConvWord2 := ModBus_ValueWord [302];
	ConvWord := ModBus_ValueWord [301];
	NDC8.LocalOrder.DestPoint := ConvDINT;
	
	ConvWord2 := ModBus_ValueWord [304];
	ConvWord := ModBus_ValueWord [303];
	NDC8.LocalOrder.OpCode := ConvDINT;
	
	ConvWord2 := ModBus_ValueWord [306];
	ConvWord := ModBus_ValueWord [305];
	NDC8.LocalOrder.OpParam1 := ConvDINT;
	
	ConvWord2 := ModBus_ValueWord [308];
	ConvWord := ModBus_ValueWord [307];
	NDC8.LocalOrder.OpParam2 := ConvDINT;
	
	LocalOrder();
	if LocalOrder.Finished then
		ModBus_ValueBOOL [204] := 0;
	end_if;
end_if;

(*Nav area init*)
if ModBus_ValueBOOL [205] then

	ConvWord2 := ModBus_ValueWord [312];
	ConvWord := ModBus_ValueWord [311];
	NDC8.NavInit.Target := ConvDINT;
	
	InitMethod := Word_TO_DINT(ModBus_ValueWord [203]);
	
	NavInit(Method:= InitMethod);
	if NavInit.Finished then
		ModBus_ValueBOOL [205] := 0;
	end_if;
end_if;

(* Force Output Flag*)
if INPUT.Auto then
	ModBus_ValueBOOL [206] := ForceOutput;
else
	ForceOutput := ModBus_ValueBOOL [206];
end_if;

INPUT.BuzzerByPass := ModBus_ValueBOOL [207];



(* external monitoring *)
ModBus_ValueWord[401] := INT_TO_WORD(NDC8.DCD_5.TorqueCurrentReference);
ModBus_ValueWord[402] := INT_TO_WORD(NDC8.DCD_7.TorqueCurrentReference);


(****************************************************************************)
(*		Required for sending data to the display							*)

OPTX2Communication();


(****************************************************************************)







































END_FUNCTION_BLOCK