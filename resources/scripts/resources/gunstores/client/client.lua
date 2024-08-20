local GunStores = Zen.Config.GunStores
local illegalWeapons, boosterWeapons, legalWeapons = {}, {}, {}

local function PurchaseWeapon(data, illegal)
    if data and data.weapon then        
        if HasPedGotWeapon(cache.ped, data.weapon, false) then 
            return Zen.Functions.Notify('You Already Have This Gun!', 'gun', '#FF0000')
        end

        local payWith = 'money'
        if illegal then 
            payWith = 'black_money'
        end

        TriggerServerEvent('gunstore:purchase', payWith, data.weapon, 'gunstore')
    end
end

local function createPoint(location, illegal)
    local point = lib.points.new(location, GunStores.Marker.Distance, {
        coords = location,
        illegal = illegal
    })
    
    function point:onExit() 
        lib.hideMenu() 
    end
    
    function point:nearby()
        if self.currentDistance < 1 and IsControlJustReleased(0, 38) then 
            if self.illegal then 
                lib.showMenu('gunstore_illegal')
            else 
                lib.showMenu('gunstore_legal')
            end
        end

        Zen.Functions.FloatText(self.coords, GunStores.Marker.Text)
    end
    
    if not illegal then 
        Zen.Functions.CreateBlip(location, GunStores.Blip)
    end
end

lib.registerMenu({
    id = 'gunstore_legal',
    title = 'Gun Store',
    position = 'bottom-right',
    options = {
        { icon = 'gun', label = 'Weapons' },
        { icon = 'gem', label = 'Booster Weapons' }
    }
}, function(selected, scrollIndex, args)
    if selected == 1 then 
        lib.showMenu('gunstore_legal_weapons')
    elseif selected == 2 then 
        if Zen.Functions.IsRolePresent(GunStores.BoosterRole) then 
            lib.showMenu('gunstore_booster_weapons')
        else
            Zen.Functions.Notify('You Don\'t Have Access!', 'gem', '#FF00FF')
        end
    end    
end)

lib.registerMenu({
    id = 'gunstore_legal_weapons',
    title = 'Weapons',
    position = 'bottom-right',
    options = {}
}, function(selected, scrollIndex, args)
    PurchaseWeapon(args, false) 
end)

lib.registerMenu({
    id = 'gunstore_booster_weapons',
    title = 'Booster Weapons',
    position = 'bottom-right',
    options = {}
}, function(selected, scrollIndex, args)
    PurchaseWeapon(args, false) 
end)

lib.registerMenu({
    id = 'gunstore_illegal',
    title = 'Black Market',
    position = 'bottom-right',
    options = {}
}, function(selected, scrollIndex, args)
    PurchaseWeapon(args, true)  
end)

for _, v in pairs(GunStores.Weapons) do 
    local wTable = {
        icon = v.icon,
        label = v.label..' - $'..Zen.Functions.FormatCommas(v.price),
        args = {
            label = v.label,
            weapon = v.weapon,
            price = v.price
        }
    }
        
    if v.illegal then  
        illegalWeapons[#illegalWeapons+1] = wTable
    elseif v.booster then 
        boosterWeapons[#boosterWeapons+1] = wTable
    else
        legalWeapons[#legalWeapons+1] = wTable
    end
end

lib.setMenuOptions('gunstore_illegal', illegalWeapons)
lib.setMenuOptions('gunstore_booster_weapons', boosterWeapons)
lib.setMenuOptions('gunstore_legal_weapons', legalWeapons)

for i = 1, #GunStores.GunStores do 
    createPoint(GunStores.GunStores[i], false)
end

for i = 1, #GunStores.BlackMarkets do 
    createPoint(GunStores.BlackMarkets[i], true)
end