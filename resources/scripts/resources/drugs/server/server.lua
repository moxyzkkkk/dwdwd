local function canCarryItem(item, amount)
    if item.limit <= 0 then
        return true
    end

    if (item.count + amount) > item.limit then
        return false
    end

    return true
end

RegisterNetEvent('drugs:receive', function(items)
    local player = ESX.GetPlayerFromId(source)
    if not player then return end

    if items.SellReward then
        local hasItem = player.getInventoryItem(items.Need.Name)

        if not hasItem or (hasItem and hasItem.count < items.Need.Amount) then
            return Zen.Functions.Notify(source, 'You Do Not Have Enough Items', 'pill', '#FF0000')
        end

        local success = pcall(function()
            player.removeInventoryItem(items.Need.Name, items.Need.Amount)
        end)

        if success then
            player.addAccountMoney('black_money', items.SellReward.Amount)
        end
    elseif items.Need then
        local hasItem = player.getInventoryItem(items.Need.Name)
        local rewardItem = player.getInventoryItem(items.Reward.Name)

        if not hasItem or (hasItem and hasItem.count < items.Need.Amount) then
            return Zen.Functions.Notify(source, 'You Do Not Have Enough Items', 'pill', '#FF0000')
        end

        if rewardItem then
            if not canCarryItem(rewardItem, items.Reward.Amount) then
                return Zen.Functions.Notify(source, 'You Can Not Carry More Items', 'pill', '#FF0000') 
            end
        end

        local success = pcall(function()
            player.removeInventoryItem(items.Need.Name, items.Need.Amount)
        end)

        if success then
            player.addInventoryItem(items.Reward.Name, items.Reward.Amount)
        end
    else
        local rewardItem = player.getInventoryItem(items.Reward.Name)

        if rewardItem then
            if not canCarryItem(rewardItem, items.Reward.Amount) then
                return Zen.Functions.Notify(source, 'You Can Not Carry More Items', 'pill', '#FF0000')
            end
        end

        player.addInventoryItem(items.Reward.Name, items.Reward.Amount)
    end
end)