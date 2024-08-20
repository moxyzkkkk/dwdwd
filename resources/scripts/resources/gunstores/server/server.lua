RegisterNetEvent('gunstore:purchase', function(a, s, f)
    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)

    local weapons = (f == 'kmenu' and Zen.Config.KMenu.Buttons.Weapons ) or (f == 'police' and Zen.Config.Police.Weapons) or (f == 'gunstore' and Zen.Config.GunStores.Weapons)
    local weapon = weapons[s]

    if xPlayer.getAccount(a).money >= weapon.price then
        xPlayer.removeAccountMoney(a, weapon.price)
        xPlayer.addWeapon(s, 500)

        Zen.Functions.Notify(_source, "You Bought "..(weapon.label or Zen.Weapons[s]).." For $"..Zen.Functions.FormatCommas(weapon.price), 'gun', '#00FF00')
    else
        Zen.Functions.Notify(_source, 'You Dont Have Enough', 'dollar', '#FF0000')
    end
end)