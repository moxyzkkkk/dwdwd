local weapons = {
    ['WEAPON_PISTOL'] = 'COMPONENT_AT_PI_SUPP_02',
    ['WEAPON_COMBATPISTOL'] = 'COMPONENT_AT_PI_SUPP',
    ['WEAPON_APPISTOL'] = 'COMPONENT_AT_PI_SUPP',
    ['WEAPON_HEAVYPISTOL'] = 'COMPONENT_AT_PI_SUPP',
    ['WEAPON_VINTAGEPISTOL'] = 'COMPONENT_AT_PI_SUPP',
    ['WEAPON_SMG'] = 'COMPONENT_AT_PI_SUPP',
    ['WEAPON_PUMPSHOTGUN'] = 'COMPONENT_AT_SR_SUPP',
    ['WEAPON_CARBINERIFLE'] = 'COMPONENT_AT_AR_SUPP',
    ['WEAPON_ADVANCEDRIFLE'] = 'COMPONENT_AT_AR_SUPP',
    ['WEAPON_BULLPUPRIFLE'] = 'COMPONENT_AT_AR_SUPP',
    ['WEAPON_ASSAULTSHOTGUN'] = 'COMPONENT_AT_AR_SUPP',
    ['WEAPON_MARKSMANRIFLE'] = 'COMPONENT_AT_AR_SUPP',
    ['WEAPON_PISTOL50'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_SPECIALCARBINE'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_SNIPERRIFLE'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_HEAVYSHOTGUN'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_BULLPUPSHOTGUN'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_MICROSMG'] = 'COMPONENT_AT_AR_SUPP_02' ,
    ['WEAPON_ASSAULTSMG'] = 'COMPONENT_AT_AR_SUPP_02',
    ['WEAPON_ASSAULTRIFLE'] = 'COMPONENT_AT_AR_SUPP_02',
}

RegisterNetEvent('usable:item', function(item)
    local ped = cache.ped
    if item == 'medkit' then 
        if GetEntityHealth(ped) ~= 200 then
            SetEntityHealth(ped, 200)
            TriggerServerEvent('usable:remove', item)
        else
            Zen.Functions.Notify("Already Max Health!", 'heart', '#FF0000')
        end
    elseif item == 'armour' then 
        if GetPedArmour(ped) ~= 100 then
            SetPedArmour(ped, 100)
            TriggerServerEvent('usable:remove', item)
        else
            Zen.Functions.Notify("Already Max Armour!", 'shield', '#FF0000')
        end
    elseif item == 'repairkit' then 
        local vehicle = lib.getClosestVehicle(cache.coords, 3.0, true)

        if DoesEntityExist(vehicle) and IsPedOnFoot(ped) then 
            TaskStartScenarioInPlace(ped, 'PROP_HUMAN_BUM_BIN', 0, true)

            CreateThread(function()
                Wait(10000)
                SetVehicleFixed(vehicle)
                SetVehicleDeformationFixed(vehicle)
                SetVehicleUndriveable(vehicle, false)
                ClearPedTasksImmediately(ped)
                TriggerServerEvent('usable:remove', 'repairkit')
            end)
        else
            Zen.Functions.Notify('No vehicles nearby!', 'xmark', '#FF0000')
        end
    elseif item == 'clip' then 
        if IsPedArmed(ped, 4) then
            hash = GetSelectedPedWeapon(ped)
            if hash ~= nil then
                AddAmmoToPed(ped, hash, 900)
            else
                Zen.Functions.Notify('You Arent Holding A Weapon', 'xmark', '#FF0000')
            end
        end
    elseif item == 'tunerchip' then 
        TriggerEvent('tunerchip:use')
    elseif item == 'suppressor' then 
        if not cache.weapon then 
            return Zen.Functions.Notify('You Arent Holding A Weapon', 'xmark', '#FF0000')
        end

        local ped = cache.ped
        local weapon = string.upper(Zen.HashKey[cache.weapon])

        if weapons[weapon] then 
            if not HasPedGotWeaponComponent(ped, weapon, GetHashKey(weapons[weapon])) then 
                Zen.Functions.Notify('You Put On Suppressor', 'check', '#00FF00')
                GiveWeaponComponentToPed(ped, weapon, GetHashKey(weapons[weapon]))
                TriggerServerEvent('usable:remove', 'suppressor')
            end
        end
    end
end)