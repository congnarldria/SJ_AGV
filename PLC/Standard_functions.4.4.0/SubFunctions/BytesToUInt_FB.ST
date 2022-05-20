FUNCTION_BLOCK BytesToUInt_FB
VAR_EXTERNAL
	NDC8:NDC8_T;
	MegaWord:word;
	HighByte:byte;
	LowByte:byte;

END_VAR

VAR_INPUT
	Byte1 : byte;
	Byte2 : byte;
END_VAR

VAR_OUTPUT
	UIntValue : uint;
END_VAR
	
VAR
	littleEndian:bool := true;
END_VAR
(*
 -----------------------------------------------------------------------------------                              
 BytesToInt_FB                   
 -----------------------------------------------------------------------------------                        

 Description:                     
 Combines two bytes to an UINT.
 littleEndian is used to control if least or most significant byte should come first.
 
 Rev 	Who		Date  		Desc
 -----------------------------------------------------------------------------------
 0.1  	KJN  	140206		Created
 -----------------------------------------------------------------------------------*)


if littleEndian then	(* First byte is least significant *)
	
	LowByte := Byte2;
	HighByte := Byte1;
	
	UIntValue := word_to_uint(MegaWord);

else					(* Second byte is least significant *)

	LowByte := Byte1;
	HighByte := Byte2;
	
	UIntValue := word_to_uint(MegaWord);

end_if;
END_FUNCTION_BLOCK