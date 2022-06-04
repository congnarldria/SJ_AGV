FUNCTION_BLOCK ASCII_TO_DEC
VAR_EXTERNAL

END_VAR

VAR_INPUT
	ASCII : dint;
END_VAR

VAR CONSTANT
	ASCII_a61 	: DINT := 16#61; 	(* Chr "a" *)
	ASCII_A41 	: DINT := 16#41; 	(* Chr "A" *)
	ASCII_0 	: DINT := 16#30;	(* Number "0" *)
END_VAR

VAR_OUTPUT
	dec	: dint;
END_VAR

VAR
	CODE : DINT;
END_VAR
IF 		ASCII >= ASCII_a61 THEN		(* Character a *)
	dec := ASCII - ASCII_a61 + 10; 

elsif 	ASCII >= ASCII_A41 THEN	(* Character A *)
	dec := ASCII - ASCII_A41 + 10; 	

else
	dec := ASCII - ASCII_0;			(* Number *)
END_IF;

END_FUNCTION_BLOCK