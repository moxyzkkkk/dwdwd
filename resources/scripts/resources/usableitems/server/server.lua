ESX.RegisterUsableItem('medkit', function(source)
	TriggerClientEvent('usable:item', source, 'medkit')
end)

ESX.RegisterUsableItem('armour', function(source)
	TriggerClientEvent('usable:item', source, 'armour')
end)

ESX.RegisterUsableItem('repairkit', function(source)
	TriggerClientEvent('usable:item', source, 'repairkit')
end)

ESX.RegisterUsableItem('clip', function(source)
	TriggerClientEvent('usable:item', source, 'clip')
	ESX.GetPlayerFromId(source).removeInventoryItem('clip', 1)
end)

ESX.RegisterUsableItem('tunerchip', function(source)
	TriggerClientEvent('usable:item', source, 'tunerchip')
end)

ESX.RegisterUsableItem('suppressor', function(source)
	TriggerClientEvent('usable:item', source, 'suppressor')
end)

RegisterNetEvent('usable:remove')
AddEventHandler('usable:remove', function(item)
	local xPlayer = ESX.GetPlayerFromId(source)
    xPlayer.removeInventoryItem(item, 1)
end)