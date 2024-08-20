Zen.Config.Chat = {
    AntiSpam = 5,
    MaxCharacters = 75,

    Commands = {
        Twitter = { 'tw', 'tweet', 'twt' },
        Advertisment = { 'ad', 'advertise' }
    },

    ChatMessages = {
        OnJoin = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style=" padding: 0.38vw; font-size: 0.781vw; background-color: rgba(255, 0, 0, 0.35); border-radius: 0.365vw; width = auto; display: flex; align-items: center; "><i class="fa-solid fa-user" style="margin-left: 1.5%;"></i> <text style="margin-left: 1.5%;"><span style="color: rgb(255,0,0)">{0}</span> has joined {1} </text></div>', 
                args = { data.name, data.server }
            })
        end,
            
        Message = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style=" padding: 0.38vw; font-size: 0.781vw; background-color: rgba(0, 0, 0, 0.65); border-radius: 0.365vw; width = auto; display: flex; align-items: center; "><img src="'..data.avatar..'" height="25" width="25" style="border-radius: 20.26vw; margin-left: 1%;"></img><text style="margin-left: 1.5%;">'..data.tag..'^7 : {0} </text></div>', 
                args = { data.message }
            })
        end,

        Twitter = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style="padding: 0.38vw; margin: 0.1vw; background-color: rgba(0, 180, 237, 0.50); border-radius: 0.26vw; border: 0.052vw solid #00C2FF; width = auto; display: flex; align-items: center;"><i class="fa-brands fa-twitter"></i><text style="margin-left: 1%;">{0} : {1}</text></div>',
                args = { data.player, data.message }
            })
        end,

        Advertisment = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style="padding: 0.38vw; margin: 0.1vw; background-color: rgba(202, 145, 0, 0.50); border-radius: 0.26vw; border: 0.052vw solid #FFC633; width = auto; display: flex; align-items: center;"><i class="fa-solid fa-rectangle-ad"></i><text style="margin-left: 1%;">{0} : {1}</text></div>',
                args = { data.player, data.message }
            })
        end
    }
}