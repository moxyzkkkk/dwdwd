
Zen.Config.ServerComservs = {
    ChatMessages = {
        Comserv = function(data)
            TriggerClientEvent('chat:addMessage', -1, {
                template = [[ <div style=" padding: 0.4vw; font-size: 0.781vw; background-color: rgba(0,160,0, 0.7); border-radius: 0.165vw; width = auto; "> 
                    <text style = "color: rgb(0, 255, 0)" }>[COMSERV]</text> {0} sent {1} to {3} actions for {2}
                </div> ]], args = { data.admin, data.player, data.reason, data.actions }
            })	
        end,

        EndComserv = function(data)
            local text = (data.admin ~= nil and "{1} ended {0}'s actions") or "{0} finished their actions"

            TriggerClientEvent('chat:addMessage', -1, {
                template = '<div style=" padding: 0.4vw; font-size: 0.781vw; background-color: rgba(0,160,0, 0.7); border-radius: 0.165vw; width = auto; "><text style = "color: rgb(0, 255, 0)" }>[COMSERV]</text> '..text..' </div>',
                args = { data.player, (data.admin ~= nil and data.admin) }
            })	
        end
    }
}