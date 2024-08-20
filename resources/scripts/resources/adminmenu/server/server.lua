local PlayersTable, OfflineTable, AdminsTable, FrozenPlayers = {}, {}, {}, {}
local SendBackCoords = {}
local Config = Zen.Config.AdminMenu

AddEventHandler('playerConnecting', function(name, setKickReason, deferrals)
    local player = tonumber(source)
    local identifier = Zen.Functions.GetIdentifier(player, 'license')

    deferrals.defer()
    Wait(0)

    if not identifier then 
        deferrals.done('\n\nUnable to Connect to Server!\n\nReason: Rockstar License Not Found')
        return
    end

    Wait(0)

    deferrals.update(identifier)

    Wait(0)

    local osTime = os.time()
    local ban_data = json.decode(MySQL.scalar.await('SELECT ban_data FROM users WHERE identifier = ?', { identifier }))

    if ban_data ~= nil and ban_data ~= 'NULL' and ban_data.unban.time <= osTime then
        MySQL.update.await('UPDATE users SET ban_data = ? WHERE identifier = ?', { nil, identifier })
        ban_data = nil
    end

    if ban_data ~= nil and ban_data ~= 'NULL' then
        deferrals.done(('\n\nYou are Currently Banned from %s!\n\nAdmin: %s\nReason: %s\nUnban: %s\n\nLicense: %s'):format(Zen.Config.Server.ServerName, ban_data.admin, ban_data.reason, ban_data.unban.label, identifier))
        return
    end

    deferrals.done()
end)

AddEventHandler('playerLoaded', function(player)
    if PlayersTable[player] ~= nil then return end

    PlayersTable[player] = {
        name = GetPlayerName(player),
        identifier = Zen.Functions.GetIdentifier(player, 'license'),
        id = player
    }

    OfflineTable[PlayersTable[player].identifier] = nil

    local AdminPerms, AdminRoles = {}, {}

    for key, value in pairs(Zen.Functions.Admin.Config.Permissions) do 
        if Zen.Functions.Discord.HaveRole(player, key) then 
            AdminRoles[key] = value 
        end
    end

    if table.type(AdminRoles) ~= 'empty' then 
        for key, value in pairs(AdminRoles) do 
            for i = 1, #value do 
                local perm = value[i]
                if not AdminPerms[perm] then
                    AdminPerms[perm] = true
                end
            end
        end
        
        for i = 1, #Zen.Functions.Admin.Config.SharedPerms do 
            local sharedPerm = Zen.Functions.Admin.Config.SharedPerms[i]
            if not AdminPerms[sharedPerm] then
                AdminPerms[sharedPerm] = true
            end
        end
    
        AdminsTable[player] = AdminPerms
        PlayersTable[player].staff = true
    end

    Player(player).state:set('active', true, false)
end)

AddEventHandler('playerDropped', function (reason)
    local player = PlayersTable[source]

    if player ~= nil then 
        OfflineTable[player.identifier] = player
        PlayersTable[source] = nil 
    end

    Player(source).state:set('active', false, false)

    if Zen.Functions.Admin.Config.ConsolePrints then 
        print('Player ' .. GetPlayerName(source) .. ' (ID: '..source..') diconnected (Reason: ' .. reason .. ')')
    end
end)

lib.callback.register('admin:server:callback', function(source, call, data)
    if call == 'online' then 
        return PlayersTable
    elseif call == 'cached' then 
        return OfflineTable
    elseif call == 'coords' then 
        return (GetPlayerName(data.target) and GetEntityCoords(GetPlayerPed(data.target))) or nil
    elseif call == 'perms' then 
        if AdminsTable[source] ~= nil then 
            return AdminsTable[source]
        end

        return nil
    end
end)

Zen.Functions.Admin = {}

Zen.Functions.Admin.Allowed = function(player, perm)
    return (AdminsTable[player] and AdminsTable[player][perm] and true) or false 
end

Zen.Functions.Admin.Immune = function(admin, target, action)
    if Zen.Functions.Admin.Allowed(target, 'immune') then
        Zen.Functions.Notify(admin, 'This Player Is Immune!', 'ban', '#FF0000')
        Zen.Functions.Notify(target, PlayersTable[admin].name..' (ID: '..admin..') Tried To '..action..' You!', 'ban', '#FF0000')
        return true
    end

    return false
end

Zen.Functions.Admin.LogFormats = function(data, player)
    if data.admin and data.target then 
        local discord = { admin = Zen.Functions.GetIdentifier(data.admin, 'discord') or 'None', target = Zen.Functions.GetIdentifier(data.target, 'discord') or 'None' }
        return ('**Player:** %s (ID: %s)\n> `%s`\n> <@%s>\n\n**'..(player and "Source" or "Admin")..':** %s (ID: %s)\n> `%s`\n> <@%s>\n'):format(PlayersTable[data.target].name, data.target, PlayersTable[data.target].identifier, discord.target, PlayersTable[data.admin].name, data.admin, PlayersTable[data.admin].identifier, discord.admin)
    elseif data.admin then 
        local discord = Zen.Functions.GetIdentifier(data.admin, 'discord') or 'None'
        return ('**'..(player and "Player" or "Admin")..':** %s (ID: %s)\n> `%s`\n> <@%s>\n'):format(PlayersTable[data.admin].name, data.admin, PlayersTable[data.admin].identifier, discord)        
    end
end

Zen.Functions.Admin.Config = Zen.Config.ServerAdminMenu

exports('Admin', function()
    return Zen.Functions.Admin
end)

local function ConsoleLog(log)
    print('^3[ADMIN-MENU]^7 '..log)
end

local function CheckPermissionsAndNotify(source, permission)
    if source == nil or source <= 0 then return false end
    if not Zen.Functions.Admin.Allowed(source, permission) then
        Zen.Functions.Notify(source, 'Invalid Permissions!', 'xmark', '#FF0000')
        return false
    end
    return true
end

local function GetTargetPlayer(source, playerId, esx)
    local target = nil
    
    if esx then 
        target = ESX.GetPlayerFromId(playerId)
    else 
        target = PlayersTable[tonumber(playerId)]
    end

    if not target then
        Zen.Functions.Notify(source, 'Player Not Online!', 'xmark', '#FF0000')
    end

    return target
end

local Notification = {
    Alert = function(target, admin, message)
        Zen.Functions.Admin.Config.ChatMessages.Alert({ 
            target = target,
            admin = GetPlayerName(admin).. '(ID: '..admin..')',
            message = message
        })
    end,

    Notice = function(to, message)
        Zen.Functions.Admin.Config.ChatMessages.Notice({ 
            target = to,
            message = message
        })
    end,
}

RegisterCommand('entitywipe', function(source, args)
    if not args[1] then 
        return Zen.Functions.Notify(source, 'Invalid Usage : /entitywipe [type] 1 = Cars, 2 = Entity', 'xmark', '#FF0000')
    else
        local type = tonumber(args[1])

        if type ~= 1 and type ~= 2 then 
            return Zen.Functions.Notify(source, 'Invalid Usage : /entitywipe [type] 1 = Cars, 2 = Entity', 'xmark', '#FF0000')
        end
    end

    local info = {
        type = (tonumber(args[1]) == 1 and 'Car') or (tonumber(args[1]) == 2 and 'Entity'),
        admin = GetPlayerName(source)
    };
    
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['entitywipe'], 'Triggered '..info.type..' Wipe', Zen.Functions.Admin.LogFormats({ admin = source }))

    Zen.Functions.Admin.Config.ChatMessages.EntityWipe({ type = info.type, time = 'In 20 Seconds', admin = info.admin})
    Wait(10000)
    Zen.Functions.Admin.Config.ChatMessages.EntityWipe({ type = info.type, time = 'In 10 Seconds', admin = info.admin})
    Wait(10000)
    Zen.Functions.Admin.Config.ChatMessages.EntityWipe({ type = info.type, time = 'Completed', admin = ''})

    if tonumber(args[1]) == 2 then 
        for k, v in pairs(GetAllObjects()) do 
            DeleteEntity(v) 
        end
    end

    for k, v in pairs(GetAllVehicles()) do
        if (GetPedInVehicleSeat(v, -1) == 0) then
            DeleteEntity(v)
        end
    end
end)

RegisterCommand('ban', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'ban') then return end

    local target = GetTargetPlayer(source, args[1])

    if not target then return end

    if Zen.Functions.Admin.Immune(source, target.id, 'Ban') then return end

    local reason
    local value = tonumber(args[#args])

    if value then
        reason = table.concat(args, ' ', 2, #args - 1) or 'Not Provided'
    else
        reason = table.concat(args, ' ', 2) or 'Not Provided'
        value = 31536000 * 5
    end

    local data = {
        target = target.id,
        reason = reason,
        value = value,
        admin = PlayersTable[tonumber(source)].name
    }

    local banTime = os.time()
    local banDay = os.date('%A, %B %d, %Y at %I:%M %p', banTime)
    local unbanTime = (banTime + data.value)
    local unbanDay = os.date('%A, %B %d, %Y at %I:%M %p', unbanTime).. ' ' ..os.date('%Z')

    MySQL.update.await('UPDATE users SET ban_data = ? WHERE identifier = ?', {
        json.encode({ 
            admin = data.admin, 
            reason = data.reason, 
            ban = { label = banDay, time = banTime }, 
            unban = { label = unbanDay, time = unbanTime } 
        }), 
        target.identifier
    })

    Notification.Notice(-1, data.admin..' banned '..target.name.. '. Reason: '..data.reason)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['ban'], 'Player was Banned', Zen.Functions.Admin.LogFormats({ admin = source, target = data.target })..("\n**Unban On:**\n> %s\n**Reason:**\n> %s"):format(unbanDay, data.reason))
    DropPlayer(data.target, ('You Have Been Banned From %s!\n\nAdmin: %s (ID: %s)\nReason: %s\nUnban In: %s'):format(Zen.Config.Server.ServerName, data.admin, tonumber(source), data.reason, unbanDay))
end)

RegisterCommand('offlineban', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'offlineban') then return end

    local reason
    local value = tonumber(args[#args])

    if value then
        reason = table.concat(args, ' ', 2, #args - 1) or 'Not Provided'
    else
        reason = table.concat(args, ' ', 2) or 'Not Provided'
        value = 31536000 * 5
    end

    local data = {
        target = args[1],
        reason = reason,
        value = value,
        admin = PlayersTable[tonumber(source)].name
    }

    if not OfflineTable[data.target] then 
        return Zen.Functions.Notify(source, 'Player Is Not Offline!', 'xmark', '#FF0000')
    end

    local banTime = os.time()
    local banDay = os.date('%A, %B %d, %Y at %I:%M %p', banTime)
    local unbanTime = (banTime + data.value)
    local unbanDay = os.date('%A, %B %d, %Y at %I:%M %p', unbanTime).. ' ' ..os.date('%Z')

    MySQL.update.await('UPDATE users SET ban_data = ? WHERE identifier = ?', {
        json.encode({ 
            admin = data.admin, 
            reason = data.reason, 
            ban = { label = banDay, time = banTime }, 
            unban = { label = unbanDay, time = unbanTime } 
        }), 
        data.target
    })

    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['offlineban'], 'Player was Offline Banned', Zen.Functions.Admin.LogFormats({ admin = source })..("\n**License:** `%s`\n\n**Unban On:**\n> %s\n**Reason:**\n> %s"):format(data.target, unbanDay, data.reason))
end)

RegisterCommand('unban', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'unban') then return end

    local license = args[1]

    if MySQL.scalar.await('SELECT * FROM users WHERE identifier = ?', { license }) == nil then
        return Zen.Functions.Notify(source, 'Invalid License!', 'xmark', '#FF0000')
    end

    local osTime = os.time()
    local banData = json.decode(MySQL.scalar.await('SELECT ban_data FROM users WHERE identifier = ?', { license }))

    if banData == nil or banData == 'NULL' then  
        Zen.Functions.Notify(source, 'This License Isn\'t Banned!', 'xmark', '#FF0000')
    else
        if banData.unban.time <= osTime then    
            Zen.Functions.Notify(source, 'This License Isn\'t Banned!', 'xmark', '#FF0000')
        else
            Zen.Functions.Notify(source, 'You Unbanned This License!', 'check', '#00FF00')
        end

        Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['unban'], 'License was Unbanned', Zen.Functions.Admin.LogFormats({ admin = source })..("\n**License:** `%s`"):format(license))
        MySQL.update.await('UPDATE users SET ban_data = ? WHERE identifier = ?', { nil, license })  
    end
end)

RegisterCommand('kick', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'kick') then return end

    local target = GetTargetPlayer(source, args[1])
    local reason = table.concat(args, ' ', 2) or 'Not Provided'

    if not target then return end

    if Zen.Functions.Admin.Immune(source, target.id, 'Kick') then return end

    Notification.Notice(-1, PlayersTable[source].name..' kicked '..target.name.. '. Reason: '..reason)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['kick'], 'Player was Kicked', Zen.Functions.Admin.LogFormats({ admin = source, target = target.id }).."\n**Reason:**\n> "..reason)
    DropPlayer(target.id, ('You Have Been Kicked From %s!\n\nAdmin: %s (ID: %s)\nReason: %s'):format(Zen.Config.Server.ServerName, PlayersTable[source].name, source, reason))
end)

RegisterCommand('setjob', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'setjob') then return end

    local target = GetTargetPlayer(source, tonumber(args[1]), true)
    if not target then return end

    if #args < 3 then
        return Zen.Functions.Notify(source, 'Invalid Arguments!', 'xmark', '#FF0000') 
    end

    if not Zen.Jobs[args[2]] then 
        return Zen.Functions.Notify(source, 'That job does not exist!', 'xmark', '#FF0000') 
    end

    local old = { job = target.job.name, rank = tostring(target.job.grade) }

    target.setJob(args[2], tonumber(args[3]))

    Notification.Notice(-1, PlayersTable[source].name..' set '..target.name.. ' to '.. Zen.Jobs[args[2]].label..' - '..Zen.Jobs[args[2]].grades[args[3]].label)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['setjob'], 'Player Job Set', Zen.Functions.Admin.LogFormats({ admin = source, target = target.source }).."\n**Old Job:** "..Zen.Jobs[old.job].label.." - "..Zen.Jobs[old.job].grades[old.rank].label.."\n**Set Job:** "..Zen.Jobs[args[2]].label.." - "..Zen.Jobs[args[2]].grades[args[3]].label)
end)

RegisterCommand('givecar', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'givecar') then return end

    local data = lib.callback.await('admin:give', source, 'vehicle', {
        vehicle = tonumber(args[2]),
        category = args[3] or 'donor'
    })
    
    if not data then 
        return Zen.Functions.Notify(source, 'That vehicle does not exist!', 'xmark', '#FF0000') 
    end

    local target = GetTargetPlayer(source, args[1])
    if not target then return end

    MySQL.insert.await('INSERT INTO `owned_vehicles` (identifier, vehicle, plate, label, type, job) VALUES (?, ?, ?, ?, ?, ?)', { target.identifier, json.encode(data.props), data.props.plate, data.vehicle.label, 'car', nil})
    
    Zen.Functions.Notify(source, 'You Gave '..target.name..' a '..data.vehicle.label..'!', 'check', '#00FF00') 
    Notification.Alert(target.id, source, 'Gave you a vehicle: '..data.vehicle.label)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['givecar'], 'Player Given Car', Zen.Functions.Admin.LogFormats({ admin = source, target = target.id }).."\n**Label:** "..data.vehicle.label.."\n**Model:** "..data.vehicle.model)
end)


RegisterCommand('givemoney', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'givemoney') then return end

    local data = lib.callback.await('admin:give', source, 'money')
    if not data then return end

    local target = GetTargetPlayer(source, data[1], true)
    if not target then return end

    if data[2] == 'give' then 
        target.addAccountMoney(data[3], data[4])
    elseif data[2] == 'set' then 
        target.setAccountMoney(data[3], data[4])
    end

    local ammount = Zen.Functions.FormatCommas(data[4])
    
    Notification.Alert(data[1], source, ((data[2] == 'give' and 'Gave you '..Zen.Accounts[data[3]]) or (data[2] == 'set' and 'Set your '.. Zen.Accounts[data[3]]..' to'))..' $'..ammount)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['givemoney'], 'Player '..((data[2] == 'give' and 'Given Money') or (data[2] == 'set' and 'Money Set')), Zen.Functions.Admin.LogFormats({ admin = source, target = target.source }).."\n**Account:** "..Zen.Accounts[data[3]].."\n**Amount:** $"..ammount)
end)

RegisterCommand('giveitem', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'giveitem') then return end

    local data = lib.callback.await('admin:give', source, 'item', Zen.Functions.Admin.Config.GiveItem)
    if not data then return end

    local target = GetTargetPlayer(source, data[1], true)
    if not target then return end

    if not Zen.Items[data[2]] then 
        return Zen.Functions.Notify(source, 'That item does not exist!', 'xmark', '#FF0000') 
    end

    target.addInventoryItem(data[2], data[3])

    Notification.Alert(data[1], source, 'Gave you x'..data[3]..' '..Zen.Items[data[2]].label)
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['giveitem'], 'Player Given Item', Zen.Functions.Admin.LogFormats({ admin = source, target = target.source }).."\n**Item:** "..Zen.Items[data[2]].label.."\n**Amount:** x"..data[3])
end)

RegisterCommand('giveweapon', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'giveweapon') then return end

    local data = lib.callback.await('admin:give', source, 'weapon', Zen.Functions.Admin.Config.GiveWeapon)
    if not data then return end

    local target = GetTargetPlayer(source, data[1], true)
    if not target then return end

    if not Zen.Weapons[data[2]] then 
        return Zen.Functions.Notify(source, 'That weapon does not exist!', 'xmark', '#FF0000') 
    end

    target.addWeapon(data[2], data[3])

    Notification.Alert(data[1], source, 'Gave you a '..Zen.Weapons[data[2]])
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['giveweapon'], 'Player Given Weapon', Zen.Functions.Admin.LogFormats({ admin = source, target = target.source }).."\n**Weapon:** "..Zen.Weapons[data[2]].."\n**Ammo:** x"..data[3])
end)

RegisterCommand('sendback', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'sendback') then return end

    local target = GetTargetPlayer(source, args[1])
    if not target then return end

    if not SendBackCoords[target.id] then 
        return Zen.Functions.Notify(source, 'That Player Does Not Have Previous Coords!', 'ban', '#FF0000')
    end

    Notification.Alert(target.id, source, 'Sent you back')

    SetEntityCoords(GetPlayerPed(target.id), SendBackCoords[target.id], false, false, false, true)
    SendBackCoords[target.id] = nil
end)

RegisterCommand('goto', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'teleport') then return end

    local target = GetTargetPlayer(source, args[1])
    if not target then return end

    Notification.Alert(target.id, source, 'Teleported to you')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['teleport'], 'Admin Teleported To Player', Zen.Functions.Admin.LogFormats({ admin = source, target = tonumber(args[1]) }))
    SendBackCoords[source] = GetEntityCoords(GetPlayerPed(source))
    SetEntityCoords(GetPlayerPed(source), GetEntityCoords(GetPlayerPed(target.id)), false, false, false, true)
end)

RegisterCommand('bring', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'teleport') then return end

    local target = GetTargetPlayer(source, args[1])
    if not target then return end

    Notification.Alert(target.id, source, 'Brought you')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['teleport'], 'Admin Brought Player', Zen.Functions.Admin.LogFormats({ admin = source, target = tonumber(args[1]) }))
    SendBackCoords[target.id] = GetEntityCoords(GetPlayerPed(target.id))
    SetEntityCoords(GetPlayerPed(target.id), GetEntityCoords(GetPlayerPed(source)), false, false, false, true)
end)

RegisterCommand('revive', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'revive') then return end

    local target = PlayersTable[tonumber(args[1])]

    if not target and not args[1] then 
        Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['revive'], 'Admin Self-Revived', Zen.Functions.Admin.LogFormats({ admin = source }))
        TriggerClientEvent('deathscreen:revive', source)
    elseif target then
        Notification.Alert(target.id, source, 'Revived you')
        Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['revive'], 'Player Revived', Zen.Functions.Admin.LogFormats({ admin = source, target = tonumber(args[1]) }))
        TriggerClientEvent('deathscreen:revive', target.id)
    else
        Zen.Functions.Notify(source, 'Player Not Online!', 'xmark', '#FF0000')
    end
end)

RegisterCommand('freeze', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'freeze') then return end

    local data = {
        target = PlayersTable[tonumber(args[1])],
        freeze = args[2]
    }

    if not data.target then 
        return Zen.Functions.Notify(source, 'Player Not Online!', 'xmark', '#FF0000') 
    end

    if FrozenPlayers[data.target.id] == data.freeze then return end

    FrozenPlayers[data.target.id] = data.freeze

    Notification.Alert(data.target.id, source, ((data.freeze == 'true' and 'Freezed') or 'Unfreezed')..' you')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['freeze'], 'Player was '..((data.freeze == 'true' and 'Freezed') or 'Unfreezed'), Zen.Functions.Admin.LogFormats({ admin = source, target = data.target.id }))
    FreezeEntityPosition(GetPlayerPed(data.target.id), (data.freeze == 'true' and true) or false)
end)

RegisterCommand('car', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'spawnvehicle') then return end
    
    local log = lib.callback.await('admin:car', source, args[1])

    if log then 
        Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['spawnvehicle'], 'Vehicle was Spawned', Zen.Functions.Admin.LogFormats({ admin = source })..("\n**Vehicle:** `%s`"):format(args[1]))
    end
end)

RegisterCommand('clearinventory', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'clearinventory') then return end

    local target = GetTargetPlayer(source, args[1], true)
    if not target then return end

    Notification.Alert(tonumber(args[1]), source, 'Cleared your inventory')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['clearinventory'], 'Players Inventory was Cleared', Zen.Functions.Admin.LogFormats({ admin = source, target = tonumber(args[1]) }))

    for k,v in pairs(target.getInventory()) do
        if v.count > 0 then
            target.setInventoryItem(v.name, 0)
        end
    end
end)

RegisterCommand('clearloadout', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'clearloadout') then return end

    local target = GetTargetPlayer(source, args[1], true)
    if not target then return end

    Notification.Alert(tonumber(args[1]), source, 'Cleared your loadout')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['clearloadout'], 'Players Loadout was Cleared', Zen.Functions.Admin.LogFormats({ admin = source, target = tonumber(args[1]) }))

    local loadout = target.getLoadout()

    for i = #loadout, 1, -1 do
        target.removeWeapon(loadout[i].name)
    end
end)

RegisterCommand('skin', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'skin') then return end

    local target = GetTargetPlayer(source, args[1])
    if not target then return end

    Notification.Alert(target.id, source, 'Force skinned you')
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['skin'], 'Players Force Skinned', Zen.Functions.Admin.LogFormats({ admin = source, target = target.id }))

    TriggerClientEvent('esx_skin:openSaveableMenu', target.id)
end)

RegisterCommand('announce', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'announce') then return end
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['announce'], 'Server Announcement', Zen.Functions.Admin.LogFormats({ admin = source })..'\n**Message:**\n'..table.concat(args, " "))
    Zen.Functions.Admin.Config.ChatMessages.Announcement({ admin = PlayersTable[source].name, message = table.concat(args, " ") })
end)

RegisterCommand('clearchat', function(source, args, rawCommand)
    if not CheckPermissionsAndNotify(source, 'clearchat') then return end
    Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['clearchat'], 'Cleared Chat', Zen.Functions.Admin.LogFormats({ admin = source }))
    TriggerClientEvent('chat:clear', -1)
    Notification.Notice(-1, GetPlayerName(source)..' cleared the chat!')
end)

if Zen.Functions.Admin.Config.Command.Report.enabled then 
    local ReportCooldown = {}

    RegisterCommand(Zen.Functions.Admin.Config.Command.Report.command, function(source, args, rawCommand)
        if source == nil or source <= 0 then return end
        local cooldown = false
        local osTime = os.time()

        if (ReportCooldown[source] == nil or osTime - ReportCooldown[source] >= Zen.Functions.Admin.Config.Command.Report.cooldown) then 
            ReportCooldown[source] = osTime
            cooldown = true
        end
        
        if (not cooldown) then
            Zen.Functions.Notify(source, "Please wait " .. (Zen.Functions.Admin.Config.Command.Report.cooldown - (osTime - ReportCooldown[source])) .. " seconds.", 'clock', '#FF0000')
            CancelEvent()
        end

        if cooldown then 
            Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['report'], 'Player Sent Report', ('\n**Player:** %s (ID: %s)\n> `%s`\n\n**Report:**\n%s'):format(PlayersTable[source].name, source, PlayersTable[source].identifier, table.concat(args, " ")))

            for key, _ in pairs(AdminsTable) do
                Zen.Functions.Admin.Config.ChatMessages.Report({ admin = key, player = '[ID: '..source..'] '..PlayersTable[source].name, report = table.concat(args, " ") })
            end

            Zen.Functions.Notify(source, "Report successfully sent! Please wait.", 'check', '#00FF00')
        end
    end)
end

if Zen.Functions.Admin.Config.Command.StaffChat.enabled then 
    RegisterCommand(Zen.Functions.Admin.Config.Command.StaffChat.command, function(source, args, rawCommand)
        if source == nil or source <= 0 then return end
        if not CheckPermissionsAndNotify(source, 'staffchat') then return end
        Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['staffchat'], 'Staff Chat', Zen.Functions.Admin.LogFormats({ admin = source })..'\n**Message:**\n'..table.concat(args, " "))
        for key, _ in pairs(AdminsTable) do
            Zen.Functions.Admin.Config.ChatMessages.StaffChat({ admin = key, player = '[ID: '..source..'] '..PlayersTable[source].name, message = table.concat(args, " ") })
        end
    end)
end

RegisterCommand('banwipe', function(source)
    if source == 0 or CheckPermissionsAndNotify(source, 'banwipe') then 
        local banData = MySQL.query.await('SELECT `identifier` FROM users WHERE ban_data IS NOT NULL')

        if banData then 
            for _, record in ipairs(banData) do
                MySQL.update.await('UPDATE users SET ban_data = ? WHERE identifier = ?', { nil, record.identifier })    
            end
        end

        ConsoleLog('Wiped ^4'..#banData..'^7 Bans!')

        if source ~= 0 then   
            Zen.Functions.Notify(source,'Wiped '..#banData..' Bans!', 'ban', '#FF0000')
            Zen.Functions.LogToDiscord(Zen.Functions.Admin.Config.Webhooks['banwipe'], 'Wiped '..#banData..' Bans.', Zen.Functions.Admin.LogFormats({ admin = source }))
        end
    end
end)