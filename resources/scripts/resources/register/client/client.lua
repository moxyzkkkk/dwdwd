local Register = Zen.Config.Register
registerOpen = false

local function closeRegister()
    registerOpen = false
    SetNuiFocus(false, false)
	Zen.Functions.NUI('hideRegister', {})
end

RegisterNetEvent('register:open', function(cancelAllow)
	if cancelAllow then 
		if not Zen.Functions.CanInteract() then 
			return Zen.Functions.Notify('Can\'t Do This Right Now!', 'xmark', '#FF0000')
		end
	end

	SetNuiFocus(true, true)
	registerOpen = true

	Zen.Functions.NUI('showRegister', {
		canClose = cancelAllow
	})
end)


RegisterNUICallback('playerRegister', function(data)
	local input = {
		data.firstName, data.lastName, data.age, data.height, data.gender
	}

	closeRegister()
	TriggerServerEvent('register:setIdentity', input)
	Wait(500)
	TriggerEvent('esx_skin:openSaveableMenu', cache.serverId)

end)

RegisterNUICallback('closeRegister', closeRegister)

