local ESX <const> = exports.es_extended:getSharedObject()
local Zones = {}
local inZone = nil
local ui_data = {
    hud_data = {
        label = "Kill Zone",
        time = 70,
        win_points = 100,
        kills = 0,
        next_kill_reward = 0,
        deaths = 0,
    },
    game_data = {},
}


RegisterNetEvent('trappin_gangs:cl:killzone:killstreak', function(data)
    if not inZone then
        return
    end
    ui_data.hud_data.kills = data.kills
    ui_data.hud_data.next_kill_reward = data.next_kill_reward
    ui_data.hud_data.label = 'Kill Zone'
    TriggerEvent('trappin_nui:gamemodes:setData', ui_data)
end)

RegisterNetEvent('trappin_gangs:cl:killzone:reset', function(data)
    ui_data.hud_data.kills = 0
    ui_data.hud_data.next_kill_reward = 0
end)

local Boot = function()
    for id, data in pairs(KillZones.zones) do
        local blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
        SetBlipSprite(blip, KillZones.blip.sprite)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, KillZones.blip.scale)
        SetBlipColour(blip, KillZones.blip.color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(data.name)
        EndTextCommandSetBlipName(blip)

        local blip2 = AddBlipForRadius(data.coords.x, data.coords.y, data.coords.z, data.coords.w)
        SetBlipHighDetail(blip2, true)
        SetBlipColour(blip2, 1)
        SetBlipAlpha(blip2, 128)

        local zone = lib.zones.sphere({
            coords = data.coords.xyz,
            radius = data.coords.w,
            debug = data.debug,
            onEnter = function()
                inZone = id
                TriggerServerEvent('trappin_gangs:sv:killzone:enter', id)
                TriggerEvent('trappin_nui:gamemodes:setType', 'killzone')
                TriggerEvent('trappin_nui:gamemodes:setData', ui_data)
                TriggerEvent('trappin_nui:gamemodes:toggle', true)
            end,
            onExit = function()
                inZone = nil
                TriggerServerEvent('trappin_gangs:sv:killzone:exit', id)
                TriggerEvent('trappin_nui:gamemodes:toggle', false)
            end,
        })

        Zones[id] = {
            blip = blip,
            blip2 = blip2,
            zone = zone,
        }
    end
end




CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    Boot()
end)
