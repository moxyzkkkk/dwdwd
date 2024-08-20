local DeathScreen = Zen.Config.DeathScreen
playerDead = false

CreateThread(function()
    Zen.Functions.NUI('setDeatScreenLocations', { respawns = DeathScreen.Buttons })
end)

for i = 1, #DeathScreen.Hospitals.Locations do
    Zen.Functions.CreateBlip(DeathScreen.Hospitals.Locations[i], DeathScreen.Hospitals.Blip)
end

RegisterNUICallback('checkingIfPlayersInZones', function(_, callback)
    CreateThread(function()
        while true do 
            Wait(0)
            if not playerDead then 
                Zen.Functions.NUI('hideDeatScreen', {})
                playerDead = false
                break
            end

            local zone = 0
            local zoneDistance = math.huge
            
            for i = 1, #DeathScreen.ReviveZones do
                local playerCoords = cache.coords
                local distance = math.sqrt((playerCoords.x - DeathScreen.ReviveZones[i].coords[1])^2 + (playerCoords.y - DeathScreen.ReviveZones[i].coords[2])^2 + (playerCoords.z - DeathScreen.ReviveZones[i].coords[3])^2)
            
                if distance <= DeathScreen.ReviveZones[i].distance and distance < zoneDistance then
                    zone = i
                    zoneDistance = distance
                end
            end
            
            if zone ~= 0 then
                local playerCoords = cache.coords
                local zoneCoords = DeathScreen.ReviveZones[zone].coords
                local zoneDistance = math.sqrt((playerCoords.x - zoneCoords[1])^2 + (playerCoords.y - zoneCoords[2])^2 + (playerCoords.z - zoneCoords[3])^2)
                
                if playerDead then 
                    Zen.Functions.NUI('showDeathScreenReviveZone', { 
                        inReviveZone = true
                    })

                    if IsControlPressed(0, 45) then
                        RespawnPlayerAt({
                            coords = cache.coords
                        }, false)
                        break
                    end
                end
            else
                Zen.Functions.NUI('showDeathScreenReviveZone', { 
                    inReviveZone = false
                })
            end
        end
    end)

    return callback('ok')
end)

RegisterNUICallback('respawnTimerFinished', function(_, callback)
    CreateThread(function()
        while true do 
            Wait(0)
            if not playerDead then 
                Zen.Functions.NUI('hideDeatScreen', {})
                playerDead = false
                break
            end
            for i = 1, #DeathScreen.Buttons do 
                if IsControlPressed(0, Zen.Keys[DeathScreen.Buttons[i].keybind]) then
                    local canPayAmount = lib.callback.await('deathscreen:checkBalance', false, DeathScreen.Buttons[i].price)
                    if canPayAmount then 
                        RespawnPlayerAt(DeathScreen.Buttons[i], true)
                        break
                    end
                end
            end
        end
    end)

    return callback('ok')
end)

RegisterNUICallback('bleedoutTimerFinished', function(_, callback)
    RespawnPlayerAt({
        coords = DeathScreen.Hospitals.Locations[math.random(1, #DeathScreen.Hospitals.Locations)]
    }, true)
    return callback('ok')
end)


function RespawnPlayerAt(data, atPD)
    local coords = data.coords
    
    if stateBag.job.name == 'police' and atPD then
        coords = DeathScreen.PoliceStation
    end

    SetEntityCoordsNoOffset(cache.ped, coords.x, coords.y, coords.z, false, false, false)
    NetworkResurrectLocalPlayer(coords.x, coords.y, coords.z, coords.w, true, false)
    ClearPedBloodDamage(cache.ped)
    TriggerEvent('playerSpawned')
    
    if stateBag.job.name ~= 'police' and coords ~= cache.coords then
        TriggerServerEvent('deathscreen:performAfterDeath', data)
    end

    Zen.Functions.NUI('hideDeatScreen', {})
    playerDead = false
end

AddEventHandler('esx:onPlayerDeath', function(data)
    if data.killedByPlayer then
        deathReason = 'Killed By '..GetPlayerName(GetPlayerFromServerId(data.killerServerId))..' ('..data.killerServerId..') - '..data.distance..' Meters'
    elseif not data.killedByPlayer then
        deathReason = 'You Have Died'
    end

    playerDead = true

    Zen.Functions.NUI('showDeatScreen', {
        deathReason = deathReason, 
        respawnTimer = (DeathScreen.OnDeath.RespawnTime / 1000), 
        bleedoutTimer = (DeathScreen.OnDeath.BleedoutTime / 1000)
    })
end)

RegisterNetEvent('deathscreen:revive', function(coords)
    NetworkResurrectLocalPlayer((coords or cache.coords), true, true, false)
    ClearPedBloodDamage(cache.ped)
    TriggerServerEvent('esx:onPlayerSpawn')
    TriggerEvent('esx:onPlayerSpawn')
    TriggerEvent('playerSpawned')

    Zen.Functions.NUI('hideDeatScreen', {})
    playerDead = false
end)

RegisterCommand('die', function()
    if not Zen.Functions.CanInteract() then 
        return Zen.Functions.Notify('Can\'t Do This Right Now!', 'xmark', '#FF0000')
    end

    SetEntityHealth(cache.ped, 0)
    playerDead = true
end)