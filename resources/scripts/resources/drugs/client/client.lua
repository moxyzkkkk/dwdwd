local Drugs = Zen.Config.Drugs
local DrugsData = { Busy = false, Pressed = false }

RegisterNetEvent('drugs:start', function(drugData, locData, task)
    DrugsData.Busy = true
    Zen.Functions.Notify(('You Started %sing %s'):format(task, drugData.Name))
    while true do
        Wait(locData.Time * 1000)
        if DrugsData.Busy then
            if playerDead then
                DrugsData.Busy = false
                break
            end

            TriggerServerEvent('drugs:receive', locData.Items)
        else
            break
        end
    end
end)

RegisterNetEvent('drugs:stop', function(drugData, task)
    DrugsData.Busy = false
    Zen.Functions.Notify(('You Stopped %sing %s'):format(task, drugData.Name))
end)

local function createDrugBlip(drugData, zone)
    local locData = drugData.Locations[zone]
    if not locData.Blip.Enabled then return end
    Zen.Functions.CreateBlip(locData.Blip.Coords, locData.Blip)
end

RegisterNetEvent('playerLoaded', function()
    for key in next, Drugs do
        local drugData = Drugs[key]

        for zone in next, drugData.Locations do
            local locData = drugData.Locations[zone]
            local marker = lib.points.new(locData.Coords, locData.Radius, { drug = key, zone = zone })

            if marker then
                createDrugBlip(drugData, zone)

                local Cooldown = false

                function marker:onExit()
                    DrugsData.Busy = false
                    Cooldown = true
                    lib.hideTextUI()
                    SetTimeout(locData.Time * 1000, function() Cooldown = false end)
                end
                
                function marker:nearby()
                    if not Cooldown then
                        lib.showTextUI((DrugsData.Busy and 'Press [E] To Stop %sing %s' or 'Press [E] To Start %sing %s'):format(self.zone, drugData.Name))
                
                        if IsControlJustPressed(0, 38) and not DrugsData.Pressed then
                            DrugsData.Pressed = true
                
                            if DrugsData.Busy then
                                TriggerEvent('drugs:stop', drugData, self.zone)
                            else
                                TriggerEvent('drugs:start', drugData, locData, self.zone)
                            end
                
                            SetTimeout(locData.Time * 1000, function() DrugsData.Pressed = false end)
                        end
                    end
                end                
            end
        end
    end
end)