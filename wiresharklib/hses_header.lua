--[[
	hses dissector for header
]]--

local hsesmodule = hses_dissector or {}
if hsesmodule.dissector_header ~= nil then
	return hsesmodule.dissector_header
end

local extendedErrorCodeStrings = 
{
	[0x1010] = "Command error",
	[0x1011] = "Error in number of command operands",
	[0x1012] = "Command operand value range over",
	[0x1013] = "Command operand length error",
	[0x1020] = "Disk full of files",
	[0x2010] = "Manipulator operating",
	[0x2020] = "Hold by programming pendant",
	[0x2030] = "Hold by playback panel",
	[0x2040] = "External hold",
	[0x2050] = "Command hold",
	[0x2060] = "Error/alarm occurring",
	[0x2070] = "Servo OFF",
	[0x2080] = "Incorrect mode",
	[0x2090] = "File accessing by other function",
	[0x2100] = "Command remote not set",
	[0x2110] = "This data cannot be accessed",
	[0x2120] = "This data cannot be loaded",
	[0x2130] = "Editing",
	[0x2150] = "Running the coordinate conversion function",
	[0x3010] = "Turn ON the servo power",
	[0x3040] = "Perform home positioning",
	[0x3050] = "Confirm positions",
	[0x3070] = "Current value not made",
	[0x3220] = "Panel lock; mode/cycle prohibit signal is ON",
	[0x3230] = "Panel lock; start prohibit signal is ON",
	[0x3350] = "User coordinate is not taught",
	[0x3360] = "User coordinate is destroyed",
	[0x3370] = "Incorrect control group",
	[0x3380] = "Incorrect base axis data",
	[0x3390] = "Relative job conversion prohibited (at CVTRJ)",
	[0x3400] = "Master job call prohibited (parameter)",
	[0x3410] = "Master job call prohibited(lamp ON during operation)",
	[0x3420] = "Master job call prohibited (teach lock)",
	[0x3430] = "Robot calibration data not defined",
	[0x3450] = "Servo power cannot be turned ON",
	[0x3460] = "Coordinate system cannot be set",
	[0x4010] = "Insufficient memory capacity (job registered memory)",
	[0x4012] = "Insufficient memory capacity (position data registered memory)",
	[0x4020] = "Job editing prohibited",
	[0x4030] = "Same job name exists",
	[0x4040] = "No specified job",
	[0x4060] = "Set an execution job",
	[0x4120] = "Position data is destroyed",
	[0x4130] = "Position data not exist",
	[0x4140] = "Incorrect position variable type",
	[0x4150] = "END instruction for job which is not master job",
	[0x4170] = "Instruction data is destroyed",
	[0x4190] = "Invalid character in job name",
	[0x4200] = "Invalid character in the label name",
	[0x4230] = "Invalid instruction in this system",
	[0x4420] = "No step in job to be converted",
	[0x4430] = "Already converted",
	[0x4480] = "Teach user coordinate",
	[0x4490] = "Relative job/ independent control function not permitted",
	[0x5110] = "Syntax error (syntax of instruction)",
	[0x5120] = "Position data error",
	[0x5130] = "No NOP or END",
	[0x5170] = "Format error (incorrect format)",
	[0x5180] = "Incorrect number of data",
	[0x5200] = "Data range over",
	[0x5310] = "Syntax error (except instruction)",
	[0x5340] = "Error in pseudo instruction specification",
	[0x5370] = "Error in condition file data record",
	[0x5390] = "Error in JOB data record",
	[0x5430] = "System data not same",
	[0x5480] = "Incorrect welding function type",
	[0x6010] = "The robot/station is under the operation",
	[0x6020] = "Not enough memory of the specified device",
	[0x6030] = "Cannot be accessed to the specified device",
	[0x6040] = "Unexpected auto backup request",
	[0x6050] = "CMOS size is over the RAM area",
	[0x6060] = "No memory allocation at the power supply on",
	[0x6070] = "Accessing error to backup file information",
	[0x6080] = "Failed in sorting backup file (Remove)",
	[0x6090] = "Failed in sorting backup file (Rename)",
	[0x6100] = "Drive name exceeds the specified values",
	[0x6110] = "Incorrect device",
	[0x6120] = "System error",
	[0x6130] = "Auto backup is not available",
	[0x6140] = "Cannot be backed up under the auto backup",
	[0xA000] = "Undefined command",
	[0xA001] = "Instance error",
	[0xA002] = "Attribute error",
	[0xA100] = "Replying data part size error (hardware limit)",
	[0xA101] = "Replying data part size error (software limit)",
	[0xB001] = "Undefined position variable",
	[0xB002] = "Data use prohibited",
	[0xB003] = "Requiring data size error",
	[0xB004] = "Out of range the data",
	[0xB005] = "Data undefined",
	[0xB006] = "Specified application unregistered",
	[0xB007] = "Specified type unregistered",
	[0xB008] = "Control group setting error",
	[0xB009] = "Speed setting error",
	[0xB00A] = "Operating speed is not setting",
	[0xB00B] = "Operation coordinate system setting error",
	[0xB00C] = "Type setting error",
	[0xB00D] = "Tool No. setting error",
	[0xB00E] = "User No. setting error",
	[0xC001] = "System error (data area setting processing error)",
	[0xC002] = "System error (over the replying data area)",
	[0xC003] = "System error (size of the data element not same)",
	[0xC800] = "System error (customize API processing error)",
	[0xCFFF] = "Other error",
	[0xD8FA] = "Transmission exclusive error (BUSY or Semaphore error)",
	[0xD8F1] = "Processing the another command (BUSY condition)",
	[0xE24F] = "Wrong parameter setting for the system backup",
	[0xE250] = "System backup file creating error (confirm if the mode is the remote mode)",
	[0xE289] = "System error",
	[0xE28A] = "System error",
	[0xE28B] = "Disconnect the communication due to receive timeout",
	[0xE28C] = "Cannot over write the target file",
	[0xE29C] = "The requested file does not exist or the file size is 0.",
	[0xE29D] = "System error",
	[0xE29E] = "System error",
	[0xE29F] = "System error",
	[0xE2A0] = "The wrong required pass",
	[0xE2A7] = "The relevant file is not in the requested file list.",
	[0xE2AA] = "System error",
	[0xE2AF] = "Receive the deletion request of the file that cannot to delete",
	[0xE2B0] = "System error",
	[0xE2B1] = "The directory cannot to be deleted",
	[0xE2B2] = "Receive the request of the sending/receiving file at the remote OFF state.",
	[0xE2B3] = "File not found",
	[0xE2B4] = "The requested pass is too long",
	[0xE444] = "Processing the another command (BUSY condition)",
	[0xE49D] = "Format error (data size 0)",
	[0xE49E] = "Format error (frame size over)",
	[0xE49F] = "Format error (frame size 0)",
	[0xE4A1] = "Format error (block number error)",
	[0xE4A2] = "Format error (ACK error)",
	[0xE4A3] = "Format error (processing category error)",
	[0xE4A4] = "Format error (access level error)",
	[0xE4A5] = "Format error (header size error)",
	[0xE4A6] = "Format error (identifier error)",
	[0xE4A7] = "Format error (the size of the requested command and received frame are different)",
	[0xE4A8] = "System error",
	[0xE4A9] = "System error",
	[0xFFF0] = "System error",
	[0xFFF2] = "System error",
	[0xFFF3] = "System error",
	[0xFFF4] = "System error",
	[0xFFF5] = "System error",
	[0xFFF6] = "Too many request and unable to process (BUSY condition)",
	[0xFFF7] = "System error",
	[0xFFF8] = "System error",
	[0xFFFE] = "The remote mode is detected, and disconnect the communication"
}

local procValueStrings = {
	[1] = "Robot Control",
	[2] = "File Control",
	}

local ackValueStrings = {
	[0] = "Request",
	[1] = "Reply or Continuation",
	}

-- fields define
local fields = hsesmodule.fields or {}

fields.header_tag  = ProtoField.string("hses.headerTag", 	"Identifier")
fields.header_size = ProtoField.uint16("hses.headerSize", 	"Header Size", base.DEC)
fields.header_dataSize   = ProtoField.uint16("hses.dataSize", 	"Data Size", base.DEC)
fields.header_proc = ProtoField.uint8 ("hses.headerproc", 	"Processing", base.DEC, procValueStrings)
fields.header_ack = ProtoField.uint8 ("hses.ack",	 		"Ack", base.DEC, ackValueStrings)
fields.header_requestId = ProtoField.uint8 ("hses.requestId", 	"Request ID", base.HEX)
fields.header_blockNo = ProtoField.uint32("hses.blockNo",	 	"Block No", base.HEX)
-- request
fields.header_command = ProtoField.uint16 ("hses.command", 		"Command", base.HEX)
fields.header_instance =  ProtoField.uint16("hses.instance",	"Instance", base.HEX)
fields.header_attribute = ProtoField.uint8 ("hses.attribute",	 	"Attribute", base.HEX)
fields.header_serviceCode = ProtoField.uint8 ("hses.serviceCode",		"Service Code", base.HEX)
-- answer
fields.header_ansServiceCode = ProtoField.uint8 ("hses.replyServiceCode",		"Service Code", base.HEX)
fields.header_ansStatus = ProtoField.uint8 ("hses.replyStatus",	"Status", base.HEX)
fields.header_ansExSize  = ProtoField.uint8 ("hses.replyExStatusSize",	"Ex Status Size", base.HEX)
fields.header_ansExstatus  = ProtoField.uint16("hses.replyExStatusCode",	"Ex Status Code", base.DEC, extendedErrorCodeStrings)

hsesmodule.fields = fields


-- experts
local experts = hsesmodule.experts or {}

experts.header_ansError = ProtoExpert.new("hses.ansError.expert","Response Error", expert.group.RESPONSE_CODE , expert.severity.ERROR)
hsesmodule.experts = experts

local function dissector_header(buffer,pinfo,headertree)
    local commandtext = ""
	local commandNo = 0
	local requestId = 0
	local responceTime = 0
	local ackValue = 0
	
    headertree:add( fields.header_tag, buffer(0,4))
    headertree:add_le( fields.header_size,buffer(4,2))
    headertree:add_le( fields.header_dataSize,buffer(6,2))
    headertree:add_le( fields.header_proc,buffer(9,1))
	ackValue = buffer(10,1):le_uint()
    headertree:add_le( fields.header_ack,buffer(10,1))
	requestId = buffer(11,1):le_uint()
    headertree:add_le( fields.header_requestId, buffer(11,1) )
    headertree:add_le( fields.header_blockNo, buffer(12,4))

    if ackValue == 0 then
		-- request	
		local serviceCode = buffer(29,1):le_uint()
		
		commandNo = buffer(24,2):le_uint()
    	commandtext = hsesmodule.getCommandName(commandNo , serviceCode, requestId)
    	headertree:append_text("Request")

	    headertree:add_le(fields.header_command, buffer(24,2)):append_text(" " .. commandtext)
	    headertree:add_le(fields.header_instance, buffer(26,2))
	    headertree:add_le(fields.header_attribute ,buffer(28,1))
	    headertree:add_le(fields.header_serviceCode, buffer(29,1))--:append_text(" " .. proctext)
		

    else
		-- answer
	    headertree:add_le( fields.header_ansServiceCode,buffer(24,1))
		
	    local status = headertree:add_le( fields.header_ansStatus,buffer(25,1))
	    headertree:add_le( fields.header_ansExSize,buffer(26,1))
		local ansExstatusValue = buffer(28,2):le_int()
	    headertree:add_le( fields.header_ansExstatus,buffer(28,2)):append_text(" (0x" .. string.format("%x",math.abs(ansExstatusValue)) .. ")" )
	    
	    if buffer(25,1):le_uint() ~= 0 then
	    	headertree:append_text(" failed " )
			status:add_proto_expert_info( experts.header_ansError )
	    end

	end

end

-- update hses_dissector
hsesmodule.dissector_header = dissector_header

hses_dissector = hsesmodule

return hsesmodule.dissector_header