local ESX = exports['es_extended']:getSharedObject()
local getEntityCoords = GetEntityCoords
local getNearbyPlayers = lib.getNearbyPlayers
local hasEntityClearLosToEntity = HasEntityClearLosToEntity

local Started = false
local Id = nil
local gangWar_Id = nil
local PlayersList = {}
local Team = {}
local Enemy = {}
local Wager = 0
local Data = {
    hud_data = {
        label = "Gang War",
        time = 0,
        win_points = 30,
        kills = 0,
        next_kill_reward = 0,
        deaths = 0,
    },
    game_data = {

    }
}
local Stop = function()
    Started = false
    gangWar_Id = nil
    Team = {}
    Enemy = {}
    TriggerEvent('trappin_nui:gamemodes:toggle', false)
end

local Start = function()
    if Started then
        return
    end
    Started = true
    local location_cache = vector3(0, 0, 0)
    CreateThread(function()
        while Started do
            location_cache = getEntityCoords(cache.ped)
            Wait(500)
        end
    end)
    CreateThread(function()
        while Started do
            Wait(0)
            for _, player in pairs(Enemy) do
                if hasEntityClearLosToEntity(cache.ped, player.ped, 17) then
                    local coords = getEntityCoords(player.ped)
                    local dist = #(location_cache - coords)
                    if dist < 15.0 then
                        DrawMarker(25, coords.x, coords.y, coords.z - 0.95, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 0.8, 0.8, 0.8,
                            255, 0, 0, 100,
                            false, false, false, true, false, false, false)
                    end
                end
            end
        end
    end)
    TriggerEvent('trappin_nui:gamemodes:setType', 'gangwar')
    TriggerEvent('trappin_nui:gamemodes:setData', Data)
    TriggerEvent('trappin_nui:gamemodes:toggle', true)
end





AddEventHandler('esx:onPlayerDeath', function(data)
    if not Started then
        return
    end
    TriggerServerEvent('trp_gangs:gangwar:sv:ondeath', gangWar_Id, data)
end)

RegisterNetEvent('trp_gangs:cl:gangwar:init', function(id, enemyList, wager, teamList, initHudData)
    if not id or not enemyList or not wager then
        return error("Invalid args")
    end
    gangWar_Id = id
    for _, playerServerId in pairs(enemyList) do
        local p_id = GetPlayerFromServerId(playerServerId)
        local p_ped = GetPlayerPed(p_id)
        Enemy[playerServerId] = {
            serverid = playerServerId,
            id = p_id,
            ped = p_ped,
        }
    end
    for _, playerServerId in pairs(teamList) do
        local p_id = GetPlayerFromServerId(playerServerId)
        local p_ped = GetPlayerPed(p_id)
        Team[playerServerId] = {
            serverid = playerServerId,
            id = p_id,
            ped = p_ped,
        }
    end
    Wager = wager
    Data.game_data = initHudData

    Start()
end)

RegisterNetEvent('trp_gangs:cl:gangwar:update', function(id, data)
    if not Started or id ~= gangWar_Id then
        return
    end

    Data.game_data = data
    TriggerEvent('trappin_nui:gamemodes:setData', Data)
end)

RegisterNetEvent('trp_gangs:cl:gangwar:killstreak', function(id, data)
    if not Started or id ~= gangWar_Id then
        return
    end
    Data.hud_data.kills = data.kills
    Data.hud_data.next_kill_reward = 0
    TriggerEvent('trappin_nui:gamemodes:setData', Data)
end)

RegisterNetEvent('trp_gangs:cl:gangwar:end', function(id)
    if not Started or id ~= gangWar_Id then
        return
    end
    Stop()
end)

RegisterNetEvent('trp_gangs:cl:gangwar:syncEnemy', function(id, xsource, delete)
    if not Started or id ~= gangWar_Id then
        return
    end
    delete = delete or false
    if delete then
        Enemy[xsource] = nil
        return
    end
    local p_id = GetPlayerFromServerId(xsource)
    local p_ped = GetPlayerPed(p_id)
    Enemy[xsource] = {
        serverid = xsource,
        id = p_id,
        ped = p_ped,
    }
end)
