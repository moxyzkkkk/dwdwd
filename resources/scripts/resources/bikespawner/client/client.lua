local BikeSpawner = Zen.Config.BikeSpawner
local currentSpawn = nil
local spawned = false

lib.registerMenu({
    id = 'bikeSpawner',
    title = 'Bike Spawner',
    position = 'bottom-right',
    options = BikeSpawner.Models
}, function(_, _, args)
    if cache.vehicle then 
        return Zen.Functions.Notify('You Already In A Vehicle', 'car', '#FF0000')
    end

    if spawned then return end

    spawned = true

    Zen.Streaming.SpawnVehicle(args.model, vec3(currentSpawn.x, currentSpawn.y, currentSpawn.z), currentSpawn.w, function(callback)
        SetVehicleNumberPlateText(callback, 'BIKE')
        TaskWarpPedIntoVehicle(cache.ped, callback, -1)
        spawned = false
    end, true, cache.serverId)
end)

for i = 1, #BikeSpawner.Spawners do 
    local marker = lib.points.new(BikeSpawner.Spawners[i].Marker, BikeSpawner.Marker.Distance)

    function marker:onEnter()
        currentSpawn = BikeSpawner.Spawners[i].Spawn
    end
    
    function marker:onExit() 
        currentSpawn = nil
        lib.hideMenu() 
    end

    function marker:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
            lib.showMenu('bikeSpawner')
        end

        Zen.Functions.FloatText(BikeSpawner.Spawners[i].Marker, BikeSpawner.Marker.Text)
    end

    Zen.Functions.CreateBlip(BikeSpawner.Spawners[i].Marker, BikeSpawner.Blip) 
end