--[[
    'comserv', 'tpm', 'teleport', 'revive', 'kick', 'freeze', 'spawnvehicle', 'repairvehicle', 'cleanvehicle', 'flipvehicle', 'staffchat', 'clearchat', 'coords', 'givecar', 'sendback', 'banwipe', 
    'endcomserv', 'ban', 'offlineban', 'clearinventory', 'clearloadout', 'spectate', 'unban', 'entitywipe',  'heal', 'godmode', 'invisible', 'noclip', 'giveweapon', 'givemoney', 'giveitem', 'setgang', 
    'setjob', 'skin',  'announce'
]]--

Zen.Config.ServerAdminMenu = {
    SharedPerms = { 'comserv', 'tpm', 'teleport', 'revive', 'kick', 'freeze', 'spawnvehicle', 'repairvehicle', 'cleanvehicle', 'flipvehicle', 'staffchat', 'clearchat', 'coords' }, -- Staff
    Permissions = {
        [960372208767742002] = { 'givecar', 'sendback', 'banwipe', 'endcomserv', 'ban', 'offlineban', 'clearinventory', 'clearloadout', 'spectate', 'unban', 'entitywipe',  'heal', 'godmode', 'invisible', 'noclip', 'giveweapon', 'givemoney', 'giveitem', 'setgang', 'setjob', 'skin',  'announce' }, -- Owner
    },

    Command = {
        Report = {
            enabled = false,
            command = 'report',
            cooldown = 10
        },

        StaffChat = {
            enabled = true,
            command = 'staff'
        }
    },

     -- if empty they can spawn any
    GiveWeapon = { 'weapon_appistol', 'weapon_combatpistol', 'weapon_specialcarbine' },
    GiveItem = { 'clip', 'medkit', 'armour', 'repairkit', 'tunerchip', 'suppressor' },

    ConsolePrints = false,

    Webhooks = {
        ['comserv'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",
        ['tpm'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['teleport'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['revive'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['kick'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['freeze'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['spawnvehicle'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['banwipe'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['report'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['staffchat'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",
        ['clearchat'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['endcomserv'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['ban'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['offlineban'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['clearinventory'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['clearloadout'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['unban'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['entitywipe'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",  
        ['giveweapon'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",
        ['givemoney'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['giveitem'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['givecar'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['setjob'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['setgang'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS", 
        ['skin'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",  
        ['announce'] = "https://discord.com/api/webhooks/1162126773463560202/dai7PZvDpMIX3JTTrloR_mdHcDfIQGZbj_6j2TbUWxT21devmIY_mMuKPcKYd_dUpITS",
    },

    ChatMessages = {
        EntityWipe = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-left: 0.156vw solid rgb(59, 152, 245); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(59, 152, 245)" }>[{1}]</text> {0} : {2} 
                </div> ]], args = { data.admin, data.type..' Wipe', data.time }
            })
        end,

        Announcement = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-left: 0.156vw solid rgb(255, 0, 0); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(255, 0, 0)" }>[ANNOUNCEMENT]</text> {0} : <br>{1} 
                </div> ]], args = { data.admin, data.message }
            })
        end,

        Report = function(data)
            TriggerClientEvent('chat:addMessage', data.admin, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(148, 16, 16, 0.65); border-left: 0.156vw solid rgb(255, 0, 0); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(255, 0, 0)" }>[REPORT]</text> {0} : {1} 
                </div> ]], 
                args = { data.player, data.report }
            })	
        end,

        StaffChat = function(data)
            TriggerClientEvent('chat:addMessage', data.admin, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-left: 0.156vw solid rgb(230, 166, 7); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(230, 166, 7)" }>[STAFF]</text> {0} : {1} 
                </div> ]], args = { data.player, data.message }
            })	
        end,

        Alert = function(data)
            TriggerClientEvent('chat:addMessage', data.target, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-left: 0.156vw solid rgb(235, 105, 23); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(235, 105, 23)" }>[ALERT]</text> {0} : {1} 
                </div> ]], args = { data.admin, data.message }
            })		
        end,

        Notice = function(data)
            TriggerClientEvent('chat:addMessage', data.target, {
                template = [[ <div style=" padding: 0.5vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-left: 0.156vw solid rgb(255, 59, 100); border-radius: 0.365vw; width = auto; "> 
                    <text style = "color: rgb(255, 59, 100)" }>[NOTICE]</text> {0}
                </div> ]], args = { data.message }
            })		
        end
    }
}