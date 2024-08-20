lib.callback.register('garage:plateUsed', function(source, plate)
    local used = MySQL.query.await('SELECT 1 FROM `owned_vehicles` WHERE `plate` = ?', { plate })
    if used[1] ~= nil then 
        return true
    end
    return false
end)

lib.callback.register('garages:get', function(source, job, type)
    local owned = {}
	local xPlayer = ESX.GetPlayerFromId(source)

    local string = 'SELECT `label`, `plate` FROM `owned_vehicles` WHERE `identifier` = @identifer'

    if job ~= nil then string = string..' AND `job` = @job' end
    if type ~= nil then string = string..' AND `type` = @type' end

    local response = MySQL.query.await(string, { 
        ['@identifer'] = xPlayer.identifier, 
        ['@job'] = job, 
        ['@type'] = type
    })

    if response then 
        for i = 1, #response do 
            owned[#owned+1] = {
                label = response[i].label,
                plate = response[i].plate
            }
        end
    end

    return owned
end)

lib.callback.register('garages:props', function(source, plate)
    local response = MySQL.query.await('SELECT `vehicle` FROM `owned_vehicles` WHERE `plate` = ?', { plate })

    return json.decode(response[1].vehicle)
end)

RegisterNetEvent('garages:give', function(id, plate)
    local source = source
    local target = tonumber(id)
    local identifier = Zen.Functions.GetIdentifier(target, 'license')

    if identifier then 
        MySQL.update.await('UPDATE owned_vehicles SET identifier = ? WHERE plate = ?', { 
            identifier, plate 
        })

        Zen.Functions.LogToDiscord(Zen.Webhooks['garages'], 'Player Gave Vehicle', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Plate:** '..plate)

        Zen.Functions.Notify(source, 'You gave a vehicle. | '..plate, 'car', '#00FF00')
        Zen.Functions.Notify(target, 'You were given a vehicle. | '..plate, 'car', '#00FF00')
    else
        Zen.Functions.Notify(source, 'Invalid Player!', 'user', '#FF0000')
    end
end)

RegisterNetEvent('garages:delete', function(plate)
	local xPlayer = ESX.GetPlayerFromId(source)

    Zen.Functions.LogToDiscord(Zen.Webhooks['garages'], 'Player Deleted Vehicle', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Plate:** '..plate)
	
    MySQL.update.await('DELETE FROM owned_vehicles WHERE identifier = ? AND plate = ?', { 
        xPlayer.identifier, plate 
    })
end)