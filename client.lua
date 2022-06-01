local witnessBlips = {}

RegisterNetEvent("VORP_Law:NotifyLawman")
AddEventHandler("VORP_Law:NotifyLawman", function(coords)
	TriggerEvent("vorp:Tip", 'Someone needs a lawman!', 10000)
	local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 50.0)
	Wait(120000)
	RemoveBlip(blip)
end)

Citizen.CreateThread(function()
    while true do
        Wait(1)
        if IsPedShooting(PlayerPedId()) then
            local _, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
            if inValues({2, 4, 5}, GetPedType(target)) then
				if math.random(1, 100) <= Config.WitnessChance then
					CreateWitness(target)
				end
            end
        end
    end
end)

--[[ DEVS BEWARE, FOR BEYOND HERE THERE BE FUNCTIONS ]]--

function CreateWitness(target)
	local target = target
    local coords = GetEntityCoords(PlayerPedId())
	local witness = GetClosestPed(target, coords)
	if witness ~= nil then
		Debug("witness created")
        local crow = CreateCrow(coords)
		TaskGoToEntity(witness, crow, -1, 1.0, 3.0)
        Wait(5000)
		HandleBlips(witness)
        Wait(30000)
        if IsPedDeadOrDying(witness) then
			Debug("witness killed before 30 seconds")
			DeleteWitness(witness, crow)
        else
			Debug("notifying law")
			DeleteWitness(witness, crow)
            TriggerServerEvent("VORP_Law:CheckJob", GetPlayers(), coords)
        end
	else
		Debug("no peds nearby to witness")
	end
end

function CreateCrow(coords)
	posX = coords.x + math.random(-100, 100)
	posY = coords.y + math.random(-100, 100)
	local crow = RequestModelAndCreatePed(GetHashKey("A_C_Crow_01"), posX, posY, coords.z, 0, true, true)
	return crow
end

function HandleBlips(witness)
	for i = 1, 10 do
		if not IsPedDeadOrDying(witness) then
			Debug("flashing blip")
			witnessBlips[#witnessBlips+1] = Citizen.InvokeNative(0x23f74c2fda6e7c61, 1260140857, witness)
			Wait(3000)
		else
			Debug("no blip, witness ded")
			break
		end
	end
end

function GetClosestPed(target, coords)
	local itemSet = CreateItemset(true)
	local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, 20.0, itemSet, 1, Citizen.ResultAsInteger())
	if size > 0 then
		for index = 0, size - 1 do
			local entity = GetIndexedItemInItemset(index, itemSet)
			if not IsPedAPlayer(entity) then
				if entity ~= target then
					if inValues({4, 5}, GetPedType(entity)) and IsPedOnFoot(entity) then
						return entity
					end
				end
			end
		end
	else
		Debug("itemset native ded")
	end
	if IsItemsetValid(itemSet) then
	   DestroyItemset(itemSet)
	end
end

function DeleteWitness(witness, crow)
	for _, blip in pairs(witnessBlips) do RemoveBlip(blip) end
	SetPedAsNoLongerNeeded(witness)
	DeletePed(crow)
end
