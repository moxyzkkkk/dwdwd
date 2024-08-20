RegisterNetEvent('billing:send', function(playerId, sharedAccountName, label, amount)
    local xPlayer = ESX.GetPlayerFromId(source)
    local xTarget = ESX.GetPlayerFromId(playerId)

    if amount > 0 and xTarget then
        TriggerEvent('esx_addonaccount:getSharedAccount', sharedAccountName, function(account)
            if account then
                MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'society', sharedAccountName, label, amount}, function(affectedRows)
                    Zen.Functions.Notify(playerId, 'You Have A New Invoice!', 'check', '#00FF00')
                    UpdateBillsTable(playerId)
                end)
            else
                MySQL.insert('INSERT INTO billing (identifier, sender, target_type, target, label, amount) VALUES (?, ?, ?, ?, ?, ?)', {xTarget.identifier, xPlayer.identifier, 'player', xPlayer.identifier, label, amount}, function(affectedRows)
                    Zen.Functions.Notify(playerId, 'You Have A New Invoice!', 'check', '#00FF00')
                    UpdateBillsTable(playerId)
                end)
            end
        end)
    end
end)


RegisterNetEvent('billing:pay', function(billId)
    local xPlayer = ESX.GetPlayerFromId(source)

    MySQL.single('SELECT sender, target_type, target, amount FROM billing WHERE id = ?', {billId}, function(result)
        if result then
            local xTarget = ESX.GetPlayerFromIdentifier(result.sender)

            if result.target_type == 'player' then
                if xTarget then
                    if xPlayer.getAccount('bank').money >= result.amount then
                        ProcessTransaction(xPlayer, xTarget, result.amount, billId, xPlayer.getAccount('bank').money >= result.amount)
                    else
                        Zen.Functions.Notify(result.sender, 'The Player Doesn\'t Have Enough To Pay The Bill!', 'xmark', '#FF0000')
                        Zen.Functions.Notify(source, 'You Don\'t Have Enough To Pay This Bill!', 'xmark', '#FF0000')
                    end
                else
                    Zen.Functions.Notify(source, 'Player No Longer Online!', 'xmark', '#FF0000')
                end
            else
                TriggerEvent('esx_addonaccount:getSharedAccount', result.target, function(account)
                    if account then
                        if xPlayer.getAccount('bank').money >= result.amount then
                            ProcessTransaction(xPlayer, account, result.amount, billId, xPlayer.getAccount('bank').money >= result.amount)
                        else
                            Zen.Functions.Notify(source, 'You Don\'t Have Enough To Pay This Bill', 'xmark', '#FF0000')
                        end
                    end
                end)
            end
        end
    end)
end)

function ProcessTransaction(payer, payee, amount, billId, isBankPayment)
    MySQL.Sync.execute('DELETE FROM billing WHERE id = ?', {billId})
    UpdateBillsTable(payer.source)

    if payer and payee and amount > 0 then
        if isBankPayment then
            payer.removeAccountMoney('bank', amount, "Paid bill")
            payee.addMoney(amount)
        else
            payer.removeAccountMoney('bank', amount, "Bill Paid")
            payee.addMoney(amount)
        end

        if payee.showNotification then
            Zen.Functions.Notify(payee.source, 'Received payment of $'..Zen.Functions.FormatCommas(amount)..' for Invoice', 'check', '#00FF00')
        end

        Zen.Functions.Notify(payer.source, 'You Paid $'..Zen.Functions.FormatCommas(amount), 'check', '#00FF00')
    end
end

function UpdateBillsTable(playerId)
    local xPlayer = ESX.GetPlayerFromId(playerId)
    
    if xPlayer then
        local bills = MySQL.Sync.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = ?', {xPlayer.identifier})
        TriggerClientEvent('billing:menu', playerId, bills)
    end
end

lib.callback.register('billing:get', function(source, player)
    local identifier = Zen.Functions.GetIdentifier(player, 'license')
    
    if not identifier then return end

    local bills = MySQL.Sync.fetchAll('SELECT amount, id, label FROM billing WHERE identifier = ?', { identifier })

    return bills or nil
end)

RegisterNetEvent('playerLoaded', function(player)
    UpdateBillsTable(player)
end) 