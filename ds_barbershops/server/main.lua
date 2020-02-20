ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('ds_clotheshops:responseSaveSkin')
AddEventHandler('ds_clotheshops:responseSaveSkin', function(skin)

	TriggerEvent('es:getPlayerFromId', source, function(user)
		TriggerEvent('es:canGroupTarget', user.getGroup(), "admin", function(available)
			if available then
				local file = io.open('resources/[esx]/ds_clotheshops/skins.txt', "a")

				file:write(json.encode(skin) .. "\n\n")
				file:flush()
				file:close()
			else
				print(('ds_clotheshops: %s attempted saving skin to file'):format(user.getIdentifier()))
			end
		end)
	end)

end)

ESX.RegisterServerCallback('ds_clotheshops:getPlayerSkin', function(source, cb)
	local xPlayer = ESX.GetPlayerFromId(source)
	
	MySQL.Async.fetchAll('SELECT * FROM users WHERE identifier = @identifier', {
		['@identifier'] = xPlayer.identifier
	}, function(users)
		local user = users[1]
		local skin = nil

		local jobSkin = {
			skin_male   = xPlayer.job.skin_male,
			skin_female = xPlayer.job.skin_female
		}
		
		if user.skin ~= nil then
			skin = json.decode(user.skin)
		end

		cb(skin, jobSkin)
	end)
end)

RegisterServerEvent('ds_clotheshops:buyclothes')
AddEventHandler('ds_clotheshops:buyclothes', function (price)
  local _source = source
  local xPlayer = ESX.GetPlayerFromId(source)

  if xPlayer.get('money') >= price then
    xPlayer.removeMoney(price)
    TriggerClientEvent('ds_clotheshops:openSaveableMenu', source)
  else
    TriggerClientEvent('esx:showNotification', _source, _U('not_enough_money'))
  end
end)
