ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

-- Command to create a gang
RegisterCommand('creategang', function(source, args)
    local leaderID = args[1]
    local gangName = args[2]
    local gangLabel = args[3]

    if leaderID == nil or gangName == nil or gangLabel == nil then
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Usage: /creategang [LEADER_ID] [GANG_NAME] [GANG_LABEL]' } })
        return
    end

    local xPlayer = ESX.GetPlayerFromId(source)

    if exports.trase_discord:hasRole(source, 'your_discord_role_id') then
        MySQL.Async.execute('INSERT INTO gangs (leader_id, gang_name, gang_label) VALUES (@leader_id, @gang_name, @gang_label)', {
            ['@leader_id'] = leaderID,
            ['@gang_name'] = gangName,
            ['@gang_label'] = gangLabel
        }, function(rowsChanged)
            if rowsChanged > 0 then
                TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', 'Gang created successfully.' } })
            else
                TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'Failed to create gang.' } })
            end
        end)
    else
        TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You do not have permission to create a gang.' } })
    end
end, false)

-- Command to accept gang invite
RegisterCommand('acceptganginvite', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local discordID = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM gang_invites WHERE player_id = @player_id AND invite_expiry > NOW()', {
        ['@player_id'] = discordID
    }, function(results)
        if results[1] then
            local invite = results[1]
            MySQL.Async.execute('UPDATE players SET gang_id = @gang_id, rank = @rank WHERE discord_id = @discord_id', {
                ['@gang_id'] = invite.gang_id,
                ['@rank'] = 3, -- Default rank
                ['@discord_id'] = discordID
            })

            MySQL.Async.execute('UPDATE gangs SET members = JSON_ARRAY_APPEND(members, \'$\', JSON_OBJECT("name", @name, "discord_id", @discord_id, "rank", 3)) WHERE id = @gang_id', {
                ['@gang_id'] = invite.gang_id,
                ['@name'] = xPlayer.getName(),
                ['@discord_id'] = discordID
            })

            MySQL.Async.execute('DELETE FROM gang_invites WHERE id = @id', {
                ['@id'] = invite.id
            })

            TriggerClientEvent('chat:addMessage', source, { args = { '^2SYSTEM', 'You have joined the gang.' } })
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'No active gang invites found.' } })
        end
    end)
end, false)

-- Event to open the UI with relevant data
RegisterNetEvent('gang:openUI')
AddEventHandler('gang:openUI', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local discordID = xPlayer.getIdentifier()

    MySQL.Async.fetchAll('SELECT * FROM gangs WHERE leader_id = @leader_id', {
        ['@leader_id'] = discordID
    }, function(results)
        if results[1] then
            local gang = results[1]
            local gangInfo = {
                gangLabel = gang.gang_label,
                members = gang.members,
                maxSlots = gang.max_slots,
                ranks = gang.ranks
            }

            TriggerClientEvent('gang:updateUI', source, gangInfo)
        else
            TriggerClientEvent('chat:addMessage', source, { args = { '^1SYSTEM', 'You are not the leader of any gang.' } })
        end
    end)
end)

-- Server-side: server/main.lua
RegisterCommand('gangmanage', function(source, args, rawCommand)
    -- Your logic here
    -- Example: TriggerClientEvent to open the UI
    local xPlayer = ESX.GetPlayerFromId(source)
    TriggerClientEvent('gang:openUI', source)
end, false)
