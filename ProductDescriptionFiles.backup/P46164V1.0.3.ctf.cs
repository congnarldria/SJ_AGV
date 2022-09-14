using System;
using System.Collections.Generic;
using System.Text;
using System.Windows.Forms;
using NDC8.DataAccess.Script;
using System.Collections;
using System.Linq;
using System.Text.RegularExpressions;
using System.Diagnostics;

namespace NDC8.Business
{

    public class P46164V1_0_3: ComponentHandlerBase5
    {
        #region Private Constants

        private const string m_WguDeviceType = "0x8000000";
        private const string m_SDIODeviceType = "0x9000000";
        int navigationMethods;

        #endregion

        #region Init
        public override void Init()
        {
            List<ComponentDataBase> comPortDevices =
                    VehicleApplication2.GetComponentsByType(ContractNodeType.ComPortDevice);

            bool com2Occupied = false;
            bool com3Occupied = false;
            bool com4Occupied = false;

            ComponentDataBase vehicleNavigator = VehicleApplication.GetComponentByName("VehicleNavigator");
            navigationMethods = Convert.ToInt32(vehicleNavigator.GetParameterValue("NavigationMethods"));

            foreach(ComponentDataBase component in comPortDevices)
            {
                if(component.ParentName == "COM1")
                {
                    com2Occupied = true;
                }
                else if(component.ParentName == "COM2")
                {
                    com3Occupied = true;
                }
                if(component.ParentName == "COM3")
                {
                    com4Occupied = true;
                }
            }

            //Add menues on COM ports
            List<ContextMenuItem> menuItems = new List<ContextMenuItem>();
            ContextMenuItem menuItem = new ContextMenuItem();
            menuItems.Clear();
            ComponentDataBase comPort = VehicleApplication2.GetComponentByName("COM1");

            if (VehicleApplication2.OkToAddComponent("Mcd"))
            {
                comPort = VehicleApplication2.GetComponentByName("COM3");
                menuItem = new ContextMenuItem();
                menuItem.Text = "Add Mcd";
                menuItem.Name = "Mcd";
                menuItem.ParentName = "COM3";
                menuItem.DeviceName = "Mcd";
                menuItem.Enabled = !com4Occupied;
                menuItem.MethodToInvoke = addMcd;
                menuItems.Add(menuItem);
                comPort.AddMenuItems(menuItems);

                ScriptNode node = new ScriptNode();
                node.DeviceName = "Mcd";
                node.ParentName = "COM3";
                addMcd(node);
            }

            List<ComponentDataBase> comPorts =
                   VehicleApplication2.GetComponentsByType(ContractNodeType.ComPort);

            // Create menu for LAN port.  Only application created with
            // NDC8 2.0 (P41894V1.2x) or newer has a LAN node and adding
            // a LAN node at upgrade does not work.
            if (!VehicleApplication2.OkToAddComponent("LAN"))
            {
                ComponentDataBase Lan = VehicleApplication2.GetComponentByName("LAN");

                menuItem = new ContextMenuItem();
                menuItem.Text = "Add LS2000";
                menuItem.Name = "LS2000_Menu";
                menuItem.ParentName = Lan.DeviceName;
                menuItem.DeviceName = "LS2000Scanner";
                menuItem.MethodToInvoke = addLS2000;

                var numOfLS2000Scanners = VehicleApplication2.GetNumberOfComponents(ContractNodeType.LS2000Scanner);
                bool bEnable = false;
                if ((HasComponent("ReflectorNavigator") ||
                     HasComponent("NaturalNavigator") ||
                     HasComponent("WallNavigator")) &&
                    numOfLS2000Scanners == 0)
                {
                    bEnable = true;
                }

                menuItem.Enabled = bEnable;

                menuItems.Add(menuItem);

                var microScan3MenuItem = CreateMicroScan3MenuItem(Lan.DeviceName, "microScan3", "microScan3");
                menuItems.Add(microScan3MenuItem);

                var nanoScan3MenuItem = CreateMicroScan3MenuItem(Lan.DeviceName, "nanoScan3", "nanoScan3");
                menuItems.Add(nanoScan3MenuItem);

                int numberOfLanSerialPorts = 4;
                for (int i = 0; i < numberOfLanSerialPorts; i++)
                {
                    menuItem = new ContextMenuItem();
                    int j = i + 5;
                    string portName = "COM" + j.ToString();
                    menuItem.Text = "Add LAN " + portName + " port";
                    menuItem.Name = portName;
                    menuItem.ParentName = Lan.DeviceName;
                    menuItem.DeviceName = portName;
                    menuItem.MethodToInvoke = addLanComPort;

                    ComponentDataBase lanDevice =
                        comPorts.Find(
                            delegate(ComponentDataBase component)
                            {
                                return (component.DeviceName == portName);
                            }
                            );

                    menuItem.Enabled = (lanDevice == null);

                    menuItems.Add(menuItem);
                }
                Lan.AddMenuItems(menuItems);
                RefreshMicroScan3MenuItems(Lan.DeviceName);
            }

            List<ComponentDataBase> canDevices =
                    VehicleApplication2.GetComponentsByType(ContractNodeType.CanDevice);

            foreach(ComponentDataBase device in canDevices)
            {
                RefineAddedCanDevice(device as CanComponentData);
            }
        }

        private void RefreshMicroScan3MenuItems(string componentName)
        {
            var numOfMicroScan3Scanners = VehicleApplication2.GetNumberOfComponents(ContractNodeType.MicroScan3Scanner);
            if ((HasComponent("ReflectorNavigator") ||
                 HasComponent("NaturalNavigator") ||
                 HasComponent("WallNavigator")) &&
                numOfMicroScan3Scanners < 2)
            {
                EnableContextMenuItems(componentName, item => item.DeviceName == "MicroScan3Scanner");
            }
            else
            {
                DisableContextMenuItems(componentName, item => item.DeviceName == "MicroScan3Scanner");
            }
        }

        private ContextMenuItem CreateMicroScan3MenuItem(string connectionPointName, string scannerTypeName, string defaultName)
        {
            ContextMenuItem menuItem = new ContextMenuItem();
            menuItem.Text = string.Format("Add {0}", scannerTypeName);
            menuItem.Name = string.Format("MicroScan3_Menu_{0}", defaultName);
            menuItem.ParentName = connectionPointName;
            menuItem.DeviceName = "MicroScan3Scanner";
            menuItem.MethodToInvoke = node => AddMicroScan3Scanner(node, defaultName);

            return menuItem;
        }

        #endregion

        #region Upgrade
        public override void UpdateVehicleApplication(ref List<ComponentDataBase> devices,
                                             ref List<ComponentDataBase> componentsOfNoneDeviceType,
                                             string oldVCT, string newVCT)
        {
            if (oldVCT.Contains("P41808"))
            {
                //We have a older definition than the Script release
                if (VehicleApplication.OkToAddComponent("ReflectorInit"))
                {
                    ComponentDataBase component = new ComponentData();
                    component = VehicleApplication.CreateComponent("ReflectorInit", "ReflectorInit");
                    componentsOfNoneDeviceType.Add(component);
                }
                if (!VehicleApplication.OkToAddComponent("LocalOrder"))
                {
                    ComponentDataBase component = VehicleApplication.GetComponentByName("LocalOrder");
                    component.SetParameter("DestPoint", "1");
                }
                if (!VehicleApplication.OkToAddComponent("Vehicle") & (VehicleApplication.OkToAddComponent("PPA")))
                {
                    ComponentDataBase component = VehicleApplication.GetComponentByName("Vehicle");
                    if ("SD" == component.GetParameterValue("VehicleType"))
                    {
                        component = VehicleApplication.CreateComponent("PPA", "PPA");
                        componentsOfNoneDeviceType.Add(component);
                    }
                }
            }
            if (newVCT.Contains("P41898") || newVCT.Contains("P41894"))
            {
                if (!VehicleApplication.OkToAddComponent("COM3"))
                {
                    ComponentDataBase COM3 = VehicleApplication.GetComponentByName("COM3");
                    COM3.SetParameter("Port", "COM3");
                }
                if (!VehicleApplication.OkToAddComponent("COM4"))
                {
                    ComponentDataBase COM4 = VehicleApplication.GetComponentByName("COM4");
                    COM4.SetParameter("Port", "COM1");
                }
            }
            if (newVCT.Contains("P41893"))
            {
                if (!VehicleApplication.OkToAddComponent("COM3"))
                {
                    ComponentDataBase COM3 = VehicleApplication.GetComponentByName("COM3");
                    COM3.SetParameter("Port", "COM1");
                }
                if (!VehicleApplication.OkToAddComponent("COM4"))
                {
                    ComponentDataBase COM4 = VehicleApplication.GetComponentByName("COM4");
                    COM4.SetParameter("Port", "COM2");
                }
            }
            if (newVCT.Contains("P41975"))
            {
                if (!VehicleApplication2.OkToAddComponent("Vehicle") & (VehicleApplication2.OkToAddComponent("TurnSignal")))
                {
                    ComponentDataBase component = VehicleApplication2.GetComponentByName("Vehicle");
                    if ("SD" == component.GetParameterValue("VehicleType"))
                    {
                        component = VehicleApplication2.CreateComponent("TurnSignal", "TurnSignal");
                        componentsOfNoneDeviceType.Add(component);
                    }
                }
            }

            // Added to be able to upgrade from 2.4.0p7 and earlier
            // OkToAddComponent is case insensitive.
            // DeleteConnectionNode, though, is case sensitive. So even if  we pass
            // the first condition there will be no node deleted if case not exactly match.
            // And if there is no match, no new component will be created.
            const string old_format = "BarCodeNavigator";
            const string new_format = "BarcodeNavigator";
            if (!VehicleApplication2.OkToAddComponent(old_format))
            {
                VehicleApplication2.DeleteConnectionNode(old_format);
                if (VehicleApplication2.OkToAddComponent(new_format))
                {
                    ComponentDataBase component = VehicleApplication2.CreateComponent(new_format, new_format);
                    componentsOfNoneDeviceType.Add(component);
                }
            }

            // Workaround for problem after upgrade because S300/S3000 is no longer supported
            // Remove all SickScanner references from NaturalNavigator and WallNavigator (not done by VAD)
            foreach(var currentComponent in componentsOfNoneDeviceType)
            {
                if (currentComponent.DeviceName == "NaturalNavigator" || currentComponent.DeviceName == "WallNavigator")
                {
                    ComponentDataBase ndtComponent = currentComponent;

                    var goodRefsList = new List<string>();
                    foreach(var refData in ndtComponent.References)
                    {
                        if (refData.SymbolName == "Sick")
                        {
                            foreach(var refItem in refData.ReferenceItem)
                            {
                                ComponentDataBase scanner = VehicleApplication.GetComponentByName(refItem.Value);
                                if (scanner != null && !string.IsNullOrEmpty(scanner.Type) && scanner.Type != "SickScanner")
                                {
                                    goodRefsList.Add(refItem.Value);
                                }
                            }
                            // clear all references to scanners
                            refData.ReferenceItem = new ReferenceItemData[0];
                        }
                    }
                    foreach(var scanner in goodRefsList)
                    {
                        ndtComponent.AddReference("Sick", scanner);
                    }
                }
            }

            RenameLaserNavigator(ref componentsOfNoneDeviceType);
        }

        private void RenameLaserNavigator(ref List<ComponentDataBase> componentsOfNoneDeviceType)
        {
            if(!VehicleApplication.OkToAddComponent("ReflectorNavigator") ||
                VehicleApplication.OkToAddComponent("LaserNavigator"))
            {
                return;
            }

            ComponentDataBase reflectorComponent = new ComponentData();
            reflectorComponent = VehicleApplication2.CreateComponent("ReflectorNavigator", "ReflectorNavigator");
            ComponentDataBase laserComponent = VehicleApplication2.GetComponentByName("LaserNavigator") as ComponentData;
            reflectorComponent.AddReference("Scanner");

            // Add the scanners connected to LaserNavigator to ReflectorNavigator
            foreach(var refData in laserComponent.References)
            {
                foreach(var refItem in refData.ReferenceItem)
                {
                    // Copy all scanner references except LS5.
                    ComponentDataBase scanner = VehicleApplication.GetComponentByName(refItem.Value);
                    if (scanner != null && !string.IsNullOrEmpty(scanner.Type) && scanner.Type != "LaserScanner")
                    {
                        reflectorComponent.AddReference("Scanner", refItem.Value);
                    }
                }
            }
            componentsOfNoneDeviceType.Add(reflectorComponent);

            // Keep all navigator references in VehicleNavigator except from the LaserNavigator reference
            foreach(var component in componentsOfNoneDeviceType)
            {
                if(component.DeviceName == "VehicleNavigator")
                {
                    ComponentDataBase currentComponent = component;
                    List<string> navigators = new List<string>();
                    // Add the reflectorcomponent to the list of navigators
                    navigators.Add(reflectorComponent.DeviceName);

                    foreach(var refData in currentComponent.References)
                    {
                        if (refData.SymbolName == "Navigators")
                        {
                            foreach (var refItem in refData.ReferenceItem)
                            {
                                if (refItem.Value != "LaserNavigator")
                                {
                                    navigators.Add(refItem.Value);
                                }
                            }
                            refData.ReferenceItem = new ReferenceItemData[0];
                        }
                    }
                    foreach(var navigator in navigators)
                    {
                        currentComponent.AddReference("Navigators", navigator);
                    }
                }
            }
        }
#endregion

        #region Background functions
        public override void RefineAddedCanDevice(CanComponentData canDevice)
        {
            if(canDevice.DeviceType == m_WguDeviceType)
            {
                bool freeConnectionPoints = VehicleApplication2.DeviceHasFreeConnectionPoints(canDevice.DeviceName);
                ContextMenuItem menuItem = canDevice.GetMenuItem("InductiveSensor");
                if(menuItem == null)
                {
                    //Create Wgu Context menu
                    List<ContextMenuItem> menuItems = new List<ContextMenuItem>();
                    menuItem = new ContextMenuItem();
                    menuItem.Text = "Add Inductive antenna";
                    menuItem.Name = "InductiveSensor";
                    menuItem.ParentName = canDevice.DeviceName;
                    menuItem.MethodToInvoke = this.InitInductiveAntenna;
                    //Mask if Inductive navigation is used
                    if ((navigationMethods & 8) > 0)
                    {
                        menuItem.Enabled = freeConnectionPoints;
                    }
                    else
                    {
                        menuItem.Enabled = false;
                    }
                    menuItems.Add(menuItem);
                    canDevice.AddMenuItems(menuItems);
                }
            }
        }

        public override void AddLanPort(ScriptNode node)
        {
        }

        public override void AddMcd(ScriptNode node)
        {
        }

        public override void AddComPort(ScriptNode node)
        {
        }

        public override void InitInductiveAntenna(ScriptNode node)
        {
            VehicleApplication2.ShowInductiveAntennaForm(node.ParentName);
        }

        public override List<ComponentDataBase> AddInductiveAntenna(string canDeviceName, string connectionPointName, string componentName)
        {
            try
            {
                //Create connection point if it do not exist
                ComponentData comp = VehicleApplication.GetConnector(connectionPointName, canDeviceName);
                if(comp == null)
                {
                    comp = VehicleApplication.CreateConnector(ContractNodeType.AntennaConnector, canDeviceName, connectionPointName) as ComponentData;
                }

                //Add Inductive antenna
                comp = VehicleApplication2.CreateDevice(componentName, "InductiveAntenna", canDeviceName, connectionPointName, false);

                string connString = canDeviceName + '.' + connectionPointName;
                if(comp != null)
                {
                    comp.SetParameter("OffsetRef", connString + "Offset");
                    comp.SetParameter("AngleRef", connString + "Angle");
                    comp.SetParameter("FreqIndexRef", connString + "FreqIndex");
                    comp.SetParameter("SignalRef", connString + "Signal");
                    comp.SetParameter("OverloadRef", connString + "Overload");
                }
                //disable menu if no more antennas can be added
                bool freeConnectionPoints = VehicleApplication2.DeviceHasFreeConnectionPoints(canDeviceName);
                if(!freeConnectionPoints)
                {
                    ComponentDataBase wgu = VehicleApplication.GetComponentByName(canDeviceName);
                    ContextMenuItem menuItem = wgu.GetMenuItem("InductiveSensor");
                    menuItem.Enabled = false;
                    wgu.UppdateMenuItem(menuItem);
                }
                if (VehicleApplication2.OkToAddComponent("WireNavigator"))
                {
                    //throw new Exception("No Inductive navigation has been choosen at startup");
                    string message = "Please note that this application has not been created for Inductive navigation. \n\r\n\r Please create a new application if your intention is to use Inductive navigation.";
                    MessageBox.Show(message, "No Inductive navigation has been choosen at startup", MessageBoxButtons.OK, MessageBoxIcon.Warning);
                }
                else
                {
                    ComponentDataBase wireNavigator = VehicleApplication.GetComponentByName("WireNavigator") as ComponentData;
                    wireNavigator.AddReference("Antennas", componentName);
                }
            }
            catch(Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
            return new List<ComponentDataBase>();
        }

        public override List<ComponentDataBase> AddSpotAntenna(string canDeviceName, string connectionPointName, string componentName)
        {
            List<ComponentDataBase> addedDevices = new List<ComponentDataBase>();
            ComponentDataBase comp = new ComponentData();
            try
            {
                //Create connection point if it do not exist
                comp = VehicleApplication.GetConnector(connectionPointName, canDeviceName);
                if (comp == null)
                {
                    comp = VehicleApplication.CreateConnector(ContractNodeType.SpotAntennaConnector, canDeviceName, connectionPointName) as ComponentData;
                    addedDevices.Add(comp);
                }

                //Add spot antenna
                comp = VehicleApplication.CreateDevice(componentName, ContractNodeType.SpotAntenna, canDeviceName, connectionPointName, false);
                addedDevices.Add(comp);
                string connString = canDeviceName + '.' + connectionPointName;
                if (comp != null)
                {
                    comp.SetParameter("Connection", connString);
                    if (VehicleApplication.OkToAddComponent("SpotNavigator"))
                    {
                        comp = VehicleApplication.CreateComponent("SpotNavigator", "SpotNavigator");
                        addedDevices.Add(comp);
                    }
                    comp = VehicleApplication.GetComponentByName("SpotNavigator") as ComponentData;
                    comp.AddReference("Antennas", componentName);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
            return addedDevices;
        }

        public override List<ComponentDataBase> AddMagneticAntenna(string canBusName, string canDeviceName, string digitalInput,
                                       string analogInput, string antennaName)
        {
            List<ComponentDataBase> addedDevices = new List<ComponentDataBase>();
            ComponentDataBase comp = new ComponentData();
            string connectorName = "MagneticAntennas";
            try
            {
                //Create connection point if it do not exist
                comp = VehicleApplication.GetConnector(connectorName, canDeviceName);
                if (comp == null)
                {
                    comp = VehicleApplication.CreateConnector(ContractNodeType.MagneticAntennaConnector, canDeviceName, connectorName) as ComponentData;
                }

                comp = VehicleApplication.CreateDevice(antennaName, ContractNodeType.MagneticAntenna, canDeviceName, connectorName, false);
                addedDevices.Add(comp);
                if (comp != null)
                {
                    comp.SetParameter("OffsetInput", canDeviceName + "." + analogInput);
                    comp.SetParameter("ValidInput", canDeviceName + "." + digitalInput);
                }
                CanComponentData deviceData = VehicleApplication.GetComponentByName(canDeviceName) as CanComponentData;
                if (canDeviceName.Contains("SDIO"))
                {
                    if ((analogInput.Length - 11) < 1)
                    {
                        throw new Exception("The Analog input has a wrong parameter name");
                    }
                    else
                    {
                        string scaleParamter = "AnInp" + analogInput.Substring(11, (analogInput.Length - 11)) + "_Scale";
                        deviceData.SetParameter(scaleParamter, "1000");
                    }
                }


                if (VehicleApplication.OkToAddComponent("WireNavigator"))
                {
                    throw new Exception("No Magnetic navigation has been choosen at startup");
                }
                else
                {
                    ComponentDataBase wireNavigator = VehicleApplication.GetComponentByName("WireNavigator") as ComponentData;
                    wireNavigator.AddReference("Antennas", antennaName);
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
            return addedDevices;
        }

        public override List<ComponentDataBase> AddDigitalSensor(string canBusName, string CanDeviceName,
                                     string digitalInput, string sensorName)
        {
            List<ComponentDataBase> addedDevices = new List<ComponentDataBase>();
            ComponentDataBase comp = new ComponentData();
            string connectorName = "DigitalSensors";
            try
            {
                KeyValuePair<string,string> templateParameter = VehicleApplication.GetSingleTemplateParameter(CanDeviceName, "NumberOfEdgeDetectDigInp");
                int numberOfSensorsUsed = Convert.ToInt32(templateParameter.Value);
                if (numberOfSensorsUsed >= 4)
                {
                    throw new Exception("The maximum number Digital Sensors has been used on the choosen CAN device");
                }

                //Create connection point if it do not exist
                comp = VehicleApplication.GetConnector(connectorName, CanDeviceName);
                if (comp == null)
                {
                    comp = VehicleApplication.CreateConnector(ContractNodeType.DigitalSensorConnector, CanDeviceName, connectorName) as ComponentData;
                }

                comp = VehicleApplication.CreateDevice(sensorName, ContractNodeType.DigitalSensor, CanDeviceName, connectorName, false);
                addedDevices.Add(comp);
                if (comp != null)
                {
                    string parameter, value;
                    CanComponentData deviceData = VehicleApplication.GetComponentByName(CanDeviceName) as CanComponentData;
                    System.Collections.Hashtable templateParameters = new System.Collections.Hashtable();

                    //set the digital input
                    parameter = "DigitalInput";
                    value = string.Format("{0}.{1}", CanDeviceName, digitalInput);
                    comp.SetParameter(parameter, value);

                    reassignDigitalSensor(CanDeviceName);
                }

                ComponentDataBase distanceMarker;
                if (VehicleApplication.OkToAddComponent("DistanceMarker"))
                {
                    distanceMarker = VehicleApplication.CreateComponent("DistanceMarker", "DistanceMarker");
                }
                else
                {
                    distanceMarker = VehicleApplication.GetComponentByName("DistanceMarker");
                }
                distanceMarker.AddReference("DigitalSensors", sensorName);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OK, MessageBoxIcon.Error);
            }

            return addedDevices;
        }


        public override bool OKToAddObject(ObjectType typeOfObject, int noOfAdded, out string helpText)
        {
            bool ret = false;
            helpText = "";
            switch (typeOfObject)
            {
                case ObjectType.DigitalSensor:
                    ret = (noOfAdded < 4);
                    if (!ret)
                    {
                        helpText = "No more Digital Sensors can be added. The maximum number of Digital Sensors is 4.";
                    }
                    break;
                case ObjectType.MagneticAntenna:
                    ret = true;
                    break;
                case ObjectType.SpotAntenna:
                    ret = true;
                    break;
                case ObjectType.InductiveAntenna:
                    ret = true;
                    break;
                default:
                    throw new Exception("Error in ValidateOKToAddObject. Invalid type of object.");
            }
            return ret;
        }

        public override void ValidateConnectionPoint(ref string root, ref string parent, ComponentDataBase device)
        {

        }

        public override void AddLaserScanner(string connectionPointName, ContractNodeType componentType)
        {
        }

        public override void AddLS2000Scanner(string deviceName, string connectionPointName)
        {
            ComponentData device = VehicleApplication2.CreateDevice(deviceName, "LS2000Scanner", "CVC700", connectionPointName, false);
            if (HasComponent("ReflectorNavigator"))
            {
                ComponentDataBase reflectorNavigator = VehicleApplication2.GetComponentByName("ReflectorNavigator");
                reflectorNavigator.AddReference("Scanner", device.DeviceName);
            }
            if (HasComponent("WallNavigator"))
            {
                ComponentDataBase wallNavigator = VehicleApplication.GetComponentByName("WallNavigator") as ComponentData;
                wallNavigator.AddReference("Sick", device.DeviceName);
            }
            if (HasComponent("NaturalNavigator"))
            {
                ComponentDataBase ndtNavigator = VehicleApplication.GetComponentByName("NaturalNavigator") as ComponentData;
                ndtNavigator.AddReference("Sick", device.DeviceName);
            }

            ComponentDataBase lan = VehicleApplication.GetComponentByName(connectionPointName);
            ContextMenuItem menuItem = lan.GetMenuItem("LS2000_Menu");
            if (menuItem != null)
            {
                menuItem.Enabled = false;
                lan.UppdateMenuItem(menuItem);
            }
        }

        public override void AddMicroScan3Scanner(string deviceName, string connectionPointName)
        {
            ComponentData device = VehicleApplication2.CreateDevice(deviceName, "MicroScan3Scanner", "CVC700", connectionPointName, false);
            if (HasComponent("ReflectorNavigator"))
            {
                ComponentDataBase reflectorNavigator = VehicleApplication2.GetComponentByName("ReflectorNavigator");
                reflectorNavigator.AddReference("Scanner", device.DeviceName);
            }
            if (HasComponent("WallNavigator"))
            {
                ComponentDataBase wallNavigator = VehicleApplication.GetComponentByName("WallNavigator") as ComponentData;
                wallNavigator.AddReference("Sick", device.DeviceName);
            }
            if (HasComponent("NaturalNavigator"))
            {
                ComponentDataBase ndtNavigator = VehicleApplication.GetComponentByName("NaturalNavigator") as ComponentData;
                ndtNavigator.AddReference("Sick", device.DeviceName);
            }

            RefreshMicroScan3MenuItems(connectionPointName);
        }

        public override void AddRadio(string comPortName, ContractNodeType radiotype)
        {
            try
            {
                ComponentData radioComponent, device;
                ComponentDataBase port, master;
                switch (radiotype)
                {
                    case ContractNodeType.Rcu:
                        device = VehicleApplication.CreateDevice("Rcu", ContractNodeType.Rcu, "CVC700", comPortName, false);
                        device.AddReference("Port", comPortName);
                        radioComponent = VehicleApplication.CreateComponent("Rcu", "Rcu");
                        port = VehicleApplication.GetComponentByName(comPortName);
                        port.SetParameter("Baudrate", "19200");
                        master = VehicleApplication.GetComponentByName("Master");
                        master.SetParameter("MasterCom", "Rcu");
                        changeMenuRadio(port, false);
                        break;
                    case ContractNodeType.Satel:
                        device = VehicleApplication.CreateDevice("Satel", ContractNodeType.Satel, "CVC700", comPortName, false);
                        device.AddReference("Port", comPortName);
                        radioComponent = VehicleApplication.CreateComponent("Satel", "Satel");
                        port = VehicleApplication.GetComponentByName(comPortName);
                        port.SetParameter("Baudrate", "9600");
                        master = VehicleApplication.GetComponentByName("Master");
                        master.SetParameter("MasterCom", "Satel");
                        changeMenuRadio(port, false);
                        break;
                    case ContractNodeType.IRModem:
                        device = VehicleApplication.CreateDevice("IRModem", ContractNodeType.IRModem, "CVC700", comPortName, false);
                        device.AddReference("Port", comPortName);
                        radioComponent = VehicleApplication.CreateComponent("IRModem", "IRModem");
                        port = VehicleApplication.GetComponentByName(comPortName);
                        port.SetParameter("Baudrate", "9600");
                        master = VehicleApplication.GetComponentByName("Master");
                        master.SetParameter("MasterCom", "IRModem");
                        changeMenuRadio(port, false);
                        break;
                    default:
                        throw new Exception("The method or operation is not implemented.");
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public override void HandleDeletedComponent(ComponentDataBase component)
        {
            if (component.Type.ToString() == "InductiveAntenna")
            {
                ComponentDataBase wgu = VehicleApplication.GetComponentByName(component.GrandParentName);
                ContextMenuItem menuItem = wgu.GetMenuItem("InductiveSensor");
                menuItem.Enabled = true;
                wgu.UppdateMenuItem(menuItem);
            }
            if (component.NodeType.ToString() == "DigitalSensor")
            {
                ConnectionData connection = component.Connection;
                string[] n = connection.Name.Split('.');
                string connectionName = n[0];
                reassignDigitalSensor(connectionName);
            }

            if (component.Type.ToString() == "MCD7P")
            {
                changeMenuForDevice(component, true);
            }
            if (component.Type.ToString() == "LS2000Scanner")
            {
                ComponentDataBase Lan = VehicleApplication.GetComponentByName(component.ParentName);
                ContextMenuItem menuItem = Lan.GetMenuItem("LS2000_Menu");
                menuItem.Enabled = true;
                Lan.UppdateMenuItem(menuItem);
            }
            if (component.Type.ToString() == "MicroScan3Scanner")
            {
                EnableContextMenuItems(component.ParentName, menuItem => menuItem.DeviceName == "MicroScan3Scanner");
            }

            if (VehicleApplication.OkToAddComponent("Rcu")
                && VehicleApplication.OkToAddComponent("Satel")
                && VehicleApplication.OkToAddComponent("IRModem")
               )
            {
                ComponentDataBase master;
                master = VehicleApplication.GetComponentByName("Master");
                master.SetParameter("MasterCom", "WLAN");
                if (component.Type == "Satel"
                    || component.Type == "Rcu"
                    || component.Type == "IRModem"
                   )
                {
                    changeMenuForDevice(component, true);
                }
            }
            if (component.Type == "LanSerialPort")
            {
                ComponentDataBase comPort = VehicleApplication2.GetComponentByName(component.ParentName);
                ContextMenuItem menuItem = comPort.GetMenuItem(component.DeviceName);
                menuItem.Enabled = true;
                comPort.UppdateMenuItem(menuItem);
            }
        }

        public override bool OkToAddDevice(ComponentDataBase Parentdevice, ContractNodeType dataType)
        {
            CanComponentData canDevice = Parentdevice as CanComponentData;

            switch (dataType)
            {
                case ContractNodeType.DigitalSensor:
                    KeyValuePair<string, string> templateParameter = VehicleApplication.GetSingleTemplateParameter(Parentdevice.DeviceName, "NumberOfEdgeDetectDigInp");
                    int numberOfSensorsUsed = Convert.ToInt32(templateParameter.Value);
                    if (VehicleApplication.OkToAddComponent("WireNavigator") &&
                        VehicleApplication.OkToAddComponent("NaturalNavigator"))
                    {
                        return false;
                    }
                    else
                    {
                        if (numberOfSensorsUsed >= 4)
                        {
                            return false;
                        }
                        else
                        {
                            return true;
                        }
                    }

                case ContractNodeType.MagneticAntenna:
                    if (VehicleApplication.OkToAddComponent("WireNavigator"))
                    {
                        return false;
                    }
                    //Mask if Magnetic navigation is used
                    else if((navigationMethods & 4) > 0)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }

                case ContractNodeType.Rcu:
                    return true;

                case ContractNodeType.Satel:
                    return true;

                case ContractNodeType.IRModem:
                    return true;

                case ContractNodeType.SpotAntenna:
                    if (VehicleApplication.OkToAddComponent("SpotNavigator"))
                    {
                        return false;
                    }
                    else if(canDevice.DeviceType == m_SDIODeviceType)
                    {
                        return true;
                    }
                    else
                    {
                        return false;
                    }
                case ContractNodeType.LaserScanner:
                        return false;

                default:
                    return false;
            }
        }

        public override void AddS3000(ScriptNode node)
        {
            ComponentDataBase comPort = VehicleApplication2.GetComponentByName(node.ParentName);

            string nameString = node.DeviceName;
            ComponentData S3000 = VehicleApplication2.CreateDevice(nameString, "SickScanner", comPort.ParentName,
                                                                node.ParentName, false);
            S3000.AddReference("Port", node.ParentName);
            //changeMenuForDevice(S3000, false);
            comPort.SetParameter("Baudrate", "19200");

            if (HasComponent("ReflectorNavigator"))
            {
                ComponentDataBase reflectorNavigator = VehicleApplication2.GetComponentByName("ReflectorNavigator");
                reflectorNavigator.AddReference("Scanner", nameString);
            }
            if (HasComponent("WallNavigator"))
            {
                ComponentDataBase wallNavigator = VehicleApplication.GetComponentByName("WallNavigator") as ComponentData;
                wallNavigator.AddReference("Sick", nameString);
            }
            if (HasComponent("NaturalNavigator"))
            {
                ComponentDataBase ndtNavigator = VehicleApplication.GetComponentByName("NaturalNavigator") as ComponentData;
                ndtNavigator.AddReference("Sick", nameString);
            }
            if(comPort.ParentName == "LAN")
            {
                S3000.SetParameter("CommType", "3");
            }
        }

        #endregion

        #region Help functions
        public void reassignDigitalSensor(string CanDeviceName)
        {
            int counter = 0;
            string parameter, value;
            CanComponentData deviceData = VehicleApplication.GetComponentByName(CanDeviceName) as CanComponentData;
            System.Collections.Hashtable templateParameters = new System.Collections.Hashtable();

            templateParameters.Add("NumberOfEdgeDetectDigInp", 4);
            deviceData.SetTemplateParameters(templateParameters);
            templateParameters.Clear();

            List<ComponentDataBase> digitalSensorList = VehicleApplication.GetComponentsByType(ContractNodeType.DigitalSensor);

            //to find ending number below
            Regex regex = new Regex(@"(\d+)$", RegexOptions.Compiled | RegexOptions.CultureInvariant);

            foreach (ComponentDataBase digitalSensor in digitalSensorList)
            {
                ConnectionData connection = digitalSensor.Connection;

                string[] n = connection.Name.Split('.');
                string connectionName = n[0];

                if (connectionName == CanDeviceName)
                {
                    //Uppdate all the sensors on the current SDIO
                    ++counter;
                    string digInput = digitalSensor.GetParameterValue("digitalInput");

                    //set the EdgeDetectInputX
                    parameter = ("EdgeDetectInput" + counter.ToString());
                    //find the ending number
                    Match match = regex.Match(digInput);
                    if (match.Success)
                        value = match.Groups[1].Value;
                    else
                        throw new Exception("The Digital input name doesn't end with a number");
                    deviceData.SetParameter(parameter, value);

                    //set the DigitalInputEdge = X
                    parameter = "DigitalInputEdge";
                    value = string.Format("{0}.{1}", CanDeviceName, ("RisingEdge" + counter.ToString()));
                    digitalSensor.SetParameter(parameter, value);
                }
            }
            //set template parameter
            parameter = "NumberOfEdgeDetectDigInp";
            value = counter.ToString();
            templateParameters.Add(parameter, value);
            deviceData.SetTemplateParameters(templateParameters);
        }

        public void changeMenuForDevice(ComponentDataBase component, bool enable)
        {
            ComponentDataBase componentParent = VehicleApplication2.GetComponentByName(component.ParentName);
            List<ContextMenuItem> itemList = componentParent.MenuItems;

            ContextMenuItem menuItem;
            for (int i = 0; i < itemList.Count; i++)
            {
                menuItem = componentParent.GetMenuItem(itemList[i].Name);
                menuItem.Enabled = enable;
                componentParent.UppdateMenuItem(menuItem);
            }
        }

        public void changeMenuRadio(ComponentDataBase port, bool enable)
        {
            List<ContextMenuItem> itemList = port.MenuItems;
            ContextMenuItem menuItem;
            for (int i = 0; i < itemList.Count; i++)
            {
                menuItem = port.GetMenuItem(itemList[i].Name);
                menuItem.Enabled = enable;
                port.UppdateMenuItem(menuItem);
            }
        }

        public void addMcd(ScriptNode node)
        {
            ComponentData mcd = VehicleApplication2.CreateDevice("Mcd", "MCD7P", "CVC700", "COM3", false);
            mcd.AddReference("Port", node.ParentName);
            ComponentDataBase comPort = VehicleApplication.GetComponentByName("COM3");
            ContextMenuItem menuItem = comPort.GetMenuItem("Mcd");
            menuItem.Enabled = false;
            comPort.UppdateMenuItem(menuItem);
        }

        public void addLS2000(ScriptNode node)
        {
            try
            {
                VehicleApplication3.ShowNameForm("LAN", nodeTemplate =>
                {
                    AddLS2000Scanner(nodeTemplate.DeviceName, node.ParentName);
                }, "LS2000");
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        private void AddMicroScan3Scanner(ScriptNode node, string defaultName)
        {
            try
            {
                VehicleApplication3.ShowNameForm(node.ParentName, nodeTemplate =>
                {
                    AddMicroScan3Scanner(nodeTemplate.DeviceName, nodeTemplate.ParentName);
                }, defaultName);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.ToString(), "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        private void EnableContextMenuItems(string connectionPointName, Func<ContextMenuItem,bool> filter)
        {
            var component = VehicleApplication.GetComponentByName(connectionPointName);
            foreach(ContextMenuItem menuItem in component.MenuItems.Where(filter).ToList())
            {
                menuItem.Enabled = true;
                component.UppdateMenuItem(menuItem);
            }
        }

        private void DisableContextMenuItems(string connectionPointName, Func<ContextMenuItem, bool> filter)
        {
            var component = VehicleApplication.GetComponentByName(connectionPointName);
            foreach (ContextMenuItem menuItem in component.MenuItems.Where(filter).ToList())
            {
                menuItem.Enabled = false;
                component.UppdateMenuItem(menuItem);
            }
        }

        public void addLanComPort(ScriptNode node)
        {
            try
            {
                if (!VehicleApplication2.OkToAddComponent(node.DeviceName))
                {
                    throw new Exception("LAN port already exists");
                }
                ComponentData comp = VehicleApplication2.CreateDevice(node.DeviceName, "LanSerialPort", "CVC700", node.ParentName, false);
                ComponentDataBase Lan = VehicleApplication.GetComponentByName(node.ParentName);
                ContextMenuItem menuItem = Lan.GetMenuItem(node.DeviceName);
                menuItem.Enabled = false;
                Lan.UppdateMenuItem(menuItem);
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message, "Script error", MessageBoxButtons.OKCancel, MessageBoxIcon.Error);
            }
        }

        public bool HasComponent(String comp)
        {
            return !VehicleApplication2.OkToAddComponent(comp);
        }
        #endregion
    }
    //MessageBox.Show("test AddComPort!\r\n\r\n" + node.ParentName + ":" + node.DeviceName);
}
