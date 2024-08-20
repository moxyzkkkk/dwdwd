scoreboardOpen = false

local function openScoreboard()
    if scoreboardOpen then return end

    local players = lib.callback.await('scoreboard:players', false)

    table.sort(players, function(a, b) return a.source < b.source end)

    Zen.Functions.NUI('showScoreboard', {
        players = players,
        count = {
            clients = playerCount.online,
            maxClients = playerCount.max
        }
    })

    SetNuiFocus(true, true)
    scoreboardOpen = true
end

RegisterCommand('scoreboard', openScoreboard, false)
RegisterKeyMapping('scoreboard', 'Open scoreboard', 'keyboard', 'F10')

RegisterNUICallback('closeScoreboard', function(_, cb)
    scoreboardOpen = false
    SetNuiFocus(false, false)
    return cb('ok')
end)


RegisterNetEvent('scoreboard:debug', function()
    if not scoreboardOpen then return end

    scoreboardOpen = false
    Zen.Functions.NUI('hideScoreboard', {})
    SetNuiFocus(false, false)
end)