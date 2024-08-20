State = {
    activeTurfs = {}, ---@type table<string, GameMode>
    activeHardPoints = {}, ---@type table<string, GameMode>
    activeJungles = {}, ---@type table<string, GameMode>
    ActiveGangWar = nil,
    wrongEnterAttempts = 5,
}

RegisterNetEvent("trp_gangs:cl:gamemode:start", function(args)
    if not args.zoneid or not args.type then
        return error("Invalid args")
    end
    TriggerServerEvent("trp_gangs:sv:" .. args.type .. ":start", args.zoneid)
end)

exports('getActiveJungle', function()
    return State.activeJungles
end)

RegisterNetEvent("trp_gangs:cl:gamemode:init", function(id, data, type, hud)
    if not id or not data or not type then
        return error("Invalid args")
    end
    data.coords = {
        x = data.coords[1],
        y = data.coords[2],
        z = data.coords[3],
        r = data.coords[4],
    }
    if type == "turf" then
        if State.activeTurfs[id] then
            return
        end
        State.activeTurfs[id] = CreateGameMode(id, data, type, hud)
        State.activeTurfs[id]:Start()
    end
    if type == "hardpoint" or type == "drugzone" then
        if State.activeHardPoints[id] then
            return
        end
        State.activeHardPoints[id] = CreateGameMode(id, data, type, hud)
        State.activeHardPoints[id]:Start()
    end
    if type == "jungle" then
        if State.activeJungles[id] then
            return
        end
        State.activeJungles[id] = CreateGameMode(id, data, type, hud)
        State.activeJungles[id]:Start()
    end
end)

RegisterNetEvent("trp_gangs:cl:sync", function(id, data, type, hud)
    if not id or not data or not type then
        return error("Invalid args")
    end
    data.coords = {
        x = data.coords[1],
        y = data.coords[2],
        z = data.coords[3],
        r = data.coords[4],
    }
    if type == "turf" then
        if State.activeTurfs[id] then
            State.activeTurfs[id]:Stop()
            State.activeTurfs[id] = nil
        end
        State.activeTurfs[id] = CreateGameMode(id, data, type, hud)
        State.activeTurfs[id]:Start()
        Wait(1000)
        State.activeTurfs[id]:StartDraw()
    end
    if type == "hardpoint" or type == "drugzone" then
        if State.activeHardPoints[id] then
            State.activeHardPoints[id]:Stop()
            State.activeHardPoints[id] = nil
        end
        State.activeHardPoints[id] = CreateGameMode(id, data, type, hud)
        State.activeHardPoints[id]:Start()
        Wait(1000)
        State.activeHardPoints[id]:StartDraw()
    end

    if type == "jungle" then
        if State.activeJungles[id] then
            State.activeJungles[id]:Stop()
            State.activeJungles[id] = nil
        end
        State.activeJungles[id] = CreateGameMode(id, data, type, hud)
        State.activeJungles[id]:Start()
        Wait(1000)
        State.activeJungles[id]:StartDraw()
    end
end)

RegisterNetEvent("trp_gangs:cl:gamemode:tpoutside", function(id, type)
    if not id or not type then
        return error("Invalid args")
    end
    if type == "turf" then
        if not State.activeTurfs[id] then
            return
        end
        State.activeTurfs[id]:tpOutside()
        return
    end
    if type == "hardpoint" or type == "drugzone" then
        if not State.activeHardPoints[id] then
            return
        end
        State.activeHardPoints[id]:tpOutside()
        return
    end
    if type == "jungle" then
        if not State.activeJungles[id] then
            return
        end
        State.activeJungles[id]:tpOutside()
        return
    end
end)

RegisterNetEvent("trp_gangs:cl:gamemode:update", function(id, data, type)
    if not id or not data or not type then
        return error("Invalid args")
    end
    if type == "turf" then
        if not State.activeTurfs[id] then
            return
        end
        State.activeTurfs[id]:updateHudData(data)
        if data.time then
            State.activeTurfs[id]:updateTime(data.time)
        end
    end
    if type == "hardpoint" or type == "drugzone" then
        if not State.activeHardPoints[id] then
            return
        end

        State.activeHardPoints[id]:updateHudData(data)
    end
    if type == "jungle" then
        if not State.activeJungles[id] then
            return
        end

        State.activeJungles[id]:updateHudData(data)
    end
end)

RegisterNetEvent("trp_gangs:cl:gamemode:updatelabel", function(id, label, type)
    if not id or not label or not type then
        return error("Invalid args")
    end
    if type == "turf" then
        if not State.activeTurfs[id] then
            return
        end
        State.activeTurfs[id]:updateLabel(label)
        return
    end
    if type == "hardpoint" or type == "drugzone" then
        if not State.activeHardPoints[id] then
            return
        end
        State.activeHardPoints[id]:updateLabel(label)
        return
    end
    if type == "jungle" then
        if not State.activeJungles[id] then
            return
        end
        State.activeJungles[id]:updateLabel(label)
        return
    end
end)

RegisterNetEvent("trp_gangs:cl:gamemode:destroy", function(id, type)
    if not id or not type then
        return error("Invalid args")
    end
    if type == "turf" then
        State.activeTurfs[id]:Stop()
        State.activeTurfs[id] = nil
        return
    end
    if type == "hardpoint" or type == "drugzone" then
        State.activeHardPoints[id]:Stop()
        State.activeHardPoints[id] = nil
        return
    end
    if type == "jungle" then
        State.activeJungles[id]:Stop()
        State.activeJungles[id] = nil
        return
    end
end)


RegisterNetEvent("trp_gangs:cl:gamemode:killstreak", function(id, data, type)
    if ClientService.currentZoneId == "" then
        return
    end
    if type == "turf" then
        if not State.activeTurfs[id] then
            return
        end
        State.activeTurfs[id]:updateHudData(data)
        return
    end

    if type == "hardpoint" or type == "drugzone" then
        if not State.activeHardPoints[id] then
            return
        end
        State.activeHardPoints[id]:updateHudData(data)
        return
    end

    if type == "jungle" then
        if not State.activeJungles[id] then
            return
        end
        State.activeJungles[id]:updateHudData(data)
        return
    end
end)

RegisterNetEvent("trp_gangs:cl:gamemode:tpout", function()
    local ped = PlayerPedId()
    FreezeEntityPosition(ped, true)
    if State.wrongEnterAttempts <= 0 then
        local coords = vector4(425.17, -983.90, 30.71, 87.35)
        ---@diagnostic disable-next-line: missing-parameter
        SetEntityCoords(ped, coords.x, coords.y, coords.z)
        SetEntityHeading(ped, coords.w)
        Wait(1000)
        FreezeEntityPosition(ped, false)
        State.wrongEnterAttempts = 5
        return
    end
    local heading = GetEntityHeading(ped)
    local newCoords = GetOffsetFromEntityInWorldCoords(ped, 0.0, -10.0, 0.0)
    ---@diagnostic disable-next-line: missing-parameter
    SetEntityCoords(ped, newCoords.x, newCoords.y, newCoords.z)
    SetEntityHeading(ped, heading + 180.0)
    Wait(1000)
    FreezeEntityPosition(ped, false)
    State.wrongEnterAttempts = State.wrongEnterAttempts - 1
end)

RegisterNetEvent('trp_gangs:cl:moneywash:startTurf', function(args)
    TriggerServerEvent('trp_gangs:sv:moneywash:startTurf', args.zoneid)
end)

RegisterNetEvent('trp_gangs:cl:moneywash:startWash', function()
    if IsPedInAnyVehicle(cache.ped, false) then
        return TriggerEvent('trappin_ui:client:notify',
            { type = 'error', text = 'You can\'t be in a vehicle to wash money' })
    end
    local input = lib.inputDialog('Money Wash', {
        {
            type = 'number',
            label = 'Amount',
            description = 'the amount of black money that u want to wash',
            required = true,
            icon = 'dollar-sign',
            min = 0,
            default = 0
        },
    })
    if input and input[1] then
        TriggerServerEvent('trp_gangs:sv:moneywash:washMoney', input[1])
    end
end)



RegisterNetEvent('trp_gangs:cl:gangwar:init', function(id, enemyList, wager, team)
    if not id or not enemyList or not wager then
        return error("Invalid args")
    end
    State.ActiveGangWar = NewGangWar({
        id = id,
        enemyList = enemyList,
        team = team,
        wager = wager,
    })
    State.ActiveGangWar:Start()
end)
