local CarWash = Zen.Config.CarWash
local usingWash = false

for i = 1, #CarWash.Locations do 
    local marker = lib.points.new(CarWash.Locations[i], CarWash.Marker.Distance)

    function marker:nearby()
        if not cache.vehicle then return end
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) and not usingWash then
            TriggerServerEvent('carwash:pay')
        end

        if not usingWash then
            Zen.Functions.FloatText(CarWash.Locations[i], CarWash.Marker.Text)
        end
    end

    Zen.Functions.CreateBlip(CarWash.Locations[i], CarWash.Blip) 
end

RegisterNetEvent('carwash:start', function()
    local dist = 'cut_family2'
    local fxName = 'cs_fam2_ped_water_splash'
    local vehicle = cache.vehicle

    usingWash = true
    FreezeEntityPosition(vehicle, true)
    RequestNamedPtfxAsset(dist)
    while not HasNamedPtfxAssetLoaded(dist) do
        Wait(1)
    end
    UseParticleFxAssetNextCall(dist)
    local particle = StartParticleFxLoopedAtCoord(fxName, cache.coords, 0.0, 0.0, 0.0, 8.0, false, false, false, 0)

    if lib.progressCircle({
        duration = 5000,
        label = 'Washing Car...',
        position = 'bottom',
        useWhileDead = false,
        canCancel = false,
        disable = {
            car = true,
            move = true,
            combat = true,
        }
    }) then
        StopParticleFxLooped(particle, false)
        SetVehicleDirtLevel(vehicle, 0.0)
        WashDecalsFromVehicle(vehicle, 1.0)
        FreezeEntityPosition(vehicle, false)
        usingWash = false
        Zen.Functions.Notify('You have successfully washed your car!', 'soap', '#09aedb')
    end
end)