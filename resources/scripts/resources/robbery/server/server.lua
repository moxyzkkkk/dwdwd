local Robbery = Zen.Config.Robbery
local ActiveRobberies = {}

local function robberyStop(store, completed)
    if not ActiveRobberies[store] then return end

    ActiveRobberies[store].cooldown = os.time()
    ActiveRobberies[store].active = false
    
    local robber = ActiveRobberies[store].robber
    local storeData = Robbery.Locations[store]

    if Player(robber).state.active then 
        Player(robber).state.robbingStore = nil
        TriggerClientEvent('robbery:stop', robber)

        if completed then 
            local reward = math.random(storeData.reward[1], storeData.reward[2])
            Zen.Functions.Notify(robber, "The robbery ended! Got $"..Zen.Functions.FormatCommas(reward).."!", 'dollar', '#00FF00')

            local xPlayer = ESX.GetPlayerFromId(robber)
            xPlayer.addAccountMoney('black_money', reward)
        else
            Zen.Functions.Notify(robber, "The robbery was cancelled!", 'xmark', '#FF0000')
        end
    end

    local cops = ESX.GetExtendedPlayers('job', 'police')

    for _, cop in pairs(cops) do
        Zen.Functions.Notify(cop.source, 'Robbery ended at '..storeData.name, 'gun', '#FF0000')
        TriggerClientEvent('robbery:blip:remove', cop.source, store)
    end
end

RegisterNetEvent('robbery:stop', robberyStop)

RegisterNetEvent('robbery:start', function(store)
    local source = source

    local storeData = Robbery.Locations[store]

    if not storeData then return end

    if ActiveRobberies[store] then 
        if ActiveRobberies[store].active == true then 
            return Zen.Functions.Notify(source, 'This Store Is Currently Being Robbed!', 'xmark', '#FF0000')
        end

        if ActiveRobberies[store].cooldown then 
            if (os.time() - ActiveRobberies[store].cooldown) >= storeData.timers[2] then 
                ActiveRobberies[store] = nil
            else
                return Zen.Functions.Notify(source, 'This Store Was Recently Robbed!', 'xmark', '#FF0000')
            end
        end
    end

    local cops = ESX.GetExtendedPlayers('job', 'police')

    if #cops < storeData.cops then
        return Zen.Functions.Notify(source, storeData.cops..' Cops Must Be Online!', 'xmark', '#FF0000')
    end

    for _, cop in pairs(cops) do
        Zen.Functions.Notify(cop.source, 'Robbery at '..storeData.name, 'gun', '#FF0000')
        TriggerClientEvent('robbery:blip', cop.source, store, storeData.coords)
    end

    ActiveRobberies[store] = {
        active = true,
        robber = source
    }

    Player(source).state:set('robbingStore', store, false)
    
    TriggerClientEvent('robbery:start', source, store)

    SetTimeout(storeData.timers[1] * 1000, function()
        if not ActiveRobberies[store].active then return end
        robberyStop(store, true)
    end)
end)

RegisterNetEvent("robbery:exited", function(store)
    robberyStop(store, false)
end)

AddEventHandler("playerDropped", function(reason)
    if not Player(source).state.robbingStore then return end

    robberyStop(Player(source).state.robbingStore, false)
    Player(source).state.robbingStore = nil
end)