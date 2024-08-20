local Cache, RolesCache = {}, {}
local Config = Zen.Config.Discord

Zen.Functions.Discord = {}

Zen.Functions.Discord.GuildId = function()
    return Config.Guild
end

Zen.Functions.Discord.Request = function(method, endpoint, jsondata, reason)
    local data = nil
    
    PerformHttpRequest("https://discordapp.com/api/"..endpoint, function(errorCode, resultData, resultHeaders)
		data = {data=resultData, code=errorCode, headers=resultHeaders}
    end, method, #jsondata > 0 and jsondata or "", {["Content-Type"] = "application/json", ["Authorization"] = "Bot "..Config.Token, ['X-Audit-Log-Reason'] = reason})

    while data == nil do
        Citizen.Wait(0)
    end
	
    return data
end

Zen.Functions.Discord.Data = function(user)
    local id = Zen.Functions.GetIdentifier(user, 'discord')

    local data = { 
        name = 'Not Found',
        avatar = "https://cdn.discordapp.com/attachments/1023347199427498125/1135688772105797795/image.png",
    }

    if id ~= nil then 
        if Cache[id] ~= nil then 
            return Cache[id]
        end

        local endpoint = ("users/%s"):format(id)
        local member = Zen.Functions.Discord.Request("GET", endpoint, {})

        if member.code == 200 then
            local info = json.decode(member.data)

            if info then 
                if info.avatar then 
                    if (info.avatar:sub(1, 1) and info.avatar:sub(2, 2) == "_") then 
                        data.avatar = "https://cdn.discordapp.com/avatars/" .. id .. "/" .. info.avatar .. ".gif";
                    else 
                        data.avatar = "https://cdn.discordapp.com/avatars/" .. id .. "/" .. info.avatar .. ".png"
                    end
                end

                data.name = (info.discriminator == 0 or info.discriminator == "0" and info.username) or (info.username .. "#" .. info.discriminator)

                Cache[id] = data
            end
        end
    end
    
    return data
end

lib.callback.register('discord:data', function(source)
    return Zen.Functions.Discord.Data(source)
end)

exports('discordData', Zen.Functions.Discord.Data)

Zen.Functions.Discord.Roles = function(user)
    local id = Zen.Functions.GetIdentifier(user, 'discord')
    
    if id then 
        if Config.CacheRoles ~= 0 and RolesCache[id] ~= nil then 
            return RolesCache[id]
        end

        local endpoint = ("guilds/%s/members/%s"):format(Config.Guild, id)
		local member = Zen.Functions.Discord.Request("GET", endpoint, {})

		if member.code == 200 then
			local info = json.decode(member.data)
			local roles = info.roles

            if Config.CacheRoles ~= 0 then 
                RolesCache[id] = roles or {}

                SetTimeout(Config.CacheRoles * 1000, function() 
                    RolesCache[id] = nil 
                end)
            end

			return roles
		end

        return false
    end

    return false
end

Zen.Functions.Discord.HaveRole = function(user, role)
    local id = Zen.Functions.GetIdentifier(user, 'discord')
    
    if id then 
        local roles = RolesCache[id] or Zen.Functions.Discord.Roles(user)

        if not roles then return false end

        for i = 1, #roles do 
            if tonumber(roles[i]) == tonumber(role) then 
                return true
            end
        end
    end

    return false
end

lib.callback.register('discord:haveRole', function(source, role)
    return Zen.Functions.Discord.HaveRole(source, role)
end)

lib.callback.register('discord:roles', function(source)
    local id = Zen.Functions.GetIdentifier(source, 'discord')

    if id then 
        local roles = RolesCache[id] or Zen.Functions.Discord.Roles(source)

        while roles == nil do 
            Wait(500)
            roles = RolesCache[id] or Zen.Functions.Discord.Roles(source)
        end

        return roles or {}
    end

    return {}
end)

CreateThread(function()
    local guild = Zen.Functions.Discord.Request("GET", "guilds/"..Config.Guild, {})
    if guild.code == 200 then
        local data = json.decode(guild.data)
        print("^4[DISCORD]^7 ^2[LINKED]^7 : ^3"..data.name..' ^2(^3'..data.id..'^2)^7')
    else
        print("^4[DISCORD]^7 ^1[ERROR]^7 : ^3Please Check Your Config^7\n ^5@scripts/resources/discord/sconfig.lua^7") 
    end
end)

