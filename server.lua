


VORP = exports.vorp_core:vorpAPI()





RegisterNetEvent("bst-law:SendNotifications")
AddEventHandler("bst-law:SendNotifications", function(players, coords)
  
  for each, player in ipairs(players) do
    local user = VORP.getCharacter(player)
    if user ~= nil then
      local job = user.job
      if job == Config.LawJob then
        TriggerClientEvent("bst-law:NotifyLaw", player, coords)
      end
      
    else
      print("Notified???")
    end
  end


end)

RegisterNetEvent("bst-law:CheckJob")
AddEventHandler("bst-law:CheckJob", function()
  local _source = source

	TriggerEvent("vorp:getCharacter", _source, function(user)
		local job = user.job
		print('Job: ' .. job)
		if job ~= Config.LawJob then
			TriggerClientEvent("bst-law:TriggerWanted", _source)
      print("WantedTriggered")
      
		end
	end)
end)







