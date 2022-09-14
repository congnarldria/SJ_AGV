using System;
using System.Windows.Forms;
using System.Collections;
using System.Collections.Generic;
using NDC8.DataAccess.Script;
using System.Diagnostics;


namespace NDC8.Business
{
    public class P46164V1_0_5 : WizardScriptBase4
    {
        private const string NOT_USED = "NotUsed";
        private const int DEFAULT_DRIVE_ENC_SCALE = 10000;
        private const int DEFAULT_STEER_ENC_SCALE = 4096;

        private List<ListItem> m_NavigationTypes = new List<ListItem>();
        #region Global
        drivetype ACD_Small;
        drivetype ACD_Medium;
        drivetype ACS;
        drivetype DCD_Small;
        drivetype DCD_Medium;
        drivetype DCD_Large;
        List<int> FreeNodeIds;


        //DCT files
        string ACD_Small_DCT = "P41885V1.3.5";
        string ACD_Medium_DCT = "P41874V1.3.4";
        string ACS_DCT = "P41883V1.3.3";
        string DCD_Small_DCT = "P46007V1.0.4";
        string DCD_Medium_DCT = "P46009V1.0.4";
        string DCD_Large_DCT = "P46020V1.0.4";
        string BUILTIN_SDIO_DCT = "P46109V1.1.1";
        string SDIO_DCT = "P41746V1.7.3";
        string CAN_Enc_DCT = "P41774V1.5.0";
        string WGU_DCT = "P41931V1.0.5";


        CheckBoxItem wallCheckBox = new CheckBoxItem("Wall", "Wall", "The vehicle will be able to navigate on wall objects using a range scanner.", false);
        CheckBoxItem ndtCheckBox = new CheckBoxItem("Natural", "Natural", "The vehicle will be able to navigate on a NDT map using a range scanner.", false);
        CheckBoxItem inductiveCheckBox = new CheckBoxItem("Inductive Wire", "Inductive Wire", "The vehicle will be able to navigate with inductive wire.", false);
        CheckBoxItem magneticCheckBox = new CheckBoxItem("Magnetic Wire", "Magnetic Wire", "The vehicle will be able to navigate with magnetic tape.", false);
        CheckBoxItem spotCheckBox = new CheckBoxItem("Spot", "Spot", "The vehicle will be able to navigate with spots.", false);
        CheckBoxItem reflectorCheckBox = new CheckBoxItem("Reflector", "Reflector", "The vehicle will be able to navigate with reflectors.", false);
        CheckBoxItem barcodeCheckBox = new CheckBoxItem("Barcode", "Barcode", "The vehicle will be able to navigate using position markers.", false);
        #endregion

        public override List<ScannerPreset> GetScannerPresets()
        {
            var list = new List<ScannerPreset>
            {
                new ScannerPreset
                {
                    Name = "1 x LS2000 / LS2000T",
                    Description = "LS2000 is a high resolution, top precision laser scanner for both reflector and natural navigation. LS2000T is for use in cold storage.",
                    ImageName = "LS2000",
                    Scanners = new List<Scanner>
                    {
                        new Scanner
                        {
                            ComponentType = "LS2000Scanner",
                            DeviceName = "LS2000",
                            ConnectionPointName = "LAN"
                        }
                    }
                },
                new ScannerPreset
                {
                    Name = "2 x microScan3",
                    Description = "microScan3 is a safety scanner developed by SICK. Two scanners are required when they are used for navigation.",
                    ImageName = "microscan3",
                    Scanners = new List<Scanner>{
                    new Scanner
                    {
                        ComponentType= "MicroScan3Scanner",
                        DeviceName = "MicroScan_Front",
                        ConnectionPointName = "LAN"
                    },
                    new Scanner
                    {
                        ComponentType= "MicroScan3Scanner",
                        DeviceName = "MicroScan_Rear",
                        ConnectionPointName = "LAN"
                    },

                }
                },
                new ScannerPreset
                {
                    Name = "2 x nanoScan3",
                    Description = "nanoScan3 is a smaller safety scanner developed by SICK. Two scanners are required when used for navigation.",
                    ImageName = "nanoscan3",
                    Scanners = new List<Scanner>
                    {
                        new Scanner
                        {
                            ComponentType = "MicroScan3Scanner",
                            DeviceName = "NanoScan_Front",
                            ConnectionPointName = "LAN"
                        },
                        new Scanner
                        {
                            ComponentType = "MicroScan3Scanner",
                            DeviceName = "NanoScan_Rear",
                            ConnectionPointName = "LAN"
                        }
                    }
                }
            };
            return list;
        }

        #region Init
        private void init()
        {
            ACD_Small = new drivetype(ACD_Small_DCT);
            ACD_Medium = new drivetype(ACD_Medium_DCT);
            ACS = new drivetype(ACS_DCT);
            DCD_Small = new drivetype(DCD_Small_DCT);
            DCD_Medium = new drivetype(DCD_Medium_DCT);
            DCD_Large = new drivetype(DCD_Large_DCT);

            FreeNodeIds = new List<int>();
            for (int i = 5; i <= 31; ++i)
            {
                FreeNodeIds.Add(i);
            }

            if (BUILTIN_SDIO_DCT != "")
            {
                FreeNodeIds.Add(2);
                for (int i = 0; i < countSDIO(); ++i)
                {
                    if (i == 0)
                    {
                        FreeNodeIds.Remove(2);
                    }
                    else
                    {
                        FreeNodeIds.Remove(10 + i);
                    }
                }
            }
            else
            {
                for (int i = 0; i < countSDIO(); ++i)
                {
                    FreeNodeIds.Remove(11 + i);
                }
            }

            //Create LAN port
            ComponentData Lan = VehicleApplication2.CreateDevice("LAN", "LAN", VehicleApplication2.ApplicationName, "CVC700", true);
        }
        #endregion

        #region Background functions
        public override bool ValidateShowInductiveAntennas(string navigationType, ref List<string> deviceTypes)
        {
            deviceTypes.Add("0x8000000");
            return (navigationType.ToLower().IndexOf("inductive") > -1);
        }

        public override void SetInductiveAntennas(List<Antenna> list)
        {
            if (VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }
            try
            {
                ComponentHandler2.VehicleApplication = VehicleApplication;

                foreach (Antenna inductiveAntenna in list)
                {
                    ComponentHandler2.AddInductiveAntenna(inductiveAntenna.CANDevice, inductiveAntenna.ConnectionPoint, inductiveAntenna.Name);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override bool ValidateShowSpotAntennas(string navigationType, ref List<string> deviceTypes)
        {
            deviceTypes.Add("0x9000000");
            return (navigationType.ToLower().IndexOf("spot") > -1);
        }

        public override bool ValidateShowSpotAntennas(string navigationType)
        {
            return (navigationType.ToLower().IndexOf("spot") > -1);
        }

        public override bool ValidateShowMagneticAntennas(string navigationType)
        {
            return (navigationType.ToLower().IndexOf("magnetic") > -1);
        }

        public override void SetVehicleType(string vehicleType)
        {
            try
            {
                ComponentData vehicle = null;
                if (VehicleApplication2.OkToAddComponent("Vehicle"))
                {
                    vehicle = VehicleApplication2.CreateComponent("Vehicle", "Vehicle");
                }
                if (vehicleType.Contains("SD"))
                {
                    vehicle.SetParameter("VehicleType", "SD");
                }
                else
                {
                    vehicle.SetParameter("VehicleType", "QUAD");
                    //Set Guidance parameters that are needed for a QUAD AGV
                    ComponentData guidance = VehicleApplication2.GetComponentByName("Guidance") as ComponentData;
                    guidance.SetParameter("LateralWeight", "2.0");
                    guidance.SetParameter("HeadingWeight ", "0.5");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override bool OKToAddWheel(int noOfAddedSD, int noOfAddedS, int noOfAddedD, WheelFunctionEnum wheelFunction, string vehicleType, out string helpText)
        {
            helpText = "";
            if (vehicleType.Contains("SD"))
            {
                helpText = "No more wheels can be added. Maximum number of wheels are 8";
                return ((noOfAddedSD + noOfAddedS + noOfAddedD) < 8);
            }
            else
            {
                helpText = "No more wheels can be added. Maximum number of wheels are 8";
                return ((noOfAddedSD + noOfAddedS + noOfAddedD) < 8);
            }

        }

        public override bool OKToLeaveWheelDialog(int noOfAddedSD, int noOfAddedS, int noOfAddedD, string vehicleType, out string helpText)
        {
            helpText = "";
            bool ret = base.OKToLeaveWheelDialog(noOfAddedSD, noOfAddedS, noOfAddedD, vehicleType, out helpText);
            if (vehicleType == "QUAD Multiwheel")
            {
                int addedWheels = noOfAddedS + noOfAddedSD;
                if (addedWheels < 2)
                {
                    helpText = "A QUAD vehicle must at least have two wheels";
                    ret = false;
                }
            }
            if (vehicleType == "SD Multiwheel")
            {
                if (!(noOfAddedSD >= 1 || (noOfAddedS >= 1 && noOfAddedD >= 1) || noOfAddedD >= 2))
                {
                    helpText = "A SD vehicle must at least have one Steer and one Drive unit";
                    ret = false;
                }
            }
            if ((noOfAddedSD + noOfAddedS + noOfAddedD) > 8)
            {
                helpText = "Too many wheels are added. Max number of weeels is 8, please delete the rest of the wheels!";
                ret = false;
            }
            return ret;
        }

        public override bool LockedNumberOfWheels(string vehicleType)
        {
            if (vehicleType == "SD")
            {
                WheelList = new List<WheelSetup>();
                WheelSetup setup1 = new WheelSetup("FrontWheel", WheelFunctionEnum.SD, ServoTypeEnum.DC, "", ServoTypeEnum.DC, "");
                WheelList.Add(setup1);
                return true;
            }
            else if (vehicleType == "QUAD")
            {
                WheelList = new List<WheelSetup>();
                WheelSetup setup1 = new WheelSetup("FrontWheel", WheelFunctionEnum.SD, ServoTypeEnum.DC, "", ServoTypeEnum.DC, "");
                WheelSetup setup2 = new WheelSetup("RearWheel", WheelFunctionEnum.SD, ServoTypeEnum.DC, "", ServoTypeEnum.DC, "");
                WheelList.Add(setup1);
                WheelList.Add(setup2);
                return true;
            }
            else
            {
                return false;
            }
        }

        public override List<ListItem> GetVehicleTypes()
        {
            List<ListItem> list = new List<ListItem>();
            list.Add(new ListItem("SD", "Will create a basic SD vehicle with one predefined steer and drive wheel. Alterations regarding AC/DC will be possible."));
            list.Add(new ListItem("QUAD", "Will create a basic QUAD vehicle with two predefined steer and drive wheels. Alterations regarding AC/DC will be possible."));
            list.Add(new ListItem("SD Multiwheel", "Create a SD vehicle with up to 8 wheels with Steer, Drive or SteerDrive functionality. A vehicle with SD functionality must always have a stiff rear axis!"));
            list.Add(new ListItem("QUAD Multiwheel", "Create a QUAD vehicle with up to 8 wheels with Steer, Drive or SteerDrive functionality."));
            return list;
        }

        public override List<ListItem> GetWheelFunctions(string vehicleType)
        {
            List<ListItem> wheelFunctions = new List<ListItem>();
            wheelFunctions.Add(new ListItem(""));
            wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.SD));
            wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.S));
            if (vehicleType.Contains("SD"))
            {
                wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.D));
                wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.DD));
            }
            if (vehicleType.Contains("QUAD"))
            {
                wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.D));
                wheelFunctions.Add(WheelSetupEnums.GetWheelFunctionListItem(WheelFunctionEnum.DD));
            }
            return wheelFunctions;

        }

        public override List<ListItem> GetServoModels(WheelFunctionEnum wheelFunction, ServoTypeEnum servoType, ServoModelReferToEnum servoModelReferTo)
        {
            List<ListItem> list = new List<ListItem>();
            if (servoType == ServoTypeEnum.AC)
            {
                switch (wheelFunction)
                {
                    case WheelFunctionEnum.SD:
                        list.Add(new ListItem("ACD 4805-W4 Small"));
                        list.Add(new ListItem("ACD 4805-W4 Medium"));
                        if ("Drive" == servoModelReferTo.ToString())
                        {
                            list.Add(new ListItem("ACS 48xx"));
                        }
                        break;
                    case WheelFunctionEnum.S:
                        list.Add(new ListItem("ACD 4805-W4 Small"));
                        list.Add(new ListItem("ACD 4805-W4 Medium"));
                        break;
                    case WheelFunctionEnum.D:
                        list.Add(new ListItem("ACD 4805-W4 Small"));
                        list.Add(new ListItem("ACD 4805-W4 Medium"));
                        if ("Drive" == servoModelReferTo.ToString())
                        {
                            list.Add(new ListItem("ACS 48xx"));
                        }
                        break;
                    case WheelFunctionEnum.DD:
                        list.Add(new ListItem("ACD 4805-W4 Small"));
                        list.Add(new ListItem("ACD 4805-W4 Medium"));
                        if ("Drive" == servoModelReferTo.ToString())
                        {
                            list.Add(new ListItem("ACS 48xx"));
                        }
                        break;
                }
            }
            else if (servoType == ServoTypeEnum.DC)
            {
                switch (wheelFunction)
                {
                    case WheelFunctionEnum.SD:
                        list.Add(new ListItem("SDIO"));
                        list.Add(new ListItem("DCD 50"));
                        list.Add(new ListItem("DCD 125"));
                        if ("Drive" == servoModelReferTo.ToString())
                        {
                            list.Add(new ListItem("DCD 250"));
                        }
                        break;
                    case WheelFunctionEnum.S:
                        list.Add(new ListItem("SDIO"));
                        list.Add(new ListItem("DCD 50"));
                        list.Add(new ListItem("DCD 125"));
                        break;
                    case WheelFunctionEnum.D:
                        list.Add(new ListItem("SDIO"));
                        list.Add(new ListItem("DCD 50"));
                        list.Add(new ListItem("DCD 125"));
                        list.Add(new ListItem("DCD 250"));
                        break;
                    case WheelFunctionEnum.DD:
                        list.Add(new ListItem("SDIO"));
                        list.Add(new ListItem("DCD 50"));
                        list.Add(new ListItem("DCD 125"));
                        list.Add(new ListItem("DCD 250"));
                        break;
                }
            }

            return list;
        }

        public override Dictionary<WheelSetup, ListItem> GetWheelsToSetEncoder(out List<ListItem> encoderChoices, out string description)
        {
            encoderChoices = new List<ListItem>();
            ListItem listItemIncremental = new ListItem("Incremental");
            ListItem listItemCAN = new ListItem("CAN");
            encoderChoices.Add(listItemIncremental);
            encoderChoices.Add(listItemCAN);
            Dictionary<WheelSetup, ListItem> wheelList = new Dictionary<WheelSetup, ListItem>();
            description = "";



            try
            {
                // For wheels without SDIO we limit the number of
                // wheels for which the user can make a choise. That
                // way we are sure that enough sdio can be added.
                int sdioAvail = 0;
                if (BUILTIN_SDIO_DCT != "" && FreeNodeIds.Contains(2))
                {
                    sdioAvail++;
                }
                for (int i = getLastCanDeviceNumber("SDIO") + 1; i < 5; i++)
                {
                    if (FreeNodeIds.Contains(10 + i))
                    {
                        sdioAvail++;
                    }
                }

                foreach (WheelSetup wheel in WheelList)
                {
                    if (wheel.WheelFunction == WheelFunctionEnum.S || wheel.WheelFunction == WheelFunctionEnum.SD)
                    {
                        // CAN encoder can only be configure to be used with SDIO id
                        // 1 or 2 since we only have two defined cobid for sending
                        // data from encoder to sdio.  For SDIO 3 and 4 the only
                        // option is incrementel encoders

                        if (wheel.SteerServoType == ServoTypeEnum.DC &&
                            (wheel.SteerServoName == "SDIO" || wheel.SteerServoName == "SDIO_1" || wheel.SteerServoName == "SDIO_2"))
                        {
                            wheelList.Add(wheel, listItemIncremental);
                        }
                        else if (!isSteerServoSDIO(wheel))
                        {
                            if (wheel.SteerServoModel == "DCD 50" ||
                                wheel.SteerServoModel == "DCD 125")
                            {
                                // Only incremental encoders for DCD:s
                            }
                            else if (wheel.DriveServoType == ServoTypeEnum.DC)
                            {
                                wheelList.Add(wheel, listItemCAN);
                            }
                            else if (sdioAvail > 0)
                            {
                                wheelList.Add(wheel, listItemCAN);
                                sdioAvail--;
                            }
                        }
                    }
                    else if (sdioAvail > 0 && wheel.WheelFunction == WheelFunctionEnum.DD)
                    {
                        if (isDriveServoSDIO(wheel) || isDriveServo2SDIO(wheel))
                        {
                            wheelList.Add(wheel, listItemCAN);
                        }
                        else if (sdioAvail > 0)
                        {
                            wheelList.Add(wheel, listItemCAN);
                            sdioAvail--;
                        }
                    }
                }

                if (wheelList.Count == 0)
                {
                    // AppDesigner will not call SetWheelEncoders() if there are no configurable wheels
                    SetWheelEncoders();
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }

            return wheelList;
        }

        public override void SetWheelEncoders()
        {

            try
            {
                int builtin = 0;
                for (int i = 0; i < countSDIO(); ++i)
                {
                    if (i == 0 && BUILTIN_SDIO_DCT != "")
                    {
                        FreeNodeIds.Remove(2);
                        builtin = 1;
                    }
                    else
                    {
                        FreeNodeIds.Remove(11 + i - builtin);
                    }
                }

                foreach (WheelSetup wheel in WheelList)
                {
                    if (isSteerServoSDIO(wheel))
                    {
                        if (wheel.SteerEncoder == "CAN")
                        {
                            int nodeid = addCANEnc(wheel);
                            setTemplateParameter(wheel.SteerServoName, "SD_Choice", "2");
                            if (wheel.SteerServoName == "SDIO")
                            {
                                setTemplateParameter(wheel.SteerServoName, "CanEncoder1", nodeid.ToString());
                            }
                        }
                    }
                    else if (wheel.SteerServoType == ServoTypeEnum.AC ||
                             wheel.SteerServoType == ServoTypeEnum.DC ||
                             wheel.WheelFunction == WheelFunctionEnum.DD)
                    {
                        if (wheel.SteerEncoder == "Incremental")
                        {
                            ComponentData wheelData = VehicleApplication2.GetComponentByName(wheel.Name) as ComponentData;
                            if (isDriveServoSDIO(wheel) || isDriveServo2SDIO(wheel))
                            {
                                //The wheel has an SDIO on the drive unit, so use that encoder.
                                string str;
                                if (wheel.DriveServoType == ServoTypeEnum.DC)
                                {
                                    str = wheel.DriveServoName + ".Enc1Angle";
                                }
                                else
                                {
                                    str = wheel.DriveServo2Name + ".Enc1Angle";
                                }
                                wheelData.SetParameter("EncAngleRef", str);
                            }
                            else if (wheel.SteerServoModel == "DCD 50" ||
                                     wheel.SteerServoModel == "DCD 125")
                            {
                                // Use encoder connected to DCD
                                wheelData.SetParameter("EncAngleRef", wheel.SteerServoName + ".Enc1Angle");
                            }
                            else
                            {
                                //make a new SDIO as Aux and connect the encoder feedback to that SDIO.
                                string device;



                                if (VehicleApplication2.OkToAddComponent("SDIO"))
                                {
                                    device = "SDIO";
                                    addDC(0, null, null, false, true);
                                }
                                else
                                {
                                    int lastSdioId = getLastCanDeviceNumber("SDIO");
                                    addDC(++lastSdioId, null, null, false, true);
                                    device = "SDIO_" + lastSdioId.ToString();
                                }
                                setTemplateParameter(device, "SD_Controller", "false");
                                setTemplateParameter(device, "AuxEncoder1", "2");
                                string str = device + ".AuxEnc1Position";
                                wheelData.SetParameter("EncAngleRef", str);
                            }
                        }
                        else if (wheel.SteerEncoder == "CAN")
                        {
                            addCANEnc(wheel);
                        }

                        if (wheel.WheelFunction != WheelFunctionEnum.DD)
                        {
                            // Set up the External sync handling for the Wheel
                            setTemplateParameter(wheel.SteerServoName, "UseExternalSync", "1");
                            CanComponentData canDevice = VehicleApplication2.GetComponentByName(wheel.SteerServoName) as CanComponentData;
                            canDevice.SetParameter("WheelReference", wheel.Name);
                        }
                    }
                }
                ComponentData vehicle = VehicleApplication2.GetComponentByName("Vehicle") as ComponentData;
                if (("SD" == vehicle.GetParameterValue("VehicleType")) && (1 == WheelList.Count))
                {
                    //Update PPA.SteerEncRef
                    ComponentData ppa = VehicleApplication2.GetComponentByName("PPA") as ComponentData;
                    if (ppa != null)
                    {
                        ComponentData wheelComponent = VehicleApplication2.GetComponentByName(WheelList[0].Name) as ComponentData;
                        string wheelEncAngleRef = wheelComponent.GetParameterValue("EncAngleRef");
                        // If Servo type 'Other' was choosen EncAngleRef is not set yet.
                        if (wheelEncAngleRef != "" && wheelEncAngleRef != "NotUsed")
                        {
                            string[] properties = wheelEncAngleRef.Split(new char[] { '.' });

                            string SteerEncRef = "";
                            if (properties[1] == "AuxEnc1Position")
                                SteerEncRef = properties[0] + ".Aux1Enc1Offset";
                            else
                                SteerEncRef = properties[0] + ".SteerEncOffset";
                            ppa.SetParameter("SteerEncRef", SteerEncRef);
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override List<ListItem> GetNavigationTypes()
        {
            m_NavigationTypes.Clear();
            //inertilaCheckBox.CheckedChanged += CheckBoxChanged;
            //m_NavigationTypes.Add(inertilaCheckBox);
            wallCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(wallCheckBox);
            ndtCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(ndtCheckBox);
            inductiveCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(inductiveCheckBox);
            magneticCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(magneticCheckBox);
            spotCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(spotCheckBox);
            reflectorCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(reflectorCheckBox);
            barcodeCheckBox.CheckedChanged += CheckBoxChanged;
            m_NavigationTypes.Add(barcodeCheckBox);

            return m_NavigationTypes;
        }



        public override void SetSpotAntennas(List<SpotAntenna> list)
        {
            if (VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }
            try
            {
                ComponentHandler2.VehicleApplication = VehicleApplication;

                foreach (SpotAntenna spotAntenna in list)
                {
                    ComponentHandler2.AddSpotAntenna(spotAntenna.CANDevice, spotAntenna.ConnectionPoint, spotAntenna.Name);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override void SetMagneticAntennas(List<MagneticAntenna> list)
        {
            if (VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }
            try
            {
                ComponentHandler2.VehicleApplication = VehicleApplication;

                foreach (MagneticAntenna magneticAntenna in list)
                {
                    ComponentHandler2.AddMagneticAntenna(magneticAntenna.CANBus,
                                                  magneticAntenna.CANDevice,
                                                  magneticAntenna.DigitalInput,
                                                  magneticAntenna.AnalogInput,
                                                  magneticAntenna.Name);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override void SetNavigationType(string navigationType)
        {
            if (VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }

            ComponentData reflectorNavigator, ReflectorInit, device;
            bool vechileNavigatorNedeed = false;
            bool spotChoosen = false;
            bool magneticChoosen = false;
            bool reflectorChoosen = false;
            bool inductiveChoosen = false;
            bool wallChoosen = false;
            bool ndtChoosen = false;
            bool barcodeChoosen = false;

            // If we have not found any decidated use of builtin sdio
            // add it here as io device.
            if (BUILTIN_SDIO_DCT != "" && VehicleApplication2.OkToAddComponent("SDIO"))
            {
                Hashtable templateParameters = new Hashtable();
                templateParameters.Add("SD_Controller", "false");
                templateParameters.Add("UseSpotAntennas", "false");
                templateParameters.Add("NumberOfEdgeDetectDigInp", "0");
                templateParameters.Add("UseAuxPWMOutput", "true");
                templateParameters.Add("AuxRegulator1", "0");
                templateParameters.Add("AuxEncoder1", "0");
                templateParameters.Add("AuxRegulator2", "0");
                templateParameters.Add("AuxEncoder2", "0");
                FreeNodeIds.Remove(2);
                CanComponentData canDevice;
                canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                VehicleApplication2.CANBusName,
                                                                BUILTIN_SDIO_DCT,
                                                                templateParameters, true);

            }

            if (navigationType.Contains("Reflector"))
            {
                reflectorChoosen = true;
                vechileNavigatorNedeed = true;
            }
            if (navigationType.Contains("Spot"))
            {
                vechileNavigatorNedeed = true;                // The number of incremental encoders it is possible
                // to have is limited by how many sdio can be
                // added.
                spotChoosen = true;
            }
            if (navigationType.Contains("Magnetic"))
            {
                vechileNavigatorNedeed = true;
                magneticChoosen = true;
            }
            if (navigationType.Contains("Inductive"))
            {
                inductiveChoosen = true;
                vechileNavigatorNedeed = true;
            }
            if (navigationType.Contains("Wall"))
            {
                wallChoosen = true;
                vechileNavigatorNedeed = true;
            }
            if (navigationType.Contains("Natural"))
            {
                ndtChoosen = true;
                vechileNavigatorNedeed = true;
            }
            if (navigationType.Contains("Barcode"))
            {
                barcodeChoosen = true;
                vechileNavigatorNedeed = true;
            }

            try
            {
                ComponentData spotNavigator, vehicleNavigator, wireNavigator, wallNavigator, ndtNavigator, barcodeNavigator;
                if (spotChoosen || magneticChoosen || inductiveChoosen)
                {
                    List<ComponentDataBase> components = VehicleApplication2.GetComponentsByType(ContractNodeType.CanDevice);
                    bool deviceFound = false;
                    foreach (ComponentDataBase comp in components)
                    {
                        CanComponentData component = comp as CanComponentData;
                        if ((component.DeviceName.Contains("SDIO_1") || (BUILTIN_SDIO_DCT != "") ))
                        {
                            deviceFound = true;
                            break;
                        }
                    }
                    if (!deviceFound)
                    {
                        addDC(1, null, null, false, true);
                        setTemplateParameter("SDIO_1", "SD_Controller", "false");
                    }
                    if (spotChoosen)
                    {
                        if (BUILTIN_SDIO_DCT != "")
                            setTemplateParameter("SDIO", "UseSpotAntennas", "true");

                        int lastSdioId = getLastCanDeviceNumber("SDIO");
                        for (int i = 1; i <= lastSdioId; i++)
                        {
                            string SDIOstr = "SDIO_" + i.ToString();
                            setTemplateParameter(SDIOstr, "UseSpotAntennas", "true");
                        }
                        spotNavigator = VehicleApplication2.CreateComponent("SpotNavigator", "SpotNavigator");
                        spotNavigator.AddReference("Antennas"); //Create a empty antennas.
                    }
                    if (magneticChoosen || inductiveChoosen)
                    {
                        wireNavigator = VehicleApplication2.CreateComponent("SemiManual", "SemiManual");
                        wireNavigator = VehicleApplication2.CreateComponent("WireNavigator", "WireNavigator");
                        wireNavigator.AddReference("DigitalSensors"); //Create a empty DigitalSensors
                        wireNavigator.AddReference("Antennas"); //Create a empty Antennas
                    }
                    if (inductiveChoosen)
                    {
                        List<short> IdList = VehicleApplication2.GetAvailableNodeIds(WGU_DCT);

                        short default_nodeid=26;

                        if (!IdList.Contains(default_nodeid) || !FreeNodeIds.Remove(default_nodeid))
                        {
                            throw new Exception("Could not allocate Node ID for:\r\n\r\nWGU");
                        }

                        Hashtable templateParameters = new Hashtable();

                        templateParameters.Add("NodeId", default_nodeid.ToString());

                        CanComponentData wgu =
                                VehicleApplication2.CreateCanDevice(VehicleApplication2.MasterControllerName,
                                                                   VehicleApplication2.CANBusName,
                                                                   WGU_DCT,
                                                                   templateParameters,
                                                                   false);
                        //Create Wgu Context menu
                        List<ContextMenuItem> menuItems = new List<ContextMenuItem>();
                        ContextMenuItem menuItem = new ContextMenuItem();
                        menuItem.Text = "Add Inductive antenna";
                        menuItem.Name = "InductiveSensor";
                        menuItem.ParentName = wgu.DeviceName;
                        menuItem.MethodToInvoke = ComponentHandler2.InitInductiveAntenna;
                        menuItems.Add(menuItem);
                        wgu.AddMenuItems(menuItems);
                    }
                }

                if (reflectorChoosen)
                {
                    reflectorNavigator = VehicleApplication2.CreateComponent("ReflectorNavigator", "ReflectorNavigator");
                    reflectorNavigator.AddReference("Scanner");  // Create empty sensor list
                    ReflectorInit = VehicleApplication2.CreateComponent("ReflectorInit", "ReflectorInit");
                }

                if (wallChoosen)
                {
                    wallNavigator = VehicleApplication2.CreateComponent("WallNavigator", "WallNavigator");
                    wallNavigator.AddReference("Sick"); //Create a empty Sick
                }
                if (ndtChoosen)
                {
                    ndtNavigator = VehicleApplication2.CreateComponent("NaturalNavigator", "NaturalNavigator");
                    ndtNavigator.AddReference("Sick"); //Create a empty Sick
                }
                if (barcodeChoosen)
                {
                    barcodeNavigator = VehicleApplication2.CreateComponent("BarcodeNavigator", "BarcodeNavigator");
                }

                if (vechileNavigatorNedeed)
                {
                    vehicleNavigator = VehicleApplication2.CreateComponent("VehicleNavigator", "VehicleNavigator");
                    if (spotChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "SpotNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "2");
                        vehicleNavigator.SetParameter("StartupNavMethod", "2");
                    }
                    if (magneticChoosen || inductiveChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "WireNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "4");
                        vehicleNavigator.SetParameter("StartupNavMethod", "4");

                    }
                    if (wallChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "WallNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "5");
                        vehicleNavigator.SetParameter("StartupNavMethod", "5");
                    }

                    if (ndtChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "NaturalNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "7");
                        vehicleNavigator.SetParameter("StartupNavMethod", "7");
                    }

                    if (barcodeChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "BarcodeNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "8");
                        vehicleNavigator.SetParameter("StartupNavMethod", "8");
                    }

                    if (reflectorChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "ReflectorNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "1");
                        vehicleNavigator.SetParameter("StartupNavMethod", "1");
                    }
                    int temp = Convert.ToInt32(reflectorChoosen) * 1 +
                               Convert.ToInt32(spotChoosen) * 2 +
                               Convert.ToInt32(magneticChoosen) * 4 +
                               Convert.ToInt32(inductiveChoosen) * 8 +
                               Convert.ToInt32(wallChoosen) * 16 +
                               Convert.ToInt32(ndtChoosen) * 64 +
                               Convert.ToInt32(barcodeChoosen) * 128;

                    vehicleNavigator.SetParameter("NavigationMethods", temp.ToString());

                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
                throw;
            }
        }


        public override void ReconfigureNavigationType(string navigationType)
        {
            if(VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }

            bool vechileNavigatorNedeed = false;
            bool naturalChoosen = false;

            if(navigationType.Contains("Natural"))
            {
                naturalChoosen = true;
                vechileNavigatorNedeed = true;
            }

            try
            {
                if(naturalChoosen)
                {
                    ComponentData ndtNavigator = VehicleApplication2.CreateComponent("NaturalNavigator", "NaturalNavigator");
                    ndtNavigator.AddReference("Sick"); //Create a empty Sick

                    List<ComponentDataBase> components = VehicleApplication2.GetComponentsByType(ContractNodeType.LS2000Scanner);
                    foreach( ComponentDataBase component in components )
                    {
                        ndtNavigator.AddReference("Sick", component.DeviceName);
                    }

                }
                if(vechileNavigatorNedeed)
                {
                    ComponentData vehicleNavigator;
                    if(VehicleApplication2.OkToAddComponent("VehicleNavigator"))
                    {
                        vehicleNavigator = VehicleApplication2.CreateComponent("VehicleNavigator", "VehicleNavigator");
                    }
                    else
                    {
                        vehicleNavigator = VehicleApplication2.GetComponentByName("VehicleNavigator") as ComponentData;
                    }

                    if(naturalChoosen)
                    {
                        vehicleNavigator.AddReference("Navigators", "NaturalNavigator");
                        vehicleNavigator.SetParameter("NavMethod", "7");
                        vehicleNavigator.SetParameter("StartupNavMethod", "7");
                    }

                    var currentNavigationMethodsStringValue = vehicleNavigator.GetParameterValue("NavigationMethods");
                    var currentNavigationMethodsValue =
                        string.IsNullOrEmpty(currentNavigationMethodsStringValue)
                            ? 0
                            : Convert.ToInt32(currentNavigationMethodsStringValue);

                    int newNavigationMethodsValue = Convert.ToInt32(naturalChoosen) * 64;
                    newNavigationMethodsValue |= currentNavigationMethodsValue;

                    vehicleNavigator.SetParameter("NavigationMethods", newNavigationMethodsValue.ToString());

                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
                throw new Exception("Script exception", ex);
            }
        }

        public override void ConfigureScanners(IEnumerable<Scanner> scanners)
        {
            foreach (var scanner in scanners)
            {
                if (scanner.ComponentType == ContractNodeType.LS2000Scanner.ToString())
                {
                    ComponentHandler5.AddLS2000Scanner(scanner.DeviceName, scanner.ConnectionPointName);
                }
                else if (scanner.ComponentType == ContractNodeType.MicroScan3Scanner.ToString())
                {
                    ComponentHandler5.AddMicroScan3Scanner(scanner.DeviceName, scanner.ConnectionPointName);
                }
            }
        }

        public override void SetDigitalSensors(List<DigitalSensor> list)
        {
            if (VehicleApplication2 == null)
            {
                throw new Exception("VehicleApplication must be set!");
            }
            try
            {
                ComponentHandler2.VehicleApplication = VehicleApplication;

                foreach (DigitalSensor digitalSensor in list)
                {
                    ComponentHandler2.AddDigitalSensor(digitalSensor.CANBus,
                               digitalSensor.CANDevice,
                               digitalSensor.DigitalInput,
                               digitalSensor.Name);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override void SetCANDevicesAndWheels(List<WheelSetup> list)
        {
            WheelList = list;
            int dcid = 0;
            bool allOk = true;
            if (BUILTIN_SDIO_DCT == "")
            {
                dcid = 1;
            }
            init();

            try
            {
                if (VehicleApplication2.OkToAddComponent("Vehicle"))
                {
                    throw new Exception("The Component \"Vehicle\" is missing");
                }

                ComponentData vehicle = VehicleApplication2.GetComponentByName("Vehicle") as ComponentData;

                foreach (WheelSetup wheel in list)
                {
                    Hashtable setParameters = new Hashtable();

                    switch (wheel.WheelFunction)
                    {
                        case WheelFunctionEnum.SD:
                            bool dcAdded = false;
                            if (isDriveServoSDIO(wheel))
                            {
                                addDC(dcid++, wheel, vehicle, false, true);
                                dcAdded = true;

                            }
                            else if (wheel.DriveServoType != ServoTypeEnum.Other)
                            {
                                addAC(wheel, vehicle, false, allOk);
                                allOk = false;
                            }

                            if (isSteerServoSDIO(wheel))
                            {
                                if (!dcAdded)
                                {
                                    addDC(dcid++, wheel, vehicle, true, true);
                                }
                                else
                                {
                                    wheel.SteerServoName = wheel.DriveServoName;
                                }
                            }
                            else if (wheel.SteerServoType != ServoTypeEnum.Other)
                            {
                                addAC(wheel, vehicle, true, allOk);
                                allOk = false;
                                if (wheel.SteerServoModel != "DCD 50" &&
                                    wheel.SteerServoModel != "DCD 125")
                                {
                                    wheel.SteerEncoder = "CAN";
                                }
                            }
                            break;
                        case WheelFunctionEnum.D:
                            if (isDriveServoSDIO(wheel))
                            {
                                addDC(dcid++, wheel, vehicle, false, true);
                            }
                            else if (wheel.DriveServoType != ServoTypeEnum.Other)
                            {
                                addAC(wheel, vehicle, false, allOk);
                                allOk = false;
                            }
                            break;
                        case WheelFunctionEnum.S:
                            if (isSteerServoSDIO(wheel))
                            {
                                addDC(dcid++, wheel, vehicle, true, true);
                            }
                            else if (wheel.SteerServoType != ServoTypeEnum.Other)
                            {
                                addAC(wheel, vehicle, true, allOk);
                                allOk = false;
                                if (wheel.SteerServoModel != "DCD 50" &&
                                    wheel.SteerServoModel != "DCD 125")
                                {
                                    wheel.SteerEncoder = "CAN";
                                }
                            }
                            break;

                        case WheelFunctionEnum.DD:

                            AddServoDDWheel(ref dcid, wheel, vehicle, allOk);
                            allOk = false;
                            wheel.SteerEncoder = "CAN";

                            break;
                        default:
                            throw new Exception("Illegal WheelFunction!");
                    }

                    createWheel(wheel, vehicle, setParameters);

                }

                if("SD" == vehicle.GetParameterValue("VehicleType"))
                {
                    //Create and initiate the PPA component PPA only if 1 wheel
                    if( 1 == list.Count)
                    {
                        setPPA(WheelList);
                    }

                    setTurnSignal();
                }

                return;
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        private void AddServoDDWheel(ref int id, WheelSetup wheel, ComponentData vehicle, bool allOk)
        {
            if (isDriveServoSDIO(wheel))
            {
                wheel.DriveServoName = CreateServoDC(id++, wheel.DriveServoModel, false, vehicle);

                var canDevice = VehicleApplication2.GetComponentByName(wheel.DriveServoName);
                if(canDevice != null)
                {
                    canDevice.SetParameter("SteerEncScale", DEFAULT_STEER_ENC_SCALE.ToString());
                }
            }
            else if (wheel.DriveServoType != ServoTypeEnum.Other)
            {
                wheel.DriveServoName = CreateServo(wheel.DriveServoModel, false, allOk, vehicle);
            }

            if (isDriveServo2SDIO(wheel))
            {
                wheel.DriveServo2Name = CreateServoDC(id++, wheel.DriveServo2Model, false, vehicle);

                var canDevice = VehicleApplication2.GetComponentByName(wheel.DriveServo2Name);
                if(canDevice != null)
                {
                    canDevice.SetParameter("SteerEncScale", DEFAULT_STEER_ENC_SCALE.ToString());
                }
            }
            else if (wheel.DriveServo2Type != ServoTypeEnum.Other)
            {
                wheel.DriveServo2Name = CreateServo(wheel.DriveServo2Model, false, false, vehicle);
            }
        }
        public string CreateServoDC(int id, string model, bool isSteerServo, ComponentData vehicle)
        {
            Hashtable templateParameters = new Hashtable();
            templateParameters.Add("SD_Controller", "true");
            templateParameters.Add("SD_Choice", "1");
            templateParameters.Add("UseSpotAntennas", "false");
            templateParameters.Add("NumberOfEdgeDetectDigInp", "0");
            templateParameters.Add("UseAuxPWMOutput", "true");
            templateParameters.Add("AuxRegulator1", "0");
            templateParameters.Add("AuxEncoder1", "0");
            templateParameters.Add("AuxRegulator2", "0");
            templateParameters.Add("AuxEncoder2", "0");

            CanComponentData canDevice;
            if (id == 0)
            {
                FreeNodeIds.Remove(2);
                canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                VehicleApplication2.CANBusName,
                                                                BUILTIN_SDIO_DCT,
                                                                templateParameters, true);

            }
            else
            {
                FreeNodeIds.Remove(10 + id);
                templateParameters.Add("VMC20Id", id.ToString());
                templateParameters.Add("DigitalOutputRtLogicUse", "0");
                templateParameters.Add("RtTripCounter1", "false");

                canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                VehicleApplication2.CANBusName,
                                                                SDIO_DCT,
                                                                templateParameters, true);
            }
            return canDevice.DeviceName;
        }

        public string CreateServo(string model, bool isSteerServo, bool useAllOk, ComponentData vehicle)
        {
            int nodeid = 0;
            nodeid = getNodeId(model);


            Hashtable templateParameters = new Hashtable();

            templateParameters.Add("NodeId", nodeid.ToString());

            if (model == "ACD 4805-W4 Small" || model == "ACD 4805-W4 Medium" ||
                model == "DCD 50" || model == "DCD 125" ||
                model == "DCD 250")
            {
                if (isSteerServo)
                {
                    templateParameters.Add("RegulationMode", "4");
                }
                else
                {
                    templateParameters.Add("RegulationMode", "0");
                }
            }
            templateParameters.Add("Auxiliary", "1");
            if (useAllOk)
            {
                templateParameters.Add("AllOK", "true");
            }
            else
            {
                templateParameters.Add("AllOK", "false");
            }
            if (isSteerServo)
            {
                templateParameters.Add("UseExternalSync", "2");
            }
            else
            {
                templateParameters.Add("UseExternalSync", "2");
            }
            CanComponentData canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                            VehicleApplication2.CANBusName,
                                                                            getdriveDCT(model),
                                                                            templateParameters, true);

            return canDevice.DeviceName;
        }
        #endregion

        #region Help functions
        private void CheckBoxChanged(object sender, EventArgs e)
        {
            CheckBoxItem checkBox = sender as CheckBoxItem;

            //Inductive changed, then change the Magnetic
            magneticCheckBox.Enabled = !inductiveCheckBox.Checked;

            //Magnetic changed, then change Inductive
            inductiveCheckBox.Enabled = !magneticCheckBox.Checked;
        }

        private bool isSteerServoSDIO(WheelSetup wheel)
        {
            return ((wheel.SteerServoType == ServoTypeEnum.DC) &&
                    (wheel.SteerServoModel.Contains("SDIO") || (wheel.SteerServoModel == "")));
        }

        private bool isDriveServoSDIO(WheelSetup wheel)
        {
            return ((wheel.DriveServoType == ServoTypeEnum.DC) &&
                    (wheel.DriveServoModel.Contains("SDIO") || (wheel.DriveServoModel == "")));
        }

        private bool isDriveServo2SDIO(WheelSetup wheel)
        {
            return ((wheel.DriveServo2Type == ServoTypeEnum.DC) &&
                    (wheel.DriveServo2Model.Contains("SDIO") || (wheel.DriveServo2Model == "")));
        }

        private void addDC(int id, WheelSetup wheel, ComponentData vehicle, bool steerServo, bool createDevice)
        {
            try
            {
                if (createDevice)
                {
                    Hashtable templateParameters = new Hashtable();
                    templateParameters.Add("SD_Controller", "true");
                    templateParameters.Add("SD_Choice", "1");
                    templateParameters.Add("UseSpotAntennas", "false");
                    templateParameters.Add("NumberOfEdgeDetectDigInp", "0");
                    templateParameters.Add("UseAuxPWMOutput", "true");
                    templateParameters.Add("AuxRegulator1", "0");
                    templateParameters.Add("AuxEncoder1", "0");
                    templateParameters.Add("AuxRegulator2", "0");
                    templateParameters.Add("AuxEncoder2", "0");

                    CanComponentData canDevice;
                    if (id == 0)
                    {
                        FreeNodeIds.Remove(2);
                        canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                        VehicleApplication2.CANBusName,
                                                                        BUILTIN_SDIO_DCT,
                                                                        templateParameters, true);

                    }
                    else
                    {
                        FreeNodeIds.Remove(10 + id);
                        templateParameters.Add("VMC20Id", id.ToString());
                        templateParameters.Add("DigitalOutputRtLogicUse", "0");
                        templateParameters.Add("RtTripCounter1", "false");

                        canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                        VehicleApplication2.CANBusName,
                                                                        SDIO_DCT,
                                                                        templateParameters, true);
                    }

                    if (null != wheel)
                    {
                        if (steerServo)
                        {
                            wheel.SteerServoName = canDevice.DeviceName;
                        }
                        else
                        {
                            wheel.DriveServoName = canDevice.DeviceName;
                        }

                        if (isSteerServoSDIO(wheel) && !isDriveServoSDIO(wheel) && !isDriveServo2SDIO(wheel))
                        {
                            canDevice.SetParameter("DriveEncScale", DEFAULT_DRIVE_ENC_SCALE.ToString());
                        }
                        else if (!isSteerServoSDIO(wheel) && (isDriveServoSDIO(wheel) || isDriveServo2SDIO(wheel)))
                        {
                            canDevice.SetParameter("SteerEncScale", DEFAULT_STEER_ENC_SCALE.ToString());
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        private void addAC(WheelSetup wheel, ComponentData vehicle, bool steerServo, bool allOk)
        {
            string DeviceName;
            try
            {
                string model;
                if (steerServo)
                {
                    model = wheel.SteerServoModel;
                }
                else
                {
                    model = wheel.DriveServoModel;
                }

                DeviceName = CreateServo(model, steerServo, allOk, vehicle);

                if (steerServo)
                {
                    wheel.SteerServoName = DeviceName;
                }
                else
                {
                    wheel.DriveServoName = DeviceName;
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        private int addCANEnc(WheelSetup wheel)
        {
            int canEncId = 0;
            try
            {
                List<short> canEncIdList = VehicleApplication2.GetAvailableNodeIds(CAN_Enc_DCT);
                for (int i = 0; i < canEncIdList.Count; i++)
                {
                    canEncId = canEncIdList[i];
                    // reserve nodeid for at least one vmc20 sdio in
                    // case of spot/wire navigation is selected later.
                    if ((canEncId != 11) && FreeNodeIds.Remove(canEncId))
                    {
                        break;
                    }
                }
                if (canEncId == 0)
                {
                    throw new Exception("Could not allocate Node ID for:\r\n\r\nCan Encoder");
                }

                Hashtable templateParameters = new Hashtable();
                templateParameters.Add("NodeId", canEncId.ToString());

                if (isSteerServoSDIO(wheel))
                {
                    if (wheel.SteerServoName == "SDIO_1")
                    {
                        templateParameters.Add("Enc_Choice", "1");
                    }
                    else if (wheel.SteerServoName == "SDIO_2")
                    {
                        templateParameters.Add("Enc_Choice", "2");
                    }
                    else if (wheel.SteerServoName == "SDIO")
                    {
                        templateParameters.Add("Enc_Choice", "4");
                    }
                }
                else
                {
                    templateParameters.Add("Enc_Choice", "3");
                }

                templateParameters.Add("BitRate", "250");

                CanComponentData canDevice = VehicleApplication2.CreateCanDevice("CVC700",
                                                                                VehicleApplication2.CANBusName,
                                                                                CAN_Enc_DCT,
                                                                                templateParameters, true);
                if (((wheel.SteerServoType == ServoTypeEnum.DC) && !isSteerServoSDIO(wheel)) ||
                    (wheel.SteerServoType == ServoTypeEnum.AC) ||
                    (wheel.WheelFunction == WheelFunctionEnum.DD))
                {
                    ComponentData wheelData = VehicleApplication2.GetComponentByName(wheel.Name) as ComponentData;
                    string str = "";
                    str = canDevice.DeviceName;
                    str += ".SteerEncAngle";
                    wheelData.SetParameter("EncAngleRef", str);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
            return canEncId;
        }

        private string getdriveDCT(string model)
        {
            Hashtable servolista = new Hashtable();
            servolista.Add("ACD 4805-W4 Small", ACD_Small.DCT);
            servolista.Add("ACD 4805-W4 Medium", ACD_Medium.DCT);
            servolista.Add("ACS 48xx", ACS.DCT);
            servolista.Add("DCD 50", DCD_Small.DCT);
            servolista.Add("DCD 125", DCD_Medium.DCT);
            servolista.Add("DCD 250", DCD_Large.DCT);

            return servolista[model].ToString();
            //if(steerServo)
            //{
            //    return (string)servolista[wheel.SteerServoModel];
            //}
            //else
            //{
            //    return (string)servolista[wheel.DriveServoModel];
            //}
        }

        public int getNodeId(string model)
        {
            switch (model)
            {
                case "ACD 4805-W4 Small":
                case "ACD 4805-W4 Medium":
                case "DCD 50":
                case "DCD 125":
                    {
                        // Prefer ID pin settable Node Id if possible
                        for (int nodeid = 5; nodeid <= 10; nodeid++)
                        {
                            if (FreeNodeIds.Remove(nodeid)) return nodeid;
                        }
                        // Skip 11-12
                        for (int nodeid = 13; nodeid <= 14; nodeid++)
                        {
                            if (FreeNodeIds.Remove(nodeid)) return nodeid;
                        }
                        // Skip 15-21
                        for (int nodeid = 22; nodeid <= 29; nodeid++)
                        {
                            if (FreeNodeIds.Remove(nodeid)) return nodeid;
                        }

                        // Try entire Node Id range if above failed (set Node Id via CAN)
                        for (int nodeid = 2; nodeid <= 31; nodeid++)
                        {
                            if (FreeNodeIds.Remove(nodeid)) return nodeid;
                        }

                        throw new Exception("Could not allocate Node ID for:\r\n\r\n" + model);
                    }
                    break;

                case "ACS 48xx":
                case "DCD 250":
                    // Prefer ID pin settable Node Id if possible
                    if (FreeNodeIds.Remove(5)) return 5;
                    if (FreeNodeIds.Remove(7)) return 7;
                    if (FreeNodeIds.Remove(22)) return 22;
                    if (FreeNodeIds.Remove(23)) return 23;

                    // Try entire Node Id range if above failed (set Node Id via CAN)
                    for (int nodeid = 2; nodeid <= 31; nodeid++)
                    {
                        if (FreeNodeIds.Remove(nodeid)) return nodeid;
                    }

                    throw new Exception("Could not allocate Node ID for:\r\n\r\n" + model);
                    break;

                default:
                    throw new Exception("Not a valid servo model:\r\n\r\n" + model);
            }
        }

        // Count how many node ids that needs to be reserved for SDIO
        private int countSDIO()
        {
            int cnt = 0;
            foreach (WheelSetup wheel in WheelList)
            {
                if (isSteerServoSDIO(wheel) ||
                    isDriveServoSDIO(wheel) ||
                    isDriveServo2SDIO(wheel))
                {
                    cnt++;
                }
                if (wheel.WheelFunction == WheelFunctionEnum.DD &&
                    isDriveServoSDIO(wheel) &&
                    isDriveServo2SDIO(wheel))
                {
                    cnt++;
                }
            }
            return cnt;
        }

        private void createWheel(WheelSetup wheel, ComponentData vehicle, Hashtable setParameters)
        {
            // int temp = 0;
            SetParameters(wheel, setParameters);

            string wheelType;
            if (wheel.WheelFunction == WheelFunctionEnum.DD)
            {
                wheelType = "WheelDD";
            }
            else
            {

                wheelType = "WheelSD";
            }

            ComponentData wheelData = VehicleApplication2.CreateDevice(wheel.Name, wheelType, VehicleApplication2.CANBusName, null, true);
            vehicle.AddReference("Wheels", wheelData.DeviceName);
            switch (wheel.WheelFunction)
            {
                case WheelFunctionEnum.SD:
                    wheelData.SetParameter("WheelType", "SD");
                    wheelData.SetParameter("SetSpeedRef", (string)setParameters["SetSpeedRef"]);
                    wheelData.SetParameter("SetAngleRef", (string)setParameters["SetAngleRef"]);
                    wheelData.SetParameter("SetSpeedEnableRef", (string)setParameters["SetSpeedEnableRef"]);
                    wheelData.SetParameter("SetAngleEnableRef", (string)setParameters["SetAngleEnableRef"]);
                    wheelData.SetParameter("EncSpeedRef", (string)setParameters["EncSpeedRef"]);
                    wheelData.SetParameter("EncDistRef", (string)setParameters["EncDistRef"]);
                    wheelData.SetParameter("EncAngleRef", (string)setParameters["EncAngleRef"]);
                    wheelData.SetParameter("X", "1000");
                    wheelData.SetParameter("Y", "0");
                    break;

                case WheelFunctionEnum.S:
                    wheelData.SetParameter("WheelType", "Steer");
                    wheelData.SetParameter("SetSpeedRef", NOT_USED);
                    wheelData.SetParameter("SetAngleRef", setParameters["SetAngleRef"].ToString());
                    wheelData.SetParameter("SetSpeedEnableRef", NOT_USED);
                    wheelData.SetParameter("SetAngleEnableRef", setParameters["SetAngleEnableRef"].ToString());
                    wheelData.SetParameter("EncSpeedRef", NOT_USED);
                    wheelData.SetParameter("EncDistRef", NOT_USED);
                    wheelData.SetParameter("EncAngleRef", setParameters["EncAngleRef"].ToString());
                    wheelData.SetParameter("X", "1000");
                    wheelData.SetParameter("Y", "0");
                    break;

                case WheelFunctionEnum.D:

                    wheelData.SetParameter("WheelType", "Drive");
                    wheelData.SetParameter("SetSpeedRef", setParameters["SetSpeedRef"].ToString());
                    wheelData.SetParameter("SetAngleRef", NOT_USED);
                    wheelData.SetParameter("SetSpeedEnableRef", setParameters["SetSpeedEnableRef"].ToString());
                    wheelData.SetParameter("SetAngleEnableRef", NOT_USED);
                    wheelData.SetParameter("EncSpeedRef", setParameters["EncSpeedRef"].ToString());
                    wheelData.SetParameter("EncDistRef", setParameters["EncDistRef"].ToString());
                    wheelData.SetParameter("EncAngleRef", NOT_USED);
                    wheelData.SetParameter("X", "0");
                    break;

                case WheelFunctionEnum.DD:
                    wheelData.SetParameter("WheelType", setParameters["WheelType"].ToString());

                    wheelData.SetParameter("LeftSetSpeedRef", setParameters["LeftSetSpeedRef"].ToString());
                    wheelData.SetParameter("RightSetSpeedRef", setParameters["RightSetSpeedRef"].ToString());

                    wheelData.SetParameter("LeftSetSpeedEnableRef", setParameters["LeftSetSpeedEnableRef"].ToString());
                    wheelData.SetParameter("RightSetSpeedEnableRef", setParameters["RightSetSpeedEnableRef"].ToString());

                    wheelData.SetParameter("LeftEncSpeedRef", setParameters["LeftEncSpeedRef"].ToString());
                    wheelData.SetParameter("RightEncSpeedRef", setParameters["RightEncSpeedRef"].ToString());

                    wheelData.SetParameter("LeftEncDistRef", setParameters["LeftEncDistRef"].ToString());
                    wheelData.SetParameter("RightEncDistRef", setParameters["RightEncDistRef"].ToString());

                    wheelData.SetParameter("X", "0");
                    break;
            }
        }

        private void SetParameters(WheelSetup wheel, Hashtable setParameters)
        {
            if (wheel.WheelFunction == WheelFunctionEnum.DD)
            {
                setParameters.Add("WheelType", "DD");

                if (isDriveServoSDIO(wheel))
                {
                    setParameters.Add("LeftSetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServoName));
                    setParameters.Add("RightSetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServo2Name));
                    setParameters.Add("LeftSetSpeedEnableRef", string.Format("{0}.DriveEnable", wheel.DriveServoName));
                    setParameters.Add("RightSetSpeedEnableRef", string.Format("{0}.DriveEnable", wheel.DriveServo2Name));
                    setParameters.Add("LeftEncSpeedRef", string.Format("{0}.Enc2Speed", wheel.DriveServoName));
                    setParameters.Add("RightEncSpeedRef", string.Format("{0}.Enc2Speed", wheel.DriveServo2Name));
                    setParameters.Add("LeftEncDistRef", string.Format("{0}.Enc2Dist", wheel.DriveServoName));
                    setParameters.Add("RightEncDistRef", string.Format("{0}.Enc2Dist", wheel.DriveServo2Name));
                }
                else if (wheel.DriveServoType == ServoTypeEnum.AC ||
                         wheel.DriveServoType == ServoTypeEnum.DC)
                {
                    setParameters.Add("LeftSetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServoName));
                    setParameters.Add("RightSetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServo2Name));
                    setParameters.Add("LeftSetSpeedEnableRef", string.Format("{0}.EnablePowerStage", wheel.DriveServoName));
                    setParameters.Add("RightSetSpeedEnableRef", string.Format("{0}.EnablePowerStage", wheel.DriveServo2Name));
                    setParameters.Add("LeftEncSpeedRef", string.Format("{0}.DriveEncSpeed", wheel.DriveServoName));
                    setParameters.Add("RightEncSpeedRef", string.Format("{0}.DriveEncSpeed", wheel.DriveServo2Name));
                    setParameters.Add("LeftEncDistRef", string.Format("{0}.DriveEncDist", wheel.DriveServoName));
                    setParameters.Add("RightEncDistRef", string.Format("{0}.DriveEncDist", wheel.DriveServo2Name));
                }
                else
                {
                    setParameters.Add("LeftSetSpeedRef", "");
                    setParameters.Add("RightSetSpeedRef", "");
                    setParameters.Add("LeftSetSpeedEnableRef", "");
                    setParameters.Add("RightSetSpeedEnableRef", "");
                    setParameters.Add("LeftEncSpeedRef", "");
                    setParameters.Add("RightEncSpeedRef", "");
                    setParameters.Add("LeftEncDistRef", "");
                    setParameters.Add("RightEncDistRef", "");
                }
            }
            else
            {
                if (isDriveServoSDIO(wheel))
                {
                    setParameters.Add("SetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServoName));
                    setParameters.Add("SetSpeedEnableRef", string.Format("{0}.DriveEnable", wheel.DriveServoName));
                    setParameters.Add("EncSpeedRef", string.Format("{0}.Enc2Speed", wheel.DriveServoName));
                    setParameters.Add("EncDistRef", string.Format("{0}.Enc2Dist", wheel.DriveServoName));
                }
                else if (wheel.DriveServoType == ServoTypeEnum.AC ||
                         wheel.DriveServoType == ServoTypeEnum.DC)
                {
                    setParameters.Add("SetSpeedRef", string.Format("{0}.SetSpeed", wheel.DriveServoName));
                    setParameters.Add("SetSpeedEnableRef", string.Format("{0}.EnablePowerStage", wheel.DriveServoName));
                    setParameters.Add("EncSpeedRef", string.Format("{0}.DriveEncSpeed", wheel.DriveServoName));
                    setParameters.Add("EncDistRef", string.Format("{0}.DriveEncDist", wheel.DriveServoName));
                }
                else
                {
                    setParameters.Add("SetSpeedRef", "");
                    setParameters.Add("SetSpeedEnableRef", "");
                    setParameters.Add("EncSpeedRef", "");
                    setParameters.Add("EncDistRef", "");
                }

                if (isSteerServoSDIO(wheel))
                {
                    setParameters.Add("SetAngleRef", string.Format("{0}.SetAngle", wheel.SteerServoName));
                    setParameters.Add("SetAngleEnableRef", string.Format("{0}.SteerEnable", wheel.SteerServoName));
                    setParameters.Add("EncAngleRef", string.Format("{0}.Enc1Angle", wheel.SteerServoName));
                }
                else if (wheel.SteerServoType == ServoTypeEnum.AC ||
                         wheel.SteerServoType == ServoTypeEnum.DC)
                {
                    setParameters.Add("SetAngleRef", string.Format("{0}.SetAngle", wheel.SteerServoName));
                    setParameters.Add("SetAngleEnableRef", string.Format("{0}.EnablePowerStage", wheel.SteerServoName));
                    setParameters.Add("EncAngleRef", string.Format("{0}.WheelAngle", wheel.SteerServoName));
                }
                else
                {
                    setParameters.Add("SetAngleRef", "");
                    setParameters.Add("SetAngleEnableRef", "");
                    setParameters.Add("EncAngleRef", "");
                }
            }
        }

        private void setPPA(List<WheelSetup> WheelList)
        {
            if (VehicleApplication2.OkToAddComponent("PPA"))
            {
                ComponentData PPA = null;
                PPA = VehicleApplication2.CreateComponent("PPA", "PPA");
                PPA.SetParameter("FrontWheelRef", WheelList[0].Name);
                ComponentData wheelData = VehicleApplication2.GetComponentByName(WheelList[0].Name) as ComponentData;
                string str = wheelData.GetParameterValue("EncAngleRef");
                string[] steerEncRef = str.Split(new char[] { '.' });
                PPA.SetParameter("SteerEncRef", steerEncRef[0]);
            }
        }

        private void setTurnSignal()
        {
            if(VehicleApplication2.OkToAddComponent("TurnSignal"))
            {
                ComponentData TurnSignal = null;
                TurnSignal = VehicleApplication2.CreateComponent("TurnSignal", "TurnSignal");
            }
        }

        private void setTemplateParameter(string deviceName, string parameter, string value)
        {
            CanComponentData deviceData = VehicleApplication2.GetComponentByName(deviceName) as CanComponentData;

            Hashtable templateParameters = new Hashtable();
            templateParameters.Add(parameter, value);
            deviceData.SetTemplateParameters(templateParameters);
        }

        private int getLastCanDeviceNumber(string device)
        {
            List<ComponentDataBase> componentList = VehicleApplication2.GetComponentsByType(ContractNodeType.CanDevice);
            int value = 0;
            foreach (ComponentDataBase comp in componentList)
            {
                CanComponentData component = comp as CanComponentData;
                if (component.DeviceName.Contains(device))
                {
                    string[] idArray = component.DeviceName.Split(new char[] { '_' });
                    if (idArray.Length > 1 && value < Convert.ToInt32(idArray[1]))
                    {
                        value = Convert.ToInt32(idArray[1]);
                    }
                }
            }
            return value;
        }

        class drivetype
        {
            #region Private Fields
            private string m_Dct;
            #endregion

            #region Public Properties
            public string DCT
            {
                get
                {
                    return m_Dct;
                }
            }
            #endregion

            #region Public Methods
            public drivetype(string Dct)
            {
                this.m_Dct = Dct;
            }
            #endregion
        }
        #endregion
    }
}
