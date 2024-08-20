local options = {}

local function OpenBills()
    if not Zen.Functions.CanInteract() then return end

    if not options or #options <= 0 then
        return Zen.Functions.Notify('You Don\'t Have Any Bills', 'bills', '#FF0000')
    end      
    
    lib.setMenuOptions('billingMenu', options)
    lib.showMenu('billingMenu')
end

RegisterNetEvent('billing:menu', function(bills)
    options = {}

    for i = 1, #bills do
        local bill = bills[i]

        options[#options+1] = {
            label = bill.label,
            description = 'Pay: $'..Zen.Functions.FormatCommas(bill.amount),
            args = { amount = bill.amount, id = bill.id }
        }
    end
end)

lib.registerMenu({
    id = 'billingMenu',
    title = 'My Bills',
    position = 'bottom-right',
    options = {}
}, function(_, _, args)
    TriggerServerEvent('billing:pay', args.id)
    Wait(350)
    OpenBills()
end)

RegisterCommand('bills', OpenBills)
RegisterKeyMapping('bills', 'Open Bills Menu', 'keyboard', 'F7')