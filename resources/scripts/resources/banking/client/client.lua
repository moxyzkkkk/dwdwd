local Banking = Zen.Config.Banking

for i = 1, #Banking.Banks do 
    local marker = lib.points.new(Banking.Banks[i], Banking.Marker.Distance)
    
    function marker:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            local input = lib.inputDialog('Player Banking', {
                {type = 'number', label = 'Amount'}, 
                {type = 'select', label = 'Type', options = {
                    {label = 'Deposit', value = 'Deposit'}, 
                    {label = 'Withdraw', value = 'Withdraw'}
                }} 
            })
            
            if not input then return end
            TriggerServerEvent('banking:use', input[2], input[1]) 
        end

        Zen.Functions.FloatText(Banking.Banks[i], Banking.Marker.Text)
    end

    Zen.Functions.CreateBlip(Banking.Banks[i], Banking.Blip) 
end