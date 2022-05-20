FUNCTION_BLOCK DEBUG_FB
VAR_EXTERNAL

END_VAR

VAR_INPUT

END_VAR

VAR_OUTPUT

END_VAR

VAR

END_VAR
if debug then
	a:= TRACE_bool('ExecDrvCmd',NDC8.Automatic.ExecDriveCommand);
	a:= TRACE_bool('CancOp',NDC8.LoadOperation.CancelOperation);
	a:= TRACE_dint('TrvlDir',NDC8.VehicleControl.TravelDir);
	a:= TRACE_BOOL('Loaded', input.LoadOnBoard);
	a:= TRACE_DINT('Segm', NDC8.LayoutPosition.Segment);
	a:= TRACE_BOOL('OnLastseg', NDC8.LoadDocking.OnLastSegment);
	a:= TRACE_DINT('StopWord', NDC8.UserDefined.StopWord);
	a:= TRACE_DINT('OpCode', NDC8.LoadOperation.OperationCode);
	a:= TRACE_DINT('OpPar1', NDC8.LoadOperation.OperationParam1);
				
	debug := false;

end_if;




END_FUNCTION_BLOCK