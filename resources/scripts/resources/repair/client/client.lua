local Repair = Zen.Config.Repair
local repairing = false

local maxRepairCount = 2
local repairCounts = {} 

for i = 1, #Repair.Locations do
    local zone = Repair.Locations[i]

    local point = lib.points.new(zone[1], zone[2])
     
    function point:onEnter()
        if not cache.vehicle or repairing then return end
        lib.showTextUI('[E] - Repair Vehicle')
    end

    function point:onExit()
        lib.hideTextUI()
    end

    function point:nearby()
        if IsControlJustReleased(0, 38) then
            local vehicle = cache.vehicle

            if not vehicle then return end

            if not cache.seat == -1 then
                return Zen.Functions.Notify('You Need To Be The Driver!', 'car', '#FF0000')
            end
        
            if repairing then 
                return Zen.Functions.Notify('You Are Already Repairing!', 'car', '#FF0000') 
            end

            repairing = true

            if lib.progressCircle({
                duration = 8000,
                position = 'bottom',
                useWhileDead = false,
                canCancel = false,
                disable = {
                    car = true
                }
            }) then 
                SetVehicleUndriveable(vehicle,false)
                SetVehicleFixed(vehicle)
                SetVehicleEngineOn(vehicle, true, false )
                Zen.Functions.Notify("The mechanic repaired your car!", "car", "#00FF00")
        
                repairing = false
            end
        end
    end

    Zen.Functions.CreateBlip(zone[1], Repair.Blip)
end

RegisterNetEvent('repair:vehicle')
AddEventHandler('repair:vehicle', function()
    local vehicle = cache.vehicle

    if not DoesEntityExist(cache.vehicle) or not cache.seat == -1 then
        return Zen.Functions.Notify('You Aren\'t In A Vehicle!', 'car', '#FF0000')
    end

    if repairing then 
        return Zen.Functions.Notify('You Are Already Repairing!', 'car', '#FF0000') 
    end

    local vehicleHandle = tostring(vehicle)
    local repairCount = repairCounts[vehicleHandle] or 0

    if (repairCount >= maxRepairCount) then
        return Zen.Functions.Notify("Your vehicle was too badly damaged. Unable to repair!", 'car', '#FF0000')
    end

    repairing = true

    if lib.progressCircle({
        duration = 8000,
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
			car = true
		}
    }) then 
        if GetVehicleEngineHealth(vehicle) < 325.0 then 
            SetVehicleUndriveable(vehicle, false)
            SetVehicleEngineHealth(vehicle, 320.0 + 5)
            SetVehiclePetrolTankHealth(vehicle, 750.0)
            SetVehicleEngineOn(vehicle, true, false)
            SetVehicleOilLevel(vehicle,(GetVehicleOilLevel(vehicle)/3)-0.5)
            repairCounts[vehicleHandle] = repairCount + 1
            Zen.Functions.Notify(Repair.Messages.Fix[math.random(#Repair.Messages.Fix)], 'car', '#00FF00')
        else
            Zen.Functions.Notify(Repair.Messages.NoFix[math.random(#Repair.Messages.NoFix)], 'car', '#FF0000')
        end

        repairing = false
    end
end)
