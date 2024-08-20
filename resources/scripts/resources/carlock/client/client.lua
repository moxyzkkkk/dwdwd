local function CarLockCheck(vehicle)
    local state = Entity(vehicle).state

    if state.ownerId == cache.serverId then
        return true
    end

    return false
end

local function CarLock()
    local vehicle = lib.getClosestVehicle(cache.coords, Zen.Config.CarLock.Distance, true)
    if vehicle and DoesEntityExist(vehicle) then
        if CarLockCheck(vehicle) == false then 
            return Zen.Functions.Notify('You Dont Own This Vehicle', 'xmark', '#b50707')
        end

        local status = GetVehicleDoorLockStatus(vehicle)
        if status == 1 then
            SetVehicleDoorsLocked(vehicle, 2)
            PlayVehicleDoorCloseSound(vehicle, 1)
            SetVehicleDoorsShut(vehicle)
            SetVehicleDoorsLockedForAllPlayers(vehicle, true)
            Zen.Functions.Notify('You Locked Your Vehicle!', 'car', '#b50707')

        elseif status == 2 then
            SetVehicleDoorsLocked(vehicle, 1)
            PlayVehicleDoorOpenSound(vehicle, 0)
            SetVehicleDoorsLockedForAllPlayers(vehicle, false)
            Zen.Functions.Notify('You Unlocked Your Vehicle!', 'car', '#07b524')

        end

        if not DoesEntityExist(cache.vehicle) then
            if not HasAnimDictLoaded('anim@mp_player_intmenu@key_fob@') then
                lib.requestAnimDict('anim@mp_player_intmenu@key_fob@')
            end

            TaskPlayAnim(cache.ped, 'anim@mp_player_intmenu@key_fob@', 'fob_click_fp', 8.0, 8.0, -1, 48, 1, false, false, false)
        end

        SetVehicleLights(vehicle, 2)
        Wait(150)
        SetVehicleLights(vehicle, 0)
        Wait(150)
        SetVehicleLights(vehicle, 2)
        Wait(150)
        SetVehicleLights(vehicle, 0)
    end
end

RegisterCommand('carlock', CarLock, false)
RegisterKeyMapping('carlock', 'Toggle your vehicle doors', 'keyboard', 'U')