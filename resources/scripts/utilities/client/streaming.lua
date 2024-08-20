Zen.Streaming = {}

Zen.Streaming.RequestModel = function(modelHash, cb)
	modelHash = (type(modelHash) == 'number' and modelHash or joaat(modelHash))

	if not HasModelLoaded(modelHash) and IsModelInCdimage(modelHash) then
		RequestModel(modelHash)

		while not HasModelLoaded(modelHash) do
			Wait(0)
		end
	end

	if cb ~= nil then
		cb()
	end
end

Zen.Streaming.SpawnVehicle = function(vehicle, coords, heading, cb, networked, lockable)
    local model = type(vehicle) == 'number' and vehicle or joaat(vehicle)
    local vector = type(coords) == "vector3" and coords or vec(coords.x, coords.y, coords.z)
    networked = networked == nil and true or networked

    CreateThread(function()
        Zen.Streaming.RequestModel(model)

        local vehicle = CreateVehicle(model, vector.xyz, heading, networked, true)

        if networked then
            local id = NetworkGetNetworkIdFromEntity(vehicle)
            SetNetworkIdCanMigrate(id, true)
            SetEntityAsMissionEntity(vehicle, true, true)
        end

        if lockable ~= false then 
            Entity(vehicle).state:set('ownerId', lockable, false)
        end

        SetVehicleHasBeenOwnedByPlayer(vehicle, true)
        SetVehicleNeedsToBeHotwired(vehicle, false)
        SetModelAsNoLongerNeeded(model)
        
        SetVehRadioStation(vehicle, 'OFF')

        RequestCollisionAtCoord(vector.xyz)
        while not HasCollisionLoadedAroundEntity(vehicle) do
            Wait(0)
        end

        if cb then
            cb(vehicle)
        end
    end)
end

Zen.Streaming.IsSpawnPointClear = function(coords, maxDistance)
    return #EnumerateEntitiesWithinDistance(GetGamePool('CVehicle'), false, coords, maxDistance)(coords, maxDistance) == 0
end

local cachedProps = {}

Zen.Streaming.GetProperties = function(plate)
    if cachedProps[plate] then 
        return cachedProps[plate]
    end

    local properties = lib.callback.await('garages:props', false, plate)

    cachedProps[plate] = properties

    return properties
end

Zen.Streaming.UpdateProperties = function(plate, props)

    if cachedProps[plate] then 
        cachedProps[plate] = nil
    end

    cachedProps[plate] = props
end

exports('UpdateProperties', Zen.Streaming.UpdateProperties)