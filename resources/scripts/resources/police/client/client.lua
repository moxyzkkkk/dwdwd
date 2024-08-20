local Police = Zen.Config.Police
local interaction, copBlips, vehicleShop, itemsTable = {}, {}, {}, {}
local componentsTable = { 
	['Silencer'] = { 'COMPONENT_AT_PI_SUPP', 'COMPONENT_AT_SR_SUPP', 'COMPONENT_AT_AR_SUPP', 'COMPONENT_AT_AR_SUPP_02', 'COMPONENT_AT_PI_SUPP_02', }, 
	['Grip'] = { 'COMPONENT_AT_AR_AFGRIP', 'COMPONENT_AT_AR_AFGRIP_02' }, 
	['Flashlight'] = { 'COMPONENT_AT_PI_FLSH', 'COMPONENT_AT_PI_FLSH_03', 'COMPONENT_AT_PI_FLSH_02', 'COMPONENT_AT_AR_FLSH' }, 
	['Scope'] = { 'COMPONENT_AT_SCOPE_LARGE', 'COMPONENT_AT_SCOPE_MACRO_MK2', 'COMPONENT_AT_PI_RAIL_02', 'COMPONENT_AT_SCOPE_MACRO', 'COMPONENT_AT_SCOPE_MACRO_02', 'COMPONENT_AT_SCOPE_MACRO_02_MK2', 'COMPONENT_AT_SCOPE_MACRO_02_SMG_MK2', 'COMPONENT_AT_SCOPE_SMALL', 'COMPONENT_AT_SCOPE_MEDIUM' }, 
	['Magazine'] = { 'COMPONENT_SMG_CLIP_03', 'COMPONENT_MACHINEPISTOL_CLIP_03', 'COMPONENT_COMBATPDW_CLIP_03', 'COMPONENT_HEAVYSHOTGUN_CLIP_03', 'COMPONENT_ASSAULTRIFLE_CLIP_03', 'COMPONENT_CARBINERIFLE_CLIP_03', 'COMPONENT_SPECIALCARBINE_CLIP_03', 'COMPONENT_COMPACTRIFLE_CLIP_03' }, 
	['Extended Clip'] = { 'COMPONENT_PISTOL_CLIP_02', 'COMPONENT_COMBATPISTOL_CLIP_02', 'COMPONENT_APPISTOL_CLIP_02', 'COMPONENT_PISTOL50_CLIP_02', 'COMPONENT_SNSPISTOL_CLIP_02', 'COMPONENT_HEAVYPISTOL_CLIP_02', 'COMPONENT_SNSPISTOL_MK2_CLIP_02', 'COMPONENT_PISTOL_MK2_CLIP_02', 'COMPONENT_VINTAGEPISTOL_CLIP_02', 'COMPONENT_MICROSMG_CLIP_02', 'COMPONENT_ASSAULTSMG_CLIP_02', 'COMPONENT_MINISMG_CLIP_02', 'COMPONENT_SMG_MK2_CLIP_02', 'COMPONENT_MACHINEPISTOL_CLIP_02', 'COMPONENT_COMBATPDW_CLIP_02', 'COMPONENT_ASSAULTSHOTGUN_CLIP_02', 'COMPONENT_HEAVYSHOTGUN_CLIP_02', 'COMPONENT_ASSAULTRIFLE_CLIP_02', 'COMPONENT_CARBINERIFLE_CLIP_02', 'COMPONENT_ADVANCEDRIFLE_CLIP_02', 'COMPONENT_SPECIALCARBINE_CLIP_02', 'COMPONENT_BULLPUPRIFLE_CLIP_02', 'COMPONENT_BULLPUPRIFLE_MK2_CLIP_02', 'COMPONENT_SPECIALCARBINE_MK2_CLIP_02', 'COMPONENT_ASSAULTRIFLE_MK2_CLIP_02', 'COMPONENT_CARBINERIFLE_MK2_CLIP_02', 'COMPONENT_COMPACTRIFLE_CLIP_02', 'COMPONENT_MILITARYRIFLE_CLIP_02', 'COMPONENT_MG_CLIP_02', 'COMPONENT_COMBATMG_CLIP_02', 'COMPONENT_COMBATMG_MK2_CLIP_02', 'COMPONENT_GUSENBERG_CLIP_02', 'COMPONENT_MARKSMANRIFLE_MK2_CLIP_02', 'COMPONENT_HEAVYSNIPER_MK2_CLIP_02', 'COMPONENT_MARKSMANRIFLE_CLIP_02' } ,
}

PolicePlayerData = { Cuffed = false, Escorted = false, VehicleEscort = false }

local function isPD()
	if stateBag.job.name ~= 'police' then return false end
	return true
end

local function createBlip(player)
	local id = GetPlayerFromServerId(player)
	if NetworkIsPlayerActive(id) and GetPlayerPed(id) ~= cache.ped then
		local ped = GetPlayerPed(id)
		local blip = GetBlipFromEntity(ped)
		if not DoesBlipExist(blip) then
			blip = AddBlipForEntity(ped)
			SetBlipSprite(blip, 1)
			SetBlipColour(blip, 57)
			ShowHeadingIndicatorOnBlip(blip, true)
			SetBlipRotation(blip, math.ceil(GetEntityHeading(ped)))
			SetBlipNameToPlayerName(blip, id)
			SetBlipScale(blip, 0.7)
			SetBlipAsShortRange(blip, true)
			copBlips[#copBlips+1] = blip
		end
	end
end

local function plyInvSearch()
	local plyState = lib.callback.await("getPlayerData", false, GetPlayerServerId(interaction.closestPlayer)) 
	local plyInventory = {}

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

local function plyCuffed()
	while PolicePlayerData.Cuffed ~= false do
		DisableControlAction(0, 1, true) -- Disable pan
		DisableControlAction(0, 2, true) -- Disable tilt
		DisableControlAction(0, 24, true) -- Attack
		DisableControlAction(0, 257, true) -- Attack 2
		DisableControlAction(0, 25, true) -- Aim
		DisableControlAction(0, 263, true) -- Melee Attack 1
		DisableControlAction(0, 32, true) -- W
		DisableControlAction(0, 34, true) -- A
		DisableControlAction(0, 31, true) -- S
		DisableControlAction(0, 30, true) -- D
		DisableControlAction(0, 45, true) -- Reload
		DisableControlAction(0, 22, true) -- Jump
		DisableControlAction(0, 289, true) -- Jump
		DisableControlAction(0, 44, true) -- Cover
		DisableControlAction(0, 37, true) -- Select Weapon
		DisableControlAction(0, 23, true) -- Also 'enter'?
		DisableControlAction(0, 288,  true) -- Disable phone
		DisableControlAction(0, 170, true) -- Animations
		DisableControlAction(0, 166, true) -- f5
		DisableControlAction(0, 344, true) -- f11
		DisableControlAction(0, 167, true) -- Job
		DisableControlAction(0, 0, true) -- Disable changing view
		DisableControlAction(0, 26, true) -- Disable looking behind
		DisableControlAction(0, 73, true) -- Disable clearing animation
		DisableControlAction(2, 199, true) -- Disable pause screen
		DisableControlAction(0, 59, true) -- Disable steering in vehicle
		DisableControlAction(0, 71, true) -- Disable driving forward in vehicle
		DisableControlAction(0, 72, true) -- Disable reversing in vehicle
		DisableControlAction(2, 36, true) -- Disable going stealth
		DisableControlAction(0, 47, true)  -- Disable weapon
		DisableControlAction(0, 264, true) -- Disable melee
		DisableControlAction(0, 257, true) -- Disable melee
		DisableControlAction(0, 140, true) -- Disable melee
		DisableControlAction(0, 141, true) -- Disable melee
		DisableControlAction(0, 142, true) -- Disable melee
		DisableControlAction(0, 143, true) -- Disable melee
		DisableControlAction(0, 75, true)  -- Disable exit vehicle
		DisableControlAction(27, 75, true) -- Disable exit vehicle
		
		if IsEntityPlayingAnim(cache.ped, 'mp_arresting', 'idle', 3) ~= 1 then
			lib.requestAnimDict('mp_arresting')
			TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0.0, false, false, false)
		end

		Wait(0)
	end
end

local function plyUncuff()
	if PolicePlayerData.Cuffed then
		Zen.Functions.Notify('Your Cuffs Fell Off!', 'handcuffs', '#1f6ecf')
		PolicePlayerData.Cuffed = false
		ClearPedSecondaryTask(cache.ped)
		SetEnableHandcuffs(cache.ped, false)
		DisablePlayerFiring(cache.ped, false)
		SetPedCanPlayGestureAnims(cache.ped, true)
		FreezeEntityPosition(cache.ped, false)
		DisplayRadar(true)

		if PolicePlayerData.Escorted then
			PolicePlayerData.Escorted = false
		end

		if PolicePlayerData.VehicleEscort then 
			PolicePlayerData.VehicleEscort = false
			if IsPedSittingInAnyVehicle(cache.ped) then
				TaskLeaveVehicle(cache.ped, cache.vehicle, 16)
			end
		end
	end
end

local function plyEscorted(escorter)
	local ply = cache.ped
	local tgt = GetPlayerPed(GetPlayerFromServerId(escorter))

	while PolicePlayerData.Escorted ~= false do
		if not IsPedSittingInAnyVehicle(tgt) then
			AttachEntityToEntity(ply, tgt, 11816, 0.54, 0.54, 0.0, 0.0, 0.0, 0.0, false, false, false, false, 2, true)
		else
			PolicePlayerData.Escorted = false
			DetachEntity(ply, true, false)
		end

		if IsPedDeadOrDying(tgt, true) then
			PolicePlayerData.Escorted = false
			DetachEntity(ply, true, false)
		end
		
		Wait(0)
	end

	PolicePlayerData.Escorted = false
	DetachEntity(ply, true, false)
end

local function RemoveVehicle()
	if DoesEntityExist(vehicleShop.current) then
		DeleteVehicle(vehicleShop.current)
	end
	
	FreezeEntityPosition(cache.ped, false)
	DestroyAllCams(true)
	RenderScriptCams(false, true, 750)
end

lib.registerMenu({
	id = 'police-citizen-info',
	title = 'Citizen Information',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-citizen-interaction')
	end,
	options = {}
})

lib.registerMenu({
	id = 'police-citizen-search',
	title = 'Citizen Search',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-citizen-interaction')
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end

	if args and args.value then
		TriggerServerEvent('police:interaction:citizen:search:confiscate', GetPlayerServerId(interaction.closestPlayer), args.type, args.value, args.amount)

		if args.type == 'account' then 
			TriggerServerEvent('esx_society:depositMoney', 'police', args.amount)
		end

		SetTimeout(300, function()
			lib.setMenuOptions('police-citizen-search', plyInvSearch())
			lib.showMenu('police-citizen-search')
		end)
	end
end)

lib.registerMenu({
	id = 'police-citizen-fine-category',
	title = 'Citizen Fine',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-citizen-fine')
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end

	TriggerServerEvent('billing:send', GetPlayerServerId(interaction.closestPlayer), 'society_police', args.label, args.amount)

	SetTimeout(300, function()
		lib.showMenu('police-citizen-fine-category')
	end)
end)

lib.registerMenu({ 
	id = 'police-citizen-fine', 
	title = 'Citizen Fine', 
	position = 'bottom-right', 
	options = {
		{ label = 'Traffic Offense', args = { category = 0 } }, 
		{ label = 'Minor Offense', args = { category = 1 } }, 
		{ label = 'Average Offense', args = { category = 2 } }, 
		{ label = 'Major Offense', args = { category = 3 } }
	},
	onClose = function()
		lib.showMenu('police-citizen-interaction')
	end
}, function(_, _, args)
	if not isPD() then return end

	if args.category then 
		local fines = {}

		for i = 1, #Police.Fines do 
			local fine = Police.Fines[i]
			if fine.category == args.category then 
				fines[#fines+1] = {
					label = fine.label,
					description = 'Pay: $'..fine.amount,
					args = {
						label = fine.label,
						amount = fine.amount
					}
				}
			end
		end

		lib.setMenuOptions('police-citizen-fine-category', fines)
		lib.showMenu('police-citizen-fine-category')
	end
end)

lib.registerMenu({
	id = 'police-citizen-fines',
	title = 'Citizen Fines',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-citizen-interaction')
	end,
	options = {}
})

lib.registerMenu({
	id = 'police-citizen-interaction',
	title = 'Police Citizen Menu',
	position = 'bottom-right',
	options = {
		{ icon = 'id-card', label = 'Identification' },
		{ icon = 'magnifying-glass', label = 'Search' },
		{ icon = 'handcuffs', label = 'Cuff / Uncuff', close = false },
		{ icon = 'user-lock', label = 'Escort', close = false },
		{ icon = 'car', label = 'Vehicle Escort', close = false },
		{ icon = 'file-invoice', label = 'Fine' },
		{ icon = 'list', label = 'Manage Unpaid Bills' }
	}
}, function(selected, _, _)
	if not isPD() then return end

	interaction.closestPlayer = nil
	local closestPlayer = lib.getClosestPlayer(cache.coords, 3.0, false)

	if not closestPlayer or closestPlayer == -1 then 
		return Zen.Functions.Notify('No One Nearby!', 'user', '#FF0000') 
	end

	interaction.closestPlayer = closestPlayer

	if selected == 1 then 
		local plyState = Player(GetPlayerServerId(interaction.closestPlayer)).state
		local options = {
			{ label = 'Name: '..plyState.name },
			{ label = 'Job: '..plyState.job.label..' - '..plyState.job.grade_label },
		}

		lib.setMenuOptions('police-citizen-info', options)
		lib.showMenu('police-citizen-info')
	elseif selected == 2 then 
		lib.setMenuOptions('police-citizen-search', plyInvSearch())
		lib.showMenu('police-citizen-search')

	elseif selected == 3 then 
		TriggerServerEvent('police:interaction:citizen:action',  GetPlayerServerId(interaction.closestPlayer), 'handcuff')
	elseif selected == 4 then 
		TriggerServerEvent('police:interaction:citizen:action', GetPlayerServerId(interaction.closestPlayer), 'escort')
	elseif selected == 5 then 
		TriggerServerEvent('police:interaction:citizen:action', GetPlayerServerId(interaction.closestPlayer), 'vehicle')
	elseif selected == 6 then 
		lib.showMenu('police-citizen-fine')
	elseif selected == 7 then 
		local bills = lib.callback.await('billing:get', false, GetPlayerServerId(interaction.closestPlayer))
		local billsTable = {}

		if #bills == 0 or bills == nil then 
			return Zen.Functions.Notify('Player Has No Fines!', 'xmark', '#FF0000')
		end
	
		for i = 1, #bills do 
			billsTable[#billsTable+1] = {
				label = bills[i].label,
				close = false,
				description = 'Amount: $'..Zen.Functions.FormatCommas(bills[i].amount)
			}
		end
	
		lib.setMenuOptions('police-citizen-fines', billsTable)
		lib.showMenu('police-citizen-fines')
	end
end)

lib.registerMenu({
	id = 'police-vehicle-info',
	title = 'Vehicle Information',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-vehicle-interaction')
	end,
	options = {}
})

lib.registerMenu({
	id = 'police-vehicle-interaction',
	title = 'Police Vehicle Menu',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-interaction')
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end

	if args and args.action then 
		local closestVehicle = lib.getClosestVehicle(cache.coords, 3.0, false)

		if args.action == 'search' then 
			local input = lib.inputDialog('Police Vehicle Lookup', {'License Plate'})
			if not input then return end
		
			local length = string.len(input[1])
			if not input[1] or length < 2 or length > 13 then
				return Zen.Functions.Notify('Invalid Registration Number.', 'car', '#FF0000')
			end

			local out, model, owner = lib.callback.await('police:interaction:vehicles', false, input[1])

			if not out then 
				return Zen.Functions.Notify('Vehicle Is Not On The Streets!', 'car', '#FF0000')
			end

			lib.setMenuOptions('police-vehicle-info', {
				{ icon = 'user', label = owner, close = false },
				{ icon = 'car', label = input[1], close = false },
			})
		
			lib.showMenu('police-vehicle-info')

		elseif DoesEntityExist(closestVehicle) then 
			if args.action == 'info' then 

				lib.setMenuOptions('police-vehicle-info', {
					{ icon = 'user', label = (Entity(closestVehicle).state.owner or 'Not Found'), close = false },
					{ icon = 'car', label = GetVehicleNumberPlateText(closestVehicle), close = false },
				})
			
				lib.showMenu('police-vehicle-info')
			elseif args.action == 'lockpick' then 
				TaskStartScenarioInPlace(cache.ped, 'WORLD_HUMAN_WELDING', 0, true)
				Wait(20000)
				ClearPedTasksImmediately(cache.ped)
				SetVehicleDoorsLocked(closestVehicle, 1)
				SetVehicleDoorsLockedForAllPlayers(closestVehicle, false)
				SetVehicleAlarm(closestVehicle, true)
				SetVehicleAlarmTimeLeft(closestVehicle, 10000)

				Zen.Functions.Notify('Vehicle Unlocked', 'car', '#1668C7')
			elseif args.action == 'impound' then 
				if interaction.vehicle.busy then return end

				TaskStartScenarioInPlace(cache.ped, 'CODE_HUMAN_MEDIC_TEND_TO_DEAD', 0, true)
				
				interaction.vehicle.busy = true
				
				SetTimeout(10000, function()
					ClearPedTasks(cache.ped)
					SetEntityAsMissionEntity(closestVehicle, true, true)
					DeleteVehicle(closestVehicle)
					Zen.Functions.Notify('You have impounded the vehicle.')
					interaction.vehicle.busy = false
					Wait(100)
				end)

				CreateThread(function()
					while interaction.vehicle.busy do
						Wait(1000)

						closestVehicle = lib.getClosestVehicle(cache.coords, 3.0, false)
						
						if not DoesEntityExist(closestVehicle) and interaction.vehicle.busy then
							Zen.Functions.Notify('The impound has been canceled because the vehicle moved.', 'car', '#FF0000')
							ClearPedTasks(cache.ped)
							interaction.vehicle.busy = false
							break
						end
					end
				end)
			end
		else
			Zen.Functions.Notify('er')
		end
	end
end)

lib.registerMenu({
	id = 'police-interaction',
	title = 'Police Menu',
	position = 'bottom-right',
	options = {
		{ label = 'Citizen Interaction' }, 
		{ label = 'Vehicle Interaction' }
	}
}, function(selected, _, _)
	if not isPD() then return end

	if selected == 1 then 
		lib.showMenu('police-citizen-interaction')
	elseif selected == 2 then 
		local options = {}
		local closestVehicle = lib.getClosestVehicle(cache.coords, 3.0, false)
		
		if DoesEntityExist(closestVehicle) then
			options[#options+1] = { label = 'Vehicle Info', args = { action = 'info' }}
			options[#options+1] = { label = 'Lockpick Vehicle', args = { action = 'lockpick' }}
			options[#options+1] = { label = 'Impound Vehicle', args = { action = 'impound' }}
		end

		options[#options+1] = { label = 'Search Database', args = { action = 'search' } }

		lib.setMenuOptions('police-vehicle-interaction', options)
		lib.showMenu('police-vehicle-interaction')
	end
end)

lib.addKeybind({
	name = 'police-interaction',
	description = 'Press F6 For Police Menu',
	defaultKey = 'F6',
	onReleased = function(self)
		if not Zen.Functions.CanInteract() then 
			return Zen.Functions.Notify('Cant Do This Right Now!', 'xmark', '#FF0000')
		end

		if lib.getOpenMenu() == 'police-interaction' then return end

		if stateBag.job.name == 'police' then 
			lib.showMenu('police-interaction')
		end
	end
})

lib.registerMenu({
	id = 'police-armory-weapons-components',
	title = 'Police Weapons Components',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-armory-weapons')
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end

	if args and args.component then 
		if not HasPedGotWeaponComponent(cache.ped, args.weapon, GetHashKey(args.component)) then 
			Zen.Functions.Notify('You Put On '..args.label, 'check', '#00FF00')
			GiveWeaponComponentToPed(cache.ped, args.weapon, GetHashKey(args.component))
		else
			Zen.Functions.Notify('You Took Off '..args.label, 'xmark', '#FF0000')
			RemoveWeaponComponentFromPed(cache.ped, args.weapon, GetHashKey(args.component))
		end
	end
end)

lib.registerMenu({
	id = 'police-armory-weapons',
	title = 'Police Weapons',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-armory')
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end

	if args and args.weapon then 
		if HasPedGotWeapon(cache.ped, args.weapon, false) then 
			local components = {}

			for category, component in pairs(componentsTable) do 
				for i = 1, #componentsTable[category], 1 do
					if DoesWeaponTakeWeaponComponent(args.weapon, GetHashKey(componentsTable[category][i])) then
						components[#components+1] = {
							label = category,
							close = false,
							args = {
								label = category,
								weapon = args.weapon,
								component = componentsTable[category][i]
							}
						}
						break 
					end 
				end

			end

			if table.type(components) ~= 'empty' then
				lib.hideMenu()
				Wait(100)
				lib.setMenuOptions('police-armory-weapons-components', components)
				lib.showMenu('police-armory-weapons-components')
			else
				Zen.Functions.Notify('No Components For This Weapon!', 'xmark', '#FF0000')
			end
			
			return
		end	

		TriggerServerEvent('gunstore:purchase', 'money', args.weapon, 'police')
	end
end)

lib.registerMenu({
	id = 'police-armory-items',
	title = 'Police Items',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-armory')
	end,
	options = {}
}, function(selected, scrollIndex, args)
	if not isPD() then return end

	local data = {
		label = args.label,
		item = args.item, 
		price = args.price * scrollIndex, 
		amount = scrollIndex
	}

	if data and data.item then 
		TriggerServerEvent('shop:purchase', data.item, data.amount, 'police')
	end
end)

lib.registerMenu({
	id = 'police-armory',
	title = 'Police Armory',
	position = 'bottom-right',
	options = {
		{ icon = 'gun', label = 'Weapons' },
		{ icon = 'box', label = 'Items' }
	}
}, function(selected, _, args)
	if not isPD() then return end

	if selected == 1 then 
		local weapons = {}
		for k, v in pairs(Police.Weapons) do 
			for j = 1, #Police.Weapons[k].ranks do 
				if stateBag.job.grade_name == v.ranks[j] then 
					local weapon = v.weapon
					local label = Zen.Weapons[weapon]..' - $'..Zen.Functions.FormatCommas(v.price)
					
					if HasPedGotWeapon(cache.ped, weapon, false) then 
						label = Zen.Weapons[weapon]..' >'
					end
					
					weapons[#weapons+1] = {
						label = label,
						close = false,
						description = 'Select To View Components',
						args = {
							label = Zen.Weapons[weapon],
							weapon = weapon,
							price = v.price,
						}
					}
				end
			end
		end

		lib.setMenuOptions('police-armory-weapons', weapons)
		lib.showMenu('police-armory-weapons')

	elseif selected == 2 then 
		local items = {}

		for k, v in pairs(itemsTable) do 
			for j = 1, #itemsTable[k].args.ranks do 
				if stateBag.job.grade_name == v.args.ranks[j] then 
					items[#items+1] = v
				end
			end
		end

		lib.setMenuOptions('police-armory-items', items)
		lib.showMenu('police-armory-items')
	end
end)

lib.registerMenu({
	id = 'police-evidence-items',
	title = 'Police Evidence Items',
	position = 'bottom-right',
	options = {}
}, function(_, _, args) 
	if stateBag.job.name ~= 'police' and stateBag.job.grade_name ~= 'boss' then return end

	local input = lib.inputDialog('EVIDENCE TAKE OUT', { {type = 'number', label = 'Quantity'}})
	if not input then return end
	
	local item = args.data
	local count = tonumber(input[1])

	if count == 0 or item.count < count then
		Zen.Functions.Notify('Invalid Quantity!', 'xmark', '#FF0000')
	else
		TriggerServerEvent('police:evidence:take', item.name, count)
		lib.showMenu('police-evidence')
	end
end)

lib.registerMenu({
	id = 'police-evidence',
	title = 'Police Evidence',
	position = 'bottom-right',
	options = {
		{ label = 'Items' }
	}
}, function(selected, _, args) 
	if not isPD() then return end

	if selected == 1 then 
		local evidence = {}
		local evidenceItems = lib.callback.await('police:evidence:items', false)

		if table.type(evidenceItems) == 'empty' then 
			return Zen.Functions.Notify('No Items Available', 'box', '#FF0000')
		end

		for i = 1, #evidenceItems do
			local item = evidenceItems[i]
			evidence[#evidence+1] = {
				icon = 'box',
				label = 'x' .. item.count .. ' ' .. Zen.Items[item.name].label,
				args = {
					data = item
				}
			}
		end

		lib.setMenuOptions('police-evidence-items', evidence)
		lib.showMenu('police-evidence-items')
	end
end)

lib.registerMenu({
	id = 'police-vehicles-view',
	title = 'Police Garage',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-vehicles')
		RemoveVehicle()
	end,
	onSelected = function(selected, secondary, args)
		if args then 
			while DoesEntityExist(vehicleShop.current) do 
				DeleteVehicle(vehicleShop.current) 
			end

			Zen.Streaming.SpawnVehicle(args.model, Police.Station[4].spawn, Police.Station[4].spawn.w, function(callback)
				FreezeEntityPosition(cache.ped, true)

				if DoesCamExist(Camera) then 
					DestroyCam(Camera) 
				end

				Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		
				SetCamCoord(Camera, GetOffsetFromEntityInWorldCoords(callback, -3.0, 4.0, 1.5))
				SetCamRot(Camera, vector3(-20.0, 0.0, GetEntityHeading(callback) - 120.0))
				RenderScriptCams(1, 1, 500, 1, 1)
				
				if DoesEntityExist(callback) then
					vehicleShop.current = callback
				end
			end, false, false)
		end
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end
	if args then 
		if args.action == 'garage' then 
			RemoveVehicle()

			Zen.Streaming.SpawnVehicle(args.model, Police.Station[4].spawn, Police.Station[4].spawn.w, function(callback)
				lib.setVehicleProperties(callback, args.properties)
				TaskWarpPedIntoVehicle(cache.ped, callback, -1)
			end, true, cache.serverId)
		elseif args.action == 'shop' then 
			
			local alert = lib.alertDialog({
				header = 'Purchase Vehicle',
				content = '',
				centered = true,
				cancel = true
			})

			if alert ~= 'confirm' then 
				return RemoveVehicle()
			end

			local plate = Zen.Functions.GeneratePlate()
			local props = lib.getVehicleProperties(vehicleShop.current)
			props.plate = plate
			local success = lib.callback.await('police:vehicles:buy', false, props, 'car', args.price, args.label)
	
			RemoveVehicle()

			if not success then 
				return Zen.Functions.Notify('Cant Afford This Vehicle!', 'dollar', '#FF0000')
			end
		end
	end
end)

lib.registerMenu({
	id = 'police-vehicles',
	title = 'Police Vehicles',
	position = 'bottom-right',
	options = {
		{ label = 'Open Garage' },
		{ label = 'Purchase Vehicle' }
	}
}, function(selected, _, args)
	if not isPD() then return end

	if selected == 1 then 
		local vehicles = lib.callback.await('garages:get', false, 'police', 'car')
		local myVehicles = {}

		if table.type(vehicles) == 'empty' then 
			return Zen.Functions.Notify('You Dont Own Any Vehicles!', 'car', '#FF0000')
		end

		for i = 1, #vehicles do 
			local properties = Zen.Streaming.GetProperties(vehicles[i].plate)

			myVehicles[#myVehicles+1] = {
				icon = 'car',
				label = vehicles[i].plate..' | '..vehicles[i].label,
				args = {
					action = 'garage',
					name = vehicles[i].label,
					model = properties.model,
					plate = vehicles[i].plate,
					properties = properties
				}
			}
		end

		lib.setMenuOptions('police-vehicles-view', myVehicles)
		lib.showMenu('police-vehicles-view')

	elseif selected == 2 then
		local shopVehicles = {}

		for i = 1, #Police.Vehicles do 
			for j = 1, #Police.Vehicles[i].ranks do 
				if stateBag.job.grade_name == Police.Vehicles[i].ranks[j] then 
					local vehicle = Police.Vehicles[i]
					shopVehicles[#shopVehicles+1] = {
						icon = 'car',
						label = vehicle.label..' - $'..Zen.Functions.FormatCommas(vehicle.price),
						args = { 
							action = 'shop',
							label = vehicle.label,
							model = vehicle.model,
							price = vehicle.price
						}
					}
				end
			end
		end

		if table.type(shopVehicles) == 'empty' then 
			return Zen.Functions.Notify('Cant Purchase Any Vehicles!', 'car', '#FF0000')
		end

		lib.setMenuOptions('police-vehicles-view', shopVehicles)
		lib.showMenu('police-vehicles-view')
	end
end)

lib.registerMenu({
	id = 'police-helicopters-view',
	title = 'Police Helicopters',
	position = 'bottom-right',
	onClose = function()
		lib.showMenu('police-helicopters')
		RemoveVehicle()
	end,
	onSelected = function(selected, secondary, args)
		if args then 
			while DoesEntityExist(vehicleShop.current) do 
				DeleteVehicle(vehicleShop.current) 
			end

			Zen.Streaming.SpawnVehicle(args.model, Police.Station[5].spawn, Police.Station[5].spawn.w, function(callback)
				FreezeEntityPosition(cache.ped, true)

				if DoesCamExist(Camera) then 
					DestroyCam(Camera) 
				end


				Camera = CreateCam("DEFAULT_SCRIPTED_CAMERA", true)
		
				SetCamCoord(Camera, GetOffsetFromEntityInWorldCoords(callback, -3.0, 4.0, 1.5))
				SetCamRot(Camera, vector3(-20.0, 0.0, GetEntityHeading(callback) - 120.0))
				RenderScriptCams(1, 1, 500, 1, 1)
				
				if DoesEntityExist(callback) then
					SetVehicleModKit(callback, 0)
					SetVehicleLivery(callback, args.livery)
					vehicleShop.current = callback
				end
			end, false, false)
		end
	end,
	options = {}
}, function(_, _, args)
	if not isPD() then return end
	if args then 
		if args.action == 'garage' then 
			RemoveVehicle()

			Zen.Streaming.SpawnVehicle(args.model, Police.Station[5].spawn, Police.Station[5].spawn.w, function(callback)
				lib.setVehicleProperties(callback, args.properties)

				SetVehicleModKit(callback, 0)
				SetVehicleLivery(callback, args.livery)
				
				TaskWarpPedIntoVehicle(cache.ped, callback, -1)
			end, true, cache.serverId)
		elseif args.action == 'shop' then 
			
			local alert = lib.alertDialog({
				header = 'Purchase Helicopter',
				content = '',
				centered = true,
				cancel = true
			})

			if alert ~= 'confirm' then 
				return RemoveVehicle()
			end

			local plate = Zen.Functions.GeneratePlate()
			local props = lib.getVehicleProperties(vehicleShop.current)
			props.plate = plate
			local success = lib.callback.await('police:vehicles:buy', false, props, 'helicopter', args.price, args.label)
	
			RemoveVehicle()

			if not success then 
				return Zen.Functions.Notify('Cant Afford This Vehicle!', 'dollar', '#FF0000')
			end
		end
	end
end)

lib.registerMenu({
	id = 'police-helicopters',
	title = 'Police Helicopters',
	position = 'bottom-right',
	options = {
		{ label = 'Open Garage' },
		{ label = 'Purchase Helicopter' }
	}
}, function(selected, _, args)
	if not isPD() then return end

	if selected == 1 then 
		local helicopters = lib.callback.await('garages:get', false, 'police', 'helicopter')
		local myVehicles = {}

		if table.type(helicopters) == 'empty' then 
			return Zen.Functions.Notify('You Dont Own Any Helicopters!', 'car', '#FF0000')
		end

		for i = 1, #helicopters do 
			local properties = Zen.Streaming.GetProperties(helicopters[i].plate)

			myVehicles[#myVehicles+1] = {
				icon = 'car',
				label = helicopters[i].plate..' | '..helicopters[i].label,
				args = {
					action = 'garage',
					name = helicopters[i].label,
					model = properties.model,
					plate = helicopters[i].plate,
					properties = properties,
					livery = 0
				}
			}
		end

		lib.setMenuOptions('police-helicopters-view', myVehicles)
		lib.showMenu('police-helicopters-view')

	elseif selected == 2 then
		local shopVehicles = {}

		for i = 1, #Police.Helicopters do 
			for j = 1, #Police.Helicopters[i].ranks do 
				if stateBag.job.grade_name == Police.Helicopters[i].ranks[j] then 
					local vehicle = Police.Helicopters[i]
					shopVehicles[#shopVehicles+1] = {
						icon = 'helicopter',
						label = vehicle.label..' - $'..Zen.Functions.FormatCommas(vehicle.price),
						args = { 
							action = 'shop',
							label = vehicle.label,
							model = vehicle.model,
							price = vehicle.price,
							livery = 0
						}
					}
				end
			end
		end

		if table.type(shopVehicles) == 'empty' then 
			return Zen.Functions.Notify('Cant Purchase Any Helicopters!', 'helicopter', '#FF0000')
		end

		lib.setMenuOptions('police-helicopters-view', shopVehicles)
		lib.showMenu('police-helicopters-view')
	end
end)


RegisterNetEvent('playerLoaded', function()
	plyUncuff()

	for k,v in pairs(Police.Items) do 
		itemsTable[#itemsTable+1] = {
			close = false,
			label = Zen.Items[v.item].label, 
			args = { label = Zen.Items[v.item].label, item = v.item, price = v.price, ranks = v.ranks },
			values = {}
		}

		for i = 1, 100 do
			local price = v.price * i

			itemsTable[#itemsTable].values[#itemsTable[#itemsTable].values+1] = {
				label = '$'..Zen.Functions.FormatCommas(price)
			}
		end
	end
end)

for i = 1, #Police.Station do 
	local point = lib.points.new(Police.Station[i].coords, Police.MarkerDistance, {
		coords = Police.Station[i].coords,
		text = '[E] - '..Police.Station[i].label,
		menu = Police.Station[i].menu
	})

	function point:onExit()
		if self.menu == 'armory' or self.menu == 'evidence' then 
			lib.hideMenu()
		end
	end
	
	function point:nearby()
		if not isPD() then return end

		if self.currentDistance < 1 and IsControlJustReleased(0, 38) then
			if self.menu == 'boss' then 
				if stateBag.job.grade_name == 'boss' then 
					TriggerEvent('esx_society:openBossMenu', 'police', function(data, menu) end, { wash = false })
				end
			elseif self.menu == 'evidence' then 
				if stateBag.job.grade_name == 'boss' then 
					lib.showMenu('police-'..self.menu)
				end
			else
				lib.showMenu('police-'..self.menu)
			end
		end

		if self.menu == 'boss' or self.menu == 'evidence' then 
			if stateBag.job.grade_name == 'boss' then 
				Zen.Functions.FloatText(self.coords, self.text)
			end
		else
			Zen.Functions.FloatText(self.coords, self.text)
		end
	end
end

Zen.Functions.CreateBlip(Police.Blip.Coords, Police.Blip)

RegisterNetEvent('police:interaction:citizen:handcuff', function()
	if not PolicePlayerData.Escorted and not PolicePlayerData.VehicleEscort then 
		PolicePlayerData.Cuffed = not PolicePlayerData.Cuffed
		if PolicePlayerData.Cuffed then
			RequestAnimDict('mp_arresting')
			while not HasAnimDictLoaded('mp_arresting') do
				Citizen.Wait(100)
			end
			
			TaskPlayAnim(cache.ped, 'mp_arresting', 'idle', 8.0, -8, -1, 49, 0, 0, 0, 0)
			SetEnableHandcuffs(cache.ped, true)
			DisablePlayerFiring(cache.ped, true)
			SetCurrentPedWeapon(cache.ped, GetHashKey('WEAPON_UNARMED'), true)
			SetPedCanPlayGestureAnims(cache.ped, false)
			FreezeEntityPosition(cache.ped, true)
			DisplayRadar(false)
			CreateThread(plyCuffed)

			SetTimeout(Police.CuffAutoRelease * 60000, function()
				plyUncuff()
			end)
		else
			ClearPedSecondaryTask(cache.ped)
			SetEnableHandcuffs(cache.ped, false)
			DisablePlayerFiring(cache.ped, false)
			SetPedCanPlayGestureAnims(cache.ped, true)
			FreezeEntityPosition(cache.ped, false)
			DisplayRadar(true)
		end
	end
end)

RegisterNetEvent('police:interaction:citizen:escort', function(escorter)
	if PolicePlayerData.Cuffed and not PolicePlayerData.VehicleEscort then
		PolicePlayerData.Escorted = not PolicePlayerData.Escorted
		plyEscorted(escorter)
	end
end)

RegisterNetEvent('police:interaction:citizen:vehicle', function()
	if PolicePlayerData.Cuffed then
		if not PolicePlayerData.VehicleEscort then 
			local vehicle = lib.getClosestVehicle(cache.coords, 5.0, false)

			if DoesEntityExist(vehicle) then
				local maxSeats, freeSeat = GetVehicleMaxNumberOfPassengers(vehicle)
				for i = maxSeats - 1, 0, -1 do
					if IsVehicleSeatFree(vehicle, i) then
						freeSeat = i
						break
					end
				end

				if freeSeat then
					TaskWarpPedIntoVehicle(cache.ped, vehicle, freeSeat)
					PolicePlayerData.VehicleEscort = true
					PolicePlayerData.Escorted = false
				end
			end
		else
			PolicePlayerData.VehicleEscort = false
			if IsPedSittingInAnyVehicle(cache.ped) then
				TaskLeaveVehicle(cache.ped, cache.vehicle, 16)
			end
		end
	end
end)