DRAW = false

local JungleTurfSpawns = {
    vector4(-84.6518, -1502.7067, 33.3453, 319.6983),
    vector4(-96.6867, -1484.7943, 33.1100, 301.6786),
    vector4(-100.1492, -1462.4097, 33.2367, 221.9866),
    vector4(-95.5096, -1446.8495, 33.4218, 251.6025),
    vector4(-86.5502, -1430.5829, 30.7471, 198.7203),
    vector4(-11.7374, -1422.3190, 30.7149, 109.6284),
    vector4(9.9399, -1453.9968, 30.4999, 96.2433),
    vector4(12.5236, -1474.2726, 30.5511, 79.4573),
    vector4(-39.0341, -1517.7687, 30.6961, 31.9243),
}

local JungleDrugZoneSpawns = {
    vector4(2317.7563, 4852.3662, 41.8082, 48.2105),
    vector4(2307.4468, 4835.1562, 40.8956, 44.3172),
    vector4(2266.1760, 4828.3584, 40.6519, 354.3383),
    vector4(2224.4185, 4877.5386, 40.9523, 275.1805),
    vector4(2232.1289, 4907.6240, 40.6621, 245.2604),
    vector4(2256.3381, 4929.7842, 40.9706, 208.9981),
    vector4(2312.0203, 4918.3403, 41.3912, 144.8896),
    vector4(2325.9426, 4900.4165, 41.6772, 115.3307)
}

---@class GameMode -- GameMode class
local GameMode = {
    draw = false,
    startdraw = false,
    id = "",
    label = "",
    type = "",
    hud = {
        kills = 0,
        time = 0,
        next_kill_reward = 0,
    },
    data = {
        id = "",
        name = "",
        coords = {
            x = 0.0,
            y = 0.0,
            z = 0.0,
            r = 0.0,
        },
        cooldown = 0,
        duration = 0,
        points_to_win = 0,
        rewards = {
            {
                type = "item",
                name = "",
                amount = 0,
            }
        }
    },
    gamedata = {

    },
    zone = nil,

}
GameMode.__index = GameMode


-- Tp The player outside of the zone.
function GameMode:tpOutside()
    if self.type == "jungle" then
        local checktype = lib.callback.await('trappin_gangs:sv:checkTurfType', false, self.id)
        local spawns
        if checktype == "jungle_drugzone" then
            spawns = JungleDrugZoneSpawns
        else
            spawns = JungleTurfSpawns
        end
        local playerPed = cache.ped
        math.randomseed(GetGameTimer())
        local coords = spawns[math.random(1, #spawns)]
        SetEntityCoords(playerPed, coords.x, coords.y, coords.z, false, false, false, false)
        SetEntityHeading(playerPed, coords.w)
    end
end

function CalcKills(data_arr, kills_to_win)
    local my_gang = LocalPlayer.state.gang.gang_name
    local gang_kills = 0
    for k, v in pairs(data_arr) do
        if v ~= nil and v.points then
            if v.label == my_gang then
                gang_kills = v.points
                break
            end
        end
    end
    return kills_to_win - gang_kills
end

-- sends signal to update event hud.
function GameMode:updateGameUI()
    local dt = {
        game_data = self.gamedata,
        hud_data = self.hud,
    }
    dt.hud_data.label = self.label
    if self.type == "turf" then
        dt.hud_data.win_points = self.data.duration * 60
    elseif self.type == "hardpoint" or self.type == "drugzone" then
        dt.hud_data.win_points = self.data.points_to_win
    elseif self.type == "jungle" then
        dt.hud_data.win_points = CalcKills(dt.game_data, self.data.kills_to_win)
    else
        dt.hud_data.win_points = self.data.points_to_win
    end
    TriggerEvent('trappin_nui:gamemodes:setData', dt)
    if not self.draw then
        self:StartDraw()
    end
end

INVEH = false
lib.onCache('vehicle', function(value)
    INVEH = value
end)


-- Starts the game mode.
function GameMode:Start()
    local vec3Coords = vector3(self.data.coords.x, self.data.coords.y, self.data.coords.z)
    self.label = self.data.name
    self.zone = lib.points.new({
        coords = vec3Coords,
        distance = self.data.coords.r,
    })
    local gm = self
    function self.zone:onEnter()
        gm:onEnter()
        if INVEH then
            DeleteVehicle(INVEH)
        end
    end

    function self.zone:onExit()
        gm:onExit()
        if INVEH then
            DeleteVehicle(INVEH)
        end
    end

    self:StartDraw()
end

function GameMode:StartDraw()
    if self.draw then return end
    self.startdraw = true
    Wait(1000)
    CreateThread(function()
        local playerPed = PlayerPedId()
        while self.startdraw and self.zone ~= nil do
            self.draw = true
            local coords = GetEntityCoords(playerPed)
            local distance = DistanceBetweenCoords(self.data.coords, coords, false)
            while (distance <= (self.data.coords.r) + 150.0) and (self.startdraw and self.zone ~= nil) do
                coords = GetEntityCoords(playerPed)
                distance = DistanceBetweenCoords(self.data.coords, coords, false)
                ---@diagnostic disable-next-line: missing-parameter
                DrawMarker(28, self.data.coords.x, self.data.coords.y, self.data.coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0,
                    self.data.coords.r + .0, self.data.coords.r + .0,
                    self.data.coords.r + .0, TURF_COLOR.r, TURF_COLOR.g, TURF_COLOR.b, TURF_COLOR.a, false, false, 2, nil,
                    nil, false)

                Wait(0)
            end
            Wait(2500)
        end

        self.draw = false
    end)
end

function GameMode:onEnter()
    ClientService:enterZone(self.id, self.data.coords, self.type)
    local t = self.type

    TriggerEvent('trappin_nui:gamemodes:setType', t)


    self:updateGameUI()
    Wait(100)
    TriggerEvent('trappin_nui:gamemodes:toggle', true)
    if not self.draw then
        self:StartDraw()
    end
end

function GameMode:onExit()
    ClientService:leaveZone(self.id)
    TriggerEvent('trappin_nui:gamemodes:toggle', false)
    if not self.draw then
        self:StartDraw()
    end
end

-- Update GameMode HUD Label
--- @param label string label to update to
function GameMode:updateLabel(label)
    if ClientService.currentZoneId ~= self.id then
        return
    end
    self.label = label
    self:updateGameUI()
end

-- Update GameMode HUD Time
--- @param time number time in seconds
function GameMode:updateTime(time)
    if ClientService.currentZoneId ~= self.id then
        return
    end
    self.hud.time = time
    self:updateGameUI()
end

-- Update GameMode HUD Data
--- @param data table {deaths = number, kills = number, next_kill_reward = number}
function GameMode:updateHudData(data)
    if ClientService.currentZoneId ~= self.id then
        return
    end
    self.hud.label = data.label or self.hud.label
    self.hud.kills = data.kills or self.hud.kills
    self.hud.next_kill_reward = data.next_kill_reward or self.hud.next_kill_reward
    self.hud.time = data.time or self.hud.time
    self.gamedata = data.data or self.gamedata

    self:updateGameUI()
end

-- Destroies the game mode.
function GameMode:Stop()
    self.zone:remove()
    self.zone = nil
    if ClientService.currentZoneId ~= self.id then
        return
    end
    DRAW = false
    ClientService:leaveZone(self.id)
    TriggerEvent('trappin_nui:gamemodes:toggle', false)
end

-- Creates a new game mode.
--- @param id string id of the game mode
--- @param data table data of the game mode {id = string, name = string, coords = vector3, cooldown = number, duration = number, rewards = table}
--- @param type string type of the game mode
--- @return GameMode game mode object
CreateGameMode = function(id, data, type, hud)
    local object = {}                                       -- create object
    object.id = id or ""                                    -- set default value for id
    object.label = object.label or ""                       -- set default value for label
    object.type = type or ""                                -- set default value for type
    object.hud = hud or {}                                  -- set default value for hud
    object.hud.kills = hud.kills or 0                       -- set default value for hud.kills
    object.hud.deaths = hud.deaths or 0                     -- set default value for hud.deaths
    object.hud.next_kill_reward = hud.next_kill_reward or 0 -- set default value for hud.next_kill_reward
    object.hud.time = 0                                     -- set default value for hud.time
    object.data = data or {}                                -- set default value for data
    object.data.id = data.id or ""                          -- set default value for data.id
    object.data.name = data.name or ""                      -- set default value for data.name
    object.data.coords = data.coords or {}                  -- set default value for data.coords
    object.data.coords.x = data.coords.x or 0.0             -- set default value for data.coords.x
    object.data.coords.y = data.coords.y or 0.0             -- set default value for data.coords.y
    object.data.coords.z = data.coords.z or 0.0             -- set default value for data.coords.z
    object.data.coords.r = data.coords.r or 0.0             -- set default value for data.coords.r
    object.data.cooldown = data.cooldown or 0               -- set default value for data.cooldown
    object.data.duration = data.duration or 0               -- set default value for data.duration
    object.data.rewards = data.rewards or {}                -- set default value for data.rewards
    object.gamedata = {}                                    -- set default value for gamedata
    object.zone = nil                                       -- set default value for zone
    object.draw = false                                     -- set default value for draw
    object.startdraw = false                                -- set default value for StartDraw
    setmetatable(object, GameMode)                          -- make GameMode handle lookup
    return object --[[@as GameMode]]
end


--[[
self.zone = CircleZone:Create(vec3Coords, self.data.coords.r, {
        name = self.id,
        useZ = true,
        debugPoly = true,
        debugColor = { 0, 255, 0 }
    })
    self.zone:onPlayerInOut(function(isPointInside)
        if isPointInside then
            ClientService:enterZone(self.id, self.data.coords, self.type)
            local t = self.type .. ":enter"
            SendNUIMessage({ type = t })
        else
            ClientService:leaveZone(self.id)
            local t = self.type .. ":leave"
            SendNUIMessage({ type = t })
        end
        self:updateGameUI()
    end)
]]
