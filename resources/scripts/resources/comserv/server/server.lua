local ComservedPlayers = {}
local stateBagSync = 0
local sConfig = Zen.Config.ServerComservs
local Admin = exports.scripts.Admin()

local function SendPlayerToComserv(player, actions, admin, reason)
    if ComservedPlayers[player] ~= nil then return end
    local identifier = Zen.Functions.GetIdentifier(player, 'license')

    stateBagSync = stateBagSync + 1
    ComservedPlayers[player] = {
        Actions = actions,
        Sender = admin,
        Reason = reason,
        stateBagSync = stateBagSync
    }

    sConfig.ChatMessages.Comserv({ actions = actions, player = GetPlayerName(player), reason = reason, admin = admin })

    MySQL.insert.await('INSERT INTO `communityservice` (identifier, actions_remaining, comserv_reason, sender_name) VALUES (?, ?, ?, ?)', { identifier, actions, reason, admin })
    Player(player).state:set('Zen:Comserv:Client', ComservedPlayers[player], true)
end

local function ReleasePlayerFromComserv(player, admin)
    local identifier = Zen.Functions.GetIdentifier(player, 'license')

    MySQL.update.await('DELETE FROM communityservice WHERE identifier = ?', { identifier })

    stateBagSync = stateBagSync + 1
    Player(player).state:set('Zen:Comserv:Client', {
        Actions = 0,
        EndedByAdmin = (admin and true) or false,
        stateBagSync = stateBagSync
    }, true)
    ComservedPlayers[player] = nil

    sConfig.ChatMessages.EndComserv({ player = GetPlayerName(player), admin = (admin and GetPlayerName(admin)) })
end

RegisterCommand('comserv', function(source, args, rawCommand)
    local source = source

    if not Zen.Functions.Admin.Allowed(source, 'comserv') then 
        return Zen.Functions.Notify(source, 'Invalid Permissions!', 'xmark', '#FF0000') 
    end

    local targetId = tonumber(args[1])
    
    if Zen.Functions.Admin.Immune(source, targetId, 'Comserv') then return end

    if targetId and GetPlayerName(targetId) ~= nil and tonumber(args[2]) and args[3] then
        SendPlayerToComserv(targetId, tonumber(args[2]), GetPlayerName(source), rawCommand:sub(13))
        Zen.Functions.LogToDiscord(Admin.Config.Webhooks['comserv'], 'Player Sent To Comserv', Zen.Functions.Admin.LogFormats({ admin = source, target = targetId }).."\n**Actions:** "..args[2].."\n**Reason:** "..rawCommand:sub(13))
    else
        Zen.Functions.Notify(source, 'Incorrect Usage! /comserv [id] [amount] [reason]', 'xmark', '#FF0000')
    end
end)

RegisterCommand('endcomserv', function(source, args, rawCommand)
    local source = source

    if not Zen.Functions.Admin.Allowed(source, 'endcomserv') then 
        return Zen.Functions.Notify(source, 'Invalid Permissions!', 'xmark', '#FF0000') 
    end

    local targetId = tonumber(args[1])
    
    if Zen.Functions.Admin.Immune(source, targetId, 'End Comserv') then return end

    if targetId and GetPlayerName(targetId) ~= nil then
        if ComservedPlayers[targetId] then
            ReleasePlayerFromComserv(targetId, source)
            Zen.Functions.LogToDiscord(Admin.Config.Webhooks['endcomserv'], 'Player Comserv Ended', Zen.Functions.Admin.LogFormats({ admin = source, target = targetId }))
        else
            Zen.Functions.Notify(source, 'This player is not currently in community service.', 'xmark', '#FF0000')
        end
    else
        Zen.Functions.Notify(source, 'Incorrect Usage! /endcomserv [id]', 'xmark', '#FF0000')
    end
end)

RegisterCommand('checkcoms', function(source, args, rawCommand)
    local source = source

    if not Zen.Functions.Admin.Allowed(source, 'comserv') then 
        return Zen.Functions.Notify(source, 'Invalid Permissions!', 'xmark', '#FF0000') 
    end

    local targetId = tonumber(args[1])

    if targetId and GetPlayerName(targetId) ~= nil then
        if ComservedPlayers[targetId] then
            Zen.Functions.Notify(source, 'Comservs: '..ComservedPlayers[targetId].Actions, 'xmark', '#FF0000')
        else
            Zen.Functions.Notify(source, 'This player is not currently in community service.', 'xmark', '#FF0000')
        end
    else
        Zen.Functions.Notify(source, 'Incorrect Usage! /endcomserv [id]', 'xmark', '#FF0000')
    end
end)


lib.callback.register('comservs:completeAction', function(source)
    if ComservedPlayers[source] == nil then return end
    ComservedPlayers[source].Actions = ComservedPlayers[source].Actions - 1
    local identifier = Zen.Functions.GetIdentifier(source, 'license')

    MySQL.update.await('UPDATE communityservice SET actions_remaining = ? WHERE identifier = ?', { ComservedPlayers[source].Actions, identifier })
    Player(source).state:set('Zen:Comserv:Client', ComservedPlayers[source], true)

    if ComservedPlayers[source].Actions == 0 then 
        ReleasePlayerFromComserv(source)
    end
end)

lib.callback.register('comservs:addExtension', function(source, amount)
    if ComservedPlayers[source] == nil then return end
    ComservedPlayers[source].Actions = ComservedPlayers[source].Actions + amount
    local identifier = Zen.Functions.GetIdentifier(source, 'license')
    
    MySQL.rawExecute.await('UPDATE communityservice SET actions_remaining = ? WHERE identifier = ?', { ComservedPlayers[source].Actions, identifier })
    Player(source).state:set('Zen:Comserv:Client', ComservedPlayers[source], true)
end)

RegisterNetEvent('playerLoaded', function(player)
    local identifier = Zen.Functions.GetIdentifier(player, 'license')
    local response = MySQL.query.await('SELECT * FROM `communityservice` WHERE `identifier` = ?', { identifier })

    if response and response[1] then
        stateBagSync = stateBagSync + 1
        ComservedPlayers[player] = {
            Actions = response[1].actions_remaining,
            Sender = response[1].sender_name,
            Reason = response[1].comserv_reason,
            stateBagSync = stateBagSync
        }

        Player(player).state:set('Zen:Comserv:Client', ComservedPlayers[player], true)
    end
end) 

AddEventHandler("playerDropped", function(reason)
    if ComservedPlayers[source] ~= nil then 
        ComservedPlayers[source] = nil
    end
end)