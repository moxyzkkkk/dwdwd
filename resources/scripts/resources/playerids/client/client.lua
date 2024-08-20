local IdsToggled = true

local function toggleIds()
    while IdsToggled do
        local wait = 1000
        local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 3.0, false)

        if table.type(players) ~= 'empty' then
            wait = 0

            for _, value in next, players do
                Zen.Functions.DrawText(GetPlayerServerId(value.id), value.coords + vec3(0, 0, 1.0), NetworkIsPlayerTalking(value.id))
            end
        end

        Wait(wait)
    end
end

CreateThread(toggleIds)

RegisterCommand('ids', function()
    IdsToggled = not IdsToggled
    if IdsToggled then 
        toggleIds() 
    end
end, false)