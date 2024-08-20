BlipManager = exports.trappin_lib:getBlipManager()
ESX = exports['es_extended']:getSharedObject()
MENUS = {}
local blipsInit = false
local keys <const> = { 257, 25, 263, 47, 264, 257, 140, 141, 142, 143 }
local inv <const> = exports.ox_inventory
local Selling = false
local Cooldown = false
local Kill = false



local loadBlips = function(config)
    if blipsInit then
        return
    end
    blipsInit = true
    if config.turf.blips.display then
        local blipData = config.turf.blips
        for _, turf in pairs(config.turf.zones) do
            local coords = vec3(turf.coords[1], turf.coords[2], turf.coords[3])
            BlipManager.CreateBlip({
                id = turf.id,
                coords = coords,
                sprite = blipData.sprite,
                color = blipData.color,
                scale = blipData.scale,
                title = "Turf " .. turf.name,
                category = 10,
            })
        end
    end
    if config.jungle_drugzone.blips.display then
        local blipData = config.jungle_drugzone.blips
        for _, zone in pairs(config.jungle_drugzone.zones) do
            local coords = vec3(zone.coords[1], zone.coords[2], zone.coords[3])
            BlipManager.CreateBlip({
                id = zone.id,
                coords = coords,
                sprite = blipData.sprite,
                color = blipData.color,
                scale = blipData.scale,
                title = "Drug Zone " .. zone.name,
            })
        end
    end
    if config.drug_zone.blips.display then
        local blipData = config.drug_zone.blips
        for _, zone in pairs(config.drug_zone.zones) do
            local coords = vec3(zone.coords[1], zone.coords[2], zone.coords[3])
            BlipManager.CreateBlip({
                id = zone.id,
                coords = coords,
                sprite = blipData.sprite,
                color = blipData.color,
                scale = blipData.scale,
                title = "Drug Zone " .. zone.name,
            })
        end
    end

    if config.money_wash.blips.display then
        local blipData = config.money_wash.blips
        for _, zone in pairs(config.money_wash.turf_zones) do
            local coords = vec3(zone.coords[1], zone.coords[2], zone.coords[3])
            BlipManager.CreateBlip({
                id = zone.id,
                coords = coords,
                sprite = blipData.sprite,
                color = blipData.color,
                scale = blipData.scale,
                title = zone.name,
            })
        end
        if blipData.display_all then
            for _, zone in pairs(config.money_wash.money_wash_zones) do
                local coords = vec3(zone[1], zone[2], zone[3])
                BlipManager.CreateBlip({
                    id = 'money_wash_zone' .. _,
                    coords = coords,
                    sprite = blipData.money_wash_blip_sprite,
                    color = blipData.money_wash_blip_color,
                    scale = blipData.money_wash_blip_scale,
                    title = "Money Wash",
                })
            end
        end
    end

    local blipData = config.jungle_turf.blips
    for _, zone in pairs(config.jungle_turf.zones) do
        local coords = vec3(zone.coords[1], zone.coords[2], zone.coords[3])
        BlipManager.CreateBlip({
            id = zone.id,
            coords = coords,
            sprite = blipData.sprite,
            color = blipData.color,
            scale = blipData.scale,
            title = zone.name,
        })
    end

    TriggerServerEvent('trp_gangs:sv:drugzone:syncblip')
end

RegisterNetEvent('trp_gangs:cl:drugzone:syncblip', function(blipdata)
    if blipdata == nil then return end
    BlipManager.DeleteBlip(blipdata.id)
    Wait(500)
    local coords = vec3(blipdata.coords.x, blipdata.coords.y, blipdata.coords.z)
    BlipManager.CreateBlip({
        id = blipdata.id,
        coords = coords,
        sprite = blipdata.sprite,
        color = blipdata.color,
        scale = blipdata.scale,
        title = blipdata.title,
    })
end)

local selling_open = false
local load_package_sellzone = function()
    for _, zone in pairs(PackageConfig.zones) do
        BlipManager.CreateBlip({
            id = 'package_sellzone' .. _,
            coords = zone,
            sprite = PackageConfig.blip.sprite,
            color = PackageConfig.blip.color,
            scale = PackageConfig.blip.scale,
            title = PackageConfig.blip.text,
        })
        local point = lib.points.new(zone.xyz, 5)


        function point:nearby()
            if selling_open then return lib.hideTextUI() end
            if IsPedInAnyVehicle(cache.ped, false) then
                return
            end
            exports.trappin_lib:create_marker({ coords = self.coords.xyz })
            if self.currentDistance > 2 then return lib.hideTextUI() end
            lib.showTextUI('[E] Sell Packages', {
                icon = 'fas fa-box-open',
            })
            if IsControlJustReleased(0, 38) then
                selling_open = true
                local itemCount = exports.ox_inventory:Search('count', "turf_package")
                if itemCount < 1 then
                    selling_open = false
                    return exports.trappin_core:notify({
                        type = 'error',
                        text = 'You do not have any packages to sell!'
                    })
                end

                local dialog = lib.inputDialog('You are about to sell packages', {
                    {
                        type = 'number',
                        label = 'Enter the amount of packages you want to sell',
                        description = 'You have ' .. itemCount,
                        min = 1,
                        max = itemCount,
                    },
                })

                if not dialog or dialog[1] == "" or dialog[1] == 0 then
                    selling_open = false
                    return
                end

                local res = lib.callback.await('trp_gangs:misc:redeem_package', false, tonumber(dialog[1]))
                if res then
                    exports.trappin_core:notify({
                        type = 'success',
                        text = 'You have sold ' .. dialog[1] .. ' packages for $' .. res
                    })
                end
                selling_open = false
                return
            end
        end
    end
end








RegisterNetEvent('trp_gangs:misc:loadConfig', function(config)
    loadBlips(config)
end)

function AcceptDialog(data)
    local input = lib.inputDialog('You are about to join gang ' .. data.label, {
        { type = 'input', label = data.reason, description = 'Enter your recruite message' },
    })

    if not input or input[1] == "" then
        return
    end
    lib.callback.await('trp_gangs:sv:recruite:apply', false, data.name, input[1])
end

function ShowRecruiteMenu(data)
    local options = {}
    for k, v in pairs(data) do
        table.insert(options, {
            title = v.label,
            description = v.reason,
            icon = 'circle',
            onSelect = function()
                AcceptDialog(v)
            end,
        })
    end
    lib.registerContext({
        id = 'recruite_menu',
        title = 'Recruite Menu',
        options = options,
    })
    lib.showContext('recruite_menu')
end

CreateThread(function()
    while not ESX.IsPlayerLoaded() do
        Wait(100)
    end
    TriggerServerEvent('trp_gangs:sv:gang:sync:player')
    TriggerServerEvent('trp_gangs:playerLoaded')
    TriggerEvent('trappin_base:playerLoaded')
    load_package_sellzone()
    TriggerServerEvent('trp_gangs:sync:all')
end)


AddEventHandler('esx:onPlayerSpawn', function()
    Wait(8000)
    TriggerServerEvent('trp_gangs:sync:all')
end)

RegisterCommand('syncevents', function()
    TriggerServerEvent('trp_gangs:sync:all')
end, false)



RegisterNetEvent('trappin_gangs:cl:recrute', function()
    local data = lib.callback.await('trp_gangs:sv:recruite:open', false)
    if not data or #data == 0 then
        exports.trappin_ui:notify({
            type = 'error',
            text = 'No gangs are recruiting!'
        })
        return
    end
    ShowRecruiteMenu(data)
end)
