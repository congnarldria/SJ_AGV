$INCLUDE_FILE


(* GLOBALE TYPEN *)



(* PROJEKT TYPEN *)



(* GLOBALE PROTOTYPEN *)

FUNCTION TIME_TO_DINT : DINT
    VAR_INPUT                                              
      T :TIME;
    END_VAR
  END_FUNCTION

FUNCTION GetTime : TIME
	VAR_INPUT
		StartTime : TIME;
	END_VAR
	END_FUNCTION

FUNCTION DINT_TO_TIME : TIME
    VAR_INPUT                                              
      Din :DINT;
    END_VAR
  END_FUNCTION



(* PROJEKT PROTOTYPEN *)



(* EXTERNE POEs *)



$END_INCLUDE_FILE
