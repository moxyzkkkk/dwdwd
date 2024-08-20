RegisterCommand('me', function(source, args)
    local text = table.concat(args, " ")

    for i = 1, #Zen.Config.Server.BlacklistedWords do 
        if string.match(string.lower(text), string.lower(Zen.Config.Server.BlacklistedWords[i])) then return end
    end

    TriggerClientEvent('me:display', source, text, source)

    local playerScope = GetPlayerScope(source)

    if playerScope ~= nil then  
        for k, v in pairs(playerScope) do 
            if v == true then 
                TriggerClientEvent('me:display', tonumber(k), text, source)
            end
        end
    end
end)
