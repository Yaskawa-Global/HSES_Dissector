--[[

HSES protocol script for Wireshark

--]]

local debug = require("debug")

function script_path()
   local str = debug.getinfo(2, "S").source
   return str
end

local folderOfThisFile = script_path():match("@?(.*[/\\])"):gsub("\\", "/") -- get folder name and replace backslash to slash

dofile( folderOfThisFile.. "wiresharklib/hses_name.lua" )
dofile( folderOfThisFile.. "wiresharklib/hses_header.lua" )
dofile( folderOfThisFile.. "wiresharklib/hses_baseCommands.lua" )

local requestIdToCommandTextTable = {}
local requestIdToCommandNoTable = {}
local requestIdToLastSendTable = {}
local requestIdToInstanceTable = {}
local requestIdToAttributeTable = {}
local flameNoToCommandNoTable = {}
local flameNoToCommandTextTable = {}
local flameNoToResponceTimeTable = {}

-- dessector
hses_proto = Proto("HSES", "YASKAWA High Speed Ethernet Server protocol")

hses_proto.fields = hses_dissector.fields
hses_proto.fields.commandText = ProtoField.string("hses.commandText", "commandText")
hses_proto.fields.header_responceTime = ProtoField.uint16("hses.responseTime",	"Command Response Time (ms)")

hses_proto.experts = hses_dissector.experts


function hses_proto.dissector(buffer,pinfo,tree)
    pinfo.cols.protocol = "HSES"
    local headertree = tree:add(hses_proto,buffer(0,32),"Header ")
    local datatree = tree:add(hses_proto,buffer(32),"Data Division ")
    local commandtext = ""
	local commandNo = 0
	local ackValue = 0
	local requestId = 0
	local responceTime = 0
	local status = 0
    
	-- common
	ackValue = buffer(10,1):le_uint()
	requestId = buffer(11,1):le_uint()

	hses_dissector.dissector_header(buffer,pinfo,headertree)

    if ackValue == 0 then
		-- request	
		local subproc = buffer(29,1):le_uint()
		commandNo = buffer(24,2):le_uint()
    	commandtext = hses_dissector.getCommandName(commandNo, subproc, requestId)

		requestIdToCommandNoTable[requestId] = commandNo
		requestIdToCommandTextTable[requestId] = commandtext
		requestIdToLastSendTable[requestId] = pinfo.rel_ts
		requestIdToInstanceTable[requestId] = buffer(26,2):le_uint()
		requestIdToAttributeTable[requestId] = buffer(28,1):le_uint()

    else
		-- answer
		if pinfo.visited then
			commandNo = flameNoToCommandNoTable[pinfo.number]
			commandtext = flameNoToCommandTextTable[pinfo.number]
			responceTime = flameNoToResponceTimeTable[pinfo.number]
		else
			commandNo = requestIdToCommandNoTable[requestId]
			commandtext = "Re: " .. requestIdToCommandTextTable[requestId]
			flameNoToCommandNoTable[pinfo.number] = commandNo
			flameNoToCommandTextTable[pinfo.number] = commandtext
			responceTime = math.ceil((pinfo.rel_ts - requestIdToLastSendTable[requestId] ) * 1000)
			flameNoToResponceTimeTable[pinfo.number] = responceTime
		end

		if buffer(25,1):le_uint() ~= 0 then
			commandtext = commandtext .. " - ERROR"
		else
			commandtext = commandtext .. " - OK"
		end
		
		commandtext = commandtext .. " [Response Time: " .. responceTime .. " ms]"
	    headertree:add( hses_proto.fields.header_responceTime, responceTime )
	end
		
	pinfo.cols.info:set(commandtext)

	-- other
    -- datatree:add(hses_proto.fields.commandText, commandtext)
	datatree:append_text(" - " .. commandtext)

	local databuffer = buffer(32)
	local serviceCode = 0
    if ackValue == 0 then
		serviceCode = buffer(29,1):le_uint()

		-- request
		if commandNo == 0x0070 then
			hses_dissector.dissector_baseAlarmData(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0071 then
			hses_dissector.dissector_baseAlarmHistory(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0072 then
			hses_dissector.dissector_baseGetStatus(databuffer,pinfo,datatree)
		elseif commandNo == 0x0073 then
			hses_dissector.dissector_baseRunningJobInfo(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0074 then
			hses_dissector.dissector_baseAxisConfiguration(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0075 then
			hses_dissector.dissector_baseGetCurrentPosition(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0077 then
			hses_dissector.dissector_baseGetCurrentTorque(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0078 then
			hses_dissector.dissector_baseIo(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x0079 then
			hses_dissector.dissector_baseRegister(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007A then
			hses_dissector.dissector_baseBvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007B then
			hses_dissector.dissector_baseIvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007C then
			hses_dissector.dissector_baseDvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007D then
			hses_dissector.dissector_baseRvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007E or commandNo == 0x008C then
			hses_dissector.dissector_baseSvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007F then
			hses_dissector.dissector_basePvariable(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x0082 then
			hses_dissector.dissector_baseResetAlarmError(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0083 then
			hses_dissector.dissector_baseHoldServo(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0084 then
			hses_dissector.dissector_baseStepCycleAuto(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0086 then
			hses_dissector.dissector_baseStartJob(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0087 then
			hses_dissector.dissector_baseSelectJob(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0089 then
			hses_dissector.dissector_baseSystemInfo(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		
		else
			return 32;
		end
	else
		serviceCode = buffer(24,1):le_uint() - 0x80
		
		-- answer
		if commandNo == 0x0070 then
			hses_dissector.dissector_baseAlarmDataAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0071 then
			hses_dissector.dissector_baseAlarmHistoryAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0072 then
			hses_dissector.dissector_baseGetStatusAns(databuffer,pinfo,datatree)
		elseif commandNo == 0x0073 then
			hses_dissector.dissector_baseRunningJobInfoAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0074 then
			hses_dissector.dissector_baseAxisConfigurationAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0075 then
			hses_dissector.dissector_baseGetPositionAns((requestIdToInstanceTable[requestId]>=100),requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0077 then
			hses_dissector.dissector_baseGetCurrentTorqueAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		elseif commandNo == 0x0078 then
			hses_dissector.dissector_baseIoAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x0079 then
			hses_dissector.dissector_baseRegisterAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007A then
			hses_dissector.dissector_baseBvariableAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007B then
			hses_dissector.dissector_baseIvariableAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007C then
			hses_dissector.dissector_baseDvariableAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007D then
			hses_dissector.dissector_baseRvariableAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007E or commandNo == 0x008C then
			hses_dissector.dissector_baseSvariableAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree,commandtext,serviceCode)
		elseif commandNo == 0x007F then
			if requestIdToAttributeTable[requestId] == 1 or requestIdToAttributeTable[requestId] == 0 then
				if databuffer(0,4):le_uint() > 0 then
					hses_dissector.dissector_baseGetPositionAns(true,requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
				else
					hses_dissector.dissector_baseGetPositionAns(false,requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
				end
			else
				hses_dissector.dissector_baseGetPositionAns(false,requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
			end
		elseif commandNo == 0x0089 then
			hses_dissector.dissector_baseSystemInfoAns(requestIdToInstanceTable[requestId],requestIdToAttributeTable[requestId],databuffer,pinfo,datatree)
		
		else
			return 32;
		end
	end

end


udp_table = DissectorTable.get("udp.port")
udp_table:add(10040,hses_proto)
udp_table:add(10041,hses_proto)
