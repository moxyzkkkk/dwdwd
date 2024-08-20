local Server = Zen.Config.Server

local function sendHUDColor(healthColor, armourColor, serverColor)
    local customColors = json.decode(GetResourceKvpString("hudcolors"))
    local healthRGB = Zen.Functions.HexToRGB(customColors and customColors[1] or healthColor)
    local armourRGB = Zen.Functions.HexToRGB(customColors and customColors[2] or armourColor)
    local serverRGB = Zen.Functions.HexToRGB(customColors and customColors[3] or serverColor)
    
    Zen.Functions.NUI('updateHudColor', {
        serverName = Server.ServerName,
        websiteLink = Server.WebsiteLink,
        discordInvite = Server.DiscordInvite,
        serverLogo = Server.Graphics.Watermark,
        healthColor = healthRGB.r..', '..healthRGB.g..', '..healthRGB.b,
        armourColor = armourRGB.r..', '..armourRGB.g..', '..armourRGB.b,
        serverColor = serverRGB.r..', '..serverRGB.g..', '..serverRGB.b
    })

    Wait(500)

    stateBag:set('color', serverRGB, false)
    ReplaceHudColourWithRgba(142, serverRGB.r, serverRGB.g, serverRGB.b, 255)
    ReplaceHudColourWithRgba(116, serverRGB.r, serverRGB.g, serverRGB.b, 0.1)
end

RegisterNetEvent('playerLoaded', function()
    sendHUDColor(Server.Colors.HealthColor, Server.Colors.ArmourColor, Server.Colors.ServerColor)
    Zen.Functions.NUI('updateHud', { serverId = cache.serverId })
    Zen.Functions.NUI('updateCarHud', { engine = false })
end)

local alreadyShowingUI = false

CreateThread(function()
    while true do
        Citizen.Wait(500)

        if IsPauseMenuActive() or playerDead or scoreboardOpen then
            if alreadyShowingUI then
                ToggleUIs(false)
                alreadyShowingUI = false
            end
        else
            if not alreadyShowingUI then
                ToggleUIs(true)
                alreadyShowingUI = true
            end

            Zen.Functions.NUI('updateHud', {
                health = playerDead and 0 or (GetEntityHealth(cache.ped) - 100),
                armour = GetPedArmour(cache.ped),
                isTalking = NetworkIsPlayerTalking(cache.playerId)
            })
        end
    end
end)

lib.onCache('vehicle', function(vehicle)
    SetPlayerCanDoDriveBy(cache.playerId, false)
    if vehicle and vehicle ~= false then

        if GetPedInVehicleSeat(vehicle, -1) == cache.ped then
            SetPlayerCanDoDriveBy(cache.playerId, false)
        else
            SetPlayerCanDoDriveBy(cache.playerId, true)
        end

        if vehicle and GetPedInVehicleSeat(vehicle, cache.seat) == cache.ped then
            SetPedIntoVehicle(cache.ped, vehicle, cache.seat)
        end

        CreateThread(function()
            while cache.vehicle and cache.vehicle ~= false do
                vehicle = cache.vehicle

                local vel = math.ceil(GetEntitySpeed(vehicle) * 1.5369)
                --local health = math.floor(GetVehicleEngineHealth(vehicle)) / 10
                --local playerPos = GetEntityCoords(cache.ped)

                Zen.Functions.NUI('updateCarHud', { speed = vel, engine = true })
                -- GetStreetNameFromHashKey(GetStreetNameAtCoord(playerPos.x, playerPos.y, playerPos.z))
                Wait(100)
            end
            
            Zen.Functions.NUI('updateCarHud', { engine = false })
        end)
    end
end)    

if Server.ColorsCommand then 
    RegisterCommand('colors', function()
        local input = lib.inputDialog('HUD COLOR', {
            { type = 'color', label = 'Health Color', default = Server.Colors.HealthColor },
            { type = 'color', label = 'Armour Color', default = Server.Colors.ArmourColor },
            { type = 'color', label = 'Other Colors', default = Server.Colors.ServerColor },
        })

        if not input then return end

        SetResourceKvp("hudcolors", json.encode(input))
        sendHUDColor(input[1], input[2], input[3])
    end)
end