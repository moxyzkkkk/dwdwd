RegisterNetEvent("deathscreen:revive", function(target)
    TriggerClientEvent('deathscreen:revive', target)
end)

RegisterNetEvent("deathscreen:performAfterDeath", function(data)
	local xPlayer = ESX.GetPlayerFromId(source)

    if Zen.Config.DeathScreen.OnDeath.RemoveLoadout then
        for i=1, #xPlayer.loadout, 1 do
            xPlayer.removeWeapon(xPlayer.loadout[i].name)
        end
    end

    if data.weapon then 
        Wait(1000)
        xPlayer.addWeapon(data.weapon, 500)
    end
end)

lib.callback.register('deathscreen:checkBalance', function(source, amount)
    local xPlayer = ESX.GetPlayerFromId(source) 
    local cash = xPlayer.getMoney()
    local bank = xPlayer.getAccount('bank').money

    if cash >= amount then
        xPlayer.removeMoney(amount) 
        return true
    elseif bank >= amount then
        xPlayer.removeAccountMoney('bank', amount) 
        return true
    end

    return false
end)
