ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

--esx_skin---
RegisterServerEvent('esx_skin:save')
AddEventHandler('esx_skin:save', function(skin)
	local xPlayer = ESX.GetPlayerFromId(source)

	MySQL.Async.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
		['@skin'] = json.encode(skin),
		['@identifier'] = xPlayer.identifier
	})
end)

RegisterServerEvent('ds_barbershops:save')
AddEventHandler('ds_barbershops:save', function(eyebrow, eyebrowopacity, beard, beardopacity, beardcolor, beardcolor, hair, hair2,haircolor, haircolor2, makeup, makeupopacity, makeupcolor, makeupcolor2)
	local _source = source
	local xPlayer = ESX.GetPlayerFromId(_source)
	MySQL.Async.fetchAll('SELECT skin FROM users WHERE identifier = @identifier', {
        ['@identifier'] = xPlayer.identifier
    },
    function(result)
    	if result[1] then
    		local skin = json.decode(result[1].skin)
    		skin["hair_1"] = hair
			skin["hair_color_1"] = haircolor
			skin["hair_color_2"] = haircolor2
			skin["eyebrows_1"] = eyebrow
			skin["eyebrows_2"] = eyebrowopacity
			skin["beard_1"] = beard
			skin["beard_2"] = beardopacity
			skin["beard_3"] = beardcolor
			skin["makeup_1"] = makeup
			skin["makeup_2"] = makeupopacity
			skin["makeup_3"] = makeupcolor
			skin["makeup_4"] = makeupcolor2
    		skin = json.encode(skin)
    		MySQL.Sync.execute('UPDATE users SET skin = @skin WHERE identifier = @identifier', {
    			['@skin'] = skin,
	    		['@identifier'] = xPlayer.identifier
	    	})
    	end
    end)
end)
