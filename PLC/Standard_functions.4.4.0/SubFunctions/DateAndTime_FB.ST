FUNCTION_BLOCK DateAndTime_FB
VAR_EXTERNAL
	NDC8:NDC8_T;

END_VAR

VAR_INPUT
	UTC_Clock	:	DINT;
END_VAR

VAR_OUTPUT
	ErrorCode	:	DINT;	(* 	0 = No errors
								1 = No UTC time input *)
								
	Year,Month,Day	:	DINT;
	Hours,Minutes,Seconds	:	DINT;
	DayWeek			:	STRING;


END_VAR

VAR
	Curr_Year, Temp_Days,Rem_Days	:	DINT;
	Rem_Seconds,Temp_Seconds	:	DINT;
	Days		:	DINT;
	Years_Bi	:	ARRAY [1..18] of DINT := [1972,1976,1980,1984,1988,1992,1996,2000,2004,2008,2012,2016,2020,2024,2028,2032,2036,2040];
	Months		:	ARRAY [1..12] of DINT := [31,28,31,30,31,30,31,31,30,31,30,31];
	WeekDays	:	ARRAY [0..6] of STRING := ['Thursday','Friday','Saturday','Sunday','Monday','Tuesday','Wednesday'];
	Start_Year 	: 	DINT := 1970;
	j,i,k		:	DINT := 1;
	Bissextile	:	BOOL;
END_VAR
(* Calculate date and time from UTC Clock NDC8.Vmc.Clock
-------------------------------------------
Seconds since 00:00:00 (Thursday) January 1 1970. 
Valid after the vehicle controller has connected to System Manager
followed by a restart of the vehicle controller. *)

If UTC_Clock < 0 then
	ErrorCode := 1;
	Return;			(* Error, exit from FB *)
End_If;

(* How many days since 00:00:00 January 1 1970 *)
Days := UTC_Clock / (60*60*24);

(* Remaining seconds from days *)
Rem_Seconds := UTC_Clock - (Days*60*60*24);

(* Day of week *)
k := Days mod 7;
k := LIMIT(0,k,6);
DayWeek := WeekDays[k];	(* Week day *)

(* Init *)
Curr_Year := Start_Year;
Temp_Days := Days;
Temp_Seconds := Rem_Seconds;
j := 1;
i := 1;

(* Year *)
while Temp_Days > 364 do
	if Years_Bi[j] = Curr_Year then
		Temp_Days := Temp_Days - 366;
		j := j+1;
		j := LIMIT(1,j,18);
	else
		Temp_Days := Temp_Days - 365;
	end_if;
	Rem_Days := Temp_Days + 1;	(* 1 day gone means January 2th so we need to add 1 day *)
	Curr_Year := Curr_Year + 1;
	Year := Curr_Year;			(* Year *)
end_while;

(* Bissextile? *)
for j := 1 to 12 do
	if Year = Years_Bi[j] then
		Bissextile := true;
		exit;		(* exit if Bissextile *)
	else
		Bissextile := false;
	end_if;
end_for;

(* Month *)
If 	Rem_Days < 28 then
	Month := i;				(* Month *)
	Day := Rem_Days;		(* Day *)
else

	while Rem_Days > 27 do
		If i = 2 then	(* February? *)
			if Bissextile then
				Rem_Days := Rem_Days - Months[i] - 1;	(* 29 days for Bissextile year *)
			else
				Rem_Days := Rem_Days - Months[i];
			end_if;
		else
			Rem_Days := Rem_Days - Months[i];
		end_if;
		i := i + 1;
		i := LIMIT(1,i,12);
		Month := i;				(* Month *)
		Day := Rem_Days;		(* Day *)
	end_while;
end_if;

(* Hours *)
Hours := Temp_Seconds / 3600;
Temp_Seconds := Rem_Seconds - (Hours*3600);

(* Minutes *)
Minutes := Temp_Seconds / 60;

(* Seconds *)
Seconds := Rem_Seconds - (Hours*3600) - (Minutes*60);

ErrorCode := 0;		(* No errors *)

END_FUNCTION_BLOCK