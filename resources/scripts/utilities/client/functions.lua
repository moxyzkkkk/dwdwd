Zen.Functions = {}

Zen.Functions.Notify = function(text, icon, color)
    lib.notify({
        title = text,
        position = 'top',
        icon = icon,
        duration = 3000,
        iconColor = color or '#FFFFFF'
    })
end

Zen.Functions.FormatCommas = function(number)
    local i, j, minus, int, fraction = tostring(number):find('([-]?)(%d+)([.]?%d*)')
    int = int:reverse():gsub("(%d%d%d)", "%1,")
    return(minus..int:reverse():gsub("^,", "")..fraction)
end

Zen.Functions.FormatSeconds = function(seconds)
    if not seconds or (seconds and tonumber(seconds) <= 0) then return '00:00' end
    seconds = tonumber(seconds)

    local hours = string.format("%02.f", math.floor(seconds / 3600))
    local minutes = string.format("%02.f", math.floor(seconds / 60 - (hours * 60)))
    local secs = string.format("%02.f", math.floor(seconds - hours * 3600 - minutes * 60));

    return ('%s:%s'):format(minutes, secs)
end

Zen.Functions.FloatText = function(coords, text)
    AddTextEntry(GetCurrentResourceName(), text)
    BeginTextCommandDisplayHelp(GetCurrentResourceName())
    EndTextCommandDisplayHelp(2, false, false, -1) 
    SetFloatingHelpTextWorldPosition(1, coords.x, coords.y, coords.z)
    SetFloatingHelpTextStyle(1, 1, 2, -1, 3, 0)
end

Zen.Functions.DrawMarker = function(coords, info)
    DrawMarker(info.type, coords.x, coords.y, coords.z, 0.0, 0.0, 0.0, 0.0, 0.0, 0.0, 1.5, 1.5, 0.5, info.color.r, info.color.g, info.color.b,info.color.a, false, true, 2, nil, nil, false)
end

Zen.Functions.CreateBlip = function(coords, info)
    blip = AddBlipForCoord(coords.x, coords.y, coords.z)
    SetBlipSprite(blip, info.Type)
    SetBlipScale(blip, info.Scale or 0.55)
    SetBlipColour(blip, info.Color)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName('STRING')
    AddTextComponentSubstringPlayerName(info.Name)
    EndTextCommandSetBlipName(blip)

    return blip
end

Zen.Functions.CreateRadiusBlip = function(coords, data)
    blip = AddBlipForRadius(coords.x, coords.y, coords.z, data.Radius)
    SetBlipSprite(blip, data.Type)
    SetBlipColour(blip, data.Color)
    SetBlipAlpha(blip, data.Alpha)   
    SetBlipAsShortRange(blip, true)  

    return blip
end

Zen.Functions.IsRolePresent = function(role)
    return lib.callback.await('discord:haveRole', false, role)
end

Zen.Functions.HexToRGB = function(hex)
    hex = hex:gsub("#", "")
    return { r = tonumber("0x" .. hex:sub(1, 2)), g = tonumber("0x" .. hex:sub(3, 4)), b = tonumber("0x" .. hex:sub(5, 6)) }
end

Zen.Functions.NUI = function(action, data)
    SendNUIMessage({
        action = action,
        data = data
    })
end

Zen.Functions.CanInteract = function()
    if IsPauseMenuActive() 
    or playerDead 
    or IsPedFatallyInjured(cache.ped) 
    or playerComserved 
    or TestingVehicle
    or PolicePlayerData.Cuffed then 
        return false
    end

    return true
end

Zen.Functions.DrawText = function(message, coords, idsTalking)
    local size, font = 0.8, 8

    local camera = GetFinalRenderedCamCoord()
    local distance = #(camera - vec3(coords.x, coords.y, coords.z))
    local scale = (size / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100

    if fov then
        scale = scale * fov
    end

    SetTextScale(0.0 * scale, 0.55 * scale)
    SetTextFont(font)
    if idsTalking then 
        SetTextColour(stateBag.color.r, stateBag.color.g, stateBag.color.b, 255)
    else
        SetTextColour(255, 255, 255, 255)
    end
    SetTextDropshadow(0, 0, 0, 0, 255)
    SetTextDropShadow()
    SetTextOutline()
    SetTextCentre(true)
    SetDrawOrigin(coords, 0)
    BeginTextCommandDisplayText('STRING')
    AddTextComponentSubstringPlayerName(message)
    EndTextCommandDisplayText(0.0, 0.0)
    ClearDrawOrigin()
end

Zen.Functions.ClearPoints = function(points)
    local pointWiped = promise.new()

	if table.type(points) ~= 'empty' then
        for _, value in next, points do
            value:remove()
        end

        table.wipe(points)
        pointWiped:resolve()
    else
        pointWiped:resolve()
    end

    return pointWiped
end

Zen.Functions.ClearBlips = function(blips)
    local blipsWiped = promise.new()

    if table.type(blips) ~= 'empty' then
        for _, value in next, blips do
            RemoveBlip(value)
        end

        table.wipe(blips)
        blipsWiped:resolve()
    else
        blipsWiped:resolve()
    end

    return blipsWiped
end

Zen.Functions.GeneratePlate = function()
    local NumberCharset = {}
    local Charset = {}

    for i = 48, 57 do table.insert(NumberCharset, string.char(i)) end
    for i = 65, 90 do table.insert(Charset, string.char(i)) end
    for i = 97, 122 do table.insert(Charset, string.char(i)) end

    local generatedPlate
    local doBreak = false

    local function GetRandomNumber(length)
        if length > 0 then
            return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
        else
            return ''
        end
    end

    local function GetRandomLetter(length)
        if length > 0 then
            return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
        else
            return ''
        end
    end

    while true do
        Wait(2)
        math.randomseed(GetGameTimer())

        generatedPlate = string.upper(GetRandomLetter(4) .. GetRandomNumber(4))

        local isPlateTaken = lib.callback.await('garage:plateUsed', false, generatedPlate)

        if not isPlateTaken then
            doBreak = true
        end

        if doBreak then
            break
        end
    end

    return generatedPlate
end

Zen.Functions.Capitilize = function(text)
    local words = {}
    for word in text:gmatch("%S+") do
        table.insert(words, word)
    end
    
    for i, word in ipairs(words) do
        words[i] = word:sub(1, 1):upper() .. word:sub(2):lower()
    end
    
    return table.concat(words, " ")
end

exports('functions', function(func)
    return Zen.Functions[func]
end)