FUNCTION_BLOCK OPTX2Communication_FB
VAR_EXTERNAL
ndc8 : NDC8_T;

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
serial_read : NDC8_SERIAL_READ;
serial_write : NDC8_SERIAL_WRITE;
init : BOOL := TRUE;

tx_header_length : BYTE := 6;
dummy : BOOL;
tr_cmd : DINT;


start_adress : INT;


OPTX2,
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

dataindex : INT;
msg_index: INT;
ix : INT;
OPTX2_message : ARRAY[1..300] of BYTE;

END_VAR
(****************************************************************************)
StartDelayTOF(IN:=StartDelay, PT:=t#20ms);

if init then
	serial_read.port := 'COM5';
	serial_write.port := 'COM5';
	init := false;
end_if;

(****************************************************************************)


		(* Only read every 20ms *)
case OPTX2 of
0:
	    StartDelay:=False; 
		IF Not StartDelayTOF.Q THEN
		    OPTX2:=1;
		END_IF;

(****************************************************************************)	
1:

	serial_read();
	msg_index := 0;
	while serial_read.length > 0 do

		(* Copy message to local buffer *)
		for dataindex := 1 to serial_read.length by 1 do
			ix := dataindex + msg_index;
			OPTX2_message[ix] := serial_read.data[dataindex];
		end_for;
		(* Point for next possible message *)
		msg_index := msg_index + serial_read.length;
		serial_read();
	end_while;
	
	IF msg_index <> 0 then
		OPTX2:=2;
	Else 
		OPTX2:=0;
	END_IF;


(****************************************************************************)			
2:
		    (* Parse *)
			tr_cmd := BYTE_TO_DINT(OPTX2_message[8]); 
			tr_len := BYTE_TO_DINT(OPTX2_message[6]);
		
			dummy := TRACE_DINT('Cmd', tr_cmd);
			dummy := TRACE_DINT('Len', tr_len);
		
			(* Copy header *)
			serial_write.data[1] := OPTX2_message[1]; 
			serial_write.data[2] := OPTX2_message[2];
			serial_write.data[3] := OPTX2_message[3]; 
			serial_write.data[4] := OPTX2_message[4]; 
			serial_write.data[5] := OPTX2_message[5];

			serial_write.data[6] := OPTX2_message[6]; 	(* Length, will be overwritten *)
			serial_write.data[7] := OPTX2_message[7]; 	(* Slave adress *)
			serial_write.data[8] := OPTX2_message[8]; 	(* Cmd *)
		
			(* Start adress to read *)
			ConvByteH:= OPTX2_message[9]; 
			ConvByteL:= OPTX2_message[10]; 
			start_adress  := Word_TO_INT(ConvWord) + 1;
			
			OPTX2:=3;

(****************************************************************************)			
3:
			
			(*Check Function type *)							
				
			case tr_cmd of  
				1: 	OPTX2:=10;	(* Check if Read Coils *)
				5:	OPTX2:=50;	(* Check if Write single Coil *)
				15:	OPTX2:=150;	(* Check if Write Multiple Coils *)
				6:	OPTX2:=60;	(* Check if Write single register *)
				16:	OPTX2:=160; (* Check if write Multiple register *)
				3:	OPTX2:=30;	(*Check if Read register *)
			Else 	
				OPTX2:=999; 	(*Send Echo *)
			end_case;

(****************************************************************************)			
10:
					(* Read Coils *)
					(* Number of Bits *)
				(* serial_read.data[11]; *)
				ConvByteH:= OPTX2_message[11]; 
				ConvByteL:= OPTX2_message[12]; 
				num_Bit  := Word_TO_DINT(ConvWord);
				num_Byte :=(num_Bit/8)+1;
				ENDBIT:=(num_Bit/8);
				Extra:=num_Bit-ENDBIT;
					Y:=start_adress; 
					Z:=10;				
					Serial_write.data[9] := DINT_TO_BYTE(num_Byte);
				 
				 IF  ENDBIT<>0 THEN      
					For Index:=1 to ENDBIT BY 1 DO
					
						ConvBit0:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit1:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit2:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit3:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit4:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit5:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit6:=ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit7:=ModBus_ValueBOOL [Y];
						serial_write.data[Z]:=ConvByteL;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
				END_IF;
					
				(*Fill in last Byte *)
				IF Extra <> 0 Then 	
					ConvByteL:=0;
						
					   	  ConvBit0:=ModBus_ValueBOOL [Y];
					If Extra >1 Then 	
						Y:=Y+1;
						ConvBit1:=ModBus_ValueBOOL [Y];
					END_IF;  
					If Extra >2 Then 	
						Y:=Y+1;
						ConvBit2:=ModBus_ValueBOOL [Y];   
					END_IF;   
					If Extra >3 Then 	
						Y:=Y+1;
						ConvBit3:=ModBus_ValueBOOL [Y];   
					END_IF;
					If Extra >4 Then 	
						Y:=Y+1;
						ConvBit4:=ModBus_ValueBOOL [Y];   
					END_IF;
					If Extra >5 Then 	
						Y:=Y+1;
						ConvBit5:=ModBus_ValueBOOL [Y];   
					END_IF;         	   
					If Extra >6 Then 	
						Y:=Y+1;
						ConvBit6:=ModBus_ValueBOOL [Y];   
					END_IF;
					serial_write.data[Z]:=ConvByteL; 	   
						   
						   
				END_IF;
					
									
					length := num_Byte+3;
					tx_length := DINT_TO_BYTE(length);
					serial_write.data[6] := tx_length; (* lp *)
					OPTX2:=10000;	
					

(****************************************************************************)			
30:
				(*Read register *)
				(* Number of words *)
				(* serial_read.data[11]; *)
				num_words := BYTE_TO_DINT(OPTX2_message[12]); 
				
					IF num_words > 11 THEN
				   		num_words:=11;
					END_IF;    
			
					Y:=start_adress; 
					Z:=10;				
					Serial_write.data[9] := DINT_TO_BYTE(num_words*2);
				        
					For Index:=1 to num_words BY 1 DO
						ConvWord:=ModBus_ValueWord [Y];
						serial_write.data[Z]:=ConvByteH;
						Z:=Z+1;
						serial_write.data[Z]:=ConvByteL;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
					
				
					length := num_words * 2 + 3;
					tx_length := DINT_TO_BYTE(length);
					serial_write.data[6] := tx_length; (* lp *)
					OPTX2:=10000;

(****************************************************************************)			
50:
			(* Write single Coil *)
	
				
					Y:=start_adress; 
					ConvByteL := OPTX2_message[11]; 
					ModBus_ValueBOOL [Y]:= ConvBit0;
							
					OPTX2:=999;

	(****************************************************************************)							
60:
				(* Write single register *)				
				(* single write *)
				(* Number of words *)
				(* serial_read.data[11]; *)
				num_words := BYTE_TO_DINT(OPTX2_message[12]); 
				Y:=start_adress;
				ConvByteH:=OPTX2_message[11]; 
			    ConvByteL:=OPTX2_message[12]; 
				ModBus_ValueWord [Y]:=ConvWord;
				
				
				OPTX2:=999;	

(****************************************************************************)			
150:
					(*Write Multiple Coils  *)
					(* Number of Bits *)
				(* serial_read.data[11]; *)
				ConvByteH:= OPTX2_message[11]; 
				ConvByteL:= OPTX2_message[12]; 
				num_Bit  := Word_TO_DINT(ConvWord);
				num_Byte :=(num_Bit/8)+1;
				ENDBIT:=(num_Bit/8);
				Extra:=num_Bit-ENDBIT;
					Y:=start_adress; 
					Z:=10;				
					
				 IF  ENDBIT <>0 THEN         
					For Index:=1 to ENDBIT BY 1 DO
					
						ConvByteL:= OPTX2_message[Z]; 
						ModBus_ValueBOOL [Y]:=ConvBit0;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit1;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit2;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit3;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit4;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit5;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit6;
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit7;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
				END_IF;
				
					
				(*Fill in last Bits *)
				ConvByteL:= OPTX2_message[Z]; 
				IF Extra <> 0 Then 	
					ModBus_ValueBOOL [Y]:=ConvBit0;
					If Extra >1 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit1;
					END_IF;  
					If Extra >2 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit2;  
					END_IF;   
					If Extra >3 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit3;  
					END_IF;
					If Extra >4 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit4;   
					END_IF;
					If Extra >5 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit5;   
					END_IF;         	   
					If Extra >6 Then 	
						Y:=Y+1;
						ModBus_ValueBOOL [Y]:=ConvBit6;   
					END_IF;
									   
				END_IF;
				OPTX2:=999;
				

(****************************************************************************)				
160:
				(* Multiple write *)
				num_words:=Byte_TO_DInt(OPTX2_message[12]); 
				(* Check if message lenght outside the Buffer, if so do what ??? *)
				IF num_words > 9 THEN
				   num_words:=9;
				END_IF;    
				Y:=start_adress;
				X:=14;
				End:= Byte_TO_Int(OPTX2_message[12]); 
			
				For Index:=1 to num_words BY 1 DO
					ConvByteH:=OPTX2_message[X]; 
					X:=X+1;
					ConvByteL:=OPTX2_message[X]; 
					ModBus_ValueWord [Y]:=ConvWord;
					X:=X+1;
					Y:=Y+1;
				END_FOR;
				
				OPTX2:=999;				


(****************************************************************************)
999:

				(*Send Echo *)
					Serial_write.data[9] := OPTX2_message[9];
					serial_write.data[10] := OPTX2_message[10]; 
					serial_write.data[11] := OPTX2_message[11];
					serial_write.data[12] := OPTX2_message[12];
					
					length :=6;
					tx_length := DINT_TO_BYTE(length);
			        serial_write.data[6] := tx_length; (* lp *)
					OPTX2:=10000;
			
(****************************************************************************)					
10000:
	
			(*Send Data *)
				
			serial_write.length := BYTE_TO_INT(tx_header_length) + BYTE_TO_INT(tx_length);
			serial_write();
			
			serial_write.length := 0;
			serial_write();
					
			
			IF serial_write.sent<>0 or serial_write.error<>0 Then
				OPTX2:=0;
				DebugCounter := DebugCounter + 1;
			End_IF;

end_case;



END_FUNCTION_BLOCK