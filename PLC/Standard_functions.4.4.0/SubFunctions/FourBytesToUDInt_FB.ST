FUNCTION_BLOCK FourBytesToUDInt_FB
VAR_EXTERNAL
	NDC8:NDC8_T;
	DMegaWord:dword;
	FirstByte:byte;
	SecondByte:byte;
	ThirdByte:byte;
	FourthByte:byte;

END_VAR

VAR_INPUT
	Byte1 : byte;
	Byte2 : byte;
	Byte3 : byte;
	Byte4 : byte;
END_VAR

VAR_OUTPUT
	UDIntValue : udint;
END_VAR
	
VAR
	littleEndian:bool := true;
END_VAR
(*
 -----------------------------------------------------------------------------------                              
 FourBytesToUDInt_FB                   
 -----------------------------------------------------------------------------------                        

 Description:                     
 Combines two bytes to an UINT.
 littleEndian is used to control if least or most significant byte should come first.
 
 Rev 	Who		Date  		Desc
 -----------------------------------------------------------------------------------
 0.1  	KJN  	140206		Created
 -----------------------------------------------------------------------------------*)


if littleEndian then	(* First byte is least significant *)
	

	FirstByte	:= Byte1;
	SecondByte	:= Byte2;
	ThirdByte	:= Byte3;
	FourthByte	:= Byte4;
	
	UDIntValue := dword_to_udint(DMegaWord);
else					(* Second byte is least significant *)

	FirstByte	:= Byte3;
	SecondByte	:= Byte4;
	ThirdByte	:= Byte1;
	FourthByte	:= Byte2;
	
	UDIntValue := dword_to_udint(DMegaWord);


end_if;
END_FUNCTION_BLOCK