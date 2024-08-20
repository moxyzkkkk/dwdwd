local PiggyBack = Zen.Config.PiggyBack
PiggyBackData = {
    Cooldown = false,
    InProgress = false,
    Target = 0
}

RegisterCommand("pb",function()
    if PiggyBackData.Cooldown then
        return Zen.Functions.Notify('Wait 3 Seconds To Use This Command Again!', 'xmark', '#FF0000')
    end

    if PiggyBackData.InProgress then 
        PiggyBackData.InProgress = false
        ClearPedSecondaryTask(cache.ped)
        DetachEntity(cache.ped, true, false)
        TriggerServerEvent("piggyback:stop",PiggyBackData.Target)
        PiggyBackData.Target = 0
        return
    end

    if not Zen.Functions.CanInteract() then 
        return Zen.Functions.Notify('Can\'t Do This Right Now!', 'xmark', '#FF0000')
    end

    local closestPlayer = lib.getClosestPlayer(cache.coords, 3.0, false)

    if not closestPlayer then 
        return Zen.Functions.Notify('No One Nearby!', 'user', '#FF0000') 
    end
        
    local targetSrc = GetPlayerServerId(closestPlayer)
    
    if targetSrc ~= -1 then
        PiggyBackData.InProgress = true
        PiggyBackData.Cooldown = true
        PiggyBackData.Target = targetSrc
        TriggerServerEvent("piggyback:sync",targetSrc)

    else
        Zen.Functions.Notify('No One Nearby!', 'user', '#FF0000')
    end

    SetTimeout(PiggyBack.Cooldown * 1000, function()
        PiggyBackData.Cooldown = false
    end)
    
    local data = PiggyBack.Animations[1]

    if not HasAnimDictLoaded(data.dict) then 
        lib.requestAnimDict(data.dict) 
    end

    while true do
        Wait(0)
        if not PiggyBackData.InProgress then
            break
        end

        if not IsEntityPlayingAnim(cache.ped, data.dict, data.anim, 3) then
            TaskPlayAnim(cache.ped, data.dict, data.anim, 8.0, -8.0, 100000, data.flag, 0, false, false, false)
        end
    end
end)
 
RegisterNetEvent("piggyback:sync", function(targetSrc)
    local playerPed = cache.ped
    local targetPed = GetPlayerPed(GetPlayerFromServerId(targetSrc))
    PiggyBackData.InProgress = true

    local data = PiggyBack.Animations[2]

    if not HasAnimDictLoaded(data.dict) then 
        lib.requestAnimDict(data.dict) 
    end
    
    AttachEntityToEntity(cache.ped, targetPed, 0, data.attach, 0.5, 0.5, 180, false, false, false, false, 2, false)

    while true do 
        Wait(0)
        if not PiggyBackData.InProgress then
            break
        end

        if not IsEntityPlayingAnim(cache.ped, data.dict, data.anim, 3) then
            TaskPlayAnim(cache.ped, data.dict, data.anim, 8.0, -8.0, 100000, data.flag, 0, false, false, false)
        end
    end
end)

RegisterNetEvent("piggyback:stop", function()
    PiggyBackData.InProgress = false
    ClearPedSecondaryTask(cache.ped)
    DetachEntity(cache.ped, true, false)
end)