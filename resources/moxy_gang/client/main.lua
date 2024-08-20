RegisterNetEvent('gang:updateUI')
AddEventHandler('gang:updateUI', function(gangInfo)
    SendNUIMessage({
        action = 'openUI',
        gangLabel = gangInfo.gangLabel,
        members = gangInfo.members,
        maxSlots = gangInfo.maxSlots,
        ranks = gangInfo.ranks
    })
    SetNuiFocus(true, true)
end)

RegisterNUICallback('closeUI', function(data, cb)
    SetNuiFocus(false, false)
    cb('ok')
end)
