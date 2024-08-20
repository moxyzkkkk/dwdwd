RegisterNetEvent('shop:purchase', function(i, a, f)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local sourceItem = xPlayer.getInventoryItem(i)

    local items = (f == 'kmenu' and Zen.Config.KMenu.Buttons.Items ) or (f == 'police' and Zen.Config.Police.Items) or (f == 'shop' and Zen.Config.Shops.Items)
    local item = items[i]

    local price = (item.price * a)
    
    if xPlayer.getMoney() >= price then
        if sourceItem.limit ~= -1 and (sourceItem.count + a) > sourceItem.limit then
            Zen.Functions.Notify(_source, "You Can Only Get "..(sourceItem.limit - sourceItem.count).." More!", 'xmark', '#FF0000')
        else
            xPlayer.removeMoney(price)
            xPlayer.addInventoryItem(i, a)
            Zen.Functions.Notify(_source, "You bought x"..a.." "..Zen.Items[i].label.." for $"..Zen.Functions.FormatCommas(price), 'basket-shopping', '#00FF00')
        end
    else
        Zen.Functions.Notify(_source, 'You dont have enough money!', 'dollar', '#FF0000')
    end
end)
