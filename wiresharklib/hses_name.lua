--[[
	hses command name table
]]--

local hsesmodule = hses_dissector or {}
if hsesmodule.getCommandName ~= nil then
	return hsesmodule.getCommandName
end


local nametable = {}
nametable[0x0070] = "Active Alarm Data"
nametable[0x0071] = "Alarm History"
nametable[0x0072] = "Get Status"
nametable[0x0073] = "Running Job Info"
nametable[0x0074] = "Axis Configuration"
nametable[0x0075] = "Get Current Position"
nametable[0x0076] = "Position Error Amount"
nametable[0x0077] = "Get Current Torque"
nametable[0x0078] = "I/O"
nametable[0x0079] = "M Register"
nametable[0x007A] = "Byte (B) Variable"
nametable[0x007B] = "Integer (I) Variable"
nametable[0x007C] = "Double (D) Variable"
nametable[0x007D] = "Real (R) Variable"
nametable[0x007E] = "16-byte String (S) Variable"
nametable[0x007F] = "Position (P) Variable"
nametable[0x0080] = "Base Position (BP) Variable"
nametable[0x0081] = "Ext Axis Position (EX) Variable"
nametable[0x0082] = "Alarm/Error Reset"
nametable[0x0083] = "HOLD or Servo Power"
nametable[0x0084] = "Step / Cycle / Auto Command"
nametable[0x0085] = "Display pendant message"
nametable[0x0086] = "Start Job"
nametable[0x0087] = "Select Job"
nametable[0x0088] = "Management Time Info"
nametable[0x0089] = "System Info"
nametable[0x008A] = "Cartesian MOV"
nametable[0x008B] = "Pulse MOV"
nametable[0x008C] = "32-byte String (S) Variable"


--[[
	to add new command from MotocomES, replace text by
		search:   ^.*= *(.*);.*/\* *(.*) *\*.*
		replace:  nametable[$1] = "$2"
]]--

local function getCommandName( commandNo, serviceCode, requestID )
	
	local prefix = " [ID: " .. requestID .. "]"
	
	local str = ""
	
	if nametable[commandNo] ~= nil then
		str = nametable[commandNo]
	else
		str = "Unknown"
	end

	local proctext = ""
	if serviceCode == 1 then
		proctext = " (Get All Attr)"
	elseif serviceCode == 2 then
		proctext = " (Set All Attr)"
	elseif serviceCode == 0x0E then
		proctext = " (Get Single Attr)"
	elseif serviceCode == 0x10 then
		proctext = " (Set Single Attr)"
	else
		proctext = ""
	end
	
	return str .. proctext .. prefix
end


-- update hses_dissector
hsesmodule.getCommandName = getCommandName

hses_dissector = hsesmodule

return hsesmodule.getCommandName
