lib.callback.register('getPlayerData', function(source, target)
    local xTarget = ESX.GetPlayerFromId(target)

    if not xTarget then return end

    return {
        inventory = xTarget.inventory,
        loadout = xTarget.loadout,
        accounts = xTarget.accounts,
    }
end)