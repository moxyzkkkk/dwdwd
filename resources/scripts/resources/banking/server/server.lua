RegisterNetEvent('banking:use', function(type, amount)
    local xPlayer = ESX.GetPlayerFromId(source)

    if (amount == nil or amount <= 0 or (type == 'Withdraw' and amount > xPlayer.getAccount('bank').money) or (type == 'Deposit' and amount > xPlayer.getAccount('money').money)) then
        return Zen.Functions.Notify(source, 'Invalid Amount!', 'dollar', '#FF0000')
    end

    if type == "Withdraw" then 
        xPlayer.removeAccountMoney('bank', amount)
        xPlayer.addMoney(amount)
    elseif type == "Deposit" then
        xPlayer.addAccountMoney('bank', amount)
        xPlayer.removeMoney(amount)
    end

    Zen.Functions.Notify(source, 'You '..type..'ed $'..amount, 'dollar', '#00FF00')

    Zen.Functions.LogToDiscord(Zen.Webhooks['banking'], 'Player '..type..'ed Bank', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Amount:** $'..Zen.Functions.FormatCommas(amount))
end)