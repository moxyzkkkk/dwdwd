local TakeHostage = Zen.Config.TakeHostage
TakeHostageData = {
    Cooldown = false,
    InProgress = false,
    Target = 0
}

local function ensureAnimDict(animDict)
	if not HasAnimDictLoaded(animDict) then 
		lib.requestAnimDict(animDict) 
	end

    return animDict
end

local function plyInvSearch()
	if not TakeHostageData.InProgress and TakeHostageData.Target == 0 then return end

	local plyState = lib.callback.await("getPlayerData", false, TakeHostageData.Target) 
	local plyInventory = {}

	if not plyState then return end

	for i = 1, #plyState.accounts, 1 do
		local account = plyState.accounts[i]
		if account.name == 'black_money' and account.money > 0 then
			plyInventory[#plyInventory+1] = {
				icon = 'dollar',
				label = 'Dirty Money:  $'..Zen.Functions.FormatCommas(account.money)..'',
				args = {
					type = 'account',
					value = 'black_money',
					amount = account.money
				}
			}

			break
		end
	end

	for i = 1, #plyState.inventory do 
		local item = plyState.inventory[i]
		if item.count > 0 and Zen.Items[item.name].canRemove then
			plyInventory[#plyInventory+1] = {
				icon = 'box',
				label = item.count..'x '..item.label..'',
				args = { type = 'item', value = item.name, amount = item.count }
			}
		end
	end

	for i = 1, #plyState.loadout do 
		local weapon = plyState.loadout[i]
		plyInventory[#plyInventory+1] = {
			icon = 'gun',
			label = Zen.Weapons[weapon.name]..' x'..weapon.ammo..' Bullets',
			args = { type = 'weapon', value = weapon.name, amount = weapon.ammo }
		}
	end

	if table.type(plyInventory) == 'empty' then 
		plyInventory[#plyInventory+1] = {
			icon = 'xmark',
			label = 'Inventory is empty!',
			close = false
		}
	end

	return plyInventory
end

if TakeHostage.SearchEnabled then 
	lib.registerMenu({
		id = 'th-search',
		title = 'Robbing',
		position = 'bottom-right',
		options = {}
	}, function(selected, scrollIndex, args)
		if args and args.value then
			TriggerServerEvent('TakeHostage:search', TakeHostageData.Target, args.type, args.value, args.amount)

			SetTimeout(300, function()
				lib.setMenuOptions('th-search', plyInvSearch())
				lib.showMenu('th-search')
			end)
		end
	end)
end

RegisterCommand('th', function()
	ClearPedSecondaryTask(cache.ped)
	DetachEntity(cache.ped, true, false)

	local canTakeHostage = false
	for i = 1, #TakeHostage.AllowedWeapons do
		if HasPedGotWeapon(cache.ped, TakeHostage.AllowedWeapons[i], false) then
			if GetAmmoInPedWeapon(cache.ped, TakeHostage.AllowedWeapons[i]) > 0 then
				canTakeHostage = true 
				foundWeapon = TakeHostage.AllowedWeapons[i]
				break
			end 					
		end
	end

	if not canTakeHostage then 
		return Zen.Functions.Notify('You need a pistol with ammo to take a hostage at gunpoint!', 'gun', '#FF0000') 
	end

	if not TakeHostageData.InProgress then	
        local closestPlayer = lib.getClosestPlayer(cache.coords, 3.0, false)

        if not closestPlayer then 
            return Zen.Functions.Notify('No One Nearby!', 'user', '#FF0000') 
        end
        
        local Target = GetPlayerServerId(closestPlayer)
        if Target ~= -1 then
            if (IsEntityPlayingAnim(GetPlayerPed(closestPlayer), "random@mugging3", "handsup_standing_base", 3)) then
                SetCurrentPedWeapon(cache.ped, foundWeapon, true)
                TakeHostageData.InProgress = true
                TakeHostageData.Target = Target
                TriggerServerEvent("TakeHostage:sync", Target)

				local data = TakeHostage.Animations[1]

				ensureAnimDict(data.animDict)

				while true do
					Wait(0)
					if not TakeHostageData.InProgress then
						break
					end

					if not IsEntityPlayingAnim(cache.ped, data.animDict, data.anim, 3) then
						TaskPlayAnim(cache.ped, data.animDict, data.anim, 8.0, -8.0, 100000, data.flag, 0, false, false, false)
					end

					DisableControlAction(0,24, true) -- disable attack
					DisableControlAction(0,25, true) -- disable aim
					DisableControlAction(0,47, true) -- disable weapon
					DisableControlAction(0,58, true) -- disable weapon
					DisableControlAction(0,21, true) -- disable sprint
					DisablePlayerFiring(cache.ped, true)

					local text = '[H] - Kill Player  \n [G] - Release Player'

					if TakeHostage.SearchEnabled then 
						text = text..'  \n [Y] - Search Player'
					end

					lib.showTextUI(text)
		
					if playerDead then	
						TakeHostageData.InProgress = false
						lib.hideTextUI()
						ensureAnimDict("reaction@shove")
						TaskPlayAnim(cache.ped, "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
						TriggerServerEvent("TakeHostage:release", TakeHostageData.Target)
					end 
		
					if IsDisabledControlJustPressed(0,47) then --release	
						TakeHostageData.InProgress = false
						lib.hideTextUI()
						ensureAnimDict("reaction@shove")
						TaskPlayAnim(cache.ped, "reaction@shove", "shove_var_a", 8.0, -8.0, -1, 168, 0, false, false, false)
						TriggerServerEvent("TakeHostage:release", TakeHostageData.Target)
						TakeHostageData.Target = 0
					elseif IsDisabledControlJustPressed(0,74) then --kill 			
						TakeHostageData.InProgress = false		
						lib.hideTextUI()
						ensureAnimDict("anim@gangops@hostage@")
						TaskPlayAnim(cache.ped, "anim@gangops@hostage@", "perp_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
						TriggerServerEvent("TakeHostage:kill", TakeHostageData.Target)
						TriggerServerEvent("TakeHostage:stop",TakeHostageData.Target)
						Wait(100)
						SetPedShootsAtCoord(cache.ped, 0.0, 0.0, 0.0, 0)
						TakeHostageData.Target = 0
					end
					
					if TakeHostage.SearchEnabled then 
						if IsDisabledControlJustPressed(0, 246) then -- search
							lib.setMenuOptions('th-search', plyInvSearch())
							lib.showMenu('th-search')
						end
					end
				end
            else
                Zen.Functions.Notify("You can't take people hostage without them surrendering!", 'xmark', '#FF0000')
            end
        else
            Zen.Functions.Notify('No One Nearby!', 'user', '#FF0000') 
        end
	end
end)

RegisterNetEvent("TakeHostage:sync", function(target)
	local targetPed = GetPlayerPed(GetPlayerFromServerId(target))
	TakeHostageData.InProgress = true

	local data = TakeHostage.Animations[2]

	ensureAnimDict(data.animDict)
	AttachEntityToEntity(cache.ped, targetPed, 0, data.attach, 0.5, 0.5, 0.0, false, false, false, false, 2, false)

	while true do 
		Wait(0)

		if not TakeHostageData.InProgress then break end

		if not IsEntityPlayingAnim(cache.ped, data.animDict, data.anim, 3) then
			TaskPlayAnim(cache.ped, data.animDict, data.anim, 8.0, -8.0, 100000, data.flag, 0, false, false, false)
		end

		DisableControlAction(0,21, true) -- disable sprint
		DisableControlAction(0,24, true) -- disable attack
		DisableControlAction(0,25, true) -- disable aim
		DisableControlAction(0,47, true) -- disable weapon
		DisableControlAction(0,58, true) -- disable weapon
		DisableControlAction(0,263, true) -- disable melee
		DisableControlAction(0,264, true) -- disable melee
		DisableControlAction(0,257, true) -- disable melee
		DisableControlAction(0,140, true) -- disable melee
		DisableControlAction(0,141, true) -- disable melee
		DisableControlAction(0,142, true) -- disable melee
		DisableControlAction(0,143, true) -- disable melee
		DisableControlAction(0,75, true) -- disable exit vehicle
		DisableControlAction(27,75, true) -- disable exit vehicle  
		DisableControlAction(0,22, true) -- disable jump
		DisableControlAction(0,32, true) -- disable move up
		DisableControlAction(0,268, true)
		DisableControlAction(0,33, true) -- disable move down
		DisableControlAction(0,269, true)
		DisableControlAction(0,34, true) -- disable move left
		DisableControlAction(0,270, true)
		DisableControlAction(0,35, true) -- disable move right
		DisableControlAction(0,271, true)
	end
end)

RegisterNetEvent("TakeHostage:release", function()
	TakeHostageData.InProgress = false 
	DetachEntity(cache.ped, true, false)
	ensureAnimDict("reaction@shove")
	TaskPlayAnim(cache.ped, "reaction@shove", "shoved_back", 8.0, -8.0, -1, 0, 0, false, false, false)
	Wait(250)
	ClearPedSecondaryTask(cache.ped)
end)

RegisterNetEvent("TakeHostage:kill", function()
	TakeHostageData.InProgress = false 
	SetEntityHealth(cache.ped,0)
	DetachEntity(cache.ped, true, false)
	ensureAnimDict("anim@gangops@hostage@")
	TaskPlayAnim(cache.ped, "anim@gangops@hostage@", "victim_fail", 8.0, -8.0, -1, 168, 0, false, false, false)
end)

RegisterNetEvent("TakeHostage:stop", function()
	TakeHostageData.InProgress = false
	ClearPedSecondaryTask(cache.ped)
	DetachEntity(cache.ped, true, false)
end)