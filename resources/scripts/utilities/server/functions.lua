Zen.Functions = {}

Zen.Functions.LogToDiscord = function(webhook, title, info, image)
    if webhook == "" then return end

    local embed = {
        color = 16711680,
        type = "rich",
        title = title,
        description = info
    }
    
    if image then
        embed.image = { url = image }
    end

    local data = {
        username = "Server Logs",
        avatar_url = "https://cdn.discordapp.com/attachments/805465153965522954/1168905694209114132/Discord-pfp-77094439.png",
        embeds = {embed}
    }

    PerformHttpRequest(webhook, function(err, text, headers)
        if Zen.Config.Server.Debug then
            if err then
                print("Error sending Discord webhook:", err)
            else
                print("Webhook response:", text)
            end
        end
    end, "POST", json.encode(data), {["Content-Type"] = "application/json"})
end

Zen.Functions.FormatCommas = function(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return(minus..int:reverse():gsub("^,", "")..fraction)
end

Zen.Functions.Notify = function(player, text, icon, color)
    return TriggerClientEvent('showNotification', player, text, icon, color)
end

Zen.Functions.AntiEvent = function(label, player, event)
    print('^1[ANTI-EVENT] '..label..'^7 : ID ^1'..player..'^7 Tried ^3"'..event..'"^7')
end

Zen.Functions.GetIdentifier = function(player, id)
    if type(id) ~= "string" then return print('Invalid usage') end

    for _, identifier in pairs(GetPlayerIdentifiers(player)) do
        if string.find(identifier, id) then
            return string.gsub(identifier, id..":", "")
        end
    end

    return nil
end

Zen.Functions.InTable = function(tbl, value)
    for _, v in ipairs(tbl) do
        if v == value then
            return true
        end
    end
    return false
end

exports('functions', function(func)
    return Zen.Functions[func]
end)