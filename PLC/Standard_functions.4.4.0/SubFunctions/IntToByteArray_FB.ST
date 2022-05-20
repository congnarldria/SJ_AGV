FUNCTION_BLOCK IntToByteArray_FB
VAR_EXTERNAL
	NDC8:NDC8_T;
	MegaWord:word;
	HighByte:byte;
	LowByte:byte;
END_VAR

VAR_INPUT
	IntValue : int;
END_VAR

VAR_OUTPUT
	ByteArray : ARRAY[1..2] OF BYTE;
END_VAR
	
VAR
	littleEndian:bool := true;
END_VAR
(*
 -----------------------------------------------------------------------------------                              
 IntToByteArray_FB                   
 -----------------------------------------------------------------------------------                        

 Description:                     
 Splits INT into an array of two bytes.
 littleEndian is used to control if least or most significant byte should come first.
 
 Rev 	Who		Date  		Desc
 -----------------------------------------------------------------------------------
 0.1  	KJN  	140205		Created
 -----------------------------------------------------------------------------------*)


(* Get word. Saved at same data positions as HighByte and LowByte *)
MegaWord := int_to_word(IntValue);

if littleEndian then	(* Start with least significant byte *)

	ByteArray[1] := HighByte;
	ByteArray[2] := LowByte;

else				(* Start with most significant byte *)

	ByteArray[2] := HighByte;
	ByteArray[1] := LowByte;
	
end_if;
END_FUNCTION_BLOCK