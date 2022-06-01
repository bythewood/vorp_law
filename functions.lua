--[ VARIOUS GENERIC FUNCTIONS FOR THE TOOLCHEST ]--

function RequestModelAndCreatePed(modelHash, x, y, z, heading, isNetwork, isScriptHostPed)
    RequestModelAndCheck(modelHash)
    local ped = CreatePedAndCheck(modelHash, x, y, z, heading, isNetwork, isScriptHostPed)
    SetModelAsNoLongerNeeded(modelHash)
    return ped
end

function CreatePedAndCheck(modelHash, x, y, z, heading, isNetwork, isScriptHostPed)
    local modelHash = modelHash
    local x = x
    local y = y
    local z = z
    local heading = heading
    local isNetwork = isNetwork
    local isScriptHostPed = isScriptHostPed
    local p7 = true
    local p8 = true
    local ped = CreatePed(modelHash, x, y, z, heading, isNetwork, isScriptHostPed, p7, p8)
    local checkCount = 0
    while not DoesEntityExist(ped) do
        checkCount = checkCount + 1
        Wait(200)
        if checkCount > 25 then -- over 5 seconds, try again
            ped = CreatePed(modelHash, x, y, z, heading, isNetwork, isScriptHostPed, p7, p8)
            checkCount = 0
        end
    end
    Citizen.InvokeNative(0x283978A15512B2FE, ped, true)
    return ped
end

function RequestModelAndCheck(modelHash)
    local modelHash = modelHash
    Citizen.CreateThread(function() RequestModel(modelHash) end)
    Wait(200)
    while not HasModelLoaded(modelHash) do
        Citizen.CreateThread(function() RequestModel(modelHash) end)
        Wait(200)
    end
end

function GetPlayers()
    local players = {}
	local numPlayersOnline = Citizen.InvokeNative(0xA4A79DD2D9600654)
    for i = 0, 9999 do
        if NetworkIsPlayerActive(i) then
            players[#players+1] = GetPlayerServerId(i)
			if #players == numPlayersOnline then break end -- break when all players found, to avoid overworking
        end
    end
    return players
end

function Debug(o)
    local o = o
    if Config.Debug then
        print(Config.DebugTitle .. ": " .. Dump(o))
    end
end

function Dump(o)
    local o = o
    if type(o) == 'table' then
       local s = '{ '
       for k,v in pairs(o) do
          if type(k) ~= 'number' then k = '"'..k..'"' end
          s = s .. '['..k..'] = ' .. dump(v) .. ','
       end
       return s .. '} '
    else
       return tostring(o)
    end
end

function inValues(table, value)
    local table = table
    local value = value
	for _, v in pairs(table) do
		if v == value then return true end
	end
	return false
end