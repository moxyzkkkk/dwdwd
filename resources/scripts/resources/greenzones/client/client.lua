local GreenZones = Zen.Config.GreenZones
insideGreenzone = false

for i, zoneData in ipairs(GreenZones.Zones) do 
    local coords = type(zoneData.coords) == 'table' and zoneData.coords or { zoneData.coords }
    
    for j, coord in ipairs(coords) do
        local zone = lib.points.new(coord, zoneData.radius, { 
            ui = zoneData.showUI or true 
        })

        function zone:onEnter()
            SetCurrentPedWeapon(cache.ped, GetHashKey("WEAPON_UNARMED"), true)
            NetworkSetFriendlyFireOption(false)
            SetLocalPlayerAsGhost(true)
            SetGhostedEntityAlpha(220)
            
            if self.ui then 
                insideGreenzone = true
                Zen.Functions.NUI('enterGreenzone', {})
            end
        end

        function zone:onExit() 
            if not TestingVehicle then 
                NetworkSetFriendlyFireOption(true)
                SetLocalPlayerAsGhost(false)
            end
            
            if self.ui then 
                insideGreenzone = false
                Zen.Functions.NUI('exitGreenzone', {})
            end
        end

        if zoneData.showOnMap or true then 
            local BlipData = GreenZones.Blip
            BlipData.Radius = zoneData.radius + tonumber(zoneData.radius * 7.4)
            Zen.Functions.CreateRadiusBlip(coord, BlipData) 
        end
    end
end
