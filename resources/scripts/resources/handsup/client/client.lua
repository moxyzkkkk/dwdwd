local HandsUp = Zen.Config.HandsUp
local handsupnigger = false

local anim = 'random@mugging3'
local anim2 = 'handsup_standing_base'

local function handsUp()
    if cache.vehicle then return end

    if not Zen.Functions.CanInteract() then 
        return Zen.Functions.Notify('You Cant Do This Right Now', 'xmark', '#FF0000') 
    end

    handsupnigger = not handsupnigger
    local ped = cache.ped

    if handsupnigger then
        if not HasAnimDictLoaded(anim) then
            lib.requestAnimDict(anim)
        end

        TaskPlayAnim(ped, anim, anim2, 8.0, 8.0, -1, 50, 0, false, false, false)
        SetCurrentPedWeapon(ped, -1569615261, true)
    else
        ClearPedTasks(ped)
    end
end

lib.addKeybind({
    name = 'handsup',
    description = 'press X to put Hands Up',
    defaultKey = 'X',
    onPressed = function() handsUp() end
})

RegisterNetEvent('force:surrender', function()
    local ped = cache.ped
    if not HasAnimDictLoaded(anim) then
        lib.requestAnimDict(anim)
    end

    TaskPlayAnim(ped, anim, anim2, 8.0, 8.0, -1, 50, 0, false, false, false)
    SetCurrentPedWeapon(ped, -1569615261, true)
end)