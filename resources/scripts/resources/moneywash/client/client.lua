local MoneyWash = Zen.Config.MoneyWash

for i = 1, #MoneyWash.Locations do 
    local point = lib.points.new(MoneyWash.Locations[i], MoneyWash.Marker.Distance, {
        coords = MoneyWash.Locations[i],
        text = MoneyWash.Marker.Text
    })
    
    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
            local input = lib.inputDialog('Money Wash', {
                {type = 'number', label = 'Amount To Wash', icon = 'dollar'},
            })

            if not input then return end  
            
            TriggerServerEvent('moneywash:process', MoneyWash.ExchangeRate, input[1])
        end

        Zen.Functions.FloatText(self.coords, self.text)
    end

    Zen.Functions.CreateBlip(MoneyWash.Locations[i], MoneyWash.Blip)
end