local KMenu = Zen.Config.KMenu

local function Action(type, data)
    if not Zen.Functions.CanInteract() then 
        return Zen.Functions.Notify('You Can\'t Do This Right Now!', 'xmark', '#FF0000')
    end

    if type == 'teleport' then 
        SetEntityCoords(cache.ped, data.location, false, false, false, true)
    elseif type == 'weapon' then 
        if HasPedGotWeapon(cache.ped, data.weapon) then return Zen.Functions.Notify('You Already Have That Gun!', 'gun', '#FF0000') end
        TriggerServerEvent('gunstore:purchase', 'money', data.weapon, 'kmenu')
    elseif type == 'item' then
        TriggerServerEvent('shop:purchase', data.item, data.amount, 'kmenu')
    end
end 

lib.registerMenu({
    id = 'kmenu_teleports',
    title = 'TELEPORTS MENU',
    position = 'bottom-right',
    options = {},
    onClose = function()
        lib.showMenu('kmenu_main')
    end
}, function(_, _, args)
    lib.showMenu(args.category)
end)

lib.registerMenu({
    id = 'kmenu_weapons',
    title = 'WEAPONS MENU',
    position = 'bottom-right',
    options = {},
    onClose = function()
        lib.showMenu('kmenu_main')
    end
}, function(_, _, args)
    Action('weapon', args)
end)

lib.registerMenu({
    id = 'kmenu_items',
    title = 'ITEMS SHOP',
    position = 'bottom-right',
    options = {},
    onClose = function()
        lib.showMenu('kmenu_main')
    end
}, function(selected, scrollIndex, args)
    local data = {
        label = args.label,
        item = args.item,
        price = args.price * scrollIndex,
        amount = scrollIndex
    }

    Action('item', data)
end)

lib.registerMenu({
    id = 'kmenu_main',
    title = 'KMenu',
    position = 'bottom-right',
    options = {
        {
            icon = 'forward',
            label = 'Teleports',
            args = {
                menu = 'kmenu_teleports'
            }
        },
        {
            icon = 'gun',
            label = 'Weapons',
            args = {
                menu = 'kmenu_weapons'
            }
        },
        {
            icon = 'basket-shopping',
            label = 'Items Shop',
            args = {
                menu = 'kmenu_items'
            }
        }
    }
}, function(_, _, args)
    if args and args.menu then 
        lib.showMenu(args.menu)
    end
end)

lib.addKeybind({ 
    name = 'kmenu_main', 
    description = 'Open KMenu', 
    defaultKey = 'K',
    onPressed = function()
        for i = 1, #KMenu.Locations do
            if #(cache.coords - KMenu.Locations[i][1]) < KMenu.Locations[i][2] then
                lib.showMenu('kmenu_main')
            end 
        end
    end, 
})

RegisterNetEvent('playerLoaded', function()
    local teleportCategorys = {}
    
    for category, locations in pairs(KMenu.Buttons.Teleports) do
        local currentTable = {}
        
        for _, option in ipairs(locations) do
            currentTable[#currentTable+1] = {
                close = false,
                icon = 'forward',
                label = option[1],
                args = {
                    location = option[2],
                }
            }
        end

        teleportCategorys[#teleportCategorys+1] = { 
            icon = 'user', 
            label = category, 
            args = {
                category = category
            } 
        }
        
        lib.registerMenu({
            id = category,
            title = category,
            position = 'bottom-right',
            options = currentTable,
            onClose = function()
                lib.showMenu('kmenu_teleports')
            end, 
        }, function(_, _, args)
            if args and args.location then
                Action('teleport', args)
            end
        end)
    end

    lib.setMenuOptions('kmenu_teleports', teleportCategorys)

    local weaponsTable = {}

    for _, v in pairs(KMenu.Buttons.Weapons) do 
        weaponsTable[#weaponsTable+1] = {
            close = false,
            icon = 'gun',
            label = Zen.Weapons[v.weapon]..' | $'..Zen.Functions.FormatCommas(v.price), 
            args = {
                label = Zen.Weapons[v.weapon],
                weapon = v.weapon,
                price = v.price
            }
        }
    end

    lib.setMenuOptions('kmenu_weapons', weaponsTable)

    local itemsTable = {}
    
    for k, v in pairs(KMenu.Buttons.Items) do 
        itemsTable[#itemsTable+1] = {
            close = false,
            icon = v.icon,
            label = Zen.Items[v.item].label, 
            args = {
                label = Zen.Items[v.item].label,
                item = v.item,
                price = v.price
            },
            values = {}
        }

        for i = 1, 100 do
            local price = v.price * i

            itemsTable[#itemsTable].values[#itemsTable[#itemsTable].values+1] = {
                label = '$'..Zen.Functions.FormatCommas(price), 
            }
        end
    end

    lib.setMenuOptions('kmenu_items', itemsTable)
end)