local TakeHostage = Zen.Config.TakeHostage
local takingHostage = {}
local takenHostage = {}

RegisterNetEvent("TakeHostage:sync", function(targetSrc)
	local source = source

	TriggerClientEvent("TakeHostage:sync", targetSrc, source)
	takingHostage[source] = targetSrc
	takenHostage[targetSrc] = source
end)

RegisterNetEvent("TakeHostage:release", function(targetSrc)
	local source = source
	TriggerClientEvent("TakeHostage:release", targetSrc, source)
	takingHostage[source] = nil
	takenHostage[targetSrc] = nil
end)

RegisterNetEvent("TakeHostage:kill", function(targetSrc)
	local source = source
	TriggerClientEvent("TakeHostage:kill", targetSrc, source)
	takingHostage[source] = nil
	takenHostage[targetSrc] = nil
end)

RegisterNetEvent("TakeHostage:stop", function(targetSrc)
	local source = source
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:stop", targetSrc)
		takingHostage[source] = nil
		takenHostage[targetSrc] = nil
	elseif takenHostage[source] then
		TriggerClientEvent("TakeHostage:stop", targetSrc)
		takenHostage[source] = nil
		takingHostage[targetSrc] = nil
	end
end)

if TakeHostage.SearchEnabled then 
    RegisterNetEvent('TakeHostage:search', function(target, type, name, amount)	
        local robber = ESX.GetPlayerFromId(source)
        local victim = ESX.GetPlayerFromId(target)

		if not robber or not victim then 
			return print('^1[CHEATER] ^3ID: '..source..' and ID: '..target..' Tried To Duplicate Inventory!^7')
		end

        if type == 'item' then
            robber.addInventoryItem(name, amount)
            victim.removeInventoryItem(name, amount)

            Zen.Functions.Notify(source, 'You stole '..amount..' '..Zen.Items[name].label..' from '..victim.name, 'user', '#ff0000')
            Zen.Functions.Notify(target, 'Your '..amount..' '..Zen.Items[name].label..' was robbed by '..robber.name, 'user', '#ff0000')

        elseif type == 'account' then
            robber.addAccountMoney(name, amount)
            victim.removeAccountMoney(name, amount)
            
            Zen.Functions.Notify(source, 'You robbed '..amount..' '..Zen.Accounts[name]..' from '..victim.name, 'user', '#ff0000')
            Zen.Functions.Notify(target, 'Your '..amount..' '..Zen.Accounts[name]..' was robbed by '..robber.name, 'user', '#ff0000')

        elseif type == 'weapon' then
            if amount == nil then amount = 0 end

            if victim.hasWeapon(name) then
                robber.addWeapon(name, amount)
                victim.removeWeapon(name, amount)

                Zen.Functions.Notify(source, 'You robbed '..Zen.Weapons[name]..' from '..victim.name, 'user', '#ff0000')
                Zen.Functions.Notify(target, 'Your '..Zen.Weapons[name]..' was robbed by '..robber.name, 'user', '#ff0000')
            else
                Zen.Functions.Notify(source, 'Something Weird Happend?!', 'xmark', '#FF0000')
            end
        end
    end)
end

AddEventHandler('playerDropped', function(reason)
	local source = source
	
	if takingHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takingHostage[source])
		takenHostage[takingHostage[source]] = nil takingHostage[source] = nil
	end

	if takenHostage[source] then
		TriggerClientEvent("TakeHostage:cl_stop", takenHostage[source])
		takingHostage[takenHostage[source]] = nil takenHostage[source] = nil
	end
end)
