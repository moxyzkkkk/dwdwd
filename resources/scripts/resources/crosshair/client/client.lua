RegisterCommand('crosshair', function()
    local default = { '', 150 }

    local data = json.decode(GetResourceKvpString("crosshair"))

    if data ~= nil then 
        default = { data[1], data[2] }
    end
    
    local input = lib.inputDialog('Crosshair Menu', {
        {type = 'input', label = 'Link', default = default[1]}, 
        {type = 'slider', label = 'Size',  default = default[2], max = 2000}
    })  

    if not input then return end

    SetResourceKvp("crosshair", json.encode(input))

    if input[1] == '' then 
        Zen.Functions.NUI('hideCrosshair', { })
    else
        Zen.Functions.NUI('showCrosshair', { link = input[1], size = input[2] })
    end
end)

AddEventHandler('playerLoaded', function()
    local data = json.decode(GetResourceKvpString("crosshair"))

    if data and data[1] == '' or data == nil then return end

    Zen.Functions.NUI('showCrosshair', { link = data[1], size = data[2] })
end)

--HideHudComponentThisFrame(14)