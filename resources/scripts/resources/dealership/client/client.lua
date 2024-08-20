local Config = Zen.Config.DealerShip
local InsideShop, isModelLoading = false, false
local preview = { dimensions = {} }
local Vehicles = {}

TestingVehicle = false

local camera = nil

local function DeleteCamera(cam)
    if DoesCamExist(cam) then
        RenderScriptCams(false, false, 3000 or 0, false, true)
        SetCamActive(cam, false)
        DestroyCam(cam, false)
        ClearFocus()
    end
end

local function CloseShop()
    lib.hideMenu()

    DisplayRadar(true)
    FreezeEntityPosition(cache.ped, false)
    NetworkSetEntityInvisibleToNetwork(cache.ped, false)

    coords = Config.Coords.Enter 

    SetEntityVisible(cache.ped, true)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, true)

    DeleteCamera(camera)

    InsideShop = false
    DeleteEntity(preview.entity)
end

RegisterCommand('fixdealership', function()
	if not InsideShop then return end
    if isModelLoading then return end
	CloseShop()
end)


local function format(vehicles)
    local format = {}

    for i = 1, #vehicles do
        table.insert(format, ('%s - $%s'):format(vehicles[i].label, Zen.Functions.FormatCommas(vehicles[i].price)))
    end

    return format
end

local function GetVehicle(vehicle, category)
    for i = 1, #Config.Vehicles do
        local categoryData = Config.Vehicles[i]
        if categoryData.name == category then
            if not vehicle then
                vehicle = 1
            end

            return categoryData.vehicles[vehicle]
        end
    end

    return nil
end

local function GetVehicleCategory(vehicle)
    for i = 1, #Config.Vehicles do
        local categoryData = Config.Vehicles[i]
        
        for j = 1, #categoryData.vehicles do 
            if categoryData.vehicles[j].label == vehicle then 
                return categoryData
            end
        end
    end

    return nil
end


exports('GetVehicle', GetVehicle)
exports('GetVehicleCategory', GetVehicleCategory)

RegisterCommand('DoScreenFadeIn', function()
    DoScreenFadeIn(333)
end)

local function PurchaseVehicle(data)
    DoScreenFadeOut(1000)
    Wait(1200)
    
    InsideShop = false

    local props = lib.getVehicleProperties(preview.entity)
    local plate = Zen.Functions.GeneratePlate()
    props.plate = plate

    while DoesEntityExist(preview.entity) do Wait(0) end

    local success = lib.callback.await('vehicleshop:buy', false, props, 'car', data.price, false, data.label)

    if not success then 
        Wait(500)
        DoScreenFadeIn(500)
        return Zen.Functions.Notify('Cant Afford This Vehicle!', 'dollar', '#FF0000')
    end


    local coords = Config.Coords.Spawn

    Zen.Streaming.SpawnVehicle(data.model, coords, coords.w, function(callback)
        lib.setVehicleProperties(callback, props)
        SetPedIntoVehicle(cache.ped, callback, -1)
        FreezeEntityPosition(cache.ped, false)
        SetVehicleNumberPlateText(cache.ped, props.plate)
    end, true, cache.serverId)

    Wait(500)
    DoScreenFadeIn(500)
end

local function TestDriveVehicle()
    TestingVehicle = true
    InsideShop = false

    DoScreenFadeOut(1000)
    Wait(1200)

    DisplayRadar(true)
    FreezeEntityPosition(cache.ped, false)
    NetworkSetEntityInvisibleToNetwork(cache.ped, false)

    DeleteCamera(camera)

    local data = Config.TestDrive
    SetEntityVisible(cache.ped, true)
    SetEntityCoords(cache.ped, data.Coords.x, data.Coords.y, data.Coords.z)

    NetworkSetFriendlyFireOption(false)
    SetLocalPlayerAsGhost(true)
    SetGhostedEntityAlpha(200)

    local model = GetEntityModel(preview.entity)
    if DoesEntityExist(preview.entity) then DeleteEntity(preview.entity) end

    local vehicle = CreateVehicle(model, data.Coords.x, data.Coords.y, data.Coords.z, data.Coords.w, true, true)
    TaskWarpPedIntoVehicle(cache.ped, vehicle, -1)
    SetVehicleNumberPlateText(cache.ped, 'DEALER')
    SetVehicleDoorsLocked(vehicle, 2)
    SetVehicleDoorsLockedForAllPlayers(vehicle, true)

    Wait(500)
    DoScreenFadeIn(500)

    local timer = data.Timer * 60
    Zen.Functions.NUI('showRobberyUI', {
        label = 'Test Drive'
    })

    while timer > 0 do
        Wait(1000)

        timer -= 1

        if cache.seat ~= -1 then
            timer = 0
            Wait(100)
            DeleteEntity(vehicle)
        end

        Zen.Functions.NUI('updateRobberyUI', {
            timer = timer
        })
    end

    TestingVehicle = false
    Zen.Functions.NUI('hideRobberyUI', {})
    DoScreenFadeOut(500)
    Wait(500)

    local coords = Config.Coords.Enter

    if DoesEntityExist(vehicle) then DeleteEntity(vehicle) end
    NetworkSetFriendlyFireOption(true)
    SetLocalPlayerAsGhost(false)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, true)

    Wait(1000)
    DoScreenFadeIn(500)
end

local function PreviewVehicle(vehicle, category)
    local data = GetVehicle(vehicle, category)
        
    if data and IsModelInCdimage(data.model) then 
        isModelLoading = true

        if DoesEntityExist(preview.entity) then
            while DoesEntityExist(preview.entity) do 
                Wait(0) 
                DisableAllControlActions(0) 
                DeleteEntity(preview.entity) 
            end
        end

        if IsModelInCdimage(data.model) then 
            local waiter = GetGameTimer()
            RequestModel(data.model)

            while not HasModelLoaded(data.model) do
                Wait(0)

                if (GetGameTimer() - waiter) >= 10000 then
                    isModelLoading = false
                    Zen.Functions.Notify(('Failed To Load Model %s (10 secs)'):format(vehicleData.model), 'xmark', '#FF0000')
                    break
                end

                RequestModel(data.model)
            end

            if (GetGameTimer() - waiter) < 10000 then
                SetEntityAsMissionEntity(preview.entity, true, true)
                DeleteVehicle(preview.entity)

                if not InsideShop then return end

                local coords = Config.Coords.Vehicle
                local entity = CreateVehicle(data.model, coords.x, coords.y, coords.z, coords.w, false, false)
                preview.entity = entity
                preview.price = data.price
                preview.name = data.label

                while not DoesEntityExist(entity) do
                    Wait(0)
                    DisableAllControlActions(0)
                end

                SetVehicleDirtLevel(entity, 0)
                TaskWarpPedIntoVehicle(entity, cache.ped, -1)
                FreezeEntityPosition(entity, true)
                isModelLoading = false
            end
        else
            Zen.Functions.Notify(('This Model Is Not Valid: %s'):format(data.model), 'xmark', '#FF0000')
        end
    end
end

lib.registerMenu({
    id = 'vehicleshop-selected',
    title = 'Vehicle Selected',
    position = 'bottom-right',
    options = {},
    onClose = function()
        lib.showMenu('vehicleshop')
    end
}, function(select, scroll, args)
    if not args then return end
    
    if args.action == 'purchase' then 
        PurchaseVehicle(args.vehicle)
    elseif args.action == 'test-drive' then 
        TestDriveVehicle()
    end
end)

local function SelectVehicle(vehicle, category)
    local data = GetVehicle(vehicle, category)
    if not data then return end

    if GetEntityModel(preview.entity) ~= GetHashKey(data.model) then return end

    local CDATA = GetVehicleCategory(data.label)
    if CDATA.role and not Zen.Functions.IsRolePresent(CDATA.role) then
        return Zen.Functions.Notify('You Can\'t Access This Category', 'vehicle', '#FF0000')
    end

    local menu = {
        { 
            icon = 'dollar', 
            label = 'Purchase Vehicle',
            args = {
                action = 'purchase',
                vehicle = data
            }
        },
        { 
            icon = 'car', 
            label = 'Test Drive Vehicle',
            args = {
                action = 'test-drive',
                vehicle = data
            }
        }
    }

    lib.setMenuOptions('vehicleshop-selected', menu)
    lib.hideMenu()
    Wait(300)
    lib.showMenu('vehicleshop-selected')
end

lib.registerMenu({
    id = 'vehicleshop',
    title = 'Vehicle Shop',
    position = 'bottom-right',
    options = {},
    onSideScroll = function(select, scroll, args)
        if isModelLoading then return end
        PreviewVehicle(scroll, args.category)
    end,
    onSelected = function(select, scroll, args)
        if isModelLoading then return end
        PreviewVehicle(scroll, args.category)
    end,
    onClose = function()
        if not DoesEntityExist(preview.entity) then 
            return lib.showMenu('vehicleshop') 
        end

        InsideShop = false
    end,
}, function(select, scroll, args)
    SelectVehicle(scroll, args.category)
end)

local function OpenVehicleShopMenu()
    InsideShop = true

    DisplayRadar(false)
    NetworkSetEntityInvisibleToNetwork(cache.ped, true)
    SetEntityVisible(cache.ped, false)

    local coords = Config.Coords.Vehicle
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, true)
    FreezeEntityPosition(cache.ped, true)

    DoScreenFadeOut(300)
    Wait(200)

    SetTimeout(300, function() lib.showMenu('vehicleshop') end)
    while not DoesEntityExist(preview.entity) do Wait(100) end

    coords = Config.Coords.Camera
    camera = CreateCamWithParams('DEFAULT_SCRIPTED_CAMERA', coords.x, coords.y, coords.z + 0.80, 0, 0, 0, 60.0, false, 2)

    SetCamAffectsAiming(camera, false)
    PointCamAtEntity(camera, preview.entity, 0.0, 0.0, 0.0, true)
    SetCamActive(camera, true)
    RenderScriptCams(true, false, 3000, true, true)

    DoScreenFadeIn(1000)

    while InsideShop do 
        if DoesEntityExist(preview.entity) then

            if not preview.dimensions[preview.name] then
                local model = GetEntityModel(cache.vehicle)
                local dimensions = GetModelDimensions(model)

                preview.dimensions[preview.name] = GetEntityCoords(preview.entity) + vec3(0.0, 0.0, dimensions.z + 3.5)
            end

            SetEntityHeading(preview.entity, GetEntityHeading(preview.entity) + 0.1)
        end

        Wait(0)
    end

    if TestingVehicle then return end

    CloseShop()
end

local point = lib.points.new(Config.Coords.Enter, 5)    
    
function point:nearby()
    if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
        OpenVehicleShopMenu()
    end

    Zen.Functions.FloatText(Config.Coords.Enter, '[E] - Vehicle Shop')
end

Zen.Functions.CreateBlip(Config.Coords.Enter, Config.Blip)

for key, value in next, Config.Vehicles do
    if not value.name then
        return warn(('Invalid category name received for index "%s"'):format(key))
    end

    if value.vehicles and type(value.vehicles) == 'table' and table.type(value.vehicles) ~= 'empty' then
        Vehicles[#Vehicles+1] =  {
            label = value.label,
            values = format(value.vehicles),
            icon = value.name ~= 'motorcycles' and 'car' or 'motorcycle',
            close = false,
            args = { category = value.name }
        }
    end
end

lib.setMenuOptions('vehicleshop', Vehicles)