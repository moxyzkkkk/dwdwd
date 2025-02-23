--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

ESX = exports['core']:getSharedObject()
PlayerData = {}

jobName = nil

CreateThread(function()    
    while (ESX.GetPlayerData() == nil or ESX.GetPlayerData().job == nil or ESX.GetPlayerData().job.name == nil) do
		Wait(100)
	end

    PlayerData = ESX.GetPlayerData()
    
    jobName = getJobName()
    updateUICurrentJob()
end)

RegisterNetEvent('esx:playerLoaded')
AddEventHandler('esx:playerLoaded', function(xPlayer)
    PlayerData = xPlayer   
end)

RegisterNetEvent('esx:setJob')
AddEventHandler('esx:setJob', function(job)
    PlayerData.job = job
    
    jobName = getJobName()
    updateUICurrentJob()
end)

function getJobName()
    if (PlayerData ~= nil and PlayerData.job ~= nil and PlayerData.job.name ~= nil) then
        return PlayerData.job.name
	end
	return nil
end
