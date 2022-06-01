RegisterNetEvent("VORP_Law:CheckJob")
AddEventHandler("VORP_Law:CheckJob", function(players, coords)
    for each, player in ipairs(players) do
        TriggerEvent("vorp:getCharacter", player, function(user)
            if user ~= nil then
				if user.job == 'police' then
					TriggerClientEvent("VORP_Law:NotifyLaw", player, coords)
				end
            end
        end)
    end
end)