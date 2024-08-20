local Server = Zen.Config.Server
local RichPresence = Zen.Config.RichPresence

CreateThread(function()
    local name = GetPlayerName(cache.playerId)

    while true do
        Wait(60 * 1000)
        SetDiscordAppId(RichPresence.AppId)
        SetDiscordRichPresenceAsset(RichPresence.Asset)
        SetDiscordRichPresenceAssetText('discord.gg/'..Server.DiscordInvite..'')
        SetRichPresence(playerCount.online..'/'..playerCount.max..' Players 😘')
        SetDiscordRichPresenceAssetText(('ID: %s | %s'):format(cache.serverId, name))
        SetDiscordRichPresenceAction(0, RichPresence.Actions[1][1], RichPresence.Actions[1][2])
        SetDiscordRichPresenceAction(1, RichPresence.Actions[2][1], RichPresence.Actions[2][2])
    end
end)