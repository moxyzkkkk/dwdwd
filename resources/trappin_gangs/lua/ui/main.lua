local isVisible = false

local DATA = {}


local Open = function()
    ToggleFrame()
end

RegisterCommand('gangmanage', Open, false)
RegisterNetEvent('trp_bossmenu:cl:openMenu', Open)

function SendReactMessage(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

function RefreshGangData()
    local data = lib.callback.await('trappin_gangs:sv:getgangdata', false)
    if not data then return nil end
    DATA = data
    return data
end

function ToggleFrame()
    isVisible = not isVisible
    if isVisible then
       local canOpen = RefreshGangData()
       if not canOpen then return end
    end
    SendReactMessage('setVisible', isVisible)
    SetNuiFocus(isVisible, isVisible)
end

RegisterNUICallback('setVisible', function(_, cb)
    ToggleFrame()
    cb({})
end)

RegisterNUICallback('getRanks', function(_, cb)
    cb(DATA.ranks or {})
end)

RegisterNUICallback('getGangInfo', function(_, cb)
    cb(DATA.info or {})
end)

RegisterNUICallback('getMembers', function(_, cb)
    cb(DATA.members or {})
end)

RegisterNUICallback('getInvites', function(_, cb)
    cb(DATA.gangWarInvites or {})
end)

RegisterNUICallback('getGangs', function(_, cb)
    cb(DATA.warGangs or {})
end)

RegisterNUICallback('getRecruits', function(_, cb)
    cb(DATA.recrutingData or {})
end)










RegisterNUICallback('addRank', function(body, resultCallback)
    local newrank = body.rank_name
    local data = lib.callback.await('trappin_gangs:sv:addRank', false, newrank)
    RefreshGangData()
    resultCallback({})
end)

RegisterNUICallback('editRank', function(body, resultCallback)
    local rankid = body.rank_id
    local newrank = body.rank_name
    local data = lib.callback.await('trappin_gangs:sv:editRank', false, rankid, newrank)
    RefreshGangData()
    resultCallback({})
end)



RegisterNuiCallback('setRecrutingSettings', function(body, resultCallback)
    local data = lib.callback.await('trappin_gangs:sv:setRecrutingSettings', false, body)
    RefreshGangData()
        return resultCallback(true)
end)

RegisterNuiCallback('editMember', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:editMember', false, body)
    RefreshGangData()
        return resultCallback(true)
end)

RegisterNuiCallback('acceptGangWar', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:acceptGangInvite', false, body.id)
    RefreshGangData()
        return resultCallback(true)
end)

RegisterNuiCallback('declineGangWar', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:declineGangWar', false, body.id)
    RefreshGangData()
        return resultCallback(true)
end)

RegisterNuiCallback('kickMember', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:kickmember', false, body.member_id)
    RefreshGangData()
        return resultCallback(true)
end)

RegisterNuiCallback('addMember', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:invite', false, body.player_id)
    RefreshGangData()
    return resultCallback(true)
end)

RegisterNuiCallback('inviteGangWar', function(body, resultCallback)
    local response = lib.callback.await('trappin_gangs:sv:addGangWarInvite', false, body)
    RefreshGangData()
    return resultCallback(true)
end)

RegisterNuiCallback('acceptGangRecruit', function(body, resultCallback)
    local response = lib.callback.await('trp_gangs:sv:recruite:accept', false, body.playerId)
    RefreshGangData()
    return resultCallback(true)
end)
RegisterNuiCallback('rejectGangRecruit', function(body, resultCallback)
    local response = lib.callback.await('trp_gangs:sv:recruite:reject', false, body.playerId)
    RefreshGangData()
    return resultCallback(true)
end)


CurrentGangInvite = nil
RegisterNetEvent('trp_gangs:cl:inviteToGang', function(gangLabel , gangName)
    TriggerEvent('trappin_ui:client:notify', {
        type = 'inform',
        text = 'You have been invited to ' .. gangLabel .. ' gang enter /acceptganginvite to accept'
    })
    CurrentGangInvite = gangName
end)

RegisterCommand('acceptganginvite', function()
    if CurrentGangInvite == nil then
        TriggerEvent('trappin_ui:client:notify', {
            type = 'inform',
            text = 'You have no gang invites'
        })
        return
    end
    local success = lib.callback.await('trappin_gangs:sv:joinGang', false, CurrentGangInvite)
end, false)

RegisterNetEvent('trp_gangs:cl:leavegang', function()
    ExecuteCommand('leavegang')
end)


RegisterNuiCallback('openVault', function(body, resultCallback)
    ToggleFrame()
    local response = lib.callback.await('trappin_gangs:sv:openvault', false)
    resultCallback({})
end)


RegisterNetEvent('trp_bossmenu:cl:opencase', function()
    lib.callback.await('trappin_gangs:sv:openvault', false)
end)

RegisterNetEvent('trp_gangs:cl:gangsLoaded', function()
    if isVisible then
        RefreshGangData()
    end
end)

local Color = nil
local canceled = false

RegisterNuiCallback('hideColorPicker', function(body, resultCallback)
    SendNUIMessage({
        action = 'toggleColorPicker',
        data = false
    })
    SetNuiFocus(false, false)
    canceled = true
end)

RegisterNuiCallback('setColorPicker', function(body, resultCallback)
    body.a = body.a * 100.0
    Color = body

    SendNUIMessage({
        action = 'toggleColorPicker',
        data = false
    })
    SetNuiFocus(false, false)
    canceled = false
end)



PickColor = function(args)
    args = args or {}
    args.r = args.r or 0
    args.g = args.g or 0
    args.b = args.b or 0
    args.a = args.a or 1
    Color = nil
    canceled = false
    SendNUIMessage({
        action = 'toggleColorPicker',
        data = true
    })
    Wait(20)
    SendNUIMessage({
        action = 'setColorPicker',
        data = args
    })
    SetNuiFocus(true, true)
    local p = promise:new()
    CreateThread(function()
        while Color == nil and canceled == false do
            Wait(0)
        end
        p:resolve(Color)
    end)
    return Citizen.Await(p)
end

exports('getColorPickerValue', PickColor)
