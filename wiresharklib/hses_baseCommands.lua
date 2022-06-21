--[[
	UAPI dissector for othercommdands
]]--

local hsesmodule = hses_dissector or {}
if hsesmodule.dissector_baseGetStatus ~= nil then
	return hsesmodule.dissector_baseGetStatus
end

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- fields define
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local fields = hsesmodule.fields or {}

-- Alarm Data (70)
local alarmDataInstanceStrings = 
{
	[1] = "First active alarm",
	[2] = "Second active alarm",
	[3] = "Third active alarm",
	[4] = "Fourth active alarm"
}
local alarmDataAttrStrings = 
{
	[0] = "All data",
	[1] = "Code",
	[2] = "Subcode",
	[3] = "Type",
	[4] = "Time",
	[5] = "Text"
}
fields.data_alarmData_Instance = ProtoField.uint16 ("hses.data.alarmData.instance", "Instance", base.DEC, alarmDataInstanceStrings)
fields.data_alarmData_Attribute = ProtoField.uint8 ("hses.data.alarmData.attribute", "Attribute", base.DEC, alarmDataAttrStrings)

fields.data_alarmData_Code = ProtoField.uint32("hses.data.alarmData.code", "Code", base.DEC)
fields.data_alarmData_Data = ProtoField.uint32("hses.data.alarmData.subcode", "Subcode", base.DEC)
fields.data_alarmData_Type = ProtoField.uint32("hses.data.alarmData.type", "Type", base.DEC)
fields.data_alarmData_Time = ProtoField.string("hses.data.alarmData.time", "Time")
fields.data_alarmData_Text = ProtoField.string("hses.data.alarmData.text", "Text")

-- Alarm History (71)
fields.data_alarmHistory_Instance = ProtoField.uint16("hses.data.alarmHistory.instance", "Instance", base.DEC)
fields.data_alarmHistory_Attribute = ProtoField.uint8 ("hses.data.alarmHistory.attribute", "Attribute", base.DEC, alarmDataAttrStrings)

-- Status (72)
fields.data_statusData1 = ProtoField.new ("Data 1", "hses.data.statusData1", ftypes.UINT32, nil, base.HEX)
fields.data_statusData1_b0 = ProtoField.new (" ", "hses.data.statusData1.b0", ftypes.BOOLEAN, {"Step","--"}, 16, 0x00000001, "") 
fields.data_statusData1_b1 = ProtoField.new (" ", "hses.data.statusData1.b1", ftypes.BOOLEAN, {"Cycle","--"}, 16, 0x00000002, "") 
fields.data_statusData1_b2 = ProtoField.new (" ", "hses.data.statusData1.b2", ftypes.BOOLEAN, {"Auto/Cont","--"}, 16, 0x00000004, "") 
fields.data_statusData1_b3 = ProtoField.new (" ", "hses.data.statusData1.b3", ftypes.BOOLEAN, {"Running","--"}, 16, 0x00000008, "") 
fields.data_statusData1_b4 = ProtoField.new (" ", "hses.data.statusData1.b4", ftypes.BOOLEAN, {"In-guard safe operation","--"}, 16, 0x00000010, "") 
fields.data_statusData1_b5 = ProtoField.new (" ", "hses.data.statusData1.b5", ftypes.BOOLEAN, {"Teach","--"}, 16, 0x00000020, "") 
fields.data_statusData1_b6 = ProtoField.new (" ", "hses.data.statusData1.b6", ftypes.BOOLEAN, {"Play","--"}, 16, 0x00000040, "") 
fields.data_statusData1_b7 = ProtoField.new (" ", "hses.data.statusData1.b7", ftypes.BOOLEAN, {"Remote","--"}, 16, 0x00000080, "") 

fields.data_statusData2 = ProtoField.new ("Data 2", "hses.data.statusData2", ftypes.UINT32, nil, base.HEX)
fields.data_statusData2_b1 = ProtoField.new (" ", "hses.data.statusData2.b1", ftypes.BOOLEAN, {"HOLD (PP)","--"}, 16, 0x00000002, "") 
fields.data_statusData2_b2 = ProtoField.new (" ", "hses.data.statusData2.b2", ftypes.BOOLEAN, {"HOLD (External)","--"}, 16, 0x00000004, "") 
fields.data_statusData2_b3 = ProtoField.new (" ", "hses.data.statusData2.b3", ftypes.BOOLEAN, {"HOLD (Command)","--"}, 16, 0x00000008, "") 
fields.data_statusData2_b4 = ProtoField.new (" ", "hses.data.statusData2.b4", ftypes.BOOLEAN, {"Alarm","--"}, 16, 0x00000010, "") 
fields.data_statusData2_b5 = ProtoField.new (" ", "hses.data.statusData2.b5", ftypes.BOOLEAN, {"Error","--"}, 16, 0x00000020, "") 
fields.data_statusData2_b6 = ProtoField.new (" ", "hses.data.statusData2.b6", ftypes.BOOLEAN, {"Servo Power","--"}, 16, 0x00000040, "") 

-- Job Info (73)
local jobInformationAttributeStrings = 
{
	[0] = "All Data",
	[1] = "Job Name",
	[2] = "Line Number",
	[3] = "Step Number",
	[4] = "Speed Override Value"
}
fields.data_jobInformation_Instance = ProtoField.string("hses.data.jobInformation.instance", "Instance")
fields.data_jobInformation_Attribute = ProtoField.uint8("hses.data.jobInformation.attribute", "Attribute", base.DEC, jobInformationAttributeStrings)
fields.data_jobInformation_Name = ProtoField.string("hses.data.jobInformation.name", "Name")
fields.data_jobInformation_Line = ProtoField.uint32("hses.data.jobInformation.line", "Line", base.DEC)
fields.data_jobInformation_Step = ProtoField.uint32("hses.data.jobInformation.step", "Step", base.DEC)
fields.data_jobInformation_SpeedOverride = ProtoField.uint32("hses.data.jobInformation.speedOverride", "Override", base.DEC)

-- Axis Configuration (74)
fields.data_axisConfiguration_Instance = ProtoField.string("hses.data.axisConfiguration.instance", "Instance")
fields.data_axisConfiguration_Axis1Name = ProtoField.string("hses.data.axis1Name", "Axis 1")
fields.data_axisConfiguration_Axis2Name = ProtoField.string("hses.data.axis2Name", "Axis 2")
fields.data_axisConfiguration_Axis3Name = ProtoField.string("hses.data.axis3Name", "Axis 3")
fields.data_axisConfiguration_Axis4Name = ProtoField.string("hses.data.axis4Name", "Axis 4")
fields.data_axisConfiguration_Axis5Name = ProtoField.string("hses.data.axis5Name", "Axis 5")
fields.data_axisConfiguration_Axis6Name = ProtoField.string("hses.data.axis6Name", "Axis 6")
fields.data_axisConfiguration_Axis7Name = ProtoField.string("hses.data.axis7Name", "Axis 7")
fields.data_axisConfiguration_Axis8Name = ProtoField.string("hses.data.axis8Name", "Axis 8")

-- Current Position (75)
local positionAttributeStrings =
{
	[0] = "All data",
	[1] = "Coordinates",
	[2] = "Form/figure",
	[3] = "Tool",
	[4] = "UF",
	[5] = "Extended form/figure",
	[6] = "Axis 1",
	[7] = "Axis 2",
	[8] = "Axis 3",
	[9] = "Axis 4",
	[10] = "Axis 5",
	[11] = "Axis 6",
	[12] = "Axis 7",
	[13] = "Axis 8",
}
fields.data_currentPosition_Instance = ProtoField.string("hses.data.position.instance", "Instance")
fields.data_currentPosition_Attribute = ProtoField.uint8("hses.data.position.attribute", "Attribute", base.DEC, positionAttributeStrings)

local positionCoordinateTypeStrings = 
{
	[0] = "Pulse",
	[16] = "BF",
	[17] = "RF",
	[18] = "UF",
	[19] = "TF"
}
fields.data_position_Coord = ProtoField.uint32("hses.data.position.coordType", "Coordinate Type", base.DEC, positionCoordinateTypeStrings)

fields.data_position_Figure = ProtoField.uint32("hses.data.position.figure", "Form / Figure", base.HEX)
fields.data_position_Figure_b0 = ProtoField.new (" ", "hses.data.position.figure.b0", ftypes.BOOLEAN, {"Back","Front"}, 8, 0x00000001, "") 
fields.data_position_Figure_b1 = ProtoField.new (" ", "hses.data.position.figure.b1", ftypes.BOOLEAN, {"Lower","Upper"}, 8, 0x00000002, "") 
fields.data_position_Figure_b2 = ProtoField.new (" ", "hses.data.position.figure.b2", ftypes.BOOLEAN, {"No flip","Flip"}, 8, 0x00000004, "") 
fields.data_position_Figure_b3 = ProtoField.new (" ", "hses.data.position.figure.b3", ftypes.BOOLEAN, {"R>=180","R<180"}, 8, 0x00000008, "") 
fields.data_position_Figure_b4 = ProtoField.new (" ", "hses.data.position.figure.b4", ftypes.BOOLEAN, {"T>=180","T<180"}, 8, 0x00000010, "") 
fields.data_position_Figure_b5 = ProtoField.new (" ", "hses.data.position.figure.b5", ftypes.BOOLEAN, {"S>=180","S<180"}, 8, 0x00000020, "") 
fields.data_position_Figure_b6 = ProtoField.new (" ", "hses.data.position.figure.b6", ftypes.BOOLEAN, {"Redundant Back","Redundant Front"}, 8, 0x00000040, "") 
fields.data_position_Figure_b7 = ProtoField.new (" ", "hses.data.position.figure.b7", ftypes.BOOLEAN, {"Reverse Conversion: Type","Reverse Conversion: Step"}, 8, 0x00000080, "") 

fields.data_position_Tool = ProtoField.uint32("hses.data.position.tool", "Tool", base.DEC)
fields.data_position_Uf = ProtoField.uint32("hses.data.position.uf", "UF", base.DEC)

fields.data_position_ExFigure = ProtoField.uint32("hses.data.position.exfigure", "Ex Form / Figure", base.HEX)
fields.data_position_ExFigure_b0 = ProtoField.new (" ", "hses.data.position.exfigure.b0", ftypes.BOOLEAN, {"L>=180","L<180"}, 8, 0x00000001, "") 
fields.data_position_ExFigure_b1 = ProtoField.new (" ", "hses.data.position.exfigure.b1", ftypes.BOOLEAN, {"U>=180","U<180"}, 8, 0x00000002, "") 
fields.data_position_ExFigure_b2 = ProtoField.new (" ", "hses.data.position.exfigure.b2", ftypes.BOOLEAN, {"B>=180","B<180"}, 8, 0x00000004, "") 
fields.data_position_ExFigure_b3 = ProtoField.new (" ", "hses.data.position.exfigure.b3", ftypes.BOOLEAN, {"E>=180","E<180"}, 8, 0x00000008, "") 
fields.data_position_ExFigure_b4 = ProtoField.new (" ", "hses.data.position.exfigure.b4", ftypes.BOOLEAN, {"W>=180","W<180"}, 8, 0x00000010, "") 
fields.data_position_ExFigure_b5 = ProtoField.new (" ", "hses.data.position.exfigure.b5", ftypes.BOOLEAN, {"",""}, 8, 0x00000020, "") 
fields.data_position_ExFigure_b6 = ProtoField.new (" ", "hses.data.position.exfigure.b6", ftypes.BOOLEAN, {"",""}, 8, 0x00000040, "") 
fields.data_position_ExFigure_b7 = ProtoField.new (" ", "hses.data.position.exfigure.b7", ftypes.BOOLEAN, {"",""}, 8, 0x00000080, "") 

fields.data_position_Units = ProtoField.string("hses.data.position.units", "Units")
fields.data_position_Axis1 = ProtoField.float("hses.data.position.axis1", "Axis 1")
fields.data_position_Axis2 = ProtoField.float("hses.data.position.axis2", "Axis 2")
fields.data_position_Axis3 = ProtoField.float("hses.data.position.axis3", "Axis 3")
fields.data_position_Axis4 = ProtoField.float("hses.data.position.axis4", "Axis 4")
fields.data_position_Axis5 = ProtoField.float("hses.data.position.axis5", "Axis 5")
fields.data_position_Axis6 = ProtoField.float("hses.data.position.axis6", "Axis 6")
fields.data_position_Axis7 = ProtoField.float("hses.data.position.axis7", "Axis 7")
fields.data_position_Axis8 = ProtoField.float("hses.data.position.axis8", "Axis 8")

-- Torque (77)
local axisSelectionStrings =
{
	[0] = "All data",
	[1] = "Axis 1",
	[2] = "Axis 2",
	[3] = "Axis 3",
	[4] = "Axis 4",
	[5] = "Axis 5",
	[6] = "Axis 6",
	[7] = "Axis 7",
	[8] = "Axis 8",
}
fields.data_currentTorque_Instance = ProtoField.string("hses.data.currentTorque.instance", "Instance")
fields.data_currentTorque_Attribute = ProtoField.uint8("hses.data.currentTorque.attribute", "Attribute", base.DEC, axisSelectionStrings)

fields.data_currentTorque_Axis1 = ProtoField.float("hses.data.currentTorque.axis1", "Axis 1")
fields.data_currentTorque_Axis2 = ProtoField.float("hses.data.currentTorque.axis2", "Axis 2")
fields.data_currentTorque_Axis3 = ProtoField.float("hses.data.currentTorque.axis3", "Axis 3")
fields.data_currentTorque_Axis4 = ProtoField.float("hses.data.currentTorque.axis4", "Axis 4")
fields.data_currentTorque_Axis5 = ProtoField.float("hses.data.currentTorque.axis5", "Axis 5")
fields.data_currentTorque_Axis6 = ProtoField.float("hses.data.currentTorque.axis6", "Axis 6")
fields.data_currentTorque_Axis7 = ProtoField.float("hses.data.currentTorque.axis7", "Axis 7")
fields.data_currentTorque_Axis8 = ProtoField.float("hses.data.currentTorque.axis8", "Axis 8")

-- I/O (78)
fields.data_Io_Group = ProtoField.string("hses.data.io.group", "Group Number")
fields.data_Io_WriteValue = ProtoField.uint8("hses.data.io.writeValue", "Value", base.DEC)
fields.data_Io_ReadValue = ProtoField.uint8("hses.data.io.readValue", "Value", base.DEC)

-- Register (79)
fields.data_register_instance = ProtoField.string("hses.data.register.instance", "Register Number")
fields.data_register_WriteValue = ProtoField.uint16("hses.data.register.writeValue", "Value", base.DEC)
fields.data_register_ReadValue = ProtoField.uint16("hses.data.register.readValue", "Value", base.DEC)

-- B Variable (7A)
fields.data_bvar_instance = ProtoField.string("hses.data.bvar.instance", "Variable Number")
fields.data_bvar_WriteValue = ProtoField.uint8("hses.data.bvar.writeValue", "Value", base.DEC)
fields.data_bvar_ReadValue = ProtoField.uint8("hses.data.bvar.readValue", "Value", base.DEC)

-- I Variable (7B)
fields.data_ivar_instance = ProtoField.string("hses.data.ivar.instance", "Variable Number")
fields.data_ivar_WriteValue = ProtoField.int16("hses.data.ivar.writeValue", "Value", base.DEC)
fields.data_ivar_ReadValue = ProtoField.int16("hses.data.ivar.readValue", "Value", base.DEC)

-- D Variable (7C)
fields.data_dvar_instance = ProtoField.string("hses.data.dvar.instance", "Variable Number")
fields.data_dvar_WriteValue = ProtoField.int32("hses.data.dvar.writeValue", "Value", base.DEC)
fields.data_dvar_ReadValue = ProtoField.int32("hses.data.dvar.readValue", "Value", base.DEC)

-- R Variable (7D)
fields.data_rvar_instance = ProtoField.string("hses.data.rvar.instance", "Variable Number")
fields.data_rvar_WriteValue = ProtoField.float("hses.data.rvar.writeValue", "Value")
fields.data_rvar_ReadValue = ProtoField.float("hses.data.rvar.readValue", "Value")

-- S Variable (7E or 8C)
fields.data_svar_instance = ProtoField.string("hses.data.svar.instance", "Variable Number")
fields.data_svar_WriteValue = ProtoField.string("hses.data.svar.writeValue", "Value")
fields.data_svar_ReadValue = ProtoField.string("hses.data.svar.readValue", "Value")

-- P Variable (7F)
fields.data_pvar_instance = ProtoField.string("hses.data.pvar.instance", "Variable Number")

-- Alarm/Error Reset (82)
fields.data_alarmReset_Instance = ProtoField.string("hses.data.alarmreset.instance", "Instance")
fields.data_alarmReset_Value = ProtoField.uint32("hses.data.alarmreset.value", "Value", base.DEC)

-- Hold/Servo (83)
local powerToggleStrings = 
{
	[1] = "ON",
	[2] = "OFF"
}
fields.data_holdservo_Instance = ProtoField.string("hses.data.holdservo.instance", "Instance")
fields.data_holdservo_Value = ProtoField.uint32("hses.data.holdservo.value", "Value", base.DEC, powerToggleStrings)

-- Step/Cycle/Auto (84)
fields.data_stepCycleAuto_Value = ProtoField.uint32("hses.data.stepcycleauto.value", "Value", base.DEC)

-- Start Job (86)
fields.data_startJob_Value = ProtoField.uint32("hses.data.startjob.value", "Value", base.DEC)

-- Select Job (87)
local jobSelectionStrings = 
{
	[0] = "Name and Line Number",
	[1] = "Job name",
	[2] = "Line number"
}
fields.data_selectJob_Instance = ProtoField.string("hses.data.selectjob.instance", "Instance")
fields.data_selectJob_Attribute = ProtoField.uint8("hses.data.selectjob.attribute", "Attribute", base.DEC, jobSelectionStrings)
fields.data_selectJob_Name = ProtoField.string("hses.data.selectjob.name", "Job name")
fields.data_selectJob_Line = ProtoField.uint32("hses.data.selectjob.line", "Line number", base.DEC)

-- System Info (89)
local systemInfoAttributeStrings = 
{
	[0] = "All information",
	[1] = "System software version",
	[2] = "Model name / application",
	[3] = "Parameter version"
}
fields.data_systemInfo_Instance = ProtoField.string("hses.data.systeminfo.instance", "Instance")
fields.data_systemInfo_Attribute = ProtoField.uint8("hses.data.systeminfo.attribute", "Attribute", base.DEC, systemInfoAttributeStrings)

fields.data_systemInfo_SystemSoftware = ProtoField.string("hses.data.systeminfo.systemsoftware", "System Software")
fields.data_systemInfo_ModelApp = ProtoField.string("hses.data.systeminfo.modelapplication", "Model / Application")
fields.data_systemInfo_Parameter = ProtoField.string("hses.data.systeminfo.parameter", "Parameter")

-------------------------------------------------------------------------
hsesmodule.fields = fields
-------------------------------------------------------------------------

-------------------------------------------------------------------------
-------------------------------------------------------------------------
-- dissectors
-------------------------------------------------------------------------
-------------------------------------------------------------------------
local function dissector_baseAlarmData(instance,attribute,dbuffer,packetInfo,tree)
	tree:add_le(fields.data_alarmData_Instance, instance)
	tree:add_le(fields.data_alarmData_Attribute, attribute)
end

local function dissector_baseAlarmDataAns(instance,attribute,dbuffer,packetInfo,tree)
	
	local byteIndex = 0

	if (attribute == 1 or attribute == 0) then
		tree:add_le(fields.data_alarmData_Code, dbuffer(byteIndex, 4):le_uint())
		byteIndex = byteIndex + 4
	end
	if (attribute == 2 or attribute == 0) then
		tree:add_le(fields.data_alarmData_Data, dbuffer(byteIndex, 4):le_uint())
		byteIndex = byteIndex + 4
	end
	if (attribute == 3 or attribute == 0) then
		tree:add_le(fields.data_alarmData_Type, dbuffer(byteIndex, 4):le_uint())
		byteIndex = byteIndex + 4
	end
	if (attribute == 4 or attribute == 0) then
		tree:add_le(fields.data_alarmData_Time, dbuffer(byteIndex, 16))
		byteIndex = byteIndex + 16
	end
	if (attribute == 5 or attribute == 0) then
		tree:add_le(fields.data_alarmData_Text, dbuffer(byteIndex, 32))
		byteIndex = byteIndex + 32
	end
end

local function dissector_baseAlarmHistory(instance,attribute,dbuffer,packetInfo,tree)
	tree:add_le(fields.data_alarmHistory_Instance, instance)
	tree:add_le(fields.data_alarmHistory_Attribute, attribute)
end

local function dissector_baseAlarmHistoryAns(instance,attribute,dbuffer,packetInfo,tree)
	dissector_baseAlarmDataAns(instance, attribute, dbuffer, packetInfo, tree)
end

local function dissector_baseGetStatus(dbuffer,pinfo,datatree)
end

local function dissector_baseGetStatusAns(dbuffer,pinfo,datatree)
	datatree:add_le(fields.data_statusData1, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b0, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b1, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b2, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b3, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b4, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b5, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b6, dbuffer(0,4))
	datatree:add_le(fields.data_statusData1_b7, dbuffer(0,4))

	datatree:add_le(fields.data_statusData2, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b1, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b2, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b3, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b4, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b5, dbuffer(4,4))
	datatree:add_le(fields.data_statusData2_b6, dbuffer(4,4))
end

local function dissector_baseRunningJobInfo(instance,attribute,dbuffer,packetInfo,tree)

	local instanceString = ""

	if instance == 1 then
		instanceString = "Master Task"
	else
		instanceString = "Subtask " .. (instance - 1)
	end

	tree:add_le(fields.data_jobInformation_Instance, instanceString)
	tree:add_le(fields.data_jobInformation_Attribute, attribute)
end

local function dissector_baseRunningJobInfoAns(instance,attribute,dbuffer,packetInfo,tree)

	local byteIndex = 0

	if (attribute == 1 or attribute == 0) then
		tree:add_le(fields.data_jobInformation_Name, dbuffer(byteIndex, 32))
		byteIndex = byteIndex + 32
	end
	if (attribute == 2 or attribute == 0) then
		tree:add_le(fields.data_jobInformation_Line, dbuffer(byteIndex, 4):le_uint())
		byteIndex = byteIndex + 4
	end
	if (attribute == 3 or attribute == 0) then
		tree:add_le(fields.data_jobInformation_Step, dbuffer(byteIndex, 4):le_uint())
		byteIndex = byteIndex + 4
	end
	if (attribute == 4 or attribute == 0) then
		tree:add_le(fields.data_jobInformation_SpeedOverride, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
end

local function dissector_baseAxisConfiguration(instance,attribute,dbuffer,packetInfo,tree)

	local instanceString = ""

	if instance >= 1 and instance <= 8 then
		instanceString = "R" .. instance .. " (pulse)"
	elseif instance >= 11 and instance <= 18 then
		instanceString = "B" .. (instance - 10) .. " (pulse)"
	elseif instance >= 21 and instance <= 44 then
		instanceString = "S" .. (instance - 20) .. " (pulse)"
	elseif instance >= 101 and instance <= 108 then
		instanceString = "R" .. (instance - 100) .. " (cartesian)"
	elseif instance >= 111 and instance <= 118 then
		instanceString = "B" .. (instance - 110) .. " (cartesian)"
	end

	tree:add_le(fields.data_axisConfiguration_Instance, instanceString)
end

local function dissector_baseAxisConfigurationAns(instance,attribute,dbuffer,packetInfo,tree)
	local byteIndex = 0
	
	if (attribute == 1 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis1Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 2 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis2Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 3 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis3Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 4 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis4Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 5 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis5Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 6 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis6Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 7 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis7Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 8 or attribute == 0) then
		tree:add_le(fields.data_axisConfiguration_Axis8Name, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
end

local function dissector_baseGetCurrentPosition(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""

	if instance >= 1 and instance <= 8 then
		instanceString = "R" .. instance .. " (pulse)"
	elseif instance >= 11 and instance <= 18 then
		instanceString = "B" .. (instance - 10) .. " (pulse)"
	elseif instance >= 21 and instance <= 44 then
		instanceString = "S" .. (instance - 20) .. " (pulse)"
	elseif instance >= 101 and instance <= 108 then
		instanceString = "R" .. (instance - 100) .. " (cartesian)"
	end

	tree:add_le(fields.data_currentPosition_Instance, instanceString)
	tree:add_le(fields.data_currentPosition_Attribute, attribute);
end

local function dissector_baseGetPositionAns(cartesian,attribute,dbuffer,packetInfo,tree)
	local byteIndex = 0
	local figure = 0
	local exfigure = 0

	if attribute == 1 or attribute == 0 then
		tree:add_le(fields.data_position_Coord, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end

	if attribute == 2 or attribute == 0 then
		figure = dbuffer(byteIndex, 4)
		byteIndex = byteIndex + 4
	end

	if attribute == 3 or attribute == 0 then
		tree:add_le(fields.data_position_Tool, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end

	if attribute == 4 or attribute == 0 then
		tree:add_le(fields.data_position_Uf, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end

	if attribute == 5 or attribute == 0 then
		exfigure = dbuffer(byteIndex, 4)
		byteIndex = byteIndex + 4
	end
	
	if attribute == 0 then
		if cartesian then
			tree:add_le(fields.data_position_Units, "Millimeters and Degrees")
		else
			tree:add_le(fields.data_position_Units, "Pulse")
		end
	end

	local value = 0.01
	value = 0.01 - 0.01

	local multiplier = 0.001
	if not cartesian then
		multiplier = 1
	end

	if attribute == 6 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis1, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if attribute == 7 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis2, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if attribute == 8 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis3, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if cartesian then
		multiplier = 0.0001
	end

	if attribute == 9 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis4, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if attribute == 10 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis5, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if attribute == 11 or attribute == 0 then
		value = dbuffer(byteIndex, 4):le_int()
		tree:add_le(fields.data_position_Axis6, value * multiplier)
		byteIndex = byteIndex + 4
	end

	if dbuffer:len() >= 48 then
		if attribute == 12 or attribute == 0 then
			value = dbuffer(byteIndex, 4):le_int()
			tree:add_le(fields.data_position_Axis7, value * multiplier)
			byteIndex = byteIndex + 4
		end
	end
	
	if dbuffer:len() >= 52 then
		if attribute == 13 or attribute == 0 then
			value = dbuffer(byteIndex, 4):le_int()
			tree:add_le(fields.data_position_Axis8, value * multiplier)
			byteIndex = byteIndex + 4
		end
	end
	
	if attribute == 2 or attribute == 0 then
		tree:add_le(fields.data_position_Figure, figure)
		tree:add_le(fields.data_position_Figure_b0, figure)
		tree:add_le(fields.data_position_Figure_b1, figure)
		tree:add_le(fields.data_position_Figure_b2, figure)
		tree:add_le(fields.data_position_Figure_b3, figure)
		tree:add_le(fields.data_position_Figure_b4, figure)
		tree:add_le(fields.data_position_Figure_b5, figure)
		tree:add_le(fields.data_position_Figure_b6, figure)
		tree:add_le(fields.data_position_Figure_b7, figure)
	end
	
	if attribute == 5 or attribute == 0 then
		tree:add_le(fields.data_position_ExFigure, exfigure)
		tree:add_le(fields.data_position_ExFigure_b0, exfigure)
		tree:add_le(fields.data_position_ExFigure_b1, exfigure)
		tree:add_le(fields.data_position_ExFigure_b2, exfigure)
		tree:add_le(fields.data_position_ExFigure_b3, exfigure)
		tree:add_le(fields.data_position_ExFigure_b4, exfigure)
		tree:add_le(fields.data_position_ExFigure_b5, exfigure)
		tree:add_le(fields.data_position_ExFigure_b6, exfigure)
		tree:add_le(fields.data_position_ExFigure_b7, exfigure)
	end
end

local function dissector_baseGetCurrentTorque(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""

	if instance >= 1 and instance <= 8 then
		instanceString = "R" .. instance .. " (pulse)"
	elseif instance >= 11 and instance <= 18 then
		instanceString = "B" .. (instance - 10) .. " (pulse)"
	elseif instance >= 21 and instance <= 44 then
		instanceString = "S" .. (instance - 20) .. " (pulse)"
	end

	tree:add_le(fields.data_currentTorque_Instance, instanceString)
	tree:add_le(fields.data_currentTorque_Attribute, attribute);
end

local function dissector_baseGetCurrentTorqueAns(instance,attribute,dbuffer,packetInfo,tree)
	local byteIndex = 0
	
	if (attribute == 1 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis1, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 2 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis2, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 3 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis3, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 4 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis4, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 5 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis5, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	if (attribute == 6 or attribute == 0) then
		tree:add_le(fields.data_currentTorque_Axis6, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
	
	if dbuffer:len() >= 28 then
		if (attribute == 7 or attribute == 0) then
			tree:add_le(fields.data_currentTorque_Axis7, dbuffer(byteIndex, 4))
			byteIndex = byteIndex + 4
		end
	end
	
	if dbuffer:len() >= 32 then
		if (attribute == 8 or attribute == 0) then
			tree:add_le(fields.data_currentTorque_Axis8, dbuffer(byteIndex, 4))
			byteIndex = byteIndex + 4
		end
	end
end

local function dissector_baseIo(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local groupString = string.format("#%04dx", instance)

	tree:add_le(fields.data_Io_Group, groupString)

	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,1):le_uint()
		tree:add_le(fields.data_Io_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. groupString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. groupString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseIoAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local groupString = string.format("#%04dx", instance)
	

	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,1):le_uint()
		tree:add_le(fields.data_Io_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. groupString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseRegister(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local registerString = string.format("M%03d", instance)
	tree:add_le(fields.data_register_instance, registerString)
	
	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,2):le_uint()
		tree:add_le(fields.data_register_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. registerString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. registerString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseRegisterAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local registerString = string.format("M%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,2):le_uint()
		tree:add_le(fields.data_register_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. registerString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseBvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("B%03d", instance)
	tree:add_le(fields.data_bvar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,1):le_uint()
		tree:add_le(fields.data_bvar_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. variableString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseBvariableAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("B%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,1):le_uint()
		tree:add_le(fields.data_bvar_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. variableString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseIvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("I%03d", instance)
	tree:add_le(fields.data_ivar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,2):le_int()
		tree:add_le(fields.data_ivar_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. variableString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseIvariableAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("I%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,2):le_int()
		tree:add_le(fields.data_ivar_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. variableString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseDvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("D%03d", instance)
	tree:add_le(fields.data_dvar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,4):le_int()
		tree:add_le(fields.data_dvar_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. variableString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseDvariableAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("D%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,4):le_int()
		tree:add_le(fields.data_dvar_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. variableString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseRvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("R%03d", instance)
	tree:add_le(fields.data_rvar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		local iovalue = dbuffer(0,4):le_float()
		tree:add_le(fields.data_rvar_WriteValue, iovalue)
		commandtext = commandtext .. " (Write " .. variableString .. " = " .. iovalue .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseRvariableAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("R%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		local iovalue = dbuffer(0,4):le_float()
		tree:add_le(fields.data_rvar_ReadValue, iovalue)
		commandtext = commandtext .. " (" .. variableString .. " = " .. iovalue .. ")"
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_baseSvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("S%03d", instance)
	tree:add_le(fields.data_svar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		if dbuffer:len() <= 16 then
			tree:add_le(fields.data_svar_WriteValue, 16)
		else
			tree:add_le(fields.data_svar_WriteValue, 32)
		end
		
		commandtext = commandtext .. " (Write " .. variableString .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseSvariableAns(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("S%03d", instance)
	
	if service == 0x01 or service == 0x0E then
		if dbuffer:len() <= 16 then
			tree:add_le(fields.data_svar_ReadValue, dbuffer(0,16))
		else
			tree:add_le(fields.data_svar_ReadValue, dbuffer(0,32))
		end		
		packetInfo.cols.info:set(commandtext)
	end
end

local function dissector_basePvariable(instance,attribute,dbuffer,packetInfo,tree,commandtext,service)
	local variableString = string.format("P%03d", instance)
	tree:add_le(fields.data_pvar_instance, variableString)
	
	if service == 2 or service == 0x10 then
		if attribute == 1 or attribute == 0 then
			if dbuffer(0,4):le_uint() > 0 then
				dissector_baseGetPositionAns(true,attribute,dbuffer,packetInfo,tree)
			else
				dissector_baseGetPositionAns(false,attribute,dbuffer,packetInfo,tree)
			end
		else
			dissector_baseGetPositionAns(false,attribute,dbuffer,packetInfo,tree)
		end
		commandtext = commandtext .. " (Write " .. variableString .. ")"
	else
		commandtext = commandtext .. " (Read " .. variableString .. ")"
	end
	
	packetInfo.cols.info:set(commandtext)
end

local function dissector_baseResetAlarmError(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""

	if instance == 1 then
		instanceString = "Reset Alarm"
	else
		instanceString = "Cancel Error"
	end

	tree:add_le(fields.data_alarmReset_Instance, instanceString)
	tree:add_le(fields.data_alarmReset_Value, dbuffer(0,4))
end

local function dissector_baseHoldServo(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""

	if instance == 1 then
		instanceString = "HOLD"
	elseif instance == 2 then
		instanceString = "Servo power"
	elseif instance == 3 then
		instanceString = "HLOCK"
	end

	tree:add_le(fields.data_holdservo_Instance, instanceString)
	tree:add_le(fields.data_holdservo_Value, dbuffer(0,4))
end

local function dissector_baseStepCycleAuto(instance,attribute,dbuffer,packetInfo,tree)
	tree:add_le(fields.data_stepCycleAuto_Value, dbuffer(0,4))
end

local function dissector_baseStartJob(instance,attribute,dbuffer,packetInfo,tree)
	tree:add_le(fields.data_startJob_Value, dbuffer(0,4))
end

local function dissector_baseSelectJob(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""
	if instance == 1 then
		instanceString = "Set the executing job"
	else
		instanceString = "Set the master job for task " .. (instance - 10)
	end
	
	tree:add_le(fields.data_selectJob_Instance, instanceString)
	tree:add_le(fields.data_selectJob_Attribute, attribute)

	local byteIndex = 0

	if attribute == 0 or attribute == 1 then 
		tree:add_le(fields.data_selectJob_Name, dbuffer(byteIndex, 32))
		byteIndex = byteIndex + 32
	end

	if attribute == 0 or attribute == 2 then
		tree:add_le(fields.data_selectJob_Line, dbuffer(byteIndex, 4))
		byteIndex = byteIndex + 4
	end
end

local function dissector_baseSystemInfo(instance,attribute,dbuffer,packetInfo,tree)
	local instanceString = ""
	if instance >= 11 and instance <= 18 then
		instanceString = "Type information (R" .. (instance - 10) .. ")"
	else
		instanceString = "Set the master job for task " .. (instance - 10)
	end
	
	tree:add_le(fields.data_systemInfo_Instance, instanceString)
	tree:add_le(fields.data_systemInfo_Attribute, attribute)
end

local function dissector_baseSystemInfoAns(instance,attribute,dbuffer,packetInfo,tree)
	local byteIndex = 0

	if attribute == 1 or attribute == 0 then
		tree:add_le(fields.data_systemInfo_SystemSoftware, dbuffer(byteIndex, 24))
		byteIndex = byteIndex + 24
	end
	
	if attribute == 2 or attribute == 0 then
		tree:add_le(fields.data_systemInfo_ModelApp, dbuffer(byteIndex, 16))
		byteIndex = byteIndex + 16
	end
	
	if attribute == 3 or attribute == 0 then
		tree:add_le(fields.data_systemInfo_Parameter, dbuffer(byteIndex, 8))
		byteIndex = byteIndex + 8
	end
end

-- update hses_dissector
hsesmodule.dissector_baseAlarmData = dissector_baseAlarmData
hsesmodule.dissector_baseAlarmDataAns = dissector_baseAlarmDataAns
hsesmodule.dissector_baseAlarmHistory = dissector_baseAlarmHistory
hsesmodule.dissector_baseAlarmHistoryAns = dissector_baseAlarmHistoryAns
hsesmodule.dissector_baseGetStatus = dissector_baseGetStatus
hsesmodule.dissector_baseGetStatusAns = dissector_baseGetStatusAns
hsesmodule.dissector_baseRunningJobInfo = dissector_baseRunningJobInfo
hsesmodule.dissector_baseRunningJobInfoAns = dissector_baseRunningJobInfoAns
hsesmodule.dissector_baseAxisConfiguration = dissector_baseAxisConfiguration
hsesmodule.dissector_baseAxisConfigurationAns = dissector_baseAxisConfigurationAns
hsesmodule.dissector_baseGetCurrentPosition = dissector_baseGetCurrentPosition
hsesmodule.dissector_baseGetPositionAns = dissector_baseGetPositionAns
hsesmodule.dissector_baseGetCurrentTorque = dissector_baseGetCurrentTorque
hsesmodule.dissector_baseGetCurrentTorqueAns = dissector_baseGetCurrentTorqueAns
hsesmodule.dissector_baseIo = dissector_baseIo
hsesmodule.dissector_baseIoAns = dissector_baseIoAns
hsesmodule.dissector_baseRegister = dissector_baseRegister
hsesmodule.dissector_baseRegisterAns = dissector_baseRegisterAns
hsesmodule.dissector_baseBvariable = dissector_baseBvariable
hsesmodule.dissector_baseBvariableAns = dissector_baseBvariableAns
hsesmodule.dissector_baseIvariable = dissector_baseIvariable
hsesmodule.dissector_baseIvariableAns = dissector_baseIvariableAns
hsesmodule.dissector_baseDvariable = dissector_baseDvariable
hsesmodule.dissector_baseDvariableAns = dissector_baseDvariableAns
hsesmodule.dissector_baseRvariable = dissector_baseRvariable
hsesmodule.dissector_baseRvariableAns = dissector_baseRvariableAns
hsesmodule.dissector_baseSvariable = dissector_baseSvariable
hsesmodule.dissector_baseSvariableAns = dissector_baseSvariableAns
hsesmodule.dissector_basePvariable = dissector_basePvariable
hsesmodule.dissector_baseResetAlarmError = dissector_baseResetAlarmError
hsesmodule.dissector_baseHoldServo = dissector_baseHoldServo
hsesmodule.dissector_baseStepCycleAuto = dissector_baseStepCycleAuto
hsesmodule.dissector_baseStartJob = dissector_baseStartJob
hsesmodule.dissector_baseSelectJob = dissector_baseSelectJob
hsesmodule.dissector_baseSystemInfo = dissector_baseSystemInfo
hsesmodule.dissector_baseSystemInfoAns = dissector_baseSystemInfoAns

hses_dissector = hsesmodule

return hsesmodule.dissector_baseGetStatus
