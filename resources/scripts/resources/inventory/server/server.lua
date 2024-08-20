RegisterNetEvent("inventory:action", function(action, data)
	local source = source
	local xPlayer = ESX.GetPlayerFromId(source)

	if action == 'use' then 
		local count = xPlayer.getInventoryItem(data.item).count
	  
		if count > 0 then
		  	ESX.UseItem(source, data.item)
		else
			Zen.Functions.Notify(source, 'Cannot Perform Action!', 'ban', '#FF0000') 
		end

	elseif action == 'give' then
		local target = tonumber(data.target)

		local xTarget = ESX.GetPlayerFromId(target)
		local distance = #(GetEntityCoords(GetPlayerPed(source)) - GetEntityCoords(GetPlayerPed(target)))

		if not xPlayer or not xTarget or distance > 4.0 then return end
		
		local item = {
			name = data.item,
			amount = data.amount
		}

		if data.type == 'item_standard' then
			local sourceItem = xPlayer.getInventoryItem(item.name)

			if item.amount > 0 and sourceItem.count >= item.amount then
			  	if xTarget.canCarryItem(item.name, item.amount) then
					xPlayer.removeInventoryItem(item.name, item.amount)
					xTarget.addInventoryItem(item.name, item.amount)
                    Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Gave Item', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Item:** '..sourceItem.label..'\n**Amount:** x'..item.amount)
					Zen.Functions.Notify(source, ("You Gave x%s %s to %s"):format(item.amount, sourceItem.label, xTarget.name), 'box', "#00FF00")
					Zen.Functions.Notify(target, ("%s Gave You x%s %s"):format(xPlayer.name, item.amount, sourceItem.label), 'box', "#00FF00")
			  	else
					Zen.Functions.Notify(source, ("%s Cant Carry Anymore %s!"):format(xTarget.name, sourceItem.label), 'xmark', "#FF0000")
			  	end
			else
				Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			end

		elseif data.type == 'item_account' then
			if item.amount > 0 and xPlayer.getAccount(item.name).money >= item.amount then
			  	xPlayer.removeAccountMoney(item.name, item.amount, "Gave to " .. xTarget.name)
			  	xTarget.addAccountMoney(item.name, item.amount, "Received from " .. xPlayer.name)
                Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Gave Money', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Account:** '..Zen.Accounts[item.name]..'\n**Amount:** $'..Zen.Functions.FormatCommas(item.amount))
				Zen.Functions.Notify(source, ("You Gave $%s %s to %s"):format(Zen.Functions.FormatCommas(item.amount), Zen.Accounts[item.name], xTarget.name), 'dollar', "#00FF00")
				Zen.Functions.Notify(target, ("%s Gave You $%s %s"):format(xPlayer.name, Zen.Functions.FormatCommas(item.amount), Zen.Accounts[item.name]), 'dollar', "#00FF00")
			else
				Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			end

		elseif data.type == 'item_weapon' then
			if xPlayer.hasWeapon(item.name) then
			  	local weaponLabel = ESX.GetWeaponLabel(item.name)
			  	if not xTarget.hasWeapon(item.name) then
					local _, weapon = xPlayer.getWeapon(item.name)
					local _, weaponObject = ESX.GetWeapon(item.name)
					item.amount = weapon.ammo
					local weaponComponents = ESX.Table.Clone(weapon.components)
					local weaponTint = weapon.tintIndex
					
					if weaponTint then
				 	 	xTarget.setWeaponTint(item.name, weaponTint)
					end

					if weaponComponents then
				  		for k, v in pairs(weaponComponents) do
							xTarget.addWeaponComponent(item.name, v)
				  		end
					end

					xPlayer.removeWeapon(item.name)
					xTarget.addWeapon(item.name, item.amount)
					
                    Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Gave Weapon', Zen.Functions.Admin.LogFormats({ admin = source, target = target }, true)..'\n**Weapon:** '..weaponLabel..'\n**Ammo:** x'..item.amount)
					Zen.Functions.Notify(source, ("You Gave a %s to %s"):format(weaponLabel, xTarget.name), 'gun', "#00FF00")
					Zen.Functions.Notify(target, ("%s Gave Youa %s"):format(xPlayer.name, weaponLabel), 'gun', "#00FF00")
			  	else
					Zen.Functions.Notify(source, ("%s Already Has A %s!"):format(xTarget.name, weaponLabel), 'xmark', "#FF0000")
			  	end
			end
		end

	elseif action == 'drop' then 
		local item = {
			name = data.item,
			amount = data.amount
		}

		if data.type == 'item_standard' then
			if item.amount == nil or item.amount < 1 then
				Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			else
			  	local xItem = xPlayer.getInventoryItem(item.name)
		
			  	if (item.amount > xItem.count or xItem.count < 1) then
					Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			  	else
					xPlayer.removeInventoryItem(item.name, item.amount)
                    Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Removed Item', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Item:** '..xItem.label..'\n**Amount:** x'..item.amount)
					Zen.Functions.Notify(source, ("You Removed x%s %s!"):format(item.amount, xItem.label), 'ban', "#FF0000")
			  	end
			end

		elseif data.type == 'item_account' then
			if item.amount == nil or item.amount < 1 then
				Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			else
			  	local account = xPlayer.getAccount(item.name)
		
			  	if (item.amount > account.money or account.money < 1) then
					Zen.Functions.Notify(source, "Quantity is invalid!", 'xmark', "#FF0000")
			  	else
					xPlayer.removeAccountMoney(item.name, item.amount, "Threw away")
                    Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Removed Money', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Account:** '..account.label..'\n**Amount:** $'..Zen.Functions.FormatCommas(item.amount))
					Zen.Functions.Notify(source, ("You Removed $%s %s!"):format(Zen.Functions.FormatCommas(item.amount), account.label), 'ban', "#FF0000")
			  	end
			end 

		elseif data.type == 'item_weapon' then
			if xPlayer.hasWeapon(item.name) then
				local _, weapon = xPlayer.getWeapon(item.name)
				local _, weaponObject = ESX.GetWeapon(item.name)
				local components, pickupLabel = ESX.Table.Clone(weapon.components)
				xPlayer.removeWeapon(item.name)
                Zen.Functions.LogToDiscord(Zen.Webhooks['inventory'], 'Player Removed Weapon', Zen.Functions.Admin.LogFormats({ admin = source }, true)..'\n**Weapon:** '..weapon.label)
				Zen.Functions.Notify(source, ("You Removed Your %s!"):format(weapon.label), 'ban', "#FF0000")
			end
		end
	end
end)