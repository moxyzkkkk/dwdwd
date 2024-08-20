local Config = Zen.Config.ScheduledDrops

if Config.Enabled then 
    local function check()
        local currentTime = os.date("*t")
        local currentSeconds = currentTime.hour * 3600 + currentTime.min * 60 + currentTime.sec

        for k, v in pairs(Config.Drops) do
            local hour, min, sec = k:match('(%d+):(%d+):(%d+)')
            local dropSeconds = hour * 3600 + min * 60 + sec

            if dropSeconds - currentSeconds == 600 then
                if Config.Webhook ~= '' then
                    local contents = '**'..v[3]..' '..v[1]..' Drop! In 10 Mins!**\n> '..Zen.Config.RichPresence.Actions[2][2]..'\n\n||@everyone||'
                    PerformHttpRequest(Config.Webhook, function(err, text, headers) end, 'POST', json.encode({ username = "Scheduled Drops", avatar_url = Zen.Config.Server.Graphics.PFP, content = contents }), { ['Content-Type'] = 'application/json' })
                end
            elseif currentSeconds == dropSeconds then
                local xPlayers = ESX.GetExtendedPlayers()
                
                for i = 1, #xPlayers, 1 do
                    local xPlayer = xPlayers[i]
                    xPlayer.addInventoryItem(v[2], v[3])
                end

                Config.Announce(v[1], v[3])
            end
        end
    end

    CreateThread(function()
        while true do
            check()
            Wait(1000)
        end
    end)
end