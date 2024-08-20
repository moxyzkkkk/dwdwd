stateBag = LocalPlayer.state
playerCount = {
    online = 0,
    max = Zen.Config.Server.MaxPlayers
}

RegisterNetEvent('showNotification', function(text, icon, color)
    Zen.Functions.Notify(text, icon, color)
end)

CreateThread(function()
    repeat 
        Wait(2000) 
    until NetworkIsSessionActive()
    
    while not stateBag.job do 
        Wait(500) 
    end
    
    TriggerServerEvent('playerLoaded', cache.serverId)
    TriggerServerEvent('gangs:playerLoaded')
    TriggerEvent('playerLoaded')

    NetworkSetTalkerProximity(12.0)
    StartAudioScene("CHARACTER_CHANGE_IN_SKY_SCENE")
    SetAudioFlag("LoadMPData", true)
    SetAudioFlag("DisableFlightMusic", true)
    SetAudioFlag("WantedMusicDisabled", true)
    SetAudioFlag("PoliceScannerDisabled", true)
    SetAudioFlag("OnlyAllowScriptTriggerPoliceScanner", true)
    SetAudioFlag("AllowPoliceScannerWhenPlayerHasNoControl", false)

    SetCanAttackFriendly(cache.ped, true, false)
	NetworkSetFriendlyFireOption(true)
    ClearPlayerWantedLevel(cache.playerId)
	SetMaxWantedLevel(0)

    SetPlayerTargetingMode(2)
    SetWind(0)

    N_0x4757f00bc6323cfe(-1553120962, 0.0) 

    StatSetInt('MP0_SHOOTING_ABILITY', 120, true)
    StatSetInt('MP0_STAMINA', 100, true)
    StatSetInt('MP0_LUNG_CAPACITY', 100, true)
    StatSetInt('MP0_STEALTH_ABILITY', 100, true)

    SetMapZoomDataLevel(0, 0.96, 0.9, 0.08, 0.0, 0.0) 
    SetMapZoomDataLevel(1, 1.6, 0.9, 0.08, 0.0, 0.0) 
    SetMapZoomDataLevel(2, 8.6, 0.9, 0.08, 0.0, 0.0) 
    SetMapZoomDataLevel(3, 12.3, 0.9, 0.08, 0.0, 0.0)
    SetMapZoomDataLevel(4, 22.3, 0.9, 0.08, 0.0, 0.0)
    SetRadarZoom(1100)
    
    ToggleUIs(true)
    UpdateTopRight()
end)

ToggleUIs = function(bool)
    if bool == true then 
        Zen.Functions.NUI('showHud', {})
        Zen.Functions.NUI('showMoneyUI', {})
        if insideGreenzone then 
            Zen.Functions.NUI('enterGreenzone', {})
        end
    else 
        Zen.Functions.NUI('hideHud', {})
        Zen.Functions.NUI('hideMoneyUI', {})
        Zen.Functions.NUI('exitGreenzone', {})
    end
end

UpdateTopRight = function(type, value)
    local data = {}
    local ply = ESX.GetPlayerData()

    if type == 'gang' or not type then 
        local gang = (value and value.label or stateBag.gang)
        local rank = (value and value.rank_label or stateBag.gang_rank)

        if gang == nil or gang == '' then 
            data.gang = ''
        else
            data.gang = gang..' - '..rank

        end
    end

    if type == 'job' or not type then 
        data.job = (value and value.label or stateBag.job.label)..' - '..(value and value.grade_label or stateBag.job.grade_label)

        if Zen.Jobs[(value and value.name or stateBag.job.name)].grades[tostring((value and value.grade or stateBag.job.grade))].name == 'unemployed' then 
            data.job = (value and value.label or stateBag.job.label)
        end
    end
    
    if type == 'accounts' or not type then 
        if value then 
            data[value.name] = Zen.Functions.FormatCommas(tonumber(value.money))
        else
            local accounts = ply.accounts
            for i = 1, #accounts do
                if accounts[i].name == 'bank' then
                    data.bank = Zen.Functions.FormatCommas(accounts[i].money)
                elseif accounts[i].name == 'money' then
                    data.money = Zen.Functions.FormatCommas(accounts[i].money)
                elseif accounts[i].name == 'black_money' then
                    data.black_money = Zen.Functions.FormatCommas(accounts[i].money)
                end
            end

        end
    end

    Zen.Functions.NUI('updateMoneyUI', data)
end

RegisterNetEvent('esx:setAccountMoney', function(account)
    local value = { name = account.name, money = account.money }
    UpdateTopRight('accounts', value)
end)

RegisterNetEvent('esx:setJob', function(data)
    UpdateTopRight('job', data)
end)

RegisterNetEvent('player:count', function(data)
    playerCount.online = data
end)

