local Garages = Zen.Config.Garages
local closestGarage = nil
local currentVehicle = nil
local viewingMode = false

local function RemoveVehicle()
	if DoesEntityExist(currentVehicle) then
		DeleteVehicle(currentVehicle)
	end
	
	FreezeEntityPosition(cache.ped, false)
	DestroyAllCams(true)
	RenderScriptCams(false, true, 750)
	viewingMode = false
end

RegisterCommand('fixgarage', function()
	if not viewingMode then return end
	RemoveVehicle()
end)

local function OpenPlayerGarage()
    local options = {}
    local owned = lib.callback.await('garages:get', false)

    if #owned == 0 then 
        return Zen.Functions.Notify('You Don\'t Own Any Vehicles', 'car', '#FF0000')
    end

    for i = 1, #owned do 
		local properties = Zen.Streaming.GetProperties(owned[i].plate)

        options[#options+1] = {
            icon = 'car',
            label = owned[i].plate..' | '..owned[i].label,
            args = {
				name = owned[i].label,
				model = properties.model,
				plate = owned[i].plate,
                properties = properties
            }
        }
    end

    lib.setMenuOptions('player_garage', options)
    Wait(100)
	viewingMode = true
    lib.showMenu('player_garage')
end

lib.registerMenu({
	id = 'player_garage',
	title = 'GARAGE MENU',
	position = 'bottom-right',
	options = {},
	onClose = function()
		RemoveVehicle()
	end,
	onSelected = function(selected, secondary, args)
		if args then 
			while DoesEntityExist(currentVehicle) do 
				DeleteVehicle(currentVehicle) 
			end

			Zen.Streaming.SpawnVehicle(args.model, closestGarage, closestGarage.w, function(callback)
				lib.setVehicleProperties(callback, args.properties)

				FreezeEntityPosition(cache.ped, true)

				if DoesCamExist(Camera) then 
					DestroyCam(Camera) 
				end

				Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		
				SetCamCoord(Camera, GetOffsetFromEntityInWorldCoords(callback, -3.0, 4.0, 1.5))
				SetCamRot(Camera, vector3(-20.0, 0.0, GetEntityHeading(callback) - 120.0))
				RenderScriptCams(1, 1, 500, 1, 1)
				
				if DoesEntityExist(callback) then
					currentVehicle = callback
				end
			end, false, false)
		end
	end
}, function(selected, scrollIndex, args)
	lib.registerMenu({
		id = "player_garage_select", 
		title = args.name..' | '..args.plate, 
		position = 'bottom-right', 		
		options = { 
			{ icon = 'gears', label = "Drive" }, 
			{ icon = 'hand-holding-hand', label = "Transfer" }, 
			{ icon = 'trash', label = "Delete" },
		},	
		
		onClose = function()
			lib.showMenu('player_garage')
		end,
	
	}, function(selected, scrollIndex, args2)
		RemoveVehicle()

		if selected == 1 then 
			Zen.Streaming.SpawnVehicle(args.model, closestGarage, closestGarage.w, function(callback)
				lib.setVehicleProperties(callback, args.properties)
				TaskWarpPedIntoVehicle(cache.ped, callback, -1)
			end, true, cache.serverId)
			
		elseif selected == 2 then 
			if not exports.scripts:GetVehicleCategory(args.name).giveable then 
				return Zen.Functions.Notify('You Cannot Give This Car!', "car", "#FF0000")
			end

			local input = lib.inputDialog('Transferring '..args.plate, {
				{type = 'number', label = 'Player ID', icon = 'tag'},
				{type = 'checkbox', label = 'CONFIRM'},
			})

			if not input then return end

			if input[1] and input[1] ~= nil and input[2] then 
				if tonumber(input[1]) == cache.serverId then return end
				TriggerServerEvent("garages:give", input[1], args.plate)	
			end

		elseif selected == 3 then 
			local alert = lib.alertDialog({
				header = 'Confirm Delete For ('..args.name..' | '..args.plate..')',
				centered = true,
				cancel = true
			})
			
			if alert == 'confirm' then
				TriggerServerEvent("garages:delete", args.plate)
				Zen.Functions.Notify('You deleted your car! | '..args.plate, "car", "#00FF00")
			end
		end
	end)

	lib.showMenu("player_garage_select")
end)

for i = 1, #Garages.Locations do 
	local point = lib.points.new(Garages.Locations[i].marker, Garages.Marker.Distance, {
		marker = Garages.Locations[i].marker,
		spawn = Garages.Locations[i].spawn,
		text = Garages.Marker.Text
	})

	function point:onEnter()
		closestGarage = self.spawn
	end
	
	function point:onExit() 
		lib.hideMenu() 
	end
	
	function point:nearby()
		if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
			if cache.vehicle or viewingMode then return end
			OpenPlayerGarage()
		end

		if not viewingMode then 
			Zen.Functions.FloatText(self.marker, self.text)
		end
	end

	Zen.Functions.CreateBlip(Garages.Locations[i].marker, Garages.Blip) 
end