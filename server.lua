


VORP = exports.vorp_core:vorpAPI()





RegisterNetEvent("VORP_Law:SendNotifications")
AddEventHandler("VORP_Law:SendNotifications", function(players, coords)
  
  for each, player in ipairs(players) do
    local user = VORP.getCharacter(player)
    if user ~= nil then
      local job = user.job
      if job == Config.LawJob then
        TriggerClientEvent("VORP_Law:NotifyLaw", player, coords)
      end
      
    else
      Debug("Notified???")
    end
  end


end)

RegisterNetEvent("VORP_Law:CheckJob")
AddEventHandler("VORP_Law:CheckJob", function()
  local _source = source

	TriggerEvent("vorp:getCharacter", _source, function(user)
		local job = user.job
		print('Job: ' .. job)
		if job ~= Config.LawJob then
			TriggerClientEvent("VORP_Law:TriggerWanted", _source)
      Debug("WantedTriggered")
      
		end
	end)
end)







