FUNCTION_BLOCK DataUpload_ModbusTCPIP_FB
VAR_EXTERNAL
ndc8 : NDC8_T;

UploadData_ModBus_ValueWord:ARRAY[1..500] OF Word;
UploadData_ModBus_ValueBOOL:ARRAY[1..400] OF BOOL;

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


ProcStep,
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
UploadData_message : ARRAY[1..300] of BYTE;



END_VAR
(****************************************************************************)
StartDelayTOF(IN:=StartDelay, PT:=t#20ms);

if init then
	serial_read.port := 'COM6';
	serial_write.port := 'COM6';
	init := false;
end_if;

(****************************************************************************)


		(* Only read every 20ms *)
case ProcStep of
0:
	    StartDelay:=False; 
		IF Not StartDelayTOF.Q THEN
		    ProcStep:=1;
		END_IF;

(****************************************************************************)	
1:

	serial_read();
	msg_index := 0;
	while serial_read.length > 0 do

		(* Copy message to local buffer *)
		for dataindex := 1 to serial_read.length by 1 do
			ix := dataindex + msg_index;
			UploadData_message[ix] := serial_read.data[dataindex];
		end_for;
		(* Point for next possible message *)
		msg_index := msg_index + serial_read.length;
		serial_read();
	end_while;
	
	IF msg_index <> 0 then
		ProcStep:=2;
	Else 
		ProcStep:=0;
	END_IF;


(****************************************************************************)			
2:
		    (* Parse *)
			tr_cmd := BYTE_TO_DINT(UploadData_message[8]); 
			tr_len := BYTE_TO_DINT(UploadData_message[6]);
		
			dummy := TRACE_DINT('Cmd', tr_cmd);
			dummy := TRACE_DINT('Len', tr_len);
		
			(* Copy header *)
			serial_write.data[1] := UploadData_message[1]; 
			serial_write.data[2] := UploadData_message[2];
			serial_write.data[3] := UploadData_message[3]; 
			serial_write.data[4] := UploadData_message[4]; 
			serial_write.data[5] := UploadData_message[5];

			serial_write.data[6] := UploadData_message[6]; 	(* Length, will be overwritten *)
			serial_write.data[7] := UploadData_message[7]; 	(* Slave adress *)
			serial_write.data[8] := UploadData_message[8]; 	(* Cmd *)
		
			(* Start adress to read *)
			ConvByteH:= UploadData_message[9]; 
			ConvByteL:= UploadData_message[10]; 
			start_adress  := Word_TO_INT(ConvWord);
			
			ProcStep:=3;

(****************************************************************************)			
3:
			
			(*Check Function type *)							
				
			case tr_cmd of  
				1: 	ProcStep:=10;	(* Check if Read Coils *)
				5:	ProcStep:=50;	(* Check if Write single Coil *)
				15:	ProcStep:=150;	(* Check if Write Multiple Coils *)
				6:	ProcStep:=60;	(* Check if Write single register *)
				16:	ProcStep:=160; (* Check if write Multiple register *)
				3:	ProcStep:=30;	(*Check if Read register *)
			Else 	
				ProcStep:=999; 	(*Send Echo *)
			end_case;

(****************************************************************************)			
10:
					(* Read Coils *)
					(* Number of Bits *)
				(* serial_read.data[11]; *)
				ConvByteH:= UploadData_message[11]; 
				ConvByteL:= UploadData_message[12]; 
				num_Bit  := Word_TO_DINT(ConvWord);
				num_Byte :=(num_Bit/8)+1;
				ENDBIT:=(num_Bit/8);
				Extra:=num_Bit-ENDBIT;
					Y:=start_adress; 
					Z:=10;				
					Serial_write.data[9] := DINT_TO_BYTE(num_Byte);
				 
				 IF  ENDBIT<>0 THEN      
					For Index:=1 to ENDBIT BY 1 DO
					
						ConvBit0:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit1:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit2:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit3:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit4:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit5:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit6:=UploadData_ModBus_ValueBOOL [Y];
						Y:=Y+1;
						ConvBit7:=UploadData_ModBus_ValueBOOL [Y];
						serial_write.data[Z]:=ConvByteL;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
				END_IF;
					
				(*Fill in last Byte *)
				IF Extra <> 0 Then 	
					ConvByteL:=0;
						
					   	  ConvBit0:=UploadData_ModBus_ValueBOOL [Y];
					If Extra >1 Then 	
						Y:=Y+1;
						ConvBit1:=UploadData_ModBus_ValueBOOL [Y];
					END_IF;  
					If Extra >2 Then 	
						Y:=Y+1;
						ConvBit2:=UploadData_ModBus_ValueBOOL [Y];   
					END_IF;   
					If Extra >3 Then 	
						Y:=Y+1;
						ConvBit3:=UploadData_ModBus_ValueBOOL [Y];   
					END_IF;
					If Extra >4 Then 	
						Y:=Y+1;
						ConvBit4:=UploadData_ModBus_ValueBOOL [Y];   
					END_IF;
					If Extra >5 Then 	
						Y:=Y+1;
						ConvBit5:=UploadData_ModBus_ValueBOOL [Y];   
					END_IF;         	   
					If Extra >6 Then 	
						Y:=Y+1;
						ConvBit6:=UploadData_ModBus_ValueBOOL [Y];   
					END_IF;
					serial_write.data[Z]:=ConvByteL; 	   
						   
						   
				END_IF;
					
									
					length := num_Byte+3;
					tx_length := DINT_TO_BYTE(length);
					serial_write.data[6] := tx_length; (* lp *)
					ProcStep:=10000;	
					

(****************************************************************************)			
30:
				(*Read register *)
				(* Number of words *)
				(* serial_read.data[11]; *)
				num_words := BYTE_TO_DINT(UploadData_message[12]); 
				
					IF num_words > 11 THEN
				   		num_words:=11;
					END_IF;    
			
					Y:=start_adress; 
					Z:=10;				
					Serial_write.data[9] := DINT_TO_BYTE(num_words*2);
				        
					For Index:=1 to num_words BY 1 DO
						ConvWord:=UploadData_ModBus_ValueWord [Y];
						serial_write.data[Z]:=ConvByteH;
						Z:=Z+1;
						serial_write.data[Z]:=ConvByteL;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
					
				
					length := num_words * 2 + 3;
					tx_length := DINT_TO_BYTE(length);
					serial_write.data[6] := tx_length; (* lp *)
					ProcStep:=10000;

(****************************************************************************)			
50:
			(* Write single Coil *)
	
				
					Y:=start_adress; 
					ConvByteL := UploadData_message[11]; 
					UploadData_ModBus_ValueBOOL [Y]:= ConvBit0;
							
					ProcStep:=999;

	(****************************************************************************)							
60:
				(* Write single register *)				
				(* single write *)
				(* Number of words *)
				(* serial_read.data[11]; *)
				num_words := BYTE_TO_DINT(UploadData_message[12]); 
				Y:=start_adress;
				ConvByteH:=UploadData_message[11]; 
			    ConvByteL:=UploadData_message[12]; 
				UploadData_ModBus_ValueWord [Y]:=ConvWord;
				
				
				ProcStep:=999;	

(****************************************************************************)			
150:
					(*Write Multiple Coils  *)
					(* Number of Bits *)
				(* serial_read.data[11]; *)
				ConvByteH:= UploadData_message[11]; 
				ConvByteL:= UploadData_message[12]; 
				num_Bit  := Word_TO_DINT(ConvWord);
				num_Byte :=(num_Bit/8)+1;
				ENDBIT:=(num_Bit/8);
				Extra:=num_Bit-ENDBIT;
					Y:=start_adress; 
					Z:=10;				
					
				 IF  ENDBIT <>0 THEN         
					For Index:=1 to ENDBIT BY 1 DO
					
						ConvByteL:= UploadData_message[Z]; 
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit0;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit1;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit2;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit3;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit4;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit5;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit6;
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit7;
						Y:=Y+1;
						Z:=Z+1;
					END_FOR;
				END_IF;
				
					
				(*Fill in last Bits *)
				ConvByteL:= UploadData_message[Z]; 
				IF Extra <> 0 Then 	
					UploadData_ModBus_ValueBOOL [Y]:=ConvBit0;
					If Extra >1 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit1;
					END_IF;  
					If Extra >2 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit2;  
					END_IF;   
					If Extra >3 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit3;  
					END_IF;
					If Extra >4 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit4;   
					END_IF;
					If Extra >5 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit5;   
					END_IF;         	   
					If Extra >6 Then 	
						Y:=Y+1;
						UploadData_ModBus_ValueBOOL [Y]:=ConvBit6;   
					END_IF;
									   
				END_IF;
				ProcStep:=999;
				

(****************************************************************************)				
160:
				(* Multiple write *)
				num_words:=Byte_TO_DInt(UploadData_message[12]); 
				(* Check if message lenght outside the Buffer, if so do what ??? *)
				IF num_words > 9 THEN
				   num_words:=9;
				END_IF;    
				Y:=start_adress;
				X:=14;
				End:= Byte_TO_Int(UploadData_message[12]); 
			
				For Index:=1 to num_words BY 1 DO
					ConvByteH:=UploadData_message[X]; 
					X:=X+1;
					ConvByteL:=UploadData_message[X]; 
					UploadData_ModBus_ValueWord [Y]:=ConvWord;
					X:=X+1;
					Y:=Y+1;
				END_FOR;
				
				ProcStep:=999;				


(****************************************************************************)
999:

				(*Send Echo *)
					Serial_write.data[9] := UploadData_message[9];
					serial_write.data[10] := UploadData_message[10]; 
					serial_write.data[11] := UploadData_message[11];
					serial_write.data[12] := UploadData_message[12];
					
					length :=6;
					tx_length := DINT_TO_BYTE(length);
			        serial_write.data[6] := tx_length; (* lp *)
					ProcStep:=10000;
			
(****************************************************************************)					
10000:
	
			(*Send Data *)
				
			serial_write.length := BYTE_TO_INT(tx_header_length) + BYTE_TO_INT(tx_length);
			serial_write();
			
			serial_write.length := 0;
			serial_write();
					
			
			IF serial_write.sent<>0 or serial_write.error<>0 Then
				ProcStep:=0;
				DebugCounter := DebugCounter + 1;
			End_IF;

end_case;



END_FUNCTION_BLOCK