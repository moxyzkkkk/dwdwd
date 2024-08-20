Zen.Config.ScheduledDrops = {
    Enabled = true,
    
    Drops = {
        ["05:30:00"] = { 'Armour', 'armour', 1 },
        ["17:30:00"] = { 'Clip', 'clip',  5 },
    },

    Announce = function(label, amount)
        TriggerClientEvent('chat:addMessage', -1, { 
            template = '<div style="padding: 0.40vw; margin: -0.1vw; background-color: rgba(17, 17, 17, 0.753); border-radius: 7px;  border-left: 4.5px solid rgb(176, 0, 0); width = auto; "><text style="position: sticky;">^1[ Scheduled Drops ]^7 : x{0} {1} Dropped.</text></div>',
            args = { amount, label }
        })
    end,

    Webhook = 'https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS'
}