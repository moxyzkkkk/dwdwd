--[[
    Removes money from the society balance of the player's job
        playerId : the server player's id
        amount : the amount of the cash to remove
]]
function removeSocietyMoney(playerId, amount, customConfigPosIndex)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount or amount <= 0) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        TriggerEvent('esx_addonaccount:getSharedAccount', Config.Positions[customConfigPosIndex].societyName, function(account)
            account.removeMoney(amount)
        end)
    end
end

--[[
    Removes cash money from the current balance of the player
        playerId : the server player's id
        amount : the amount of the cash to remove
]]
function removePlayerCashMoney(playerId, amount)
    playerId = tonumber(playerId)
    amount = math.floor(tonumber(amount))
    
    if (not playerId or playerId < 1 or not GetPlayerName(playerId)) then return end
    if (not amount or amount <= 0) then return end

    if (not ESX) then return end
    
    local esxPlayer = ESX.GetPlayerFromId(playerId)
    if (esxPlayer) then
        esxPlayer.removeMoney(amount)
    end
end

--[[
    Save vehicle properties on database in table `owned_vehicles`
        vehicleProps : the vehicles properties to save
]]
function saveVehicleProperties(vehicleProps)
    if ((not vehicleProps) or (not vehicleProps.plate) or (not vehicleProps.model)) then return end 

    if (not MySQL) then
        print('[esx_mechanic] mysql-async not found')
        return
    end

    MySQL.Async.fetchAll('SELECT vehicle FROM owned_vehicles WHERE plate = @plate', {
        ['@plate'] = vehicleProps.plate
    }, function(result)
        if (result and result[1]) then
            local vehicle = json.decode(result[1].vehicle)
    
            if (vehicleProps.model == vehicle.model) then
                MySQL.Async.execute('UPDATE owned_vehicles SET vehicle = @vehicle WHERE plate = @plate', {
                    ['@plate'] = vehicleProps.plate,
                    ['@vehicle'] = json.encode(vehicleProps)
                })
            end
        end
    end)
end