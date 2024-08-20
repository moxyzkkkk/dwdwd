RegisterCommand('dv', function()
    if not DoesEntityExist(cache.vehicle) then
        return
    end

    if not Zen.Functions.CanInteract() then 
        return Zen.Functions.Notify('Can\'t Do This Right Now!', 'xmark', '#FF0000')
    end

    if cache.seat and cache.seat == -1 then
        local netId = NetworkGetNetworkIdFromEntity(cache.vehicle)
        if not NetworkDoesNetworkIdExist(netId) then return end

        DeleteEntity(cache.vehicle)
    end
end, false)