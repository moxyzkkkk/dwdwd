local peds = {}
local GetGameTimer = GetGameTimer

RegisterNetEvent('me:display', function(text, target)
    local player = GetPlayerFromServerId(target)
    
    if player ~= -1 or target == cache.serverId then
        local ped = GetPlayerPed(player)
        local dist = #(cache.coords - GetEntityCoords(ped))
        local los = HasEntityClearLosToEntity(cache.ped, ped, 17)

        if dist <= 5 and los then
            local exists = peds[ped] ~= nil
            
            peds[ped] = {
                time = GetGameTimer() + 5000,
                text = text
            }

            if not exists then
                local display = true
                
                while display do
                    Wait(4)
                    local position = GetEntityCoords(ped)

                    Zen.Functions.DrawText(peds[ped].text, position + vec3(0, 0, 1.2), true)
                    display = GetGameTimer() <= peds[ped].time
                end
                
                peds[ped] = nil
            end
        end
    end
end)

lib.callback.register('me:nearby', function()
    local nearby = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 5.0, true)

    local playersId = {}

    for i = 1, #nearby do 
        playersId[#playersId+1] = GetPlayerServerId(nearby[i].id)
    end

    return playersId 
end)