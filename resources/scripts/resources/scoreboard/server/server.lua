local players = {}

RegisterNetEvent('playerLoaded', function(player)
    local discordData = Zen.Functions.Discord.Data(player)

    table.insert(players, {
        name = GetPlayerName(player),
        source = tonumber(player),
        discord = discordData.name,
        avatar = discordData.avatar,
        ping = GetPlayerPing(player)
    })

    TriggerClientEvent('player:count', -1, GetNumPlayerIndices())
end) 

AddEventHandler('playerDropped', function()
    local player = source

    for key, value in next, players do
        if tonumber(value.source) == tonumber(player) then
            table.remove(players, key)
        end
    end

    TriggerClientEvent('player:count', -1, GetNumPlayerIndices())

    return
end)

lib.callback.register('scoreboard:players', function()
    for key, value in next, players do
        value.ping = GetPlayerPing(value.source)
    end

    return players
end)

RegisterCommand('+scoreboard_debug', function(source)
    if source ~= 0 then return end

    TriggerClientEvent('scoreboard:debug', -1)
end)