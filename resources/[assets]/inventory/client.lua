local CanInteract = exports.scripts:functions('CanInteract')
local Notify = exports.scripts:functions("Notify")

local inventoryOpen = false
local avatarSet = false

local function discord()
    local data = lib.callback.await("discord:data", false)
    SendNUIMessage({ action = "avatar", avatar = data.avatar })
    avatarSet = true
end

local function getInventory(me, player)
    local items = {}
    local data = ESX.GetPlayerData()

    for i = 1, #(data.accounts) do
        local account = data.accounts[i]
		if account.name ~= 'bank' and account.money > 0 then
            items[#items + 1] = { label = account.label, count = account.money, name = account.name, type = "item_account", usable = false, rare = false, limit = -1, canRemove = true }
        end
	end
    
    for _, item in ipairs(data.inventory) do
        if item.count > 0 then
            item.type = "item_standard"
            items[#items + 1] = item
        end
    end
    
    for _, weapon in ipairs(data.loadout) do
        if weapon.name ~= "WEAPON_UNARMED" then
            items[#items + 1] = { label = weapon.label, count = GetAmmoInPedWeapon(cache.ped, GetHashKey(weapon.name)), limit = -1, type = "item_weapon", name = weapon.name, usable = false, rare = false, canRemove = true }
        end
    end

    SendNUIMessage({ action = "setPlayerItems", playerItems = items })
end

local function inventory(toggle, other)
    if toggle then 
        if not avatarSet then discord() end
        getInventory(true)

        SendNUIMessage({ 
            action = "display", 
            type = (other and "other") or "normal",
            text = other or ''
        })
    else
        SendNUIMessage({ action = "hide" })
    end

    inventoryOpen = toggle
    SetNuiFocus(toggle, toggle)
end

lib.addKeybind({ name = 'inventory', description = 'Open Inventory', defaultKey = 'F2', 
    onReleased = function()
        if inventoryOpen then return end
        if not CanInteract() then return end
        inventory(true)
    end
})  

RegisterNUICallback("closeInventory", function() inventory(false) end)

local function itemClose(name)
    for key, value in ipairs(Zen.Inventory.CloseOnUse) do
        if value == name then
            return true
        end
    end
    return false
end

local function check(rs)
    for key, value in ipairs(Zen.Inventory.Resources) do
        if value == rs then
            return true
        end
    end
    return false
end

RegisterNUICallback("UseItem", function(data, cb)
    if not CanInteract() then return end

    TriggerServerEvent("inventory:action", "use", {
        item = data.item.name
    })
    
    if itemClose(data.item.name) then
        inventory(false)
    else
        Wait(250)
        getInventory(true)
    end

    cb("ok")
end)

RegisterNUICallback("GiveItem", function(data, cb)
    if not CanInteract() then return end

    local players = lib.getNearbyPlayers(GetEntityCoords(cache.ped), 3.0, false)

    if table.type(players) == 'empty' then
        return Notify('No One Nearby!', "user", "#FF0000")
    end

    local list = {}

    for i = 1, #players do
        list[#list+1] = {
            label = GetPlayerServerId(players[i].id)..' - '..GetPlayerName(players[i].id),
            value = GetPlayerServerId(players[i].id)
        }
    end
    
    local input = lib.inputDialog('Select Player', { 
        { type = 'select', label = 'Player', options = list } 
    })

    if not input then return end

    local count = tonumber(data.number)

    if data.item.type == "item_weapon" then
        count = GetAmmoInPedWeapon(cache.ped, GetHashKey(data.item.name))
    end

    TriggerServerEvent("inventory:action", "give", { target = input[1], type = data.item.type, amount = count, item = data.item.name })
    Wait(250)
    getInventory(true)

    cb("ok")
end)

RegisterNUICallback("DropItem", function(data, cb)
    if not CanInteract() then return end
    
    local alert = lib.alertDialog({ header = 'Are You Sure You Want To Remove?', centered = true, cancel = true })

    if alert ~= 'confirm' or IsPedSittingInAnyVehicle(cache.ped) then return end

    if type(data.number) == "number" and math.floor(data.number) == data.number then
        TriggerServerEvent("inventory:action", "drop", { type = data.item.type, amount = data.number, item = data.item.name })
    end

    Wait(250)
    getInventory(true)
    cb("ok")
end)

RegisterNetEvent("inventory:open", function(target)
    if not check(GetInvokingResource()) then return end

    getInventory(false, target)
    inventory(true, "Player: "..GetPlayerName(GetPlayerFromServerId(target)))
end)