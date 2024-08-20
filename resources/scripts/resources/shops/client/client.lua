local Shops = Zen.Config.Shops

lib.registerMenu({ 
    id = 'shops', 
    title = 'Shop Menu', 
    position = 'bottom-right', 
    options = {},
}, function(selected, scrollIndex, args) 
    local data = {
        label = args.label,
        item = args.item,
        price = args.price * scrollIndex,
        amount = scrollIndex
    }

    TriggerServerEvent('shop:purchase', data.item, data.amount, 'shop')
end)

for i = 1, #Shops.Locations do 
    local point = lib.points.new(Shops.Locations[i], Shops.Marker.Distance)

    function point:onExit() 
        lib.hideMenu('shops') 
    end
    
    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
            lib.showMenu('shops') 
        end

        Zen.Functions.FloatText(Shops.Locations[i], Shops.Marker.Text)
    end

    Zen.Functions.CreateBlip(Shops.Locations[i], Shops.Blip)
end

RegisterNetEvent('playerLoaded', function()
    local shopsTable = {}
    
    for k, v in pairs(Shops.Items) do 
        shopsTable[#shopsTable+1] = {
            close = false,
            icon = v.icon,
            label = v.label, 
            args = {
                label = v.label,
                item = v.item,
                price = v.price
            },
            values = {}
        }

        for i = 1, 100 do
            local price = v.price * i

            shopsTable[#shopsTable].values[#shopsTable[#shopsTable].values+1] = {
                label = '$'..Zen.Functions.FormatCommas(price), 
            }
        end
    end

    lib.setMenuOptions('shops', shopsTable)
end)