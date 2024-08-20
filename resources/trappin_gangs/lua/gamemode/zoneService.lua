TURF_COLOR = {
    r = 127.0, g = 0.0, b = 255.0, a = 77
}

ClientService = {
    lastZoneId = nil,
    lastZoneType = nil,
    currentZoneId = nil,
    currentZoneType = nil,
    currentZoneCoords = { x = 0.0, y = 0.0, z = 0.0, r = 0.0 }
}

function ClientService:enterZone(zoneId, coords, type)
    self.currentZoneId = zoneId
    self.currentZoneType = type

    self.currentZoneCoords = coords
    local ev = "trp_gangs:sv:" .. ClientService.currentZoneType .. ":zone:enter"

    TriggerServerEvent(ev, ClientService.currentZoneId)
end

function ClientService:leaveZone(zoneId)
    local ev = "trp_gangs:sv:" .. self.currentZoneType .. ":zone:leave"
    TriggerServerEvent(ev, zoneId)
    self.lastZoneId = self.currentZoneId
    self.lastZoneType = self.currentZoneType

    SetTimeout(1000 * 15, function()
        if self.lastZoneId == zoneId then
            self.lastZoneId = nil
            self.lastZoneType = nil
        end
    end)

    self.currentZoneId = nil
    self.currentZoneType = nil
    self.currentZoneCoords = { x = 0.0, y = 0.0, z = 0.0, r = 0.0 }
end

AddEventHandler('esx:onPlayerDeath', function(data, ignore)
    ignore = ignore or false
    if ignore then return end
    if (not ClientService.currentZoneId) or (not ClientService.currentZoneType) then
        return
    end
    local distance = DistanceBetweenCoords(ClientService.currentZoneCoords,
        data.victimCoords, false)
    if distance > ClientService.currentZoneCoords.r then return end
    local ev = "trp_gangs:sv:" .. ClientService.currentZoneType ..
        ":zone:playerdeath"
    TriggerServerEvent(ev, ClientService.currentZoneId, data)
end)

exports('isInGameModeZone', function()
    if ClientService.currentZoneId ~= nil or ClientService.currentZoneType ~=
        nil then
        return true
    end
    return false
end)

exports('GetCurrentZone', function()
    return ClientService.currentZoneId, ClientService.currentZoneType, ClientService.currentZoneCoords
end)

CreateThread(function()
    local turfColor = GetResourceKvpString('turf_color')
    if turfColor then
        TURF_COLOR = json.decode(turfColor)
        TURF_COLOR.a = 77
    end
end)

exports('TpOutGameMode', function()
    if not ClientService.currentZoneId or not ClientService.currentZoneType then return end
    TriggerEvent('trp_gangs:cl:gamemode:tpoutside', ClientService.currentZoneId, ClientService.currentZoneType)
end)

RegisterNetEvent('trappin_gangs:cl:tpoutgamemode', function()
    if not ClientService.currentZoneId or not ClientService.currentZoneType then return end
    TriggerEvent('trp_gangs:cl:gamemode:tpoutside', ClientService.currentZoneId, ClientService.currentZoneType)
end)

RegisterCommand('turfcolor', function(src, args)
    local color = PickColor()
    if not color then return end
    if color.a > 77 then
        color.a = 77
    end
    TURF_COLOR = color
    SetResourceKvp('turf_color', json.encode(TURF_COLOR))
    TriggerEvent('trappin_ui:client:notify', {
        type = 'inform',
        text = 'Turf color set'
    })
end, false)
