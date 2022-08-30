$INCLUDE_FILE


(* GLOBALE TYPEN *)



(* PROJEKT TYPEN *)

TYPE CAN_IO_3_T :
    STRUCT 
        DigitalInput1_SteerLimitF_L : BOOL ;   (* Digital Input 1 value  *)
        DigitalInput2_SteerLimitF_R : BOOL ;   (* Digital Input 2 value  *)
        DigitalInput3_SteerLimitR_L : BOOL ;   (* Digital Input 3 value  *)
        DigitalInput4_SteerLimitR_R : BOOL ;   (* Digital Input 4 value  *)
        DigitalInput5_LIMF_O : BOOL ;   (* Digital Input 5 value  *)
        DigitalInput6_LIMR_O : BOOL ;   (* Digital Input 6 value  *)
        DigitalInput7 : BOOL ;   (* Digital Input 7 value  *)
        DigitalInput8 : BOOL ;   (* Digital Input 8 value  *)
        DigitalInput9_AreaF_IN1 : BOOL ;   (* Digital Input 9 value  *)
        DigitalInput10_AreaF_IN2 : BOOL ;   (* Digital Input 10 value  *)
        DigitalInput11 : BOOL ;   (* Digital Input 11 value  *)
        DigitalInput12 : BOOL ;   (* Digital Input 12 value  *)
        DigitalInput13_AreaR_IN1 : BOOL ;   (* Digital Input 13 value  *)
        DigitalInput14_AreaR_IN2 : BOOL ;   (* Digital Input 14 value  *)
        DigitalInput15 : BOOL ;   (* Digital Input 15 value  *)
        DigitalInput16 : BOOL ;   (* Digital Input 16 value  *)
        DigitalOutput1_BuzzerCh1 : BOOL ;   (* Digital Output 1 value  *)
        DigitalOutput2_BuzzerCh2 : BOOL ;   (* Digital Output 2 value  *)
        DigitalOutput3_BuzzerCh3 : BOOL ;   (* Digital Output 3 value  *)
        DigitalOutput4_BuzzerCh4 : BOOL ;   (* Digital Output 4 value  *)
        DigitalOutput5 : BOOL ;   (* Digital Output 5 value  *)
        DigitalOutput6 : BOOL ;   (* Digital Output 6 value  *)
        DigitalOutput7 : BOOL ;   (* Digital Output 7 value  *)
        DigitalOutput8 : BOOL ;   (* Digital Output 8 value  *)
        DigitalOutput9_AreaF_SW1 : BOOL ;   (* Digital Output 9 value  *)
        DigitalOutput10_AreaF_SW2 : BOOL ;   (* Digital Output 10 value  *)
        DigitalOutput11 : BOOL ;   (* Digital Output 11 value  *)
        DigitalOutput12 : BOOL ;   (* Digital Output 12 value  *)
        DigitalOutput13_AreaR_SW1 : BOOL ;   (* Digital Output 13 value  *)
        DigitalOutput14_AreaR_SW2 : BOOL ;   (* Digital Output 14 value  *)
        DigitalOutput15 : BOOL ;   (* Digital Output 15 value  *)
        DigitalOutput16 : BOOL ;   (* Digital Output 16 value  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        
   END_STRUCT;
END_TYPE

TYPE SDIO_T :
    STRUCT 
        IMUGyroX : INT ;   (* Gyroscope x-axis value, cdeg/s  *)
        IMUGyroY : INT ;   (* Gyroscope y-axis value, cdeg/s  *)
        IMUGyroZ : INT ;   (* Gyroscope z-axis value, cdeg/s  *)
        IMUAccX : INT ;   (* Accelerometer x-axis value, mg  *)
        IMUAccY : INT ;   (* Accelerometer x-axis value, mg  *)
        IMUAccZ : INT ;   (* Accelerometer x-axis value, mg  *)
        IMUError : UINT ;   (* IMU Error value  *)
        IMUGyroXScale : INT ;   (* Gyroscope x-axis scale value (the value 10000 corresponds to a real scale value of 1.0)  *)
        IMUGyroYScale : INT ;   (* Gyroscope y-axis scale value (the value 10000 corresponds to a real scale value of 1.0)  *)
        IMUGyroZScale : INT ;   (* Gyroscope z-axis scale value (the value 10000 corresponds to a real scale value of 1.0)  *)
        DigitalInput1_Polarity : BOOL ;   (* Digital Input 1 Polarity, pin #A22  *)
        DigitalInput2_Polarity : BOOL ;   (* Digital Input 2 Polarity, pin #A14  *)
        DigitalInput3_Polarity : BOOL ;   (* Digital Input 3 Polarity, pin #A7  *)
        DigitalInput4_Polarity : BOOL ;   (* Digital Input 4 Polarity, pin #A6  *)
        DigitalInput5_Polarity : BOOL ;   (* Digital Input 5 Polarity, pin #A13  *)
        DigitalInput6_Polarity : BOOL ;   (* Digital Input 6 Polarity, pin #A21  *)
        DigitalInput7_Polarity : BOOL ;   (* Digital Input 7 Polarity, pin #A20  *)
        DigitalInput8_Polarity : BOOL ;   (* Digital Input 8 Polarity, pin #A19  *)
        DigitalInput9_Polarity : BOOL ;   (* Digital Input 9 Polarity, pin #B22  *)
        DigitalInput10_Polarity : BOOL ;   (* Digital Input 10 Polarity, pin #B23  *)
        DigitalInput11_Polarity : BOOL ;   (* Digital Input 11 Polarity, pin #A18  *)
        DigitalInput12_Polarity : BOOL ;   (* Digital Input 12 Polarity, pin #A17  *)
        DigitalOutput2_Polarity : BOOL ;   (* Digital Output 2 Polarity, pin #B7  *)
        DigitalOutput3_Polarity : BOOL ;   (* Digital Output 3 Polarity, pin #B6  *)
        DigitalOutput4_Polarity : BOOL ;   (* Digital Output 4 Polarity, pin #B5  *)
        DigitalOutput5_Polarity : BOOL ;   (* Digital Output 5 Polarity, pin #B4  *)
        DigitalOutput6_Polarity : BOOL ;   (* Digital Output 6 Polarity, pin #B1  *)
        DigitalOutput7_Polarity : BOOL ;   (* Digital Output 7 Polarity, pin #B3  *)
        DigitalOutput8_Polarity : BOOL ;   (* Digital Output 8 Polarity, pin #B2  *)
        DigitalOutput12_Polarity : BOOL ;   (* Digital Output 12 Polarity, pin #A3  *)
        DigitalOutput13_Polarity : BOOL ;   (* Digital Output 13 Polarity, pin #A10  *)
        DigitalOutput14_Polarity : BOOL ;   (* Digital Output 14 Polarity, pin #A2  *)
        DigitalOutput15_Polarity : BOOL ;   (* Digital Output 15 Polarity, pin #A9  *)
        DigitalOutput16_Polarity : BOOL ;   (* Digital Output 16 Polarity, pin #A16  *)
        AnInp1_Scale : DINT ;   (* Analog Input 1 Scale, pin #B15  *)
        AnInp2_Scale : DINT ;   (* Analog Input 2 Scale, pin #B17  *)
        AnInp3_Scale : DINT ;   (* Analog Input 3 Scale, pin #B10  *)
        AnInp4_Scale : DINT ;   (* Analog Input 4 Scale, pin #B18  *)
        AnInp5_Scale : DINT ;   (* Analog Input 5 Scale, pin #B11  *)
        AnInp6_Scale : DINT ;   (* Analog Input 6 Scale, pin #B19  *)
        AnInp7_Scale : DINT ;   (* Analog Input 7 Scale, pin #B12  *)
        AnInp8_Scale : DINT ;   (* Analog Input 8 Scale, pin #B20  *)
        AnInp9_Scale : DINT ;   (* Analog Input 9 Scale, pin #B13  *)
        AnInp10_Scale : DINT ;   (* Analog Input 10 Scale, pin #B21  *)
        AnInp11_Scale : DINT ;   (* Analog Input 11 Scale, pin #B14  *)
        AnInp1_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp2_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp3_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp4_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp5_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp6_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp7_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp8_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp9_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp10_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp11_Delta : UDINT ;   (* Asynchroneous transmission will be triggered if input has changed more than this value since last transmission.  *)
        AnInp1_Offset : DINT ;   (* Analog Input 1 Offset, pin #B15  *)
        AnInp2_Offset : DINT ;   (* Analog Input 2 Offset, pin #B17  *)
        AnInp3_Offset : DINT ;   (* Analog Input 3 Offset, pin #B10  *)
        AnInp4_Offset : DINT ;   (* Analog Input 4 Offset, pin #B18  *)
        AnInp5_Offset : DINT ;   (* Analog Input 5 Offset, pin #B11  *)
        AnInp6_Offset : DINT ;   (* Analog Input 6 Offset, pin #B19  *)
        AnInp7_Offset : DINT ;   (* Analog Input 7 Offset, pin #B12  *)
        AnInp8_Offset : DINT ;   (* Analog Input 8 Offset, pin #B20  *)
        AnInp9_Offset : DINT ;   (* Analog Input 9 Offset, pin #B13  *)
        AnInp10_Offset : DINT ;   (* Analog Input 10 Offset, pin #B21  *)
        AnInp11_Offset : DINT ;   (* Analog Input 11 Offset, pin #B14  *)
        DigitalInput1_BTN_STR : BOOL ;   (* Digital Input 1 value, pin #A22  *)
        DigitalInput2_BTN_RST : BOOL ;   (* Digital Input 2 value, pin #A14  *)
        DigitalInput3_BMP_O1 : BOOL ;   (* Digital Input 3 value, pin #A7  *)
        DigitalInput4_BMP_O2 : BOOL ;   (* Digital Input 4 value, pin #A6  *)
        DigitalInput5_BTN_BRK : BOOL ;   (* Digital Input 5 value, pin #A13  *)
        DigitalInput6 : BOOL ;   (* Digital Input 6 value, pin #A21  *)
        DigitalInput7 : BOOL ;   (* Digital Input 7 value, pin #A20  *)
        DigitalInput8_BMP_E : BOOL ;   (* Digital Input 8 value, pin #A19  *)
        DigitalInput9 : BOOL ;   (* Digital Input 9 value, pin #B22  *)
        DigitalInput10 : BOOL ;   (* Digital Input 10 value, pin #B23  *)
        DigitalInput11 : BOOL ;   (* Digital Input 11 value, pin #A18  *)
        DigitalInput12_EMO : BOOL ;   (* Digital Input 12 value, pin #A17  *)
        AllOK_DigitalOutput1 : BOOL ;   (* Reserved Digital Output 1 (All-OK, pin #B8)  *)
        DigitalOutput2_LEDF_L : BOOL ;   (* Digital Output 2 value, pin #B7  *)
        DigitalOutput3_LEDF_R : BOOL ;   (* Digital Output 3 value, pin #B6  *)
        DigitalOutput4_LEDR_L : BOOL ;   (* Digital Output 4 value, pin #B5  *)
        DigitalOutput5_LEDR_R : BOOL ;   (* Digital Output 5 value, pin #B4  *)
        DigitalOutput6_LED_INPOS : BOOL ;   (* Digital Output 6 value, pin #B1  *)
        DigitalOutput7_LED_STR : BOOL ;   (* Digital Output 7 value, pin #B3  *)
        DigitalOutput8_LED_RST : BOOL ;   (* Digital Output 8 value, pin #B2  *)
        DigitalOutput12_LEFTMGS : BOOL ;   (* Digital Output 12 value, pin #A3  *)
        DigitalOutput13_PWR_OFF : BOOL ;   (* Digital Output 13 value, pin #A10  *)
        DigitalOutput14_LED_BRK : BOOL ;   (* Digital Output 14 value, pin #A2  *)
        DigitalOutput15 : BOOL ;   (* Digital Output 15 value, pin #A9  *)
        DigitalOutput16_RIGHTMGS : BOOL ;   (* Digital Output 16 value, pin #A16  *)
        AnalogInput1 : INT ;   (* Analog Input 1 value, pin #B15. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput2 : INT ;   (* Analog Input 2 value, pin #B17. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput3 : INT ;   (* Analog Input 3 value, pin #B10. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput4 : INT ;   (* Analog Input 4 value, pin #B18. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput5 : INT ;   (* Analog Input 5 value, pin #B11. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput6 : INT ;   (* Analog Input 6 value, pin #B19. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput7 : INT ;   (* Analog Input 7 value, pin #B12. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput8 : INT ;   (* Analog Input 8 value, pin #B20. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput9 : INT ;   (* Analog Input 9 value, pin #B13. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput10 : INT ;   (* Analog Input 10 value, pin #B21. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        AnalogInput11 : INT ;   (* Analog Input 11 value, pin #B14. The value is the applied input voltage (in Volts) * Scale + Offset  *)
        PWMOutput1 : INT ;   (* PWM Output 1 value, pin #A5. The value is the duty cycle of the output.  *)
        PWMOutput2 : INT ;   (* PWM Output 2 value, pin #A12. The value is the duty cycle of the output.  *)
        PWMOutput3 : INT ;   (* PWM Output 3 value, pin #A11. The value is the duty cycle of the output.  *)
        Reg1Output : INT ;   (* Regulator 1 output value  *)
        Reg2Output : INT ;   (* Regulator 2 output value  *)
        GroundFaultEvent : BOOL ;   (* If set to true, a ground fault will cause a system event 229.  *)
        GroundFaultActive : BOOL ;   (* True if a ground fault is present  *)
        Temperature : DINT ;   (* Current temperature  *)
        XV_Out : DINT ;   (* Current xv out voltage  *)
        B_Plus : DINT ;   (* Current b plus voltage  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        IMUAxis : STRING ;   (* The axis in the IMU that gives the angular rate for vehicle.  *)
        IMUNavActive : BOOL ;   (* Use the angular rate from the IMU when calculating the position of the vehicle.  *)
        
   END_STRUCT;
END_TYPE

TYPE DCD_8_T :
    STRUCT 
        MotorCurrentRegP : INT ;   (* Motor Parameter: Proportional gain in the PI-parts of the current controller.  *)
        MotorCurrentRegI : INT ;   (* Motor Parameter: Integral gain in the PI-parts of the current controller.  *)
        ForwardMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during forward acceleration.  *)
        ReverseMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse acceleration.  *)
        MaxTorqueCurrentChange : INT ;   (* The maximum allowed change during 1 ms (i.e. derivate) of the Torque Current that is allowed. A too high derivate may for example introduce noise in the gear.  *)
        ForwardMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during forward braking/deceleration.  *)
        ReverseMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse braking/deceleration.  *)
        SpeedRegP : UINT ;   (* Proportional gain in the PI-parts of the speed controller.  *)
        SpeedRegI : UINT ;   (* Integral gain in the PI-parts of the speed controller.  *)
        RegSupervisionCheckOutHysteresis : UINT ;   (* Current limit for supervision. Supervision is enabled when the requested torque current goes above this limit. (Regulator supervision 0x6210)  *)
        RegSupervisionFailureDelay : UINT ;   (* Delay before safe state in absence of movement in correct direction. 0 = Disable. (Regulator supervision 0x6210)  *)
        SteerEncScale : UDINT ;   (* Steering Encoder Scale  *)
        SteerEncOffset : INT ;   (* Steering Encoder Offset (Position of Sync pulse)  *)
        PosRegP : INT ;   (* Proportional gain in the PI-parts of the position controller.  *)
        PosRegI : INT ;   (* Integral gain in the PI-parts of the position controller.  *)
        LimOutMax : INT ;   (* Max motor speed as output from position controller and input to speed controller.
VoltageFeedback: 1024 = 48V, Otherwise: 16384 = 90 deg/s  *)
        MaxWheelAngle : INT ;   (* Wheel Angle Limit. 0 = No Limit  *)
        SlowDownZone : INT ;   (* Speed limited zone approaching MaxWheelAngle.  *)
        LimOutMaxSlowDownZone : UINT ;   (* Speed limit for the slow down zone.  *)
        EndLimitSwitchPolarity : UINT ;   (* Polarity of end limit switch. Default is active high.  *)
        SyncGate : BOOL ;   (* Set true to allow sync. Set to false to reject unwanted sync pulse in multi turn application.  *)
        SyncFilter : UINT ;   (* Window where we expect sync pulse to appear  *)
        SyncEmergency : BOOL ;   (* Encoder Sync Emergency. 0 = Sync Emergency disabled. OBS! Disabling the sync emergency can be a serious safety issue!  *)
        ReverseEncoderDirection : BOOL ;   (* Set true to reverse encoder direction. Same effect as swapping A and B signals.  *)
        VoltageFeedback : BOOL ;   (* Set true to use motor voltage as speed feedback instead of encoder. (Speed scale: 1024 = 48 V)  *)
        SpeedRegOffset : INT ;   (* Current to compensate for friction. Added to speed regulator output with sign depending on the command speed.  *)
        ReadyToSwitchOn : BOOL ;   (* Ready To Switch On (Dc bus is charged)  *)
        SwitchedOn : BOOL ;   (* Switched On  *)
        PowerStageEnabled : BOOL ;   (* Power Stage Enabled  *)
        Error : BOOL ;   (* Error  *)
        SwitchOnDisabled : BOOL ;   (* Switch On Disabled	(Dc bus voltage to low, charging timeout)  *)
        Warning : BOOL ;   (* Warning  *)
        WheelAngle : INT ;   (* Wheel Angle  *)
        Reserved_DigitalInput2 : BOOL ;   (* Digital Input 2 value, encoder sync, pin 14  *)
        Reserved_DigitalInput3 : BOOL ;   (* Digital Input 3 value, end limit switch, pin 13  *)
        SwitchOn : BOOL ;   (* Switch On  *)
        EnablePowerStage : BOOL ;   (* Enable Power Stage  *)
        SetAngle : INT ;   (* Set Angle  *)
        DigitalOutput1 : BOOL ;   (* Digital Output 1 value, pin 2  *)
        DigitalOutput2 : BOOL ;   (* Digital Output 2 value, pin 18  *)
        DigitalOutput3 : BOOL ;   (* Digital Output 3 value, pin 21  *)
        DigitalOutput4 : BOOL ;   (* Digital Output 4 value, pin 22  *)
        DcBusVoltage : UINT ;   (* Runtime voltage measurement on the B+ input  *)
        TorqueCurrentReference : INT ;   (* Output from speed controller, input to current controller.  *)
        TorqueCurrent : INT ;   (* Actual torque current in current controller.  *)
        EncoderStatus : UINT ;   (* Bit0 - Sync Valid. Set when first sync pulse inside the sync window has been detected  *)
        EncoderCounterValue : UINT ;   (* Number of pulse edges captured.  *)
        SpuriousSyncCounter : UINT ;   (* Counter for sync pulses detected outside sync window. Valid after first sync pulse inside the sync window has been detected  *)
        MissingSyncCounter : UINT ;   (* Counter for expected but not present sync pulses inside sync window. Valid after first sync pulse inside the sync window has been detected  *)
        HeatsinkTemperature : INT ;   (* Temperature of the heatsink  *)
        ExtendedWarnings : UDINT ;   (* Extended Warnings set by the drive, valid when Warning bit is set  *)
        ExtendedErrors : UDINT ;   (* Extended Errors set by the drive, valid when Error bit is set  *)
        RegSupervisionTimer : UINT ;   (* Timer counting absence of movement in correct direction. See: Reg Supervision Failure Delay  *)
        RegSupervisionTimerMax : UINT ;   (* Max value of Reg Supervision Timer since power on.  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        
   END_STRUCT;
END_TYPE

TYPE DCD_7_T :
    STRUCT 
        MotorCurrentRegP : INT ;   (* Motor Parameter: Proportional gain in the PI-parts of the current controller.  *)
        MotorCurrentRegI : INT ;   (* Motor Parameter: Integral gain in the PI-parts of the current controller.  *)
        MaxCommandSpeed : UINT ;   (* Max command speed  *)
        ForwardMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during forward acceleration.  *)
        ReverseMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse acceleration.  *)
        MaxTorqueCurrentChange : INT ;   (* The maximum allowed change during 1 ms (i.e. derivate) of the Torque Current that is allowed. A too high derivate may for example introduce noise in the gear.  *)
        ForwardMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during forward braking/deceleration.  *)
        ReverseMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse braking/deceleration.  *)
        SpeedRegP : UINT ;   (* Proportional gain in the PI-parts of the speed controller.  *)
        SpeedRegI : UINT ;   (* Integral gain in the PI-parts of the speed controller.  *)
        RegSupervisionCheckOutHysteresis : UINT ;   (* Current limit for supervision. Supervision is enabled when the requested torque current goes above this limit. (Regulator supervision 0x6210)  *)
        RegSupervisionFailureDelay : UINT ;   (* Delay before safe state in absence of movement in correct direction. 0 = Disable. (Regulator supervision 0x6210)  *)
        ReverseEncoderDirection : BOOL ;   (* Set true to reverse encoder direction. Same effect as swapping A and B signals.  *)
        VoltageFeedback : BOOL ;   (* Set true to use motor voltage as speed feedback instead of encoder. (Speed scale: 1024 = 48 V)  *)
        SpeedRegOffset : INT ;   (* Current to compensate for friction. Added to speed regulator output with sign depending on the command speed.  *)
        ReadyToSwitchOn : BOOL ;   (* Ready To Switch On (Dc bus is charged)  *)
        SwitchedOn : BOOL ;   (* Switched On  *)
        PowerStageEnabled : BOOL ;   (* Power Stage Enabled  *)
        Error : BOOL ;   (* Error  *)
        SwitchOnDisabled : BOOL ;   (* Switch On Disabled	(Dc bus voltage to low, charging timeout)  *)
        Warning : BOOL ;   (* Warning  *)
        DriveEncScale : UDINT ;   (* The number of pulses per 1000 mm.  *)
        DriveEncDist : UINT ;   (* Drive Encoder Distance  *)
        DriveEncSpeed : INT ;   (* Drive Enc Speed  *)
        DigitalInput2_OverRelayRS : BOOL ;   (* Digital Input 2 value, pin 14  *)
        DigitalInput3_OverRelayRD : BOOL ;   (* Digital Input 3 value, pin 13  *)
        SwitchOn : BOOL ;   (* Switch On  *)
        EnablePowerStage : BOOL ;   (* Enable Power Stage  *)
        SetSpeed : INT ;   (* Set Speed  *)
        DigitalOutput1 : BOOL ;   (* Digital Output 1 value, pin 2  *)
        DigitalOutput2_Braker : BOOL ;   (* Digital Output 2 value, pin 18  *)
        DigitalOutput3 : BOOL ;   (* Digital Output 3 value, pin 21  *)
        DigitalOutput4 : BOOL ;   (* Digital Output 4 value, pin 22  *)
        DcBusVoltage : UINT ;   (* Runtime voltage measurement on the B+ input  *)
        TorqueCurrentReference : INT ;   (* Output from speed controller, input to current controller.  *)
        TorqueCurrent : INT ;   (* Actual torque current in current controller.  *)
        HeatsinkTemperature : INT ;   (* Temperature of the heatsink  *)
        ExtendedWarnings : UDINT ;   (* Extended Warnings set by the drive, valid when Warning bit is set  *)
        ExtendedErrors : UDINT ;   (* Extended Errors set by the drive, valid when Error bit is set  *)
        RegSupervisionTimer : UINT ;   (* Timer counting absence of movement in correct direction. See: Reg Supervision Failure Delay  *)
        RegSupervisionTimerMax : UINT ;   (* Max value of Reg Supervision Timer since power on.  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        
   END_STRUCT;
END_TYPE

TYPE DCD_6_T :
    STRUCT 
        MotorCurrentRegP : INT ;   (* Motor Parameter: Proportional gain in the PI-parts of the current controller.  *)
        MotorCurrentRegI : INT ;   (* Motor Parameter: Integral gain in the PI-parts of the current controller.  *)
        ForwardMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during forward acceleration.  *)
        ReverseMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse acceleration.  *)
        MaxTorqueCurrentChange : INT ;   (* The maximum allowed change during 1 ms (i.e. derivate) of the Torque Current that is allowed. A too high derivate may for example introduce noise in the gear.  *)
        ForwardMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during forward braking/deceleration.  *)
        ReverseMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse braking/deceleration.  *)
        SpeedRegP : UINT ;   (* Proportional gain in the PI-parts of the speed controller.  *)
        SpeedRegI : UINT ;   (* Integral gain in the PI-parts of the speed controller.  *)
        RegSupervisionCheckOutHysteresis : UINT ;   (* Current limit for supervision. Supervision is enabled when the requested torque current goes above this limit. (Regulator supervision 0x6210)  *)
        RegSupervisionFailureDelay : UINT ;   (* Delay before safe state in absence of movement in correct direction. 0 = Disable. (Regulator supervision 0x6210)  *)
        SteerEncScale : UDINT ;   (* Steering Encoder Scale  *)
        SteerEncOffset : INT ;   (* Steering Encoder Offset (Position of Sync pulse)  *)
        PosRegP : INT ;   (* Proportional gain in the PI-parts of the position controller.  *)
        PosRegI : INT ;   (* Integral gain in the PI-parts of the position controller.  *)
        LimOutMax : INT ;   (* Max motor speed as output from position controller and input to speed controller.
VoltageFeedback: 1024 = 48V, Otherwise: 16384 = 90 deg/s  *)
        MaxWheelAngle : INT ;   (* Wheel Angle Limit. 0 = No Limit  *)
        SlowDownZone : INT ;   (* Speed limited zone approaching MaxWheelAngle.  *)
        LimOutMaxSlowDownZone : UINT ;   (* Speed limit for the slow down zone.  *)
        EndLimitSwitchPolarity : UINT ;   (* Polarity of end limit switch. Default is active high.  *)
        SyncGate : BOOL ;   (* Set true to allow sync. Set to false to reject unwanted sync pulse in multi turn application.  *)
        SyncFilter : UINT ;   (* Window where we expect sync pulse to appear  *)
        SyncEmergency : BOOL ;   (* Encoder Sync Emergency. 0 = Sync Emergency disabled. OBS! Disabling the sync emergency can be a serious safety issue!  *)
        ReverseEncoderDirection : BOOL ;   (* Set true to reverse encoder direction. Same effect as swapping A and B signals.  *)
        VoltageFeedback : BOOL ;   (* Set true to use motor voltage as speed feedback instead of encoder. (Speed scale: 1024 = 48 V)  *)
        SpeedRegOffset : INT ;   (* Current to compensate for friction. Added to speed regulator output with sign depending on the command speed.  *)
        ReadyToSwitchOn : BOOL ;   (* Ready To Switch On (Dc bus is charged)  *)
        SwitchedOn : BOOL ;   (* Switched On  *)
        PowerStageEnabled : BOOL ;   (* Power Stage Enabled  *)
        Error : BOOL ;   (* Error  *)
        SwitchOnDisabled : BOOL ;   (* Switch On Disabled	(Dc bus voltage to low, charging timeout)  *)
        Warning : BOOL ;   (* Warning  *)
        WheelAngle : INT ;   (* Wheel Angle  *)
        Reserved_DigitalInput2 : BOOL ;   (* Digital Input 2 value, encoder sync, pin 14  *)
        Reserved_DigitalInput3 : BOOL ;   (* Digital Input 3 value, end limit switch, pin 13  *)
        SwitchOn : BOOL ;   (* Switch On  *)
        EnablePowerStage : BOOL ;   (* Enable Power Stage  *)
        SetAngle : INT ;   (* Set Angle  *)
        DigitalOutput1 : BOOL ;   (* Digital Output 1 value, pin 2  *)
        DigitalOutput2 : BOOL ;   (* Digital Output 2 value, pin 18  *)
        DigitalOutput3 : BOOL ;   (* Digital Output 3 value, pin 21  *)
        DigitalOutput4 : BOOL ;   (* Digital Output 4 value, pin 22  *)
        DcBusVoltage : UINT ;   (* Runtime voltage measurement on the B+ input  *)
        TorqueCurrentReference : INT ;   (* Output from speed controller, input to current controller.  *)
        TorqueCurrent : INT ;   (* Actual torque current in current controller.  *)
        EncoderStatus : UINT ;   (* Bit0 - Sync Valid. Set when first sync pulse inside the sync window has been detected  *)
        EncoderCounterValue : UINT ;   (* Number of pulse edges captured.  *)
        SpuriousSyncCounter : UINT ;   (* Counter for sync pulses detected outside sync window. Valid after first sync pulse inside the sync window has been detected  *)
        MissingSyncCounter : UINT ;   (* Counter for expected but not present sync pulses inside sync window. Valid after first sync pulse inside the sync window has been detected  *)
        HeatsinkTemperature : INT ;   (* Temperature of the heatsink  *)
        ExtendedWarnings : UDINT ;   (* Extended Warnings set by the drive, valid when Warning bit is set  *)
        ExtendedErrors : UDINT ;   (* Extended Errors set by the drive, valid when Error bit is set  *)
        RegSupervisionTimer : UINT ;   (* Timer counting absence of movement in correct direction. See: Reg Supervision Failure Delay  *)
        RegSupervisionTimerMax : UINT ;   (* Max value of Reg Supervision Timer since power on.  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        
   END_STRUCT;
END_TYPE

TYPE DCD_5_T :
    STRUCT 
        MotorCurrentRegP : INT ;   (* Motor Parameter: Proportional gain in the PI-parts of the current controller.  *)
        MotorCurrentRegI : INT ;   (* Motor Parameter: Integral gain in the PI-parts of the current controller.  *)
        MaxCommandSpeed : UINT ;   (* Max command speed  *)
        ForwardMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during forward acceleration.  *)
        ReverseMaxAccTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse acceleration.  *)
        MaxTorqueCurrentChange : INT ;   (* The maximum allowed change during 1 ms (i.e. derivate) of the Torque Current that is allowed. A too high derivate may for example introduce noise in the gear.  *)
        ForwardMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during forward braking/deceleration.  *)
        ReverseMaxBrakeTorqueCurrent : INT ;   (* Maximum allowed torque current during reverse braking/deceleration.  *)
        SpeedRegP : UINT ;   (* Proportional gain in the PI-parts of the speed controller.  *)
        SpeedRegI : UINT ;   (* Integral gain in the PI-parts of the speed controller.  *)
        RegSupervisionCheckOutHysteresis : UINT ;   (* Current limit for supervision. Supervision is enabled when the requested torque current goes above this limit. (Regulator supervision 0x6210)  *)
        RegSupervisionFailureDelay : UINT ;   (* Delay before safe state in absence of movement in correct direction. 0 = Disable. (Regulator supervision 0x6210)  *)
        ReverseEncoderDirection : BOOL ;   (* Set true to reverse encoder direction. Same effect as swapping A and B signals.  *)
        VoltageFeedback : BOOL ;   (* Set true to use motor voltage as speed feedback instead of encoder. (Speed scale: 1024 = 48 V)  *)
        SpeedRegOffset : INT ;   (* Current to compensate for friction. Added to speed regulator output with sign depending on the command speed.  *)
        ReadyToSwitchOn : BOOL ;   (* Ready To Switch On (Dc bus is charged)  *)
        SwitchedOn : BOOL ;   (* Switched On  *)
        PowerStageEnabled : BOOL ;   (* Power Stage Enabled  *)
        Error : BOOL ;   (* Error  *)
        SwitchOnDisabled : BOOL ;   (* Switch On Disabled	(Dc bus voltage to low, charging timeout)  *)
        Warning : BOOL ;   (* Warning  *)
        DriveEncScale : UDINT ;   (* The number of pulses per 1000 mm.  *)
        DriveEncDist : UINT ;   (* Drive Encoder Distance  *)
        DriveEncSpeed : INT ;   (* Drive Enc Speed  *)
        DigitalInput2_OverRelayFS : BOOL ;   (* Digital Input 2 value, pin 14  *)
        DigitalInput3_OverRelayFD : BOOL ;   (* Digital Input 3 value, pin 13  *)
        SwitchOn : BOOL ;   (* Switch On  *)
        EnablePowerStage : BOOL ;   (* Enable Power Stage  *)
        SetSpeed : INT ;   (* Set Speed  *)
        AllOK_DigitalOutput1 : BOOL ;   (* Reserved Digital Output 1 value, pin 2  *)
        DigitalOutput2_Braker : BOOL ;   (* Digital Output 2 value, pin 18  *)
        DigitalOutput3 : BOOL ;   (* Digital Output 3 value, pin 21  *)
        DigitalOutput4 : BOOL ;   (* Digital Output 4 value, pin 22  *)
        DcBusVoltage : UINT ;   (* Runtime voltage measurement on the B+ input  *)
        TorqueCurrentReference : INT ;   (* Output from speed controller, input to current controller.  *)
        TorqueCurrent : INT ;   (* Actual torque current in current controller.  *)
        HeatsinkTemperature : INT ;   (* Temperature of the heatsink  *)
        ExtendedWarnings : UDINT ;   (* Extended Warnings set by the drive, valid when Warning bit is set  *)
        ExtendedErrors : UDINT ;   (* Extended Errors set by the drive, valid when Error bit is set  *)
        RegSupervisionTimer : UINT ;   (* Timer counting absence of movement in correct direction. See: Reg Supervision Failure Delay  *)
        RegSupervisionTimerMax : UINT ;   (* Max value of Reg Supervision Timer since power on.  *)
        BusID : DINT ;   (* CAN bus ID  *)
        NodeID : DINT ;   (* CAN node ID  *)
        FailureAction : DINT ;   (* 0 = Background, the background programs takes action when an error occur in the device. 1 = PLC, no action from background program. The error should be handled by the PLC application.  *)
        ActiveInSafeState : BOOL ;   (* Decides if the device will start up in safe state.  *)
        NMTState : UDINT ;   (* The current CANopen state of the device.  *)
        SdoBufferSize : DINT ;   (* The current size of the client SDO buffer (read/write SDO's from the vehicle controller to this device).  *)
        
   END_STRUCT;
END_TYPE

TYPE LanSerialPort_T :
    STRUCT 
        Protocol : DINT ;   (* Protocol used for IP communication.  *)
        IP : STRING ;   (* In case of Protocol set to UDP client or TCP client this should be set
to the IP address of the UDP/TCP server that the PLC connects to. With
Protocol set to UDP server or TCP server this specify the IP address of
the vehicle controller which clients should use.

In the case of Protocol set to UDP server or TCP server, the special
value "LAN" means that connections are only allowed on the
LAN interface and the special value "ANY" allows connections
on both the LAN interface and the WLAN interface.

Changing the address from the PLC will result in the connection being
closed. The new IP address will be used in the next PLC loop serial
read/write.  Note! It is not possible to change the address for a
range sensor connected using a LAN-serial-adapter.  *)
        Port : DINT ;   (* In case of Protocol set to UDP client or TCP client this should be set
to the port of the UDP/TCP server that the PLC connects to. With
Protocol set to UDP server or TCP server this specify the port on the
vehicle controller that the PLC opens for connections.

Changing the port from the PLC will result in the connection being
closed. The new port will be used in the next PLC loop serial
read/write.  Note! It is not possible to change the port for a range
sensor connected using a LAN-serial-adapter.  *)
        SendBuffer : BOOL ;   (* With SendBuffer set, outgoing data is sent over IP when the PLC
function block NDC_SERIAL_WRITE is called with argument
LENGTH=0. Without SendBuffer set, data is sent immediately but each IP
packet will contain at most 32 bytes data with more IP traffic as a
result.  *)
        
   END_STRUCT;
END_TYPE

TYPE ReflectorNavigator_T :
    STRUCT 
        RefStatValid : BOOL ;   (* Reflector statistics file is valid  *)
        NumberOfAssociatedReflectors : DINT ;   (* Number of associated reflectors detected by the vehicle. Updated every 500 milliseconds.  *)
        SelectReflectorType : DINT ;   (* Decides the reflector type to be used for navigation.
0 = Automatic, based on the reflectors in the layout.
1 = Flat reflector, measuring center of reflector.
2 = Flat reflector, measuring right edge of reflector.
3 = Cylindrical reflector.  *)
        
   END_STRUCT;
END_TYPE

TYPE VehicleNavigator_T :
    STRUCT 
        NavMethod : DINT ;   (* Current navigation method, 1 = reflector, 2 = spot, 4 = wire, 5 = wall, 7 = natural, 8 = barcode  *)
        NavMethodText : STRING ;   (* Current navigation method.  *)
        StartupNavMethod : DINT ;   (* Vehicle navigation method at startup. 1 = reflector, 2 = spot, 4 = wire, 5 = wall, 7 = natural, 8 = barcode  *)
        SetNavMethod : DINT ;   (* Set navigation method, 1 = reflector, 2 = spot, 4 = wire, 5 = wall, 7 = natural, 8 = barcode  *)
        SetNavMethodEN : BOOL ;   (* Set this to request current navigation method to change to SetNavMethod. Clear when SetNavMethodENO is cleared.  *)
        SetNavMethodENO : BOOL ;   (* Set by background program when SetNavModeError is properly set. Cleared when SetNavMethodEN is cleared.  *)
        SetNavMethodErr : DINT ;   (* 0 = no error, 1 = not supported by vehicle application.  *)
        SetNavMethodErrText : STRING ;   (* Error text.  *)
        IgnoreAbnormalEncVal : BOOL ;   (* When enabled a single sample with abnormal encoder values will not cause position unknown. Instead previous encoder values are used to update position.  *)
        RangeLogInhibit : DINT ;   (* Minimal time between range scan sent to black box file and service tool. Only read on startup of vehicle controller.  *)
        NavLevelEventLimit : DINT ;   (* A system event will be sent if Position.NavLevel goes below NavLevelEventLimit when the vehicle is in Automatic mode. Set to 0 to disable.  *)
        SleepTime : DINT ;   (* No position updates from sensor data when the vehicle has been standing still this time or longer. If SleepTime is set to -1 then the position will always be updated.  *)
        CorrectionX : DINT ;   (* Accumulated correction in vehicle local coordinates, with 5 s exponential decay.  *)
        CorrectionY : DINT ;   (* Accumulated correction in vehicle local coordinates, with 5 s exponential decay.  *)
        CorrectionAngle : DINT ;   (* Accumulated correction in vehicle local coordinates, with 5 s exponential decay.  *)
        
   END_STRUCT;
END_TYPE

TYPE NaturalNavigator_T :
    STRUCT 
        MatchRatio : DINT ;   (* Ratio between points matched to map and total number of points in range scan.  *)
        LowMatchRatio : DINT ;   (* Limit for acceptable match ratio value. Navigation lost if lower and MaxDeadReckoningDistance travelled.  *)
        HighMatchRatio : DINT ;   (* Max navigation level if match ratio is higher than this. Note that for a Navigation Init to be valid, the match ratio value must be equal or higher than this limit.  *)
        Reliability : DINT ;   (* Quality of range scan as a position observation.  *)
        LowReliability : DINT ;   (* Low limit for acceptable reliability value. Navigation lost if lower and MaxDeadReckoningDistance travelled.  *)
        HighReliability : DINT ;   (* High limit for reliability value. If reliability value is higher than this it will not reduce the navigation level.  *)
        CorrectionXLimit : DINT ;   (* If VehicleNavigator.CorrectionX is higher than this, navigation is lost. Navlevel starts to decrease at half of this limit.  *)
        CorrectionYLimit : DINT ;   (* If VehicleNavigator.CorrectionY is higher than this, navigation is lost. Navlevel starts to decrease at half of this limit.  *)
        CorrectionAngleLimit : DINT ;   (* If VehicleNavigator.CorrectionAngle is higher than this, navigation is lost. Navlevel starts to decrease at half of this limit.  *)
        PointThreshold : REAL ;   (* Match point if the Mahalanobi distance is less than this.  *)
        VarScan : REAL ;   (* Models uncertainty in range measurement versus dead reckoning.  *)
        SensorTimeout : DINT ;   (* Sets navigation level to 0 if no new measurements are received from the sensor within this time limit.  *)
        
   END_STRUCT;
END_TYPE

TYPE ReflectorInit_T :
    STRUCT 
        StatusID : DINT ;   (* 0 = position found, 1 = too few angles, 2 = bad spread of angles,  3 = too many false angles (failed to associate angles with known reflectors within specified area), 4 = ambiguous position (alias point), 5 = aborted, 7 = vehicle is moving  *)
        StatusText : STRING ;   (* Status text  *)
        
   END_STRUCT;
END_TYPE

TYPE Vehicle_T :
    STRUCT 
        VehicleType : STRING ;   (* Vehicle type  *)
        VehicleID : DINT ;   (* Vehicle Identity in the NDC8 System. Configured in the vehicle web interface.  *)
        IndividualName : STRING ;   (* Name for this vehicle individual. Configured in the vehicle web interface. Only set when external individual parameter file is used.  *)
        OptionClass : DINT ;   (* Defines vehicle option class. Used when verifying options with the master computer.  *)
        MaxSpeed : DINT ;   (* This symbol defines the maximum speed for the vehicle defined in mm/s  *)
        SimulationMode : BOOL ;   (* Vehicle simulation mode  *)
        StopTolerance : DINT ;   (* Distance before the stop point at which the speed is set to zero  *)
        StopPointTrim : DINT ;   (* Moves the stop point to adjust for vehicle unique mechanics in the load handling. A positive value moves the stop point in the vehicles forward direction, i.e., the vehicle drives longer on a forward segment and stops earlier on a backward segment  *)
        CreepSpeed : DINT ;   (* Speed used during CreepDistance. CreepSpeed is used in the end of a drive order to be able to stop as close at the destination point as possible. Used in conjunction with StopTolerance, this will give a high stop precision  *)
        CreepDistance : DINT ;   (* The distance before the destination point where the vehicle shall drive with selected creep-speed  *)
        AccSlope : DINT ;   (* Vehicle acceleration  *)
        DecSlope : DINT ;   (* Deceleration used during slow down.
Deceleration slope changes dynamically during ramping down to be able
hit the target point or speed more precisely. The value of this
parameter is used as the initial slope when ramping down is started.

The controller can temporarily use a higher deceleration but not higher than
Vehicle.EmcyDecSlope.  *)
        EmcyDecSlope : DINT ;   (* Deceleration used in automatic mode when outside safety-zone or position lost. This slope is also used when QuickStop symbol is set.
Note that this slope is not normally used when the EStop button is pressed.  *)
        SpeedDelayCompensation : DINT ;   (* Delay between the vehicle controller commanding a lower speed and the vehicle actually starting to slow down.  *)
        SteeringDelayCompensation : DINT ;   (* Compensation for delay in the steering control loop  *)
        Blocked : BOOL ;   (* Blocked at the end of the last segment.  *)
        CarrierType : DINT ;   (* Defines vehicle carriertype 1 to 8 (0 means any). Used in conjunction with segment carriertypes in the layout  *)
        WaitForWheelTurnMaxAngle : DINT ;   (* Maximum difference between actual (enc) wheel angle and new (set) wheel angle to make vehicle start driving. In manual and semi-manual mode this function is applied only once each time entering the mode. Hence, if writing a new value to the parameter, it will not have effect until next time entering manual or semimanual-mode.  *)
        
   END_STRUCT;
END_TYPE

TYPE LS2000Scanner_T :
    STRUCT 
        DetectDistance : DINT ;   (* Sight distance for laser scanner  *)
        Sensitivity : DINT ;   (* Detection sensitivity level. High sensitivity give more detections but also potentially increases number of false.
Low sensitivity eliminates a lot of false detecions but also removes potentially real (good) detections.  *)
        ReflectorShadow : DINT ;   (* Defines the length (in mm) of a reflector shadow - the area
immediately following a detected reflector where the LS2000
ignores any new reflectors.  The recommended value for this
parameter is 0.

Note: This parameter is incompatible with the UpsideDown
parameter.  *)
        X : DINT ;   (* Laser Scanner position X  *)
        Y : DINT ;   (* Laser Scanner position Y  *)
        Angle : REAL ;   (* Laser Scanner position Angle  *)
        UpsideDown : BOOL ;   (* Indicates if the range sensor is mounted upside down.

Set to False if the range sensor is mounted right side up.
Set to True if the range sensor is mounted upside down.  *)
        IP : STRING ;   (* The IP address used to connect to the scanner.  *)
        Field1_X1 : DINT ;   (* Bottom X position in vehicle coordinate where the field starts. This value should be less than Field1_X2 to define a valid field.  *)
        Field1_X2 : DINT ;   (* Top X position in vehicle coordinate where the field ends. This value should be greater than Field1_X1 to define a valid field.  *)
        Field1_Y1 : DINT ;   (* Right Y position in vehicle coordinate where the field starts. This value should be less than Field1_Y2 to define a valid field.  *)
        Field1_Y2 : DINT ;   (* Left Y position in vehicle coordinate where the field ends. This value should be greater than Field1_Y1 to define a valid field.  *)
        Field1_Triggered : BOOL ;   (* True if something is inside field  *)
        Field1_Dist : DINT ;   (* Distance from sensor to nearest object inside field. Valid only if Field1_Triggered is true.  *)
        Field2_X1 : DINT ;   (* Bottom X position in vehicle coordinate where the field starts. This value should be less than Field2_X2 to define a valid field.  *)
        Field2_X2 : DINT ;   (* Top X position in vehicle coordinate where the field ends. This value should be greater than Field2_X1 to define a valid field.  *)
        Field2_Y1 : DINT ;   (* Right Y position in vehicle coordinate where the field starts. This value should be less than Field2_Y2 to define a valid field.  *)
        Field2_Y2 : DINT ;   (* Left Y position in vehicle coordinate where the field ends. This value should be greater than Field1_Y1 to define a valid field.  *)
        Field2_Triggered : BOOL ;   (* True if something is inside field  *)
        Field2_Dist : DINT ;   (* Distance from sensor to nearest object inside field. Valid only if Field2_Triggered is true.  *)
        Sector1_Ignore : BOOL ;   (* If enabled bearings within sector will be ignored.  *)
        Sector1_Heading : DINT ;   (* Heading of sector. Measured from the symmetry axis of the vehicle to the center of the sector.  *)
        Sector1_Size : DINT ;   (* Size of sector. The ignored sector is from Heading - Size/2 to Heading + Size/2.  *)
        Sector2_Ignore : BOOL ;   (* If enabled bearings within sector will be ignored.  *)
        Sector2_Heading : DINT ;   (* Heading of sector. Measured from the symmetry axis of the vehicle to the center of the sector.  *)
        Sector2_Size : DINT ;   (* Size of sector. The ignored sector is from Heading - Size/2 to Heading + Size/2.  *)
        Sector3_Ignore : BOOL ;   (* If enabled bearings within sector will be ignored.  *)
        Sector3_Heading : DINT ;   (* Heading of sector. Measured from the symmetry axis of the vehicle to the center of the sector.  *)
        Sector3_Size : DINT ;   (* Size of sector. The ignored sector is from Heading - Size/2 to Heading + Size/2.  *)
        Sector4_Ignore : BOOL ;   (* If enabled bearings within sector will be ignored.  *)
        Sector4_Heading : DINT ;   (* Heading of sector. Measured from the symmetry axis of the vehicle to the center of the sector.  *)
        Sector4_Size : DINT ;   (* Size of sector. The ignored sector is from Heading - Size/2 to Heading + Size/2.  *)
        Sector5_Ignore : BOOL ;   (* If enabled bearings within sector will be ignored.  *)
        Sector5_Heading : DINT ;   (* Heading of sector. Measured from the symmetry axis of the vehicle to the center of the sector.  *)
        Sector5_Size : DINT ;   (* Size of sector. The ignored sector is from Heading - Size/2 to Heading + Size/2.  *)
        Connected : BOOL ;   (* True when the communication with LS2000 is working.  *)
        NavActive : BOOL ;   (* Use this sensor for navigation at the moment  *)
        Attached : BOOL ;   (* When set to false the vehicle controller will not try to communicate with this sensor nor use measurement from it.  *)
        Temperature : DINT ;   (* The temperature reported by the LS2000, updated every 2 seconds when LS2000 is used. This value is only valid when Connected=1.  *)
        
   END_STRUCT;
END_TYPE

TYPE WheelSD_T :
    STRUCT 
        MaxAngularSpeed : DINT ;   (* Max steer angular speed allowed  *)
        MinSteerAngle : DINT ;   (* Min steer angle allowed  *)
        MaxSteerAngle : DINT ;   (* Max steer angle allowed  *)
        X : DINT ;   (* Wheel position X (lengthwise along the symmetry axis). Positive in the forwards direction.  *)
        Y : DINT ;   (* Wheel position Y (perpendicular to the symmetry axis). Positive to the left.  *)
        SetSpeedRef : STRING ;   (* Symbolic name for wheel set speed  *)
        SetAngleRef : STRING ;   (* Symbolic name for wheel set angle  *)
        SetSpeedEnableRef : STRING ;   (* Symbolic name for wheel speed regulator enable  *)
        SetAngleEnableRef : STRING ;   (* Symbolic name for wheel angle regulator enable  *)
        EncSpeedRef : STRING ;   (* Symbolic name for wheel speed feedback  *)
        EncDistRef : STRING ;   (* Symbolic name for wheel distance feedback. If set to NotUsed EncSpeedRef will be used for distance feedback.  *)
        EncAngleRef : STRING ;   (* Symbolic name for wheel angle feedback  *)
        EncSpeedPlcInputRef : STRING ;   (* If EncSpeedRef or EncDistRef points to a symbol that is computed by PLC then this should point to the variable that the PLC uses as input for the calculation. The encoder value is then considered to be ready when the input variable has been received over the CAN bus (or otherwised updated) and the PLC has been executed.  *)
        EncAnglePlcInputRef : STRING ;   (* If EncAngleRef points to a symbol that is computed by PLC then this should point to the variable that the PLC uses as input for the calculation. The encoder value is then considered to be ready when the input variable has been received over the CAN bus (or otherwised updated) and the PLC has been executed.  *)
        WheelType : STRING ;   (* Type of wheel, Possible values are Steer, Drive and SD  *)
        PlcSetAngle : DINT ;   (* Set by PLC to control steering. Sent directly to external steer regulator
                if proper bit in PlcSelectMask and PlcSelect is set.  *)
        PlcSetSpeed : DINT ;   (* Set by PLC to control speed. Sent directly to external drive regulator
                if proper bit in PlcSelectMask and PlcSelect is set.  *)
        
   END_STRUCT;
END_TYPE

TYPE BlockedInfo_T :
    STRUCT 
        BlockedById : DINT ;   (* 0 = Unknown, 1 = Not blocked, 2 = Blocked by SSIO, 3 = Blocked by other Agv(s).  *)
        BlockedByText : STRING ;   (* Blocked by text.  *)
        LogicalLine : DINT ;   (* Logical SSIO line. Valid only when blocked by SSIO.  *)
        UnitNumber : DINT ;   (* Unit id in a logical line. Valid only when blocked by SSIO.  *)
        IoId : DINT ;   (* ID of input/output in unit. Valid only when blocked by SSIO.  *)
        IoType : DINT ;   (* 0 = Input, 1 = Output. Valid only when blocked by SSIO.  *)
        Status : DINT ;   (* 0 = OFF, 1 = ON, 2 = Flash 1Hz. Valid only when blocked by SSIO.  *)
        Vehicle1 : DINT ;   (* ID of blocking vehicle. Valid only when blocked by other AGV  *)
        Vehicle2 : DINT ;   (* ID of blocking vehicle. Valid only when blocked by other AGV  *)
        Vehicle3 : DINT ;   (* ID of blocking vehicle. Valid only when blocked by other AGV  *)
        Vehicle4 : DINT ;   (* ID of blocking vehicle. Valid only when blocked by other AGV  *)
        
   END_STRUCT;
END_TYPE

TYPE ExternalPath_T :
    STRUCT 
        ReqExtSegment : BOOL ;   (* Requesting a new external segment when true  *)
        ReqSegmentId : DINT ;   (* Id of the requested external segment.  *)
        
   END_STRUCT;
END_TYPE

TYPE UserDefined_T :
    STRUCT 
        DoNavInit : BOOL ;   (* Boolean_1  *)
        Braker_Signal : BOOL ;   (* Boolean_2  *)
        DoLocalOrder : BOOL ;   (* Boolean_3  *)
        ChangeOrderMode : BOOL ;   (* Boolean_4  *)
        LowBatSim : BOOL ;   (* Boolean_5  *)
        Boolean_6 : BOOL ;   (* Boolean_6  *)
        Boolean_7 : BOOL ;   (* Boolean_7  *)
        Boolean_8 : BOOL ;   (* Boolean_8  *)
        Boolean_9 : BOOL ;   (* Boolean_9  *)
        Boolean_10_BlockPowOffEn : BOOL ;   (* Boolean_10  *)
        Boolean_11_LostPosPowOffEn : BOOL ;   (*   *)
        Boolean_12 : BOOL ;   (*   *)
        Boolean_13 : BOOL ;   (*   *)
        Boolean_14 : BOOL ;   (*   *)
        Boolean_15 : BOOL ;   (*   *)
        Boolean_16 : BOOL ;   (*   *)
        Boolean_17 : BOOL ;   (*   *)
        Boolean_18 : BOOL ;   (*   *)
        Boolean_19 : BOOL ;   (*   *)
        Boolean_20_OnlineOrderMode : BOOL ;   (* 1 = Local Mode; 0 = Host Mode  *)
        Boolean_21 : BOOL ;   (*   *)
        Boolean_22 : BOOL ;   (*   *)
        Boolean_23 : BOOL ;   (*   *)
        Boolean_24 : BOOL ;   (*   *)
        Boolean_25 : BOOL ;   (*   *)
        Boolean_26 : BOOL ;   (*   *)
        Boolean_27 : BOOL ;   (*   *)
        Boolean_28 : BOOL ;   (*   *)
        Boolean_29 : BOOL ;   (*   *)
        Boolean_30 : BOOL ;   (*   *)
        StopWord : DINT ;   (* Integer32_1  *)
        Integer32_2 : DINT ;   (* Integer32_2  *)
        Integer32_3 : DINT ;   (* Integer32_3  *)
        Integer32_4 : DINT ;   (* Integer32_4  *)
        Integer32_5 : DINT ;   (* Integer32_5  *)
        SlowDownDisable : DINT ;   (* Integer32_6  *)
        PPAEnable : DINT ;   (* Integer32_7  *)
        SafetyScannerTurnAngle : DINT ;   (* Integer32_8  *)
        NormalCreepDistance : DINT ;   (* Integer32_9  *)
        Integer32_10_PCLMODBUS : DINT ;   (* Integer32_10  *)
        Integer32_11 : DINT ;   (* Integer32_11  *)
        Integer32_12 : DINT ;   (* Integer32_12  *)
        Integer32_13 : DINT ;   (* Integer32_13  *)
        Integer32_14 : DINT ;   (* Integer32_14  *)
        Integer32_15 : DINT ;   (* Integer32_15  *)
        Integer32_16 : DINT ;   (* Integer32_16  *)
        Integer32_17 : DINT ;   (* Integer32_17  *)
        Integer32_18 : DINT ;   (* Integer32_18  *)
        Integer32_19 : DINT ;   (* Integer32_19  *)
        Integer32_20 : DINT ;   (* Integer32_20  *)
        Integer32_21 : DINT ;   (* Integer32_21  *)
        Integer32_22 : DINT ;   (* Integer32_22  *)
        Integer32_23 : DINT ;   (* Integer32_23  *)
        Integer32_24 : DINT ;   (* Integer32_24  *)
        Integer32_25 : DINT ;   (* Integer32_25  *)
        Integer32_26 : DINT ;   (* Integer32_26  *)
        Integer32_27 : DINT ;   (* Integer32_27  *)
        Integer32_28 : DINT ;   (* Integer32_28  *)
        Integer32_29 : DINT ;   (* Integer32_29  *)
        Integer32_30 : DINT ;   (* Integer32_30  *)
        Integer32_31 : DINT ;   (* Integer32_31  *)
        Integer32_32 : DINT ;   (* Integer32_32  *)
        Integer32_33 : DINT ;   (* Integer32_33  *)
        Integer32_34 : DINT ;   (* Integer32_34  *)
        Integer32_35 : DINT ;   (* Integer32_35  *)
        Integer32_36 : DINT ;   (* Integer32_36  *)
        Integer32_37 : DINT ;   (* Integer32_37  *)
        Integer32_38 : DINT ;   (* Integer32_38  *)
        Integer32_39 : DINT ;   (* Integer32_39  *)
        Integer32_40 : DINT ;   (* Integer32_40  *)
        Integer32_41 : DINT ;   (* Integer32_41  *)
        Integer32_42 : DINT ;   (* Integer32_42  *)
        Integer32_43 : DINT ;   (* Integer32_43  *)
        Integer32_44 : DINT ;   (* Integer32_44  *)
        Integer32_45 : DINT ;   (* Integer32_45  *)
        Integer32_46 : DINT ;   (* Integer32_46  *)
        Integer32_47 : DINT ;   (*   *)
        Integer32_48 : DINT ;   (*   *)
        Integer32_49 : DINT ;   (*   *)
        Integer32_50_BattLowVol : DINT ;   (*   *)
        Integer32_51_BattLowSel : DINT ;   (* 1=L or M or H, 2=M or H, 3=H  *)
        Integer32_52_PowOffTm : DINT ;   (* ms  *)
        Integer32_53_OverVESTOPTm : DINT ;   (*   *)
        Integer32_54 : DINT ;   (*   *)
        Integer32_55_TravelDistance : DINT ;   (*   *)
        Integer32_56 : DINT ;   (*   *)
        Integer32_57 : DINT ;   (*   *)
        Integer32_58_LS2000_Attached_D : DINT ;   (*   *)
        Integer32_59_LS2000_Attached_H : DINT ;   (*   *)
        Integer32_60_LS2000_Attached_M : DINT ;   (*   *)
        
   END_STRUCT;
END_TYPE

TYPE SlavebusControl_T :
    STRUCT 
        EnterPreOpEN : BOOL ;   (* Set by background when requesting to enter NMT state pre-operational. Cleared when ENO is set.  *)
        EnterPreOpENO : BOOL ;   (* Set by PLC when transition to NMT state pre-operational is granted. Cleared when EN is cleared.  *)
        
   END_STRUCT;
END_TYPE

TYPE PLCEmergency_T :
    STRUCT 
        Canbus : DINT ;   (* Bus to send emergency on. 0 = first bus, 1 = second bus.  *)
        Code : DINT ;   (* Error code according to CANopen standard.  *)
        ErrReg : DINT ;   (* Error register according to CANopen standard.  *)
        Byte1 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte2 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte3 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte4 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte5 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        EmcyEN : BOOL ;   (* Set by PLC when emergency data is available. Cleared by PLC when ENO is set.  *)
        EmcyENO : BOOL ;   (* Set by the vehicle controller when emergency data has been read. Cleared by the vehicle controller when EN is cleared.  *)
        
   END_STRUCT;
END_TYPE

TYPE CanOpenEmergency_T :
    STRUCT 
        EmcyEN : BOOL ;   (* Set by background when emergency data is available for a CAN device that has FailureAction set to PLC. Cleared when ENO is set.  *)
        EmcyENO : BOOL ;   (* Set by PLC when read emergency data, cleared when EN is cleared.  *)
        BusID : DINT ;   (* CAN bus id.  *)
        NodeID : DINT ;   (* CAN node id.  *)
        Code : DINT ;   (* Error code according to CANopen standard. When an emergency is generated by background program (node id is negative), the node id for the node it concerns is the last 5 bits of the code.  *)
        ErrReg : DINT ;   (* Error register according to CANopen standard.  *)
        Byte1 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte2 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte3 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte4 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        Byte5 : DINT ;   (* Manufacturer specific error field according to CANopen standard.  *)
        
   END_STRUCT;
END_TYPE

TYPE CanOpenMaster_T :
    STRUCT 
        MasterExecutionPeriod : DINT ;   (* Execution period for the CANopen master component. Unit is [ms].  *)
        SyncPeriod : DINT ;   (* Sync producer period given in multiples of MasterExecutionPeriod.  *)
        CollectTimeout : DINT ;   (* Collect timeout before can server enters safe state  *)
        CanMasterCmd : DINT ;   (* Command to CAN master when CanMasterEN is set, 1 = RestartCan, 2 = GoToSafeState  *)
        CanMasterCmdEN : BOOL ;   (* Commands CAN master to CanMasterCmd. Clear it when CanMasterCmdENO is set.  *)
        CanMasterCmdENO : BOOL ;   (* Set by background when commands CAN master to CanMasterCmd. Cleared when CanMasterEN is cleared.  *)
        NMTState : UDINT ;   (* The current CANopen state of the vehicle controller. Interpretation:
                        Initializing (0) = loading definition,
                        Stopped (4) = unable to start due to fatal definition error,
                        Operational (5) = The vehicle controller fully operational either in normal state or in safestate,
                        PreOperational (127) = pre-operational, configuration of slave devices,
                        Unknown (255) = state undefined, no communication with node  *)
        State : DINT ;   (* Current state of the CanOpenMaster application, 0 = NormalState, 1 = SafeState. When any error is detected that PLC does not handle, the vehicle controller will enter SafeState. Information about the error causing SafeState is available in properties StatusText, EMCY_NodeID, EMCY_Code, EMCY_ErrReg, EMCY_Byte1, etc. SafeState is a passive/diagnostic state and AllOk will be set to false.  *)
        StatusText : STRING ;   (* Text description of error that caused the vehicle controller to enter SafeState. Only valid when State = SafeState.  *)
        EMCY_BusID : DINT ;   (* Bus ID that reported the error. Only valid when State = SafeState.  *)
        EMCY_NodeID : DINT ;   (* Node ID that reported the error. Only valid when State = SafeState.  *)
        EMCY_Code : DINT ;   (* CANopen emergency code, see device documentation. Only valid when State = SafeState.  *)
        EMCY_ErrReg : DINT ;   (* Error registry. Only valid when State = SafeState.  *)
        EMCY_Byte1 : DINT ;   (* Manufacturer specific field, byte 1. Only valid when State = SafeState.  *)
        EMCY_Byte2 : DINT ;   (* Manufacturer specific field, byte 2. Only valid when State = SafeState.  *)
        EMCY_Byte3 : DINT ;   (* Manufacturer specific field, byte 3. Only valid when State = SafeState.  *)
        EMCY_Byte4 : DINT ;   (* Manufacturer specific field, byte 4. Only valid when State = SafeState.  *)
        EMCY_Byte5 : DINT ;   (* Manufacturer specific field, byte 5. Only valid when State = SafeState.  *)
        
   END_STRUCT;
END_TYPE

TYPE Layout_T :
    STRUCT 
        LayoutName : STRING ;   (* Name of Layout  *)
        SystemName : STRING ;   (* Name of System  *)
        ModificationDate : STRING ;   (* Date when last edit  *)
        ModificationTime : STRING ;   (* Time when last edit  *)
        FileRevision : DINT ;   (* Layout revision number  *)
        NewLayoutAvailable : BOOL ;   (* Indicates that a new layout has been downloaded to the vehicle.  *)
        ReloadNewLayout : BOOL ;   (* When set to true and a new layout is available, the vehicle controller
will load the new layout when the vehicle is standing still. This
parameter allows the PLC to control when the reload will happen.  *)
        
   END_STRUCT;
END_TYPE

TYPE VehicleApplication_T :
    STRUCT 
        Name : STRING ;   (* Vehicle application name  *)
        ModificationDate : STRING ;   (* Date when last edit  *)
        ModificationTime : STRING ;   (* Time when last edit  *)
        CompilationID : STRING ;   (* Generated at last export  *)
        TimeStamp : DINT ;   (* Time stamp  *)
        
   END_STRUCT;
END_TYPE

TYPE OMPLC_T :
    STRUCT 
        ChargeOM : INT ;   (* Data1  *)
        Stop_OM : INT ;   (*   *)
        R_BCD1 : INT ;   (*   *)
        R_BCD2 : INT ;   (*   *)
        R_BCD3 : INT ;   (*   *)
        Cur_Pnt : INT ;   (*   *)
        Drv_Area : INT ;   (*   *)
        Cur_Seg : INT ;   (*   *)
        Data9 : INT ;   (*   *)
        IKEY : INT ;   (* Data10  *)
        Phase : INT ;   (* Data11  *)
        Fetch : INT ;   (* Data12  *)
        Delivery : INT ;   (* Data13  *)
        Data14 : INT ;   (*   *)
        Data15 : INT ;   (*   *)
        Data16 : INT ;   (*   *)
        Data17 : INT ;   (*   *)
        OrderState : INT ;   (* Data18  *)
        OrderStateValue : INT ;   (* Data19  *)
        DebugLevel : INT ;   (* Data20  *)
        StopWord : INT ;   (* Data21  *)
        Data22 : INT ;   (*   *)
        Data23 : INT ;   (*   *)
        Data24 : INT ;   (*   *)
        Data25 : INT ;   (*   *)
        Data26 : INT ;   (*   *)
        Data27 : INT ;   (*   *)
        Data28 : INT ;   (*   *)
        Data29 : INT ;   (*   *)
        Data30 : INT ;   (*   *)
        Data31 : INT ;   (*   *)
        Data32 : INT ;   (*   *)
        Data33 : INT ;   (*   *)
        Data34 : INT ;   (*   *)
        Data35 : INT ;   (*   *)
        Data36 : INT ;   (*   *)
        Data37 : INT ;   (*   *)
        Data38 : INT ;   (*   *)
        Data39 : INT ;   (*   *)
        Fire_alarm : INT ;   (* Data40  *)
        Data41 : INT ;   (*   *)
        Data42 : INT ;   (*   *)
        Data43 : INT ;   (*   *)
        Data44 : INT ;   (*   *)
        Data45 : INT ;   (*   *)
        Data46 : INT ;   (*   *)
        Data47 : INT ;   (*   *)
        Data48 : INT ;   (*   *)
        Data49 : INT ;   (*   *)
        Data50 : INT ;   (*   *)
        Data51 : INT ;   (*   *)
        Data52 : INT ;   (*   *)
        Data53 : INT ;   (*   *)
        Data54 : INT ;   (*   *)
        Data55 : INT ;   (*   *)
        Data56 : INT ;   (*   *)
        Data57 : INT ;   (*   *)
        Data58 : INT ;   (*   *)
        Data59 : INT ;   (*   *)
        Data60 : INT ;   (*   *)
        Data61 : INT ;   (*   *)
        Data62 : INT ;   (*   *)
        Data63 : INT ;   (*   *)
        Data64 : INT ;   (*   *)
        Data65 : INT ;   (*   *)
        Data66 : INT ;   (*   *)
        Data67 : INT ;   (*   *)
        Data68 : INT ;   (*   *)
        Data69 : INT ;   (*   *)
        Data70 : INT ;   (*   *)
        Data71 : INT ;   (*   *)
        Data72 : INT ;   (*   *)
        Data73 : INT ;   (*   *)
        Data74 : INT ;   (*   *)
        Data75 : INT ;   (*   *)
        Data76 : INT ;   (*   *)
        Data77 : INT ;   (*   *)
        Data78 : INT ;   (*   *)
        Data79 : INT ;   (*   *)
        Data80 : INT ;   (*   *)
        Data81 : INT ;   (*   *)
        Data82 : INT ;   (*   *)
        Data83 : INT ;   (*   *)
        Data84 : INT ;   (*   *)
        Data85 : INT ;   (*   *)
        Data86 : INT ;   (*   *)
        Data87 : INT ;   (*   *)
        Data88 : INT ;   (*   *)
        Data89 : INT ;   (*   *)
        Data90 : INT ;   (*   *)
        Data91 : INT ;   (*   *)
        Data92 : INT ;   (*   *)
        Data93 : INT ;   (*   *)
        Data94 : INT ;   (*   *)
        Data95 : INT ;   (*   *)
        Data96 : INT ;   (*   *)
        Data97 : INT ;   (*   *)
        Data98 : INT ;   (*   *)
        Data99 : INT ;   (*   *)
        LastUnload : INT ;   (* Data100  *)
        Data101 : INT ;   (*   *)
        Data102 : INT ;   (*   *)
        Data103 : INT ;   (*   *)
        Data104 : INT ;   (*   *)
        Data105 : INT ;   (*   *)
        Data106 : INT ;   (*   *)
        Data107 : INT ;   (*   *)
        Data108 : INT ;   (*   *)
        Data109 : INT ;   (*   *)
        Data110 : INT ;   (*   *)
        Data111 : INT ;   (*   *)
        Data112 : INT ;   (*   *)
        Data113 : INT ;   (*   *)
        Data114 : INT ;   (*   *)
        Data115 : INT ;   (*   *)
        Data116 : INT ;   (*   *)
        Data117 : INT ;   (*   *)
        Data118 : INT ;   (*   *)
        Data119 : INT ;   (*   *)
        Data120 : INT ;   (*   *)
        
   END_STRUCT;
END_TYPE

TYPE Wlan_T :
    STRUCT 
        AccessPoint : STRING ;   (* MAC address of the access point that is currently used.  *)
        SSID : STRING ;   (* SSID of the access point that is currently used. Set to - when we are not connected to an access point.  *)
        Channel : DINT ;   (* Currently used WLAN channel.  *)
        SignalLevel : DINT ;   (* Current signal level of the WLAN connection.  *)
        BitRate : DINT ;   (* Current WLAN bit rate.  *)
        
   END_STRUCT;
END_TYPE

TYPE Vmc_T :
    STRUCT 
        AllOK : BOOL ;   (* Vehicle controller AllOK signal  *)
        Clock : DINT ;   (* Vehicle clock (UTC). Seconds since 00:00:00 January 1 1970. Valid after the vehicle controller has connected to NT8000 followed by a restart of the vehicle controller.  *)
        LocalClock : DINT ;   (* Vehicle local clock adjusted for local timezone and daylight savings time. Seconds since 00:00:00 January 1 1970. Valid after the vehicle controller has connected to NT8000 followed by a restart of the vehicle controller.  *)
        PlcLoopTime : DINT ;   (* Time used for executing the last PLC loop.  *)
        PlcLoopTimeMax : DINT ;   (* Max time used for executing the PLC loop.  *)
        PlcLoopTimeAvg : DINT ;   (* Average time used for executing the PLC loop the last 100 times.  *)
        
   END_STRUCT;
END_TYPE

TYPE Master_T :
    STRUCT 
        MasterLinkUp : BOOL ;   (* Vehicle is connected to master controller  *)
        MasterCom : STRING ;   (* Vehicle communication to master controller  *)
        
   END_STRUCT;
END_TYPE

TYPE SerialPort_RS485_T :
    STRUCT 
        Baudrate : DINT ;   (* Baudrate (bits/second)  *)
        Databits : DINT ;   (* Number of data bits  *)
        Parity : STRING ;   (* Parity (None, Even, Odd)  *)
        Stopbits : DINT ;   (* Number of stopbits  *)
        Protocol : STRING ;   (* Protocol  *)
        
   END_STRUCT;
END_TYPE

TYPE SerialPort_RS422_T :
    STRUCT 
        Baudrate : DINT ;   (* Baudrate (bits/second)  *)
        Databits : DINT ;   (* Number of data bits  *)
        Parity : STRING ;   (* Parity (None, Even, Odd)  *)
        Stopbits : DINT ;   (* Number of stopbits  *)
        Protocol : STRING ;   (* Protocol  *)
        
   END_STRUCT;
END_TYPE

TYPE SerialPort_RS232_T :
    STRUCT 
        Baudrate : DINT ;   (* Baudrate (bits/second)  *)
        Databits : DINT ;   (* Number of data bits  *)
        Parity : STRING ;   (* Parity (None, Even, Odd)  *)
        Stopbits : DINT ;   (* Number of stopbits  *)
        Protocol : STRING ;   (* Protocol  *)
        
   END_STRUCT;
END_TYPE

TYPE PLC_Application_T :
    STRUCT 
        TxStatusBit0_Load : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit1_EaLD : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit2_HaveCmd : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit3_RelBRK : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit4_LowBatt : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit5_WaitLow : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit6_Charge : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit7_ChgComp : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit8_Manual : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit9_EStop : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit10_Blocked : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit11_IrStop : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit12_LostP : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit13 : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit14 : BOOL ;   (* Application status bit to Master  *)
        TxStatusBit15 : BOOL ;   (* Application status bit to Master  *)
        UserEventEN : BOOL ;   (* Set this flag to send a User Event. Clear when ENO is set  *)
        UserEventENO : BOOL ;   (* Response to PLC User Event is executed. Clear when EN is cleared  *)
        UserEventCode : DINT ;   (* User Event code  *)
        UserEventPar1 : DINT ;   (* User Event parameter 1  *)
        UserEventPar2 : DINT ;   (* User Event parameter 2  *)
        UserEventPar3 : DINT ;   (* User Event parameter 3  *)
        UserEventPar4 : DINT ;   (* User Event parameter 4  *)
        
   END_STRUCT;
END_TYPE

TYPE VehicleOptions_T :
    STRUCT 
        StatusID : DINT ;   (* Verfication of options. 0 = Valid, 1 = Unknown, 2 = Invalid option(s): 'number(s)'  *)
        StatusText : STRING ;   (* Status text.  *)
        MaxNoVehicles : DINT ;   (* Number of vehicles in class supported by dongle and software options KEY CODE.  *)
        MaxSpeed : DINT ;   (* Maximum travel speed limit supported by dongle and software options KEY CODE.  *)
        VehicleOptClass : DINT ;   (* Acknowledged vehicle option class by master computer.  *)
        VehicleTypeQuad : BOOL ;   (* Quad vehicle supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheel : BOOL ;   (* Multi vehicle supported by dongle and software options KEY CODE.  *)
        RadioComm : BOOL ;   (* Radio on serial port supported by dongle and software options KEY CODE.  *)
        NavLaser : BOOL ;   (* Navigation method Laser supported by dongle and software options KEY CODE.  *)
        NavSpot : BOOL ;   (* Navigation method Spot supported by dongle and software options KEY CODE.  *)
        NavMagnetic : BOOL ;   (* Navigation method Magnetic supported by dongle and software options KEY CODE.  *)
        NavInductive : BOOL ;   (* Navigation method Inductive supported by dongle and software options KEY CODE.  *)
        NavWall : BOOL ;   (* Navigation method Wall supported by dongle and software options KEY CODE.  *)
        ExternalPath : BOOL ;   (* Sending an external path to the vehicle supported by dongle and software options KEY CODE.  *)
        RangeAndWalls : BOOL ;   (* Sending wall data to the vehicle or to read range sensor scan data supported by dongle and software options KEY CODE.  *)
        DualCANBus : BOOL ;   (* A second CANbus supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheelerSD : BOOL ;   (* Multi wheeler SD supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheelerQuad4 : BOOL ;   (* Multi wheeler Quad for max 4 steeringwheels supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheelerQuad8 : BOOL ;   (* Multi wheeler Quad for max 8 steeringwheels supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheelerQuad16 : BOOL ;   (* Multi wheeler Quad for max 16 steeringwheels supported by dongle and software options KEY CODE.  *)
        VehicleTypeMultiWheelerQuad20 : BOOL ;   (* Multi wheeler Quad for max 20 steeringwheels supported by dongle and software options KEY CODE.  *)
        IMUSupport : BOOL ;   (* IMU supported by dongle and software options KEY CODE.  *)
        NetworkInterface : BOOL ;   (* Vehicle controller TCP/UDP interface supported by dongle and software options KEY CODE.  *)
        NavBarcode : BOOL ;   (* Navigation method Barcode supported by dongle and software options KEY CODE.  *)
        ThirdPartyNavigationSensor : BOOL ;   (* Third party navigation sensor(s) supported by dongle and software options KEY CODE.  *)
        
   END_STRUCT;
END_TYPE

TYPE VehicleControl_T :
    STRUCT 
        SetSpeed : DINT ;   (* Current commanded vehicle set-speed  *)
        TravelDir : DINT ;   (* Current, and latest, travel direction. 1 = forward, 0 = backward  *)
        Moving : BOOL ;   (* Vehicle is moving  *)
        Estop : BOOL ;   (* Set when the vehicle is emergency stopped  *)
        Stop : BOOL ;   (* The PLC sets this to stop the vehicle using the normal Vehicle.DecSlope.  *)
        QuickStop : BOOL ;   (* The PLC sets this to stop the vehicle using the Vehicle.EmcyDecSlope.  *)
        SlowDown : BOOL ;   (* The PLC sets this to make the vehicle enter SlowDownSpeed. Typically used on flexible segments when using sensor stop  *)
        SlowDownSpeed : DINT ;   (* Slowdown speed. See SlowDown  *)
        OperationMode : DINT ;   (* Current operation mode. 0 = Automatic, 1 = Manual, 2 = SemiAutomatic, 3 = SemiManual  *)
        SensorStopInputSignal : STRING ;   (* Symbolic name for digital input to be used as sensor stop. Also see SensorStopEnable  *)
        SensorStopInputPolarity : BOOL ;   (* Polarity switch for SensorStopInputSignal. Also see SensorStopEnable  *)
        SensorStopEnable : BOOL ;   (* Enable / Disable of SensorStopInput 0=disable, 1=enable. The intention is to use this to stop the vehicle on a sensor, at an operation point on a flexible segment and in conjunction with the LoadDocking.Arrived function. Though, there are no limits to use it in other situations too. When enabled, the vehicle will stop and stand still, as long as the selected sensor, SensorStopInputSignal, is active, due to its polarity, SensorStopInputPolarity. When the signal is not active, the vehicle goes on driving (if commanded of course)  *)
        BrakeOutputSignal : STRING ;   (* Symbolic name for digital output where brake is connected, to disable type NotUsed  *)
        BrakeOutputPolarity : BOOL ;   (* Polarity setting for brake digital output  *)
        BrakeOnDelay : DINT ;   (* Delay before the brakes are applied  *)
        BrakeOffDelay : DINT ;   (* Delay before trying to move the vehicle after the brakes have been released. To allow for the brakes to mechanically release.  *)
        EstopInputSignal : STRING ;   (* Symbolic name for digital input where Estop is connected, to disable type NotUsed. If you have not set this correct you can get emcy on the Can-Bus. This happens when the regulators try to move the wheels and there's no power on the servos.  *)
        EstopInputPolarity : BOOL ;   (* Polarity setting for estop digital input  *)
        HaltRequest : BOOL ;   (* Halt request to PLC application, used in detour function  *)
        HaltRequestDone : BOOL ;   (* Halt request done, set by PLC application, used in detour function  *)
        PreventAppDownload : BOOL ;   (* When true will an application transfer from AppDesigner and halt and restart from web interface be prevented.  *)
        PlcSetSteerEnable : BOOL ;   (* Set by PLC to enable/disable external steer regulator if proper bit in PlcSelectMask and PlcSelect is set. If vehicle is e-stopped the regulator must be disabled.  *)
        PlcSetDriveEnable : BOOL ;   (* Set by PLC to enable/disable external drive regulator if proper bit in PlcSelectMask and PlcSelect is set. If vehicle is e-stopped the regulator must be disabled.  *)
        PlcSelectMask : DINT ;   (* Select mask: Bit0:PlcSetAngle Bit1:PlcSetSpeed Bit2:PlcSetSteerEnable Bit3:PlcSetDriveEnable (PlcSetAngle and PlcSetSpeed is controlled per defined wheel)  *)
        PlcSelect : BOOL ;   (* PLC overrides bits selected by mask.  *)
        VeryLateSSIO : BOOL ;   (* Request for PLC application to stop movement, due to late SSIO blocking  *)
        CollisionRisk : BOOL ;   (* When the System Manager detects there is a collision risk for the vehicle, it will
transfer this information to the vehicle and the CollisionRisk parameter will be set. The parameter can only
be set in automatic and master mode. In all other cases the parameter is cleared.  *)
        
   END_STRUCT;
END_TYPE

TYPE CANBus_T :
    STRUCT 
        BusID : DINT ;   (* Physical CAN ID  *)
        MasterNodeID : DINT ;   (* Node ID for the CanOpen Master. If the buses are interconnected make sure they don't have the same MasterNodeID.  *)
        LoadBase : DINT ;   (* This property specifies the amount of CAN bus load that is allocated as margin and for background communication.  *)
        Bitrate : DINT ;   (* Bitrate (kBit/s)  *)
        NMTMaster : BOOL ;   (* Set to true if this unit is NMT master in a CANOpen network  *)
        SlaveComponent : STRING ;   (* Name of the component that represent the vehicle controller slave. Ignored if NMTMaster is true  *)
        SyncGeneration : BOOL ;   (* Set to true if syncs should be sent on this can channel. Ignored if NMTMaster is false  *)
        ReadSDO_NodeID : DINT ;   (* Node ID  *)
        ReadSDO_ObjectIndex : DINT ;   (* Object Index  *)
        ReadSDO_SubIndex : DINT ;   (* Sub Index  *)
        ReadSDO_Value : DINT ;   (* Output value  *)
        ReadSDO_StrValue : STRING ;   (* String output value  *)
        ReadSDO_DataType : STRING ;   (* Data type of value to read. Valid datatypes are:
BOOLEAN, UNSIGNED8, INTEGER8, UNSIGNED16, INTEGER16, UNSIGNED32, INTEGER32, VISIBLE_STRING.
For the type VISIBLE_STRING the value is passed in ReadSDO_StrValue parameter.  *)
        ReadSDO_Valid : BOOL ;   (* True if the returned Value is valid  *)
        ReadSDO_ErrorText : STRING ;   (* Error description. Empty if no error  *)
        ReadSDO_EN : BOOL ;   (* Trigger of SDO read operation  *)
        ReadSDO_ENO : BOOL ;   (* Trigger of operation done  *)
        WriteSDO_NodeID : DINT ;   (* Node ID  *)
        WriteSDO_ObjectIndex : DINT ;   (* Object Index  *)
        WriteSDO_SubIndex : DINT ;   (* Sub Index  *)
        WriteSDO_Value : DINT ;   (* Input value  *)
        WriteSDO_StrValue : STRING ;   (* Input value  *)
        WriteSDO_DataType : STRING ;   (* Data type of value to read. Valid datatypes are:
BOOLEAN, UNSIGNED8, INTEGER8, UNSIGNED16, INTEGER16, UNSIGNED32, INTEGER32, VISIBLE_STRING.
For the type VISIBLE_STRING the value is passed in WriteSDO_StrValue parameter.  *)
        WriteSDO_Valid : BOOL ;   (* True if the returned Value is valid  *)
        WriteSDO_ErrorText : STRING ;   (* Error description. Empty if no error  *)
        WriteSDO_EN : BOOL ;   (* Trigger of SDO write operation  *)
        WriteSDO_ENO : BOOL ;   (* Trigger of operation done  *)
        State : DINT ;   (* CAN channel state 0=disabled, 1=active, 2=error passive, 3=bus off  *)
        
   END_STRUCT;
END_TYPE

TYPE LoadOperation_T :
    STRUCT 
        OperationCode : DINT ;   (* Operation code. Used by the PLC to perform some application defined action at the operation point  *)
        OperationParam1 : DINT ;   (* Operation parameter 1. Additional operation data  *)
        OperationParam2 : DINT ;   (* Operation parameter 2. Additional operation data  *)
        CancelOperation : BOOL ;   (* Cancel operation is requested. This does not necessarily mean that the operation will be canceled. The PLC determine if to do or not. If the PLC cancels the operation it shall answer with a nonzero LoadOpError value in the LoadOpDone function  *)
        LoadOpDoneError : DINT ;   (* 0 = load operation ok, 1.. = load operation failed  *)
        LoadOpDoneResult : DINT ;   (* Operation result code  *)
        LoadOpDoneEN : BOOL ;   (* Set this when error and result is set properly. Clear when ENO is set. This must not be set/used if not OnTarget is set  *)
        LoadOpDoneENO : BOOL ;   (* Function is executed by background  *)
        
   END_STRUCT;
END_TYPE

TYPE LoadDocking_T :
    STRUCT 
        OnLastSegment : BOOL ;   (* Vehicle is driving on the segment leading to the operation point  *)
        DistOpPoint : DINT ;   (* Remaining distance to the operation point. The distance is measured as the crow flies.
The value is updated each half second if the delta distance is greater than 150mm +-50mm. The delta distance is
the calculated distance between the current position and the position used last time the parameter was updated.  *)
        RequestDistance : BOOL ;   (* Set by background program to request the PLC for a distance to drive on a flexible segment  *)
        PlcDistError : DINT ;   (* Error reported during a plc distance sequence:
0 = Ok.
1 = Distance error. The distance is probably longer than distance left on the segment. or PlcDistFromEnd flag is not properly set.
2 = Wrong mode. A plc distance sequence is started by the PLC, but the background program has not requested one (RequestDistance is not set).
3 = No line. A plc distance sequence is started on a segment that is not a line.
4 = Wrong segment. The symbol ArrivedEN has been set on a segment that is either not flexible or not the last commanded segment.  *)
        PlcDistENO : BOOL ;   (* Function executed by background and error is properly set. Cleared when EN is cleared.  *)
        PlcDistance : DINT ;   (* Set the distance to drive on the flexible segment  *)
        PlcDistFromEnd : BOOL ;   (* Set if PlcDistance shall be measured from the endpoint of the flexible segment. Otherwise it will be from the startpoint  *)
        PlcDistEN : BOOL ;   (* Set this when the other plc dist parameters are set properly. Clear it when ENO is set  *)
        OnTarget : BOOL ;   (* Set by background program when standing on the operation point. This is the start signal to the PLC for the load operation. It is cleared when the PLC sets LoadOpDoneEN and the background program responds with LoadOpDoneENO.  *)
        ArrivedEN : BOOL ;   (* Set arrived on a flexible segment, when the vehicle stands still, to force the LoadDocking.OnTarget signal. Clear when ENO is set  *)
        ArrivedENO : BOOL ;   (* Respond to PLC arrived is executed. Clear when EN is cleared  *)
        
   END_STRUCT;
END_TYPE

TYPE PointTrigger_T :
    STRUCT 
        Value : DINT ;   (* Point attribute value  *)
        Value2 : DINT ;   (* Point attribute value  *)
        Bit0_DepoST_Att : BOOL ;   (* Point attribute bit  *)
        Bit1_ShutEQ_Att : BOOL ;   (* Point attribute bit  *)
        Bit2 : BOOL ;   (* Point attribute bit  *)
        Bit3 : BOOL ;   (* Point attribute bit  *)
        Bit4_Area1_Pnt : BOOL ;   (* Point attribute bit  *)
        Bit5_Area2_Pnt : BOOL ;   (* Point attribute bit  *)
        Bit6_Area4_Pnt : BOOL ;   (* Point attribute bit  *)
        Bit7_Area8_Pnt : BOOL ;   (* Point attribute bit  *)
        Bit8_HP_Pnt : BOOL ;   (* Point attribute bit  *)
        Bit9_Chrg_Right : BOOL ;   (* Point attribute bit  *)
        Bit10_Chrg_Left : BOOL ;   (* Point attribute bit  *)
        Bit11 : BOOL ;   (* Point attribute bit  *)
        Bit12 : BOOL ;   (* Point attribute bit  *)
        Bit13 : BOOL ;   (* Point attribute bit  *)
        Bit14_Full_Chrg : BOOL ;   (* Point attribute bit  *)
        Bit15 : BOOL ;   (* Point attribute bit  *)
        
   END_STRUCT;
END_TYPE

TYPE SegmentTrigger_T :
    STRUCT 
        Value : DINT ;   (* Segment attribute value  *)
        Value2 : DINT ;   (* Segment attribute value  *)
        Bit0_StartDDAtt : BOOL ;   (* Segment attribute bit  *)
        Bit1 : BOOL ;   (* Segment attribute bit  *)
        Bit2 : BOOL ;   (* Segment attribute bit  *)
        Bit3 : BOOL ;   (* Segment attribute bit  *)
        Bit4_Area1_Seg : BOOL ;   (* Segment attribute bit  *)
        Bit5_Area2_Seg : BOOL ;   (* Segment attribute bit  *)
        Bit6_Area4_Seg : BOOL ;   (* Segment attribute bit  *)
        Bit7_Area8_Seg : BOOL ;   (* Segment attribute bit  *)
        Bit8 : BOOL ;   (* Segment attribute bit  *)
        Bit9 : BOOL ;   (* Segment attribute bit  *)
        Bit10_DDLeft_A : BOOL ;   (* Segment attribute bit  *)
        Bit11_DDRight_A : BOOL ;   (* Segment attribute bit  *)
        Bit12_TurnLeft_A : BOOL ;   (* Segment attribute bit  *)
        Bit13_TurnRght_A : BOOL ;   (* Segment attribute bit  *)
        Bit14_DisIrSlow : BOOL ;   (* Segment attribute bit  *)
        Bit15_DisIrStop : BOOL ;   (* Segment attribute bit  *)
        
   END_STRUCT;
END_TYPE

TYPE SSIO_T :
    STRUCT 
        LogicalLine : DINT ;   (* Logical SSIO line.  *)
        UnitNumber : DINT ;   (* Unit id in a logical line.  *)
        InputOutputID : DINT ;   (* ID of input/output in unit.  *)
        RequestType : DINT ;   (* 0:Read input status, 1:Read output status, 2:Set output status.  *)
        SetStatus : DINT ;   (* The status to set in case of a Set output status request, 0:OFF, 1:ON, 2:Flash 1Hz.  *)
        Status : DINT ;   (* The returned status in case of a read request. Valid only when SSIO_ENO is set.  *)
        SSIO_EN : BOOL ;   (* First set SSIO address and request type then set this property to initiate a SSIO request. Clear when SSIO_ENO is set and Status has been read.  *)
        SSIO_ENO : BOOL ;   (* Set by background software when the SSIO request has been executed. For a read request this means that the reply can be read from the Status property.  *)
        Error : DINT ;   (* 0:No error, 1:Timeout.  *)
        
   END_STRUCT;
END_TYPE

TYPE LocalOrder_T :
    STRUCT 
        DestPoint : DINT ;   (* Destination point  *)
        OpCode : DINT ;   (* Operation code if there is an operation to be performed at the destination point  *)
        OpParam1 : DINT ;   (* Additional operation parameter  *)
        OpParam2 : DINT ;   (* Additional operation parameter  *)
        Error : DINT ;   (* Error codes set by background. Only valid when OrderENO is set.
0  = Ok.
1  = General nack.
2  = Destination point does not exist.
3  = Sync point not ok. Probably zero. The sync point is where the last order stopped, and from where the new order starts.
4  = No way to reach the destination point.
10 = Not in system.
11 = Master mode.
12 = Wrong operation mode. The vehicle must be in Auto mode to accept local orders.
20 = Invalid destination point.
21 = Order in progress.  *)
        OrderEN : BOOL ;   (* Set when proper values are assigned to the local order parameters. Cleared when ENO is set  *)
        OrderENO : BOOL ;   (* Set by background program when Error is assigned. Cleared when EN is cleared  *)
        
   END_STRUCT;
END_TYPE

TYPE BlackBox_T :
    STRUCT 
        TrigENO : BOOL ;   (* Set when a BlackBox is trigged manually.  Cleared when EN is cleared  *)
        TrigEN : BOOL ;   (* Set this when you want to trig a BlackBox. Clear it when ENO is set  *)
        TrigReason : STRING ;   (* Short description why blackbox was trigged. Used as title in the vehicle controller web interface.  *)
        
   END_STRUCT;
END_TYPE

TYPE Manual_T :
    STRUCT 
        PlcAngle : DINT ;   (* Manual angle set by Plc to background software if proper bit in PlcSelectMask and PlcSelected is set  *)
        PlcSpeed : DINT ;   (* Manual speed set by Plc to background software if proper bit in PlcSelectMask and PlcSelected is set.  *)
        PlcSteerMode : DINT ;   (* Manual steer mode for a Quad/2xSD vehicle set by Plc to background software if proper bit in PlcSelectMask and PlcSelected is set. 0: 2*SD Anti-parallel, 1: 2*SD Parallel, 2: DiffDrive  *)
        PlcSetOperationMode : DINT ;   (* Operation mode set by Plc to background software if proper bit in PlcSelectMask and PlcSelected is set. 0 = Automatic, 1 = Manual, 2 = SemiAutomatic, 3 = SemiManual  *)
        PlcSelectMask : DINT ;   (* Individually select mask: Bit0:PlcAngle Bit1:PlcSpeed Bit2:PlcSetOperationMode Bit3:Reserved Bit4:PlcSteerMethod  *)
        PlcSelect : BOOL ;   (* PLC overrides MCD signals  *)
        
   END_STRUCT;
END_TYPE

TYPE Automatic_T :
    STRUCT 
        DestPoint : DINT ;   (* The endpoint of current order  *)
        ExecDriveCommand : BOOL ;   (* Vehicle executes a drive mission (or has one in queue)  *)
        CurrentOrderMode : DINT ;   (* 1 = Master mode, 2 = Local mode, 3 = Local mode with TM  *)
        StartupOrderMode : DINT ;   (* Vehicle order mode at startup. 1 = Master mode, 2 = Local mode, 3 = Local mode with TM  *)
        SetOrderMode : DINT ;   (* Set new vehicle order mode . 1 = Master mode, 2 = Local mode, 3 = Local mode with TM  *)
        SetOrderModeError : DINT ;   (* Error codes from background program when trying to set order mode. 0 = Ok, 1 = Undefined mode, 2 = Order in progress  *)
        SetOrderModeEN : BOOL ;   (* Set this when proper value is assigned to SetOrderMode. Clear it when SetOrderModeENO is set  *)
        SetOrderModeENO : BOOL ;   (* Set by background program when SetOrderModeError is properly set. Cleared when SetOrderModeEN is cleared  *)
        StatusID : DINT ;   (* Order status:
0 = No order.
1 = Have order with no operation and the vehicle is driving to the destination point.
2 = Have order with operation and the vehicle is driving to the destination point.
3 = Standing on the operation point and wait for operation to finish.
4 = Master has canceled the non operation order and the vehicle is driving to the end of the last ordered segment.
5 = Master has canceled the operation order and the vehicle is driving to the end of the operation segment.
6 = Master has canceled the operation order and the vehicle is standing on the operation point, waiting for the PLC to cancel the order.  *)
        StatusText : STRING ;   (* Status text  *)
        
   END_STRUCT;
END_TYPE

TYPE LayoutPosition_T :
    STRUCT 
        InSystem : BOOL ;   (* Set to true when the vehicle is in the system, after a successful auto insert.  *)
        Point : DINT ;   (* Current point. When not on point, the value is set to zero  *)
        Segment : DINT ;   (* The segment that the vehicle is currently traveling on. When the current segment is unknown the value is set to zero.  *)
        Distance : DINT ;   (* Traveled distance on current segment. Valid if LayoutPosition.Segment is non-zero.  *)
        RemainingDistance : DINT ;   (* Remaining distance on current segment. Valid if LayoutPosition.Segment is non-zero.  *)
        MaxSpeed : DINT ;   (* By the layout allowed maximum speed on current segment. Valid if LayoutPosition.Segment is non-zero.  *)
        
   END_STRUCT;
END_TYPE

TYPE GenericDisplay_T :
    STRUCT 
        VehicleStatusID : DINT ;   (* Background choosen id of current vehicle status  *)
        VehicleStatusInlineValue : DINT ;   (* The value that the Background can insert into the vehicle status string  *)
        PlcVehicleStatusID : DINT ;   (* Plc choosen id of current vehicle status  *)
        PlcVehicleStatusInlineValue : DINT ;   (* The value that the PLC optionally can insert into the vehicle status string  *)
        PlcEnable : BOOL ;   (* Enable PLC rights to use set vehicle status  *)
        
   END_STRUCT;
END_TYPE

TYPE Autoinsert_T :
    STRUCT 
        Speed : DINT ;   (* Autoinsert speed. This speed is used during the whole autoinsert  *)
        AllowBackwards : BOOL ;   (* Allows the vehicle to autoinsert backwards  *)
        SearchAngleLimit : DINT ;   (* From vehicle, the maximum angle where to search for a point to autoinsert to  *)
        SearchDistance : DINT ;   (* The maximum distance from the vehicle where to search for a point to autoinsert to  *)
        PointAngleLimit : DINT ;   (* Maximum angle deviation to consider the vehicle to be on point or segment. If this value exceeds 0.75*Guidance.SafetyZoneTh then 0.75*Guidance.SafetyZoneY will be used instead.  *)
        PointTolerance : DINT ;   (* The maximum distance to a point/segment to consider the vehicle to be on that point/segment. If this value exceeds 0.75*Guidance.SafetyZoneY then 0.75*Guidance.SafetyZoneY will be used instead.  *)
        PointInsertInhibit : BOOL ;   (* PointInsertInhibit
This flag has only effect if none of the segments leading into a potential
insert point are autoinsert segments. If so, and an insert point is found when
the flag is set, the vehicle will not insert to the point, and not to any
other point in the layout. The insert is aborted and the vehicle will remain
"not in system"  *)
        OnSegment : BOOL ;   (* Is set if the vehicle is inside the safetyzone, during an autoinsert. When OnSegment, the user can release the override button on the MCD  *)
        Target : DINT ;   (* The point the vehicle is inserting to.  *)
        QuickEnable : BOOL ;   (* Allows new orders to execute as soon as the vehicle is on segment during an autoinsert. Also make vehicle use the layout speed instead of autoinsert speed when on segment. If this flag is set, when an autoinsert is running, a new order will be accepted and the vehicle will immediately drive to the destination without stopping on the aimed autoinsert point. Requires a NDC8 2.4 compatible Master.  *)
        StatusID : DINT ;   (* Autoinsert states:
0 = Idle. Enters this state when switched to manual mode. Leaves the state when switched to auto or semi-automatic mode.
1 = Searching. Searching for a point or segment to insert to.
2 = InProgressForward. Autoinserting in forward direction. Need a positive manual speed as long as not on segment.
3 = InProgressBackward. Autoinserting in backward direction. Need a negative manual speed as long as not on segment.
4 = Finished. The vehicle is in system. Will keep this state until switched to manual mode.
5 = Failed. The autoinsert failed. Will keep this state until switched to manual mode.  *)
        StatusText : STRING ;   (* Autoinsert state text. See StatusID.  *)
        
   END_STRUCT;
END_TYPE

TYPE Guidance_T :
    STRUCT 
        SafetyZoneX : DINT ;   (* This parameter defines the safety zone for the segment end-points. The value is defined in mm.  *)
        SafetyZoneY : DINT ;   (* This parameter defines the safety zone on the sides of the segment. The value is defined in mm.  *)
        SafetyZoneTh : DINT ;   (* This parameter defines the safety zone for the vehicle angle deviation from the segment. The value is defined in degrees.  *)
        OutsideSafetyZone : BOOL ;   (* The vehicle is outside the Safety Zone  *)
        LateralWeight : REAL ;   (* Weight for lateral error in the cost function used to compute control gains for path following.  A higher value will reduce lateral errors faster but makes the steering less smoth.  *)
        HeadingWeight : REAL ;   (* Weight for heading error in the cost function used to compute control gains for path following. A higher value will reduce heading errors faster but makes the steering less smoth.  *)
        UsePredictedPosition : BOOL ;   (* Use a predicted position to guide the vehicle. The predicted position is computed using the vehicles current velocity and the time Vehicle.SteeringDelayCompensation.  *)
        CurvatureLimitsControl : BOOL ;   (* When enabled the guidance feedback control is limited in such a way that the sum of feedforward part due to curvature and the control part neved exceed 90 degrees for a wheel on the symmetry axis. This will reduce the risk of unstable steering in cases of large guidance errors in sharp curves.  *)
        StrictDiffMode : BOOL ;   (* No wheel turn when driving on diff-segment with a Quad vehicle.This
will prevent the vehicle controller from trying to rotate the wheels
more than +/- 90 degrees but will probably increase the guidance
error.

To be able to steer the vehicle correctly with this flag activated the
wheels must be mounted on the center line, that is the y-coordinates for
the wheels must be 0.

This parameter has only effect if the vehicle is of type Quad.  *)
        LoopTime : DINT ;   (* Time between updates of setvalues.  *)
        StatusTrigDistance : DINT ;   (* When the vehicle has this distance left to drive a guide status (and also a nav status) is trigged and sent to host and application (PLC). 0 (default) means the function is disabled  *)
        DevPosValid : BOOL ;   (* True when the vehicle is not moving and the Guidance.DevX, Guidance.DevY and Guidance.DevAngle are updated for the current position.  *)
        DevX : DINT ;   (* Distance to end point on current command, positive value if beyond point.  *)
        DevY : DINT ;   (* The vehicle y deviation from the segment.  *)
        DevAngle : DINT ;   (* The vehicle angle deviation from the segment.  *)
        DistanceToStop : DINT ;   (* Distance to drive until the vehicle has to stop. The reason for the stop is indicated in the StopReason property. Valid when the vehicle is in Automatic mode.  *)
        StopReason : DINT ;   (* Reason for stop. Valid when the vehicle is in Automatic mode.
0 = Vehicle will stop because it has not received any more drive commands
1 = Vehicle will stop and change travel direction
2 = Vehicle will stop and change steer mode
3 = Vehicle must stop and turn the wheels before continuing to drive
4 = Vehicle will stop before or after a rotation
5 = Vehicle will stop at a z-segment  *)
        
   END_STRUCT;
END_TYPE

TYPE Position_T :
    STRUCT 
        X : DINT ;   (* Vehicle position X  *)
        Y : DINT ;   (* Vehicle position Y  *)
        Angle : DINT ;   (* Vehicle position angle  *)
        Angle2 : DINT ;   (* Vehicle position angle  *)
        NavLevel : DINT ;   (* Navigation quality in percent. 0 = lost, 100 = superb  *)
        Valid : BOOL ;   (* Valid signal (property values are valid)  *)
        
   END_STRUCT;
END_TYPE

TYPE MCD7P_T :
    STRUCT 
        Speed : DINT ;   (* Speed from Mcd  *)
        Angle : DINT ;   (* Angle from Mcd  *)
        Buttons : DINT ;   (* Buttons from Mcd  *)
        DeviceType : STRING ;   (* A Manual Control Device  *)
        Button1 : BOOL ;   (* Auto mode button  *)
        Button2 : BOOL ;   (* Semi mode button  *)
        Button3 : BOOL ;   (* Man mode button  *)
        Button4 : BOOL ;   (* Forward backward button  *)
        Button5 : BOOL ;   (* Low speed button  *)
        Button6 : BOOL ;   (* High speed button  *)
        Button7 : BOOL ;   (* Override button  *)
        Button8 : BOOL ;   (* Load1 up button  *)
        Button9 : BOOL ;   (* Load1 down button  *)
        Button10 : BOOL ;   (* Load2 left button  *)
        Button11 : BOOL ;   (* Load2 right button  *)
        McdHighSpeed : DINT ;   (* Mcd high or max speed  *)
        McdLowSpeed : DINT ;   (* Mcd low speed  *)
        Valid : BOOL ;   (* Set when an MCD device is up and running  *)
        
   END_STRUCT;
END_TYPE

TYPE NavInit_T :
    STRUCT 
        Method : DINT ;   (* Navigation init methods:
0. NavAreaInit. The vehicle controller will search for a
   position within the given navigation area. If navigation area is
   set to 0 the vehicle controller will search the whole layout. Only
   supported by laser (reflector) navigation and natural navigation.

1. PointInit. The vehicle controller will search for a position in an
   area around the given NDC point. The size of the search area is
   defined by PointSearchLimit and PointAngleSearchLimit. Only
   supported by laser (reflector) navigation and natural navigation.

2. SetPosition. The vehicle controller will set its position to that
   of the given NDC point. The vehicle must be in manual or semi manual
   mode and standing still.

3. CoordinatesInit. The vehicle controller will search for a position
   in an area around the given coordinates. The size of the search
   area is defined by PointSearchLimit and PointAngleSearchLimit. Only
   supported by laser (reflector) navigation and natural navigation.

4. SetCoordinates. The vehicle controller will set its position to
   that of the given given coordinates. The vehicle must be in manual
   or semi manual mode and standing still.  *)
        Target : DINT ;   (* Target is point id in case of PointInit or SetPosition methods. For
NavAreaInit it is the area id. Not used for other init methods.  *)
        TargetX : DINT ;   (* Target X coordinate, only used if init method is SetCoordinates or CoordinatesInit  *)
        TargetY : DINT ;   (* Target Y coordinate, only used if init method is SetCoordinates or CoordinatesInit  *)
        TargetAngle : DINT ;   (* Target Angle coordinate in cdeg, only used in case of SetCoordinates or CoordinatesInit  *)
        RequestEN : BOOL ;   (* Input valid  *)
        RequestENO : BOOL ;   (* Output valid  *)
        Error : DINT ;   (* Error codes
0 = Navigation initialization succeeded.
1 = Unknown method.
3 = Target does not exist.
4 = Not supported.
5 = Not in manual mode or semi manual.
6 = Too few reflector bearings.
7 = Bad distribution of bearings.
8 = Reflector init failed in current search area.
9 = Ambiguous position. More than one valid position found in current search
    area.
10 = Init calculation aborted.
11 = Vehicle is moving.
12 = Position outside search area.
15 = No range measurements.
16 = Bad range match.
17 = Empty init area.
18 = Multi oriented point.
19 = Unknown position marker.
20 = No position marker measurements.  *)
        PointSearchLimit : DINT ;   (* Max distance from the target point in PointInit and CoordinatesInit.
If no position is found within the limits, the vehicle will redo the init-process until it finds one.  *)
        PointSearchAngleLimit : DINT ;   (* Maximum angular deviation allowed from the target point in PointInit
and CoordinatesInit. If no position is found within the limits, the
vehicle will redo the init-process until it finds one.  *)
        LostSearchLimit : DINT ;   (* Max distance from old position when doing init after navigation
lost. If no position is found within the distance, the vehicle will
redo the init-process until it finds one.  *)
        
   END_STRUCT;
END_TYPE

TYPE NDC8_T : 
    STRUCT 
	NavInit : NavInit_T;
	    Mcd : MCD7P_T;
	    Position : Position_T;
	    Guidance : Guidance_T;
	    Autoinsert : Autoinsert_T;
	    Opt : GenericDisplay_T;
	    LayoutPosition : LayoutPosition_T;
	    Automatic : Automatic_T;
	    Manual : Manual_T;
	    BlackBox : BlackBox_T;
	    LocalOrder : LocalOrder_T;
	    SSIO : SSIO_T;
	    SegmentTrigger : SegmentTrigger_T;
	    PointTrigger : PointTrigger_T;
	    LoadDocking : LoadDocking_T;
	    LoadOperation : LoadOperation_T;
	    CANBus1 : CANBus_T;
	    CANBus2 : CANBus_T;
	    VehicleControl : VehicleControl_T;
	    VehicleOptions : VehicleOptions_T;
	    PLC_Application : PLC_Application_T;
	    COM1 : SerialPort_RS232_T;
	    COM2 : SerialPort_RS422_T;
	    COM3 : SerialPort_RS485_T;
	    Master : Master_T;
	    Vmc : Vmc_T;
	    Wlan : Wlan_T;
	    OMPLC : OMPLC_T;
	    VehicleApplication : VehicleApplication_T;
	    Layout : Layout_T;
	    CanOpenMaster : CanOpenMaster_T;
	    CanOpenEmergency : CanOpenEmergency_T;
	    PLCEmergency : PLCEmergency_T;
	    SlavebusControl : SlavebusControl_T;
	    UserDefined : UserDefined_T;
	    ExternalPath : ExternalPath_T;
	    BlockedInfo : BlockedInfo_T;
	    FrontWheel : WheelSD_T;
	    RearWheel : WheelSD_T;
	    COM5 : LanSerialPort_T;
	    LS2000 : LS2000Scanner_T;
	    Vehicle : Vehicle_T;
	    ReflectorInit : ReflectorInit_T;
	    NaturalNavigator : NaturalNavigator_T;
	    VehicleNavigator : VehicleNavigator_T;
	    ReflectorNavigator : ReflectorNavigator_T;
	    COM6 : LanSerialPort_T;
	    DCD_5 : DCD_5_T;
	    DCD_6 : DCD_6_T;
	    DCD_7 : DCD_7_T;
	    DCD_8 : DCD_8_T;
	    SDIO : SDIO_T;
	    CAN_IO_3 : CAN_IO_3_T;
	    

   END_STRUCT;
END_TYPE



(* GLOBALE PROTOTYPEN *)



(* PROJEKT PROTOTYPEN *)

$INCLUDE "C:\USERS\USER\DESKTOP\CVC700\SJ_2SD_G5_CVC700\PLC\$GEN$\DISPLAYSTOPSTRING_FB.PTT"


(* EXTERNE POEs *)



$END_INCLUDE_FILE
