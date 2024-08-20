local Robbery = Zen.Config.Robbery
local ActiveStore = nil
local Blips = {}

for i = 1, #Robbery.Locations do 
    local zone = Robbery.Locations[i]
    local point = lib.points.new(zone.coords, Robbery.Marker.Distance, {
        index = i,
        marker = zone.coords,
        text = Robbery.Marker.Text
    })
     
    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
            TriggerServerEvent('robbery:start', self.index)
        end

        Zen.Functions.FloatText(self.marker, self.text)
    end

    Zen.Functions.CreateBlip(zone.coords, Robbery.Blip)
end

RegisterNetEvent("robbery:blip", function(store, coords)
	blip = AddBlipForCoord(coords.x, coords.y, coords.z)
	SetBlipSprite(blip, 161)
	SetBlipScale(blip, 2.0)
	SetBlipColour(blip, 39)
	PulseBlip(blip)

    Blips[store] = blip
end)

RegisterNetEvent("robbery:blip:remove", function(store)
    RemoveBlip(Blips[store])
    Blips[store] = nil
end)

RegisterNetEvent("robbery:start", function(store)
    local storeData = Robbery.Locations[store]
    local timer = storeData.timers[1]
    
    local ActiveStore = store

    Zen.Functions.NUI('showRobberyUI', { label = storeData.name })

    CreateThread(function()
        local exited = false

        while timer > 0 and ActiveStore ~= nil do
            Wait(1000)
            
            if timer > 0 then
                timer = timer - 1
            end

            Zen.Functions.NUI('updateRobberyUI', {
                timer = timer
            })

            if #(cache.coords - storeData.coords) > storeData.radius then
                exited = true
                break
			end
        end

        if exited then 
            TriggerServerEvent("robbery:exited", store)
            timer, ActiveStore = 0, nil

            Zen.Functions.NUI('hideRobberyUI', {})
        end
    end)
end)

RegisterNetEvent("robbery:stop", function()
	ActiveStore = nil
    Zen.Functions.NUI('hideRobberyUI', {})
end)