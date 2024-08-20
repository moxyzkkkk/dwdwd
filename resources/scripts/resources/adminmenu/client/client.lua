local Config = Zen.Config.AdminMenu
local IsAdmin = false
local spectating, noclipping = false, false
local AdminPerms = nil
local BanLengths = {}
local allowedCars = {}

local onlinePlayerOptions = {
    { label = 'Kick', icon = 'arrow-right', args = { action = 'kick' }, close = false },
    { label = 'Ban', icon = 'ban', values = BanLengths, args = { action = 'ban' }, close = false },
    { label = 'Teleport', icon = 'right-left', values = { 'Goto', 'Bring' }, args = { action = 'teleport' }, close = false },
    { label = 'Frozen', icon = 'snowflake', values = { 'Freeze', 'Unfreeze' }, args = { action = 'freeze' }, close = false },
    { label = 'Spectate', icon = 'eye', args = { action = 'spectate' }, close = false },
    { label = 'Revive', icon = 'heart-pulse', args = { action = 'revive' }, close = false }
}

local cachedPlayerOptions = {
    { label = 'Offline Ban', icon = 'ban', values = BanLengths, args = { action = 'offlineban' }, close = false }
}

local manageServerOptions = {
    { label = 'Teleport To Marker', icon = 'location-dot', args = { action = 'tpm' }, close = false },
    { label = 'Entity Wipe', icon = 'broom', values = { 'Car Wipe', 'Entity Wipe' }, args = { action = 'entitywipe' }, close = false },
    { label = 'Unban Player', icon = 'user-gear', args = { action = 'unban' }, close = false },
    { label = 'Copy Coords', icon = 'thumbtack', values = { 'vec3()', 'vec4()', '{ x = , y = , z =  }' }, args = { action = 'coords' }, close = false }
}

local vehicleOptions = {
    { label = 'Spawn Car', icon = 'car-on', args = { action = 'spawnvehicle' }, close = false },
    { label = 'Repair Car', icon = 'wrench', args = { action = 'repairvehicle' }, close = false },
    { label = 'Clean Car', icon = 'hand-sparkles', args = { action = 'cleanvehicle' }, close = false },
    { label = 'Flip Car', icon = 'rotate', args = { action = 'flipvehicle' }, close = false },
    { label = 'Delete Car', icon = 'x', args = { action = 'deletevehicle' }, close = false },
}

local selfOptions = {
    { label = 'Heal', values = { 'Health', 'Armour' }, args = { action = 'heal' }, close = false },
    { label = 'GodMode', args = { action = 'godmode' }, close = false, checked = false },
    { label = 'Invisible', args = { action = 'invisible' }, close = false, checked = false }
}

local playerPerms, cachedPerms = {}, {}

local function generateMenuOptions(options, permissions)
    local perms = {}
    for i = 1, #options do
        if Zen.Functions.Admin.Allowed(options[i].args.action) then
            perms[#perms + 1] = options[i]
        end
    end

    if #perms <= 0 then
        perms[#perms + 1] = {
            label = 'You Cant Do Anything!',
            close = false
        }
    end

    return perms
end

lib.callback.register('admin:give', function(type, data)
    if type == 'money' then 
        local input = lib.inputDialog('Give/Set Money', {
            {type = 'number', required = true, label = 'Player ID'},
            {type = 'select', label = 'Type', required = true, options = { { label = 'Set Money', value = 'set' }, { label = 'Give Money', value = 'give'}}},
            {type = 'select', label = 'Account', required = true, options = { {label = 'Bank', value = 'bank'}, {label = 'Cash', value = 'money'}, {label = 'Dirty', value = 'black_money'} }},
            {type = 'number', label = 'Amount', required = true, min = 1 },
        })

        return input

    elseif type == 'item' then 
        local input_options = {}

        input_options[#input_options+1] = { type = 'number', label = 'Player ID', required = true }

        if table.type(data) ~= 'empty' then 
            local items = {}

            for i = 1, #data do
                items[#items+1] = {
                    label = Zen.Items[data[i]].label,
                    value = data[i]
                }
            end

            input_options[#input_options+1] = { type = 'select', label = 'Item', options = items }
        else
            input_options[#input_options+1] = { type = 'input', placeholder = 'armour', label = 'Item', required = true }
        end
            
        input_options[#input_options+1] = {type = 'number', label = 'Amount', default = 1}

        local input = lib.inputDialog('Give Item', input_options)

        return input

    elseif type == 'weapon' then 
        local input_options = {}

        input_options[#input_options+1] = { type = 'number', label = 'Player ID', required = true }

        if table.type(data) ~= 'empty' then 
            local weapons = {}

            for i = 1, #data do
                weapons[#weapons+1] = {
                    label = Zen.Weapons[data[i]],
                    value = data[i]
                }
            end

            input_options[#input_options+1] = { type = 'select', label = 'Weapon', options = weapons }
        else
            input_options[#input_options+1] = { type = 'input', placeholder = 'weapon_appistol', label = 'Weapon', required = true }
        end
            
        input_options[#input_options+1] = {type = 'number', label = 'Ammo', default = 500}

        local input = lib.inputDialog('Give Weapon', input_options)

        return input

    elseif type == 'vehicle' then
        local vehicle = exports.scripts:GetVehicle(data.vehicle, data.category)
        if vehicle == nil then return false end

        local props

        Zen.Streaming.SpawnVehicle(vehicle.model, vec3(cache.coords.x, cache.coords.y, cache.coords.z + 6.0), GetEntityHeading(cache.ped), function(callback)
            SetEntityLocallyInvisible(callback)
            props = lib.getVehicleProperties(callback)
            SetTimeout(100, function()
                DeleteVehicle(callback)
            end)
        end, false, false)

    
        local plate = Zen.Functions.GeneratePlate()
        props.plate = plate

        return { vehicle = vehicle, props = props }
    end
end)

lib.callback.register('admin:car', function(model)
    if not IsModelInCdimage(joaat(model)) then 
        Zen.Functions.Notify('Thats Not A Valid Model!', 'car', '#FF0000')
        return false
    end

    if table.type(allowedCars) ~= 'empty' then 
        local proceed = false

        for i = 1, #allowedCars do 
            if allowedCars[i].value == model then 
                proceed = true
            end
        end

        if proceed == false then 
            return Zen.Functions.Notify('You Can\'t Spawn This!', 'car', '#FF0000')
        end
    end

    if cache.seat and cache.seat == -1 then 
        local netId = NetworkGetNetworkIdFromEntity(cache.vehicle)
        if not NetworkDoesNetworkIdExist(netId) then return end
        
        DeleteEntity(cache.vehicle)
    end

    Zen.Streaming.SpawnVehicle(model, GetEntityCoords(cache.ped), GetEntityHeading(cache.ped), function(callback)
        TaskWarpPedIntoVehicle(cache.ped, callback, -1)
    end, true, false)

    return true
end)

AddEventHandler('playerLoaded', function()
    local data = lib.callback.await('admin:server:callback', false, 'perms')

    if data ~= nil then 
        IsAdmin = true
        AdminPerms = data

        for key, value in pairs(Config.Bans.Lengths) do
            table.insert(BanLengths, { label = key, value = value })
        end

        for k,v in pairs(Config.SpawnCar) do 
            allowedCars[#allowedCars+1] = {
                label = v,
                value = k 
            }
        end
    
        table.sort(BanLengths, function(a, b) return a.value < b.value end)

        playerPerms = generateMenuOptions(onlinePlayerOptions)
        cachedPerms = generateMenuOptions(cachedPlayerOptions)

        lib.setMenuOptions('admin-manage-server', generateMenuOptions(manageServerOptions))
        lib.setMenuOptions('admin-vehicle-options', generateMenuOptions(vehicleOptions))
        lib.setMenuOptions('admin-self-options', generateMenuOptions(selfOptions))
    end
end)

local function openMenu(menu)
    lib.showMenu(menu)    
end

Zen.Functions.Admin = {}

Zen.Functions.Admin.Allowed = function(perm)
    return (AdminPerms and AdminPerms[perm] and true) or false 
end

exports('Admin', function()
    return Zen.Functions.Admin
end)

local function TPM()
    if not Zen.Functions.Admin.Allowed('tpm') then return end

    local WaypointHandle = GetFirstBlipInfoId(8)

    if DoesBlipExist(WaypointHandle) then
        local WaypointVec3 = GetBlipInfoIdCoord(WaypointHandle)

        for Height = 1, 1000 do
            SetPedCoordsKeepVehicle(cache.ped, WaypointVec3.x, WaypointVec3.y, Height + 0.0)
            if GetGroundZFor_3dCoord(WaypointVec3.x, WaypointVec3.y, Height + 0.0) then
                SetPedCoordsKeepVehicle(cache.ped, WaypointVec3.x, WaypointVec3.y, Height + 0.0)
                break
            end

            Wait(0)
        end
        Zen.Functions.Notify('Teleported To Marker!', 'check', '#00FF00')
    else
        Zen.Functions.Notify('No Waypoint Set!', 'ban', '#FF0000')
    end
end

local function StopSpectate()
    RequestCollisionAtCoord(spectating.vec3)
    NetworkSetInSpectatorMode(false, cache.ped)
    FreezeEntityPosition(cache.ped, false)
    SetEntityCoords(cache.ped, spectating.vec3)
    SetEntityHeading(cache.ped, spectating.heading)
    SetEntityVisible(cache.ped, true)       
end

RegisterCommand(Config.OpenMenu.Command, function()
    if not IsAdmin then return end

    if lib.getOpenMenu() == 'admin-main' then return end
    lib.showMenu('admin-main')
end)

lib.addKeybind({
    name = Config.OpenMenu.Command,
    description = 'press F9 to open admin',
    defaultKey = Config.OpenMenu.Keybind,
    onReleased = function(self)
        ExecuteCommand(Config.OpenMenu.Command)
    end
})

lib.registerMenu({
    id = 'admin-online-players',
    title = 'Online Players', 
    position = 'top-right',
    options = {},
    onClose = function() lib.showMenu('admin-player-list') end
    
}, function(_, _, args)
    if args then 
        local selectedMenu = 'admin-selected-player-'..args.id

        lib.registerMenu({
            id = selectedMenu,
            title = 'Viewing '..args.name..' (ID: '..args.id..')', 
            position = 'top-right',
            options = playerPerms,
            onClose = function() lib.showMenu('admin-online-players') end
        }, function(_, scroll2, args2)
            local action = args2.action
            if args2 and action then 
                if action == 'kick' then
                    lib.hideMenu(selectedMenu)
                    Wait(250)
                    
                    local reason = lib.inputDialog(action..'ing'..args.name..' (ID: '..args.id..')', { 'Reason' })

                    if reason and reason[1] ~= '' then
                        ExecuteCommand('kick '.. args.id ..' ' .. table.concat(reason, " "))
                    else
                        Zen.Functions.Notify('Please put a reason!', 'ban', '#FF0000')
                    end
                    
                    Wait(250)
                    lib.showMenu(selectedMenu)

                elseif action == 'ban' then 
                    lib.hideMenu(selectedMenu)
                    Wait(250)
                    
                    local reason = lib.inputDialog(action..'ing '..args.name..' (ID: '..args.id..')', { 'Reason' })
                    
                    if reason and reason[1] ~= '' then
                        ExecuteCommand('ban '.. args.id ..' ' .. table.concat(reason, " ") .. ' ' ..tostring(BanLengths[scroll2].value))
                    else
                        Zen.Functions.Notify('Please put a reason!', 'ban', '#FF0000')
                    end
                    
                    Wait(250)
                    lib.showMenu(selectedMenu)
                

                elseif action == 'teleport' then
                    if scroll2 == 1 then 
                        ExecuteCommand('goto '..args.id)
                    elseif scroll2 == 2 then 
                        ExecuteCommand('bring '..args.id)
                    end

                elseif action == 'freeze' then
                    ExecuteCommand('freeze '..args.id..' '..tostring(action == 'freeze' and scroll2 == 1))

                elseif action == 'spectate' then
                    if spectating == false then

                        spectating = {
                            vec3 = (GetEntityCoords(cache.ped) - vec3(0.0, 0.0, 1.0)),
                            heading = GetEntityHeading(cache.ped)
                        }

                        local pedCoords = lib.callback.await('admin:server:callback', false, 'coords', { target = args.id })
                        if pedCoords == nil then return Zen.Functions.Notify('This Player Isn\'t Online Anymore!', 'user', '#FF0000') end

                        lib.showTextUI('Hold [E] To Stop')
                        RequestCollisionAtCoord(pedCoords)
                        SetEntityVisible(cache.ped, false)
                        SetEntityCoords(cache.ped, pedCoords.x, pedCoords.y, pedCoords.z - 2.5)

                        Wait(500)

                        FreezeEntityPosition(cache.ped, true)
                        NetworkSetInSpectatorMode(true, GetPlayerPed(GetPlayerFromServerId(args.id)))
                        
                        CreateThread(function()
                            while spectating ~= args.id and GetPlayerFromServerId(args.id) ~= -1 do
                                pedCoords = GetEntityCoords(GetPlayerPed(GetPlayerFromServerId(args.id)))
                                SetEntityCoords(cache.ped, pedCoords.x, pedCoords.y, pedCoords.z - 2.5)
                                if IsControlPressed(0, 38) then
                                    lib.hideTextUI()
                                    StopSpectate()
                                    spectating = args.id
                                end
                                Wait(500)
                            end
                            
                            if spectating ~= args.id then
                                StopSpectate()                     
                                Zen.Functions.Notify('This Player Isn\'t Online Anymore!', 'xmark', '#FF0000')
                            end
                            lib.hideTextUI()
                            spectating = false
                        end)
                    else
                        lib.hideTextUI()
                        StopSpectate()
                        spectating = args.id
                    end
                elseif action == 'revive' then 
                    ExecuteCommand('revive '..args.id)
                end
            end
        end)

        lib.showMenu(selectedMenu)
    end
end)

lib.registerMenu({
    id = 'admin-cached-players',
    title = 'Cached Players', 
    position = 'top-right',
    options = {},
    onClose = function() lib.showMenu('admin-player-list') end
}, function(_, _, args)
    if args then 
        local selectedMenu = 'admin-selected-player2-'..args.id

        lib.registerMenu({
            id = selectedMenu,
            title = 'Viewing '..args.name..' (ID: '..args.id..')', 
            position = 'top-right',
            options = cachedPerms,
            onClose = function() lib.showMenu('admin-cached-players') end
        }, function(_, scroll2, args2)
            local action = args2.action
            if args2 and action then 
                if action == 'offlineban' then
                    lib.hideMenu(selectedMenu)
                    Wait(250)
                    
                    local reason = lib.inputDialog(action..'ing'..args.name..' (ID: '..args.id..')', { 'Reason' })

                    if reason and reason[1] ~= '' then
                        ExecuteCommand('offlineban '.. args.identifier ..' ' .. table.concat(reason, " ") .. ' ' ..tostring(BanLengths[scroll2].value))
                    else
                        Zen.Functions.Notify('Please put a reason!', 'ban', '#FF0000')
                    end
                    
                    Wait(250)
                    lib.showMenu(selectedMenu)
                end
            end
        end)

        lib.showMenu(selectedMenu)
    end

end)

lib.registerMenu({
    id = 'admin-player-list',
    title = 'Server Player List',
    position = 'top-right',
    options = {
        { icon = 'users', label = 'Online Players', args = { menu = 'online' } },
        { icon = 'xmark', label = 'Cached Players', args = { menu = 'cached' } }
    },
    onClose = function() lib.showMenu('admin-main') end
}, function(_,_,args)
    if args and args.menu then
        local PlayersTable = {}
        local players = lib.callback.await('admin:server:callback', false, args.menu)
        
        for key, value in pairs(players) do
            if value ~= nil then
                PlayersTable[#PlayersTable + 1] = {
                    icon = (value.staff and 'star') or 'user',
                    label = '[ID: ' .. value.id .. '] '..value.name,
                    args = value
                }
            end
        end
        
        if #PlayersTable <= 0 then
            PlayersTable[#PlayersTable + 1] = {
                label = 'No Players Found',
                close = false
            }
        else
            table.sort(PlayersTable, function(a, b) return a.args.id < b.args.id end)
        end

        lib.setMenuOptions('admin-'..args.menu..'-players', PlayersTable)
        lib.showMenu('admin-'..args.menu..'-players')
    end
end)

lib.registerMenu({
    id = 'admin-manage-server',
    title = 'Manage Server',
    position = 'top-right',
    options = {},
    onClose = function() lib.showMenu('admin-main') end
}, function(_,scroll,args)
    if args and args.action then 
        local action = args.action

        if action == 'tpm' then
            ExecuteCommand('tpm')
        elseif action == 'entitywipe' then 
            ExecuteCommand('entitywipe '..scroll)
        elseif action == 'unban' then 
            lib.hideMenu('admin-manage-server')
            Wait(250)

            local input = lib.inputDialog('Unban Player', { 'License' })

            if not input then return end

            ExecuteCommand('unban '..input[1])

            Wait(250)
            lib.showMenu('admin-manage-server')
        elseif action == 'coords' then 
            lib.hideMenu('admin-manage-server')
            Wait(250)
            local coords = { x = (math.floor(GetEntityCoords(cache.ped).x * 100) / 100), y = (math.floor(GetEntityCoords(cache.ped).y * 100) / 100), z = (math.floor(GetEntityCoords(cache.ped).z * 100) / 100), w = (math.floor(GetEntityHeading(cache.ped) * 100) / 100) }

            local text = nil

            if scroll == 1 then 
                text = 'vec3('..coords.x..', '..coords.y..', '..coords.z..')'
            elseif scroll == 2 then 
                text = 'vec4('..coords.x..', '..coords.y..', '..coords.z..', '..coords.w..')'
            elseif scroll == 3 then 
                text = '{ x = '..coords.x..', y = '..coords.y..', z = '..coords.z..' }'
            end

            lib.setClipboard(text)

            Wait(250)
            lib.showMenu('admin-manage-server')
        end
    end
end)

lib.registerMenu({
    id = 'admin-vehicle-options',
    title = 'Vehicle Options',
    position = 'top-right',
    options = {},
    onClose = function() lib.showMenu('admin-main') end,
}, function(_,_,args)
    if args and args.action then
        local action = args.action
        local vehicle = cache.vehicle

        if vehicle == false and action ~= 'spawnvehicle' then
            return Zen.Functions.Notify('You\'re Not In A Vehicle!', 'car', '#FF0000')
        end

        if action == 'spawnvehicle' then
            lib.hideMenu('admin-vehicle-options')
            Wait(250)

            local input_options = {}

            if table.type(allowedCars) ~= 'empty' then 
                input_options[#input_options+1] = { type = 'select', label = 'Vehicle', options = allowedCars }
            else
                input_options[#input_options+1] = { type = 'input', label = 'Vehicle' }
            end
                
            local input = lib.inputDialog('Spawn Car', input_options)

            if not input then Wait(250) lib.showMenu('admin-vehicle-options') return end

            ExecuteCommand('car '..input[1])

            Wait(250)
            lib.showMenu('admin-vehicle-options')
            
        elseif action == 'repairvehicle' then 
            SetVehicleEngineHealth(vehicle, 1000)
            SetVehicleEngineOn(vehicle, true, true)
            SetVehicleFixed(vehicle)
        elseif action == 'cleanvehicle' then
            SetVehicleDirtLevel(vehicle, 0)
        elseif action == 'flipvehicle' then
            local CarRotation = GetEntityRotation(vehicle, 2)
            SetEntityRotation(vehicle, CarRotation[1], 0, CarRotation[3], 2, true)
            SetVehicleOnGroundProperly(vehicle)
        elseif action == 'deletevehicle' then
            DeleteEntity(vehicle)
        end
    end
end)

lib.registerMenu({
    id = 'admin-self-options',
    title = 'Self Options',
    position = 'top-right',
    options = {},
    onClose = function() lib.showMenu('admin-main') end,
    onCheck = function(_, checked, args)
        if args and args.action then
            local action = args.action
            local ped = cache.ped

            if action == 'godmode' then
                SetEntityInvincible(ped, checked)
            elseif action == 'invisible' then
                SetEntityVisible(ped, not checked)
            end
        end
    end
}, function(_,scroll,args)
    if args and args.action then 
        local action = args.action

        if action == 'heal' then 
            if scroll == 1 then 
                SetEntityHealth(cache.ped, 200)
            elseif scroll == 2 then
                SetPedArmour(cache.ped, 100)
            end
        end
    end
end)

lib.registerMenu({
    id = 'admin-main',
    title = 'Admin Menu', 
    position = 'top-right',
    options = {
        { icon = 'users', label = 'Players List', args = { menu = 'admin-player-list' } },
        { icon = 'gear', label = 'Manage Server', args = { menu = 'admin-manage-server' } },
        { icon = 'car', label = 'Vehicle Options', args = { menu = 'admin-vehicle-options' } },
        { icon = 'user', label = 'Self Options', args = { menu = 'admin-self-options' } },
    }
}, function(_, _, args)
    if not IsAdmin then return end

    if args and args.menu then 
        openMenu(args.menu)
    end
end)

local NoClipBinds = { W = false, S = false, LShift = false }

RegisterCommand('heal', function()
    if not Zen.Functions.Admin.Allowed('heal') then return end

    SetEntityHealth(cache.ped, 200)
    SetPedArmour(cache.ped, 100)
end)

RegisterCommand('tpm', TPM)

RegisterCommand('noclip', function()
    if not Zen.Functions.Admin.Allowed('noclip') then return end

    noclipping = not noclipping
    CreateThread(function()
        SetEntityVisible(cache.ped, false, false)
        SetEntityInvincible(cache.ped, true)
        SetEntityCollision(cache.ped, false, false)
        FreezeEntityPosition(cache.ped, true)
        local PiDivided = (math.pi / 180.0)

        while noclipping do
            Wait(10)
            if NoClipBinds.W or NoClipBinds.S then
                local HeadingOffset = (GetGameplayCamRelativeHeading() + GetEntityHeading(cache.ped)) * PiDivided
                local CoordsOffsetX = -math.sin(HeadingOffset)
                local CoordsOffsetY = math.cos(HeadingOffset)
                local CoordsOffsetZ = (GetGameplayCamRelativePitch() * PiDivided)
                local PedCoords = GetEntityCoords(cache.ped)
                local Speed = ((NoClipBinds.LShift and 4.0) or 1.0)
                local Coords = { x = PedCoords.x, y = PedCoords.y, z = PedCoords.z }

                if NoClipBinds.W then
                    Coords.x = (Coords.x + Speed * CoordsOffsetX)
                    Coords.y = (Coords.y + Speed * CoordsOffsetY)
                    Coords.z = (Coords.z + Speed * CoordsOffsetZ)

                elseif NoClipBinds.S then
                    Coords.x = (Coords.x - Speed * CoordsOffsetX)
                    Coords.y = (Coords.y - Speed * CoordsOffsetY)
                    Coords.z = (Coords.z - Speed * CoordsOffsetZ)

                end

                SetEntityCoordsNoOffset(cache.ped, Coords.x, Coords.y, Coords.z, true, true, true)
            else
                Wait(50)
            end
        end

        SetEntityVisible(cache.ped, true, true)
        SetEntityInvincible(cache.ped, false)
        SetEntityCollision(cache.ped, true, true)
        FreezeEntityPosition(cache.ped, false)
    end)
end)

for bind in pairs(NoClipBinds) do
    lib.addKeybind({
        name = 'admin:binds:'..bind..':'..GetGameTimer(),
        description = 'NoClip Bind ('..bind..')',
        defaultKey = bind,
        onPressed = function()
            NoClipBinds[bind] = true    
        end,
        onReleased = function()
            NoClipBinds[bind] = false
        end
    })
end