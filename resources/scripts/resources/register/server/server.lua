RegisterNetEvent('register:setIdentity', function(data, player)   
	local identifier = Zen.Functions.GetIdentifier(source, 'license')
	
    MySQL.update.await('UPDATE `users` SET `firstname` = ?, `lastname` = ?, `dateofbirth` = ?, `sex` = ?, `height` = ? WHERE identifier = ?', { 
        data[1], data[2], data[3], data[5], data[4], identifier 
    })

    TriggerEvent('register:update', source, data)
end)

RegisterNetEvent('register:update', function(playerId, data)
	local xPlayer = ESX.GetPlayerFromId(playerId)

	if xPlayer then
		xPlayer.setName(('%s %s'):format(data[1], data[2]))
		xPlayer.set('firstName', data[1])
		xPlayer.set('lastName', data[2])
		xPlayer.set('dateofbirth', data[3])
		xPlayer.set('sex', data[5])
		xPlayer.set('height', data[4])
	end
end)

RegisterCommand("register", function(source, args, rawCommand)
	TriggerClientEvent('register:open', source, true)
end)