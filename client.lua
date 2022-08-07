local createdped = {}
local count = {}
local witnessBlips = {}
local town = nil
local coords = nil
local spawnPolice = false

-- Enter town notifications.
Citizen.CreateThread(
    function()
        local HasAlreadyEnteredMarker = false

        while true do
            Citizen.Wait(1000)

            local IsInMarker = false
            local x, y, z = table.unpack(GetEntityCoords(PlayerPedId()))
            local ZoneTypeId = 1
            local current_district = Citizen.InvokeNative(0x43AD8FC02B429D33, x, y, z, ZoneTypeId)

            if current_district then
                IsInMarker = true

                if current_district == 459833523 then
                    town = "Valentine"
                elseif current_district == 1053078005 then
                    town = "Blackwater"
                elseif current_district == 427683330 then
                    town = "Strawberry"
                elseif current_district == -765540529 then
                    town = "Saint Denis"
                elseif current_district == 7359335 then
                    town = "Annesburg"
                elseif current_district == -744494798 then
                    town = "Armadillo"
                elseif current_district == 2046780049 then
                    town = "Rhodes"
                elseif current_district == 2126321341 then
                    town = "Vanhorn"
                elseif current_district == -1524959147 then
                    town = "Tumbleweed"
                end
            end

            if IsInMarker and not HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = true
            end

            if not current_district and HasAlreadyEnteredMarker then
                HasAlreadyEnteredMarker = false
            end
        end
    end
)
---Witness Creation-
function CreateWitness(target)
    local target = target
    local coords = GetEntityCoords(PlayerPedId())
    local witness = GetClosestPed(target, coords)
    local playerPed = PlayerPedId()
    if witness ~= nil and spawnPolice == false then
        print("witness created")
        Citizen.InvokeNative(0x22B0D0E37CCB840D, witness, playerPed, 15, -1, 0, 3, 0)
        Citizen.InvokeNative(0x59B57C4B06531E1E, false)
        Wait(5000)
        HandleBlips(witness)
        Wait(6000)
        if IsPedDeadOrDying(witness) then
            TriggerEvent("vorp:Tip", "~t2~ Witness Was Killed!", 4000)
        else
            TriggerServerEvent("bst-law:CheckJob")
            print("checked job")
            TriggerServerEvent("bst-law:SendNotifications", GetPlayers(), coords)
            print("notified")
            spawnPolice = true

           
        end
    else
        TriggerEvent("vorp:Tip", "~t6~ No NPC Nearby To Witness!", 4000)
    end
end

---- Are you Shooting or in Melee---
Citizen.CreateThread(
    function()
        while true do
            
            local isshooting = IsPedShooting(PlayerPedId())
            local retrval, target = GetEntityPlayerIsFreeAimingAt(PlayerId())
            
            Wait(1)
            if isshooting and town and spawnPolice == false then
                if GetPedType(target) == 4 or GetPedType(target) == 5 or GetPedType(target) == 2 and town then
                    
                    
                    if inValues({2, 4, 5}, GetPedType(target)) then
                TriggerEvent(
                    "vorp:ShowAdvancedRightNotification",
                    "Possible Gun Crime Committed",
                    "toast_awards_set_h",
                    "awards_set_h_006",
                    "COLOR_RED",
                    3000
                )
                coords = GetEntityCoords(PlayerPedId())
                Citizen.InvokeNative(0x59B57C4B06531E1E, false)
                CreateWitness(target)
            end
        end
    end
        end
    end
)



Citizen.CreateThread(
    function()
        while true do
            local ispedmeleecombat = IsPedInMeleeCombat(PlayerPedId())
           
            local retrval, target = GetPlayerTargetEntity(PlayerId())
            
            Wait(1)
            if ispedmeleecombat and town and spawnPolice == false then
                if GetPedType(target) == 4 or GetPedType(target) == 5 or GetPedType(target) == 2 and town then
                    
                    
                    if inValues({2, 4, 5}, GetPedType(target)) then
                        
                TriggerEvent(
                    "vorp:ShowAdvancedRightNotification",
                    "Possible Assault Committed",
                    "toast_awards_set_h",
                    "awards_set_h_006",
                    "COLOR_RED",
                    3000
                )
                coords = GetEntityCoords(PlayerPedId())
                Citizen.InvokeNative(0x59B57C4B06531E1E, false)
                CreateWitness(target)
            
                end
            end
        end
    end
end
           
           
    
)


                
function inValues(table, value)
    local table = table
    local value = value
	for _, v in pairs(table) do
		if v == value then return true end
	end
	return false
end      
    
--- finding closest ped to shooting or melee----
function GetClosestPed(target, coords)
    local itemSet = CreateItemset(true)
   
    local size = Citizen.InvokeNative(0x59B57C4B06531E1E, coords, 50.0, itemSet, 1, Citizen.ResultAsInteger())
    
    if size > 0 then
        for index = 0, size - 1 do
            local entity = GetIndexedItemInItemset(index, itemSet)
            if not IsPedAPlayer(entity) and not IsEntityDead(entity) then
                if entity ~= target then
                    if GetPedType(entity) == 4 or GetPedType(entity) == 5 and IsPedOnFoot(entity) then
                       

                        return entity
                    end
                end
            end
        end
    else
        print("Script Is Broken Restart")
    end
    if IsItemsetValid(itemSet) then
        DestroyItemset(itemSet)
    end
end

------ Player Wanted Towns ------
function Wanted(town)
    if town == "Valentine" then
        hash = GetHashKey("S_M_M_VALDEPUTY_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Valentine Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Blackwater" then
        hash = GetHashKey("s_m_m_ambientblwpolice_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Blackwater Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        PlaySoundFrontend("POLICE_WHISTLE_MULTI", "MOB2_SOUNDSET", true, 1)
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Strawberry" then
        hash = GetHashKey("A_M_M_STRDEPUTYRESIDENT_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Strawberry Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Saint Denis" then
        hash = GetHashKey("s_m_m_ambientsdpolice_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Saint Denis Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
        PlaySoundFrontend("POLICE_WHISTLE_MULTI", "MOB2_SOUNDSET", true, 1)
    elseif town == "Annesburg" then
        hash = GetHashKey("A_M_M_ASBDEPUTYRESIDENT_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Annesburg Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Armadillo" then
        hash = GetHashKey("A_M_M_ARMDEPUTYRESIDENT_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Armadillo Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Rhodes" then
        hash = GetHashKey("A_M_M_RHDDEPUTYRESIDENT_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Rhodes Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Vanhorn" then
        hash = GetHashKey("A_M_M_VALDEPUTYRESIDENT_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Vanhorn Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    elseif town == "Tumbleweed" then
        hash = GetHashKey("S_M_M_TumDeputies_01")
        TriggerEvent(
            "vorp:NotifyLeft",
            "WANTED!",
            "You are wanted by Tumbleweed Police!",
            "pm_awards_mp",
            "awards_set_e_004",
            4000,
            "COLOR_WHITE"
        )
        Wait(3000)
        TriggerEvent("vorp:ShowTopNotification", "~e~You're Wanted!", "Your Crimes ~e~ Have been Reported!", 4000)
    end

    RequestModel(hash)
    if not HasModelLoaded(hash) then
        RequestModel(hash)
    end
    while not HasModelLoaded(hash) do
        Citizen.Wait(1)
    end

    local x, y, z = coords.x, coords.y, coords.z

    if
        town == "Valentine" or "Blackwater" or "Strawberry" or "Saint Denis" or "Annesburg" or "Armadillo" or "Rhodes" or
            "Vanhorn" or
            "Tumbleweed"
     then
        random_cops = math.random(1, 3)
        if random_cops == 1 then
            lawmen = {
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true}
            }
        elseif random_cops == 2 then
            lawmen = {
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true}
            }
        elseif random_cops == 3 then
            lawmen = {
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true},
                {hash = hash, x, y, z, true, true, true, true}
            }
        end
    end

    for k, item in pairs(lawmen) do
        local coords = GetEntityCoords(PlayerPedId())
        local randomAngle = math.rad(math.random(0, 360))
        local x = coords.x + math.sin(randomAngle) * math.random(1, 100) * 2.0
        local y = coords.y + math.cos(randomAngle) * math.random(1, 100) * 2.0 -- 20.0 is the radius i set
        local z = coords.z
        local b, rdcoords, rdcoords2 = GetClosestVehicleNode(coords.x, coords.y, coords.z, 1, 10.0, 10.0)
        if (rdcoords.x == 0.0 and rdcoords.y == 0.0 and rdcoords.z == 0.0) then
            local valid, outPosition = GetSafeCoordForPed(x, y, z, false, 8)
            if valid then
                x = outPosition.x
                y = outPosition.y
                z = outPosition.z
            end
        else
            --local inwater = Citizen.InvokeNative(0x43C851690662113D, createdped[k], 100)
            --if inwater then
            -- DeleteEntity(createdped[k])
            --end
            local valid, outPosition = GetSafeCoordForPed(x, y, z, false, 16)
            if valid then
                x = outPosition.x
                y = outPosition.y
                z = outPosition.z
            end

            local foundground, groundZ, normal = GetGroundZAndNormalFor_3dCoord(x, y, z)
            if foundground then
                z = groundZ
            else
               
                DeleteEntity(k)
            end
        end
        createdped[k] = CreatePed(item.hash, x, y, z, true, true, false, false)
        blip = Citizen.InvokeNative(0x23f74c2fda6e7c61, -118010418, createdped[k])
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, "LawMan")
        TaskGoToCoordAnyMeans(createdped[k], coords.x, coords.y, coords.z, 10, PlayerPedId(), true, 0, 0)
       
        Citizen.InvokeNative(0x59B57C4B06531E1E, false)
        Citizen.InvokeNative(0x8DE82BC774F3B862, true)
        SetPedSeeingRange(createdped[k], 70.0)
        SetPedHearingRange(createdped[k], 80.0)
        SetPedCombatAttributes(createdped[k], 46, 1)
        SetPedCombatAttributes(createdped[k], 125, 1)
        SetPedFleeAttributes(createdped[k], 0, 0)
        SetPedCombatRange(createdped[k], 1)
        SetPedRelationshipGroupHash(createdped[k], GetHashKey(0x06C3F072))
        SetRelationshipBetweenGroups(5, GetHashKey("PLAYER"), GetHashKey("0x06C3F072"))
        SetRelationshipBetweenGroups(5, GetHashKey("0x06C3F072"), GetHashKey("PLAYER"))
        TaskCombatPed(createdped[k], PlayerPedId())
        SetPedCombatAbility(createdped[k], 2)
        Citizen.InvokeNative(0x2D64376CF437363E, createdped[k], true) --CanPedBeMounted
        Citizen.InvokeNative(0x43C851690662113D, createdped[k], 1)
        Citizen.InvokeNative(0x283978A15512B2FE, createdped[k], true) --SetRandomOutfitVariation
        Citizen.InvokeNative(0xBD75500141E4725C, createdped[k], 'LAW') --SetPedCombatAttributeHash
        Citizen.InvokeNative(0xF166E48407BAC484, createdped[k], PlayerPedId(), 0, 16) --TaskCombatPed
        SetPedCombatMovement(createdped[k], 2)
        Citizen.InvokeNative(0x9587913B9E772D29, createdped[k], true) --place entity on ground
        

        --- Out of Area or Are Lawmen Dead? ---
        Citizen.CreateThread(
            function()
                while next(createdped) ~= nil do
                   
                    Citizen.Wait(1000)
                    local playercoords = GetEntityCoords(PlayerPedId())
                    local distance = GetDistanceBetweenCoords(playercoords, coords.x, coords.y, coords.z, true)
                    if distance > 250 and spawnPolice == true then
                        Wait(500)                       
                        DeleteEntity(v)                       
                        CleanUpAndReset(true)
                    end
                    for k, v in pairs(createdped) do
                        local playerPed = PlayerPedId()
                         local PlayerHealth = GetEntityHealth(playerPed)
                        if IsEntityDead(v) then                           
                            createdped[k] = nil
                            SetEntityAsMissionEntity(v, false, false)
                            SetEntityAsNoLongerNeeded(v)
                        else
                            if PlayerHealth == 0 then
                                spawnPolice = false
                                SetEntityAsMissionEntity(v, false, false)
                                SetEntityAsNoLongerNeeded(v)
                                CleanUpAndReset(true)
                                TriggerEvent(
                    "vorp:ShowTopNotification",
                    "~e~You Have Died!",
                    "You're No Longer Wanted!",
                    4500
                )
                            end
                        end
                    end
                end
                
                Wait(1000)
                SetEntityAsMissionEntity(v, false, false)
                SetEntityAsNoLongerNeeded(v)
                local playerPed = PlayerPedId()
                local PlayerHealth = GetEntityHealth(playerPed)
                if PlayerHealth > 0 then
                TriggerEvent(
                    "vorp:ShowTopNotification",
                    "~e~You Have Escaped The law!",
                    "You're No Longer Wanted!",
                    4500
                )
                RemoveBlip(blip2)
                spawnPolice = false
                CleanUpAndReset(true)
                end
            end
        )
    end
end
--- RED AREA BLIP WHEN WANTED ---
function wantedblip()
    blip2 = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 250.0, "COLOR_RED")
    Citizen.InvokeNative(0x9CB1A1623062F402, blip2, "Wanted Area")
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip2, 0x76674069)
    Citizen.InvokeNative(0x662D364ABF16DE2F, blip2, 0x3F90ADF0)
    Wait(1000)
    TriggerEvent("vorp:TipBottom", "Kill All The Police or Flee Wanted Area", 15000)
end

--- Cleaning Up Left Over Lawmen ---

function CleanUpAndReset(Deletenpc)
           
    for _, ped in ipairs(createdped) do
		--if DoesEntityExist(ped) or not DoesEntityExist(ped) then            
            if Deletenpc then
                RemoveBlip(blip)
                RemoveBlip(blip2)
                spawnPolice = false
            end
                SetEntityAsMissionEntity(ped, false, false)
			    SetEntityAsNoLongerNeeded(ped)
            
        --end
    end

    createdped = {}
end

-- Trigger Wanted ---
RegisterNetEvent("bst-law:TriggerWanted")
AddEventHandler(
    "bst-law:TriggerWanted",
    function()
        if spawnPolice == true then
            Wanted(town)
            wantedblip()
            
            print("triggered")
        end
    end
)

-- Notification + blip Map for Players Police
RegisterNetEvent("bst-law:NotifyLaw")
AddEventHandler(
    "bst-law:NotifyLaw",
    function(coords)
        TriggerEvent(
            "vorp:NotifyLeft",
            "An Outlaw Was Seen",
            "",
            "menu_textures",
            "menu_icon_spectate",
            4000,
            "COLOR_RED"
        )
        local blip = Citizen.InvokeNative(0x45f13b7e0a15c880, -1282792512, coords.x, coords.y, coords.z, 50.0)
        Citizen.InvokeNative(0x9CB1A1623062F402, blip, "Possible Crime Committed")
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, 0x76674069)
        Citizen.InvokeNative(0x662D364ABF16DE2F, blip, 0x3F90ADF0)
        Wait(10000)
        RemoveBlip(blip)
    end
)

-- Get Players from server
function GetPlayers()
    local players = {}
    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, GetPlayerServerId(i))
        end
    end
    return players
end

--- Handles Witness Blip ---
function HandleBlips(witness)
    for i = 1, 1 do
        if not IsPedDeadOrDying(witness) then
            TriggerEvent(
                "vorp:NotifyLeft",
                "A Witness Has Seen Your Crime",
                "",
                "menu_textures",
                "menu_icon_spectate",
                4000,
                "COLOR_RED"
            )
            Wait(1000)
            local blip3 = Citizen.InvokeNative(0x23f74c2fda6e7c61, -1049390151, witness)
            Wait(6000)
            RemoveBlip(blip3)
        else
            print("no blip, witness dead")
        end
    end
end
--- command incase Red Blip Bugs ---
RegisterCommand(
    "dblip",
    function(source, args, rawCommand) --  COMMAND IN CASE WANTED BLIP GETS STUCK
        RemoveBlip(blip2)
    end
)
