local ComservData = {}
local Comservs = Zen.Config.Comservs
playerComserved = false

local function CreateNewTask()
    local selected = math.random(1, #Comservs.Actions)

    while ComservData.Task == selected do
        Wait(0)
        selected = math.random(1, #Comservs.Actions)
    end

    return selected
end

local function handleAction()
    if ComservData.Busy then return end

    local offset = GetOffsetFromEntityGivenWorldCoords(cache.ped, 0.0, 0.0, -5.0)
    local entity = CreateObject(`prop_tool_broom`, offset.x, offset.y, offset.z, true, true, false)

    while not DoesEntityExist(entity) do Wait(0) end
    if not HasAnimDictLoaded('amb@world_human_janitor@male@idle_a') then lib.requestAnimDict('amb@world_human_janitor@male@idle_a') end

    ComservData.Busy = true

    TaskPlayAnim(cache.ped, 'amb@world_human_janitor@male@idle_a', 'idle_a', 8.0, -8.0, -1, 0, 0, false, false, false)
    AttachEntityToEntity(entity, cache.ped, GetPedBoneIndex(cache.ped, 28422), -0.005, 0.0, 0.0, 360.0, 360.0, 0.0, true, true, false, true, 0, true)
    FreezeEntityPosition(cache.ped, true)

    SetTimeout(10 * 1000, function()
        lib.callback("comservs:completeAction", false, function()
            ComservData.Busy = false

            DetachEntity(entity, true, true)
            DeleteEntity(entity)

            while DoesEntityExist(entity) do Wait(0) end
            ClearPedTasks(cache.ped)
            FreezeEntityPosition(cache.ped, false)
        end)
    end)
end

local function FinishComserv(bool)
    local coords = bool and Comservs.Service[1] or Comservs.Release
    RequestCollisionAtCoord(coords.x, coords.y, coords.z)
    SetEntityCoords(cache.ped, coords.x, coords.y, coords.z, true, false, false, true)
    SetEntityHeading(cache.ped, coords.w)

    if not bool then
        playerComserved = false
        Zen.Functions.NUI('hideComservUI', {})
        SetCanAttackFriendly(cache.ped, true, false)
        NetworkSetFriendlyFireOption(true)
    end
end

local function StartComserv(data)
    ComservData = { Sender = data.Sender, Reason = data.Reason, Actions = data.Actions }

    playerComserved = true
    SetEntityCoords(cache.ped, Comservs.Service[1]) 

    local marker = lib.points.new(Comservs.Service[1], Comservs.Service[2])

    function marker:onEnter()
        if stateBag.Comservs <= 0 then return end
        SetCurrentPedWeapon(cache.ped, GetHashKey("WEAPON_UNARMED"), true)
        DisplayRadar(false)
        SetCanAttackFriendly(cache.ped, false, false)
        NetworkSetFriendlyFireOption(false)
    end
    
    function marker:onExit() 
        DisplayRadar(true)
        if stateBag.Comservs <= 0 then return end
        lib.callback("comservs:addExtension", false, function()
            FinishComserv(true)
        end, Comservs.ExtensionOnLeave)
    end

    function marker:nearby()
        if not playerComserved then return end
        HudWeaponWheelIgnoreSelection()
        DisableControlAction(0, 37, true)
        DisableControlAction(0, 199, true)

        if not ComservData.Task then
            ComservData.Task = CreateNewTask()
        end

        local action = Comservs.Actions[ComservData.Task]
        if action then
            local distance = #(cache.coords - action)

            if not prompted and distance <= 3.0 then
                prompted = true
            elseif prompted and distance > 3.0 then
                prompted = false
            end

            if prompted and not ComservData.Busy and IsControlJustPressed(0, 38) then
                handleAction()
            end

            if not ComservData.Busy then 
                Zen.Functions.FloatText(action, '[E] - Clean Floor')
            end
        end 
    end

    return FinishComserv(true)
end

AddStateBagChangeHandler('Zen:Comserv:Client', '', function(player, _, args)
    local id = tonumber((tostring(player):gsub('player:', '')))
    if not args or id ~= cache.serverId then return end
    
    stateBag.Comservs = args.Actions    
    if args.Actions == 0 or args.EndedByAdmin then return FinishComserv(false) end


    Zen.Functions.NUI('updateComservUI', { actions = args.Actions })

    if playerComserved then
        ComservData.Task = CreateNewTask()

        Zen.Functions.NUI('updateComservUI', { actions = args.Actions })
    else
        Zen.Functions.NUI('showComservUI', { 
            admin = args.Sender, 
            reason = args.Reason 
        })
        StartComserv(args)
    end
end)