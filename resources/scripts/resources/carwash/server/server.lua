RegisterNetEvent('carwash:pay', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local price = Zen.Config.CarWash.WashPrice

    if xPlayer.getMoney() >= price then
        xPlayer.removeMoney(price)
        TriggerClientEvent('carwash:start', source)
    else
        return Zen.Functions.Notify(source, 'You dont have enough money!', 'car', '#FF0000')
    end
end)