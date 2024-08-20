lib.callback.register('police:interaction:vehicles', function(source, plate)
	local vehicles = GetAllVehicles()

    for i = 1, #vehicles do
        local vehicle = vehicles[i]
		
        if DoesEntityExist(vehicle) and GetVehicleNumberPlateText(vehicle):gsub("%s+", "") == plate:gsub("%s+", "") then
            return true, GetEntityModel(vehicle), (Entity(vehicle).state.ownerId or 'Not Found')
        end
    end

    return false
end)

RegisterNetEvent('police:interaction:citizen:search:confiscate', function(target, type, name, amount)
	local plyState = Player(source).state

	if plyState.job.name ~= 'police' then 
		return Zen.Functions.AntiEvent('^4[POLICE]', source, 'police:interaction:citizen:search:confiscate')
	end
	
	local police = ESX.GetPlayerFromId(source)
	local player = ESX.GetPlayerFromId(target)

	if type == 'item' then
		TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
			inventory.addItem(name, amount)
			player.removeInventoryItem(name, amount)
		end)

		Zen.Functions.LogToDiscord(Zen.Webhooks['police'], 'Confiscated Item', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Item:** '..Zen.Items[name].label..'\n**Amount:** '..amount)
		Zen.Functions.Notify(source, 'You confiscated '..amount..' '..Zen.Items[name].label..' from '..player.name, 'user-shield', '#1f6ecf')
		Zen.Functions.Notify(target, 'Your '..amount..' '..Zen.Items[name].label..' was confiscated by '..police.name, 'user-shield', '#1f6ecf')

	elseif type == 'account' then
		player.removeAccountMoney(name, amount)
		
		Zen.Functions.LogToDiscord(Zen.Webhooks['police'], 'Confiscated Account Money', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Account:** '..Zen.Accounts[name]..'\n**Amount:** $'..amount)
		Zen.Functions.Notify(source, 'You confiscated '..amount..' '..Zen.Accounts[name]..' from '..player.name, 'user-shield', '#1f6ecf')
		Zen.Functions.Notify(target, 'Your '..amount..' '..Zen.Accounts[name]..' was confiscated by '..police.name, 'user-shield', '#1f6ecf')

	elseif type == 'weapon' then
		if amount == nil then amount = 0 end

		if player.hasWeapon(name) then
			player.removeWeapon(name, amount)

			Zen.Functions.LogToDiscord(Zen.Webhooks['police'], 'Confiscated Weapon', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Weapon:** '..Zen.Weapons[name])
			Zen.Functions.Notify(source, 'You confiscated '..Zen.Weapons[name]..' from '..player.name, 'user-shield', '#1f6ecf')
			Zen.Functions.Notify(target, 'Your '..Zen.Weapons[name]..' was confiscated by '..police.name, 'user-shield', '#1f6ecf')
		else
			Zen.Functions.Notify(source, 'Something Weird Happend?!', 'xmark', '#FF0000')
        end
	end
end)

RegisterNetEvent('police:interaction:citizen:action', function(target, action)
	local plyState = Player(source).state

	if plyState.job.name ~= 'police' then 
		return Zen.Functions.AntiEvent('^4[POLICE]', source, 'police:interaction:citizen:action')
	end

	if target ~= -1 then
		TriggerClientEvent('police:interaction:citizen:'..action, target, source)
	end
end)

lib.callback.register('police:vehicles:buy', function(source, props, type, price, label)
	local xPlayer = ESX.GetPlayerFromId(source)
	local success = false

	if xPlayer.getMoney() >= price then
		xPlayer.removeMoney(price)
		Zen.Functions.LogToDiscord(Zen.Webhooks['police'], 'Police Bought Vehicle', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Price:** $'..Zen.Functions.FormatCommas(price)..'\n**Vehicle:** '..label)
		MySQL.insert.await('INSERT INTO `owned_vehicles` (identifier, vehicle, plate, label, type, job) VALUES (?, ?, ?, ?, ?, ?)', { xPlayer.identifier, json.encode(props), props.plate, label, type, xPlayer.job.name })
		success = true
	else
		Zen.Functions.Notify(source, 'You Dont Have Enough Money!', 'dollar', '#FF0000')
	end

	return success
end)

RegisterCommand("duty", function(source, args, rawCommand)
    local source = source
    local xPlayer = ESX.GetPlayerFromId(source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    if job == 'police' then
        xPlayer.setJob('offpolice', grade)
    elseif job == 'offpolice' then
        xPlayer.setJob('police', grade) 
    end
end)

CreateThread(function()
	TriggerEvent('esx_society:registerSociety', 'police', 'Police', 'society_police', 'society_police', 'society_police', {type = 'public'})
end)

lib.callback.register('police:evidence:items', function(source)
	local inventory = GetSharedInventory('society_police')
	return inventory.items or {}
end)

RegisterNetEvent('police:evidence:take')
AddEventHandler('police:evidence:take', function(itemName, count)
	local plyState = Player(source).state

	if plyState.job.name ~= 'police' or plyState.job.grade_name ~= 'boss'  then 
		return Zen.Functions.AntiEvent('^4[POLICE]', source, 'police:evidence:take')
	end

	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_police', function(inventory)
		local inventoryItem = inventory.getItem(itemName)

		if count > 0 then
			if xPlayer.canCarryItem(itemName, count) then
				inventory.removeItem(itemName, count)
				xPlayer.addInventoryItem(itemName, count)
			else
				Zen.Functions.Notify(source, 'Invalid Quantity!', 'ban', '#FF0000') 
			end
		else
			Zen.Functions.Notify(source, 'Invalid Quantity!', 'ban', '#FF0000') 
		end
	end)
end)