Active = nil
Drop = nil
Blip = nil
Radius = nil
Flying = false
dropped = false

---@param cb function callback
---@param onFinish? function callback
---@return table|nil thread object
local NewThread = function(cb, onFinish)
    if type(cb) ~= 'function' then
        return error('NewThread: cb is not a function')
    end
    local self = {}
    self.state = false
    self.start = function()
        if self.state then
            return
        end
        self.state = true
        CreateThread(function()
            while self.state do
                cb()
                Wait(0)
            end
            if type(onFinish) == 'function' then
                onFinish()
            end
        end)
    end
    self.stop = function()
        self.state = false
    end
    return self
end

local ui_data = {
    hud_data = {
        label = "Air Drop Event",
        time = 70,
        win_points = 100,
        kills = 0,
        next_kill_reward = 0,
        deaths = 0,
    },
    game_data = {},
}







RegisterNetEvent('trappin_gangs:cliet:drops:create', function(data)
    Active = data
    CreateThread(function()
        SpawnPlane(data.coords, data.items)
    end)
    Blip = AddBlipForCoord(data.coords.x, data.coords.y, data.coords.z)
    SetBlipSprite(Blip, Config.Blip.Sprite)
    SetBlipDisplay(Blip, 4)
    SetBlipScale(Blip, Config.Blip.Scale)
    SetBlipAsShortRange(Blip, true)
    SetBlipColour(Blip, Config.Blip.Color)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentSubstringPlayerName(Config.Blip.Label)
    EndTextCommandSetBlipName(Blip)
    Radius = AddBlipForRadius(data.coords.x ,data.coords.y , data.coordss.z, 100.0) -- need to have .0
    SetBlipColour(Radius, 1)
    SetBlipAlpha(Radius, 128)
end)




function SpawnPlane(a, b)
    local model = GetHashKey(Config.Vehicle.Model)
    LoadModel(model)

    local pilotModel = GetHashKey(Config.Vehicle.Pilot)
    LoadModel(pilotModel)

    local startTime = GetGameTimer()
    local lastUpdate = startTime


    local direction = a.xyz
    local vehicleCoords = vector3(3500, -3500, Config.Vehicle.Height)
    color = 1
    Vehicle = CreateVehicle(model, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, a.w, false, true)
    Pilot = CreatePed(4, pilotModel, vehicleCoords.x, vehicleCoords.y, vehicleCoords.z, a.w, false, true)
    if Config.BlipForPlane then
        planeblip = AddBlipForEntity(Vehicle)
        SetBlipSprite(planeblip, 307)
        SetBlipRotation(planeblip, GetEntityHeading(Pilot))
    end


    while not DoesEntityExist(Vehicle) do
        Citizen.Wait(50)
    end
    while not DoesEntityExist(Pilot) do
        Citizen.Wait(50)
    end
    SetPedIntoVehicle(Pilot, Vehicle, -1)

    ControlLandingGear(Vehicle, 3)
    SetVehicleEngineOn(Vehicle, true, true, false)
    SetEntityVelocity(Vehicle, direction.x * Config.Vehicle.Speed, direction.y * Config.Vehicle.Speed, 0.0)

    while not NetworkHasControlOfEntity(Vehicle) do
        NetworkRequestControlOfEntity(Vehicle)
        Citizen.Wait(50)
    end


    local vehicle = 0
    if ped then
        if IsPedInAnyHeli(Pilot) or IsPedInAnyPlane(Pilot) then
            vehicle = GetVehiclePedIsIn(Pilot , false)
        end
    else
        ped = 0
    end
    local dx = a.x - vehicleCoords.x
    local dy = a.y - vehicleCoords.y
    local heading = GetHeadingFromVector_2d(dx, dy)

    TaskPlaneMission(Pilot, Vehicle, vehicle, ped, a.x, a.y, a.z + 250, 6, 0, 0, heading, 2000.0, 400.0)


    Flying = true

    while Flying do
        SetBlipRotation(planeblip, Ceil(GetEntityHeading(Pilot)))
        if color == 1 then
            SetBlipColour(planeblip, 6)
            color = 2
        else
            SetBlipColour(planeblip, 3)
            color = 1
        end
        local pcoords = GetEntityCoords(Vehicle)
        local dist = #(pcoords - a.xyz)
     
        if dist < 950.0 or dropped then
            Arrived(a)
            dropped = true
            TaskPlaneMission(Pilot, Vehicle, vehicle, ped, -3500, 3500, Config.Vehicle.Height, 6, 0, 0, a.w, 2000.0,
                400.0)

            if dist > 1500 then
                Flying = false
                DeleteEntity(Vehicle)
                Vehicle = 0
                DeleteEntity(Pilot)
                Pilot = 0
                return
            end
        end
        Wait(1000)
    end

    Citizen.Wait(5000)
end

function Arrived(pos)
    if dropped then
        return
    end
    lib.callback.await('trappin_gangs:server:drops:setDropped', false, pos)
end

function LoadModel(model)
    while not HasModelLoaded(model) do
        RequestModel(model)
        Citizen.Wait(25)
    end
end

Model = `prop_drop_crate_01`
Zone = nil
Spawning = false
OnGround = false



HoldingThread = {
    state = false
}
HoldingThread.start = function()
    if HoldingThread.state then
        return
    end
    HoldingThread.state = true

    CreateThread(function()
        local playerPos = GetEntityCoords(cache.ped)
        local anim <const> = PackageConfig.animation
        TaskStartScenarioInPlace(cache.ped, anim.scenario, 0, false)
        HoldingThread.state = lib.callback.await('trappin_gangs:server:drops:hold', false, playerPos)
        while HoldingThread.state do
            FreezeEntityPosition(cache.ped, true)
            if IsControlJustPressed(0, 73) then
                HoldingThread.state = false
                break
            end
            if not IsPedUsingScenario(cache.ped, anim.scenario) then
                HoldingThread.state = false
                break
            end
            if LocalPlayer.state.dead then
                HoldingThread.state = false
                break
            end
            Wait(0)
        end
        lib.callback.await('trappin_gangs:server:drops:unhold', false, playerPos)
        Wait(2000)
        ClearPedTasksImmediately(cache.ped)
        FreezeEntityPosition(cache.ped, false)
    end)
end
local ESX = exports['es_extended']:getSharedObject()

function PrepDataForUI()
    if not Active then
        return
    end
    ui_data.hud_data.time = (Active.hold_time / 1000)
    if #Active.holders == 0 then
        return
    end
    local players = 0
    for k, v in pairs(Active.holders) do
        if v ~= nil then
            players = players + 1
        end
    end
    ui_data.game_data = {
        {
            label = Active.holded_by_name,
            players = 0,
        }
    }
end

UIThread = NewThread(function()
    if not Active or LocalPlayer.state.dead then
        return UIThread.stop()
    end
    Wait(1000)
    PrepDataForUI()
    TriggerEvent('trappin_nui:gamemodes:setData', ui_data)
end)

local inZone = false

RegisterNetEvent('trappin_gangs_client:drops:reset', function()
    Active = nil
    DeleteObject(Drop)
    Drop = nil
    DeleteEntity(Pilot)
    Pilot = nil
    DeleteEntity(Vehicle)
    Vehicle = nil
    RemoveBlip(Blip)
    RemoveBlip(Radius)
    Blip = nil
    Radius = nil
    Flying = false

    dropped = false

    if inZone then
        ClearPedTasksImmediately(cache.ped)
        FreezeEntityPosition(cache.ped, false)
        ui_data = {
            hud_data = {
                label = "",
                time = 0,
                win_points = 0,
                kills = 0,
                next_kill_reward = 0,
                deaths = 0,
            },
            game_data = {},
        }
        TriggerEvent('trappin_nui:gamemodes:setData', ui_data)
        TriggerEvent('trappin_nui:gamemodes:toggle', false)
    end

    if Zone ~= nil then
        Zone:remove()
        Zone = nil
        inZone = false
    end
    
    
end)


AddEventHandler('esx:onPlayerDeath', function(data)
    if not inZone then
        return
    end
    UIThread.stop()
    TriggerEvent('trappin_nui:gamemodes:toggle', false)
end)



lib.callback.register('trappin_gangs:cl:isInDropZone', function()
    return inZone
end)

exports('isInDropZone', function()
    return inZone
end)


RegisterNetEvent('trappin_gangs:client:drops:dropped', function(data, force)
    force = force or false
    if not force then
        if not Active then
            return
        end
        if not Active.coords then
            return
        end
    end
    if not data then
        return
    end
    if force then
        Active = data
    end

    OnGround = true
    ui_data.hud_data.time = Active.hold_time / 1000
    ui_data.hud_data.label = 'Air Drop Event'
    local coords = vector3(Active.coords.x, Active.coords.y, Active.coords.z - 0.5)
    Zone = lib.zones.sphere({
        coords = Active.coords,
        radius = 100.0,
        debug = false,
        onEnter = function()
            UIThread.start()
            inZone = true
            TriggerEvent('trappin_nui:gamemodes:setType', 'drop')
            TriggerEvent('trappin_nui:gamemodes:toggle', true)
        end,
        onExit = function(self)
            UIThread.stop()
            inZone = false
            TriggerEvent('trappin_nui:gamemodes:toggle', false)
        end,
        inside = function(self)
            local playerPos = GetEntityCoords(cache.ped)
            local dist = #(playerPos - coords)
            if dist < 5.0 then
                ShowFloatingHelpNotification(GenerateRandomText(8),
                    "Time left: " .. (Active.hold_time / 1000) .. 'seconds', coords)
            end
            if LocalPlayer.state.dead then
                return
            end
            if dist <= 1.5 then
                if HoldingThread.state then
                    ESX.ShowHelpNotification('Press ~INPUT_VEH_DUCK~ to cancel holding')
                else
                    ESX.ShowHelpNotification('Press ~INPUT_CONTEXT~ to hold the drop')
                end
                if IsControlJustPressed(0, 38) and not HoldingThread.state then
                    HoldingThread.start()
                end
            end
        end
    })
end)

RegisterNetEvent('trappin_gangs:client:drops:killstreak', function(data)
    if not Active then
        return
    end
    ui_data.hud_data.kills = data.kills
    ui_data.hud_data.next_kill_reward = data.next_kill_reward
    TriggerEvent('trappin_nui:gamemodes:setData', ui_data)
end)


RegisterNetEvent('trappin_gangs:client:drops:refresh', function(active)
    if not Active then
        return
    end
    Active = active
end)






ShowFloatingHelpNotification = function(i, msg, coords)
    AddTextEntry('FloatingHelpNotificationsc' .. i, msg)
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z + 0.8)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
    BeginTextCommandDisplayHelp('FloatingHelpNotificationsc' .. i)
    EndTextCommandDisplayHelp(2, false, false, -1)
end
GenerateRandomText = function(length)
    local text = ""
    for i = 1, length do
        text = text .. string.char(math.random(97, 122))
    end
    return text
end

CreateFloatingText = function(args)
    args = args or {}
    args.id = args.id or GenerateRandomText(7)
    args.text = args.text or "Press [E] to interact"
    args.key = args.key or 38
    args.job = args.job or nil
    args.playerJob = args.playerJob or nil
    args.cb = args.cb or function()
        print("You pressed E")
    end
    args.coords = args.coords or vector3(0, 0, 0)

    local self = {}
    self.started = false
    self.Start = function()
        if self.started then return end
        if args.job and args.playerJob ~= args.job then return end
        self.started = true
        CreateThread(function()
            while self.started do
                ShowFloatingHelpNotification(args.id, args.text, args.coords)
                if args.key and IsControlJustPressed(0, args.key) then
                    args.cb()
                    self.started = false
                    break
                end
                Wait(1)
            end
            ClearAllHelpMessages()
        end)
    end
    self.Stop = function()
        self.started = false
        ClearAllHelpMessages()
    end
    return self
end



RegisterNetEvent('esx:playerLoaded', function(xPlayer, isNew, skin)
    TriggerServerEvent('trappin_gangs:sv:drops:sync')
end)
