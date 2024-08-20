local chatInputActive = false
local chatInputActivating = false
local chatHidden = true
local chatLoaded = false
local chatVisibilityToggle = false

RegisterNetEvent('chatMessage')
RegisterNetEvent('chat:addTemplate')
RegisterNetEvent('chat:addMessage')
RegisterNetEvent('chat:addSuggestion')
RegisterNetEvent('chat:addSuggestions')
RegisterNetEvent('chat:removeSuggestion')
RegisterNetEvent('chat:clear')
RegisterNetEvent('chat:toggleChat')
RegisterNetEvent('__cfx_internal:serverPrint')
RegisterNetEvent('_chat:messageEntered')
AddEventHandler('chatMessage', function(author, color, text)
	local args = { text }
	if author ~= "" then
		table.insert(args, 1, author)
	end
	if(not chatVisibilityToggle)then
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = {
				color = color,
				multiline = true,
				args = args
			}
		})
	end
end)
AddEventHandler('__cfx_internal:serverPrint', function(msg)
	if(not chatVisibilityToggle)then
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = {
				color = { 0, 0, 0 },
				multiline = true,
				args = { msg }
			}
		})
	end
end)
AddEventHandler('chat:addMessage', function(message)
	if(not chatVisibilityToggle)then
		SendNUIMessage({
			type = 'ON_MESSAGE',
			message = message
		})
	end
end)
AddEventHandler('chat:addSuggestion', function(name, help, params)
	SendNUIMessage({
		type = 'ON_SUGGESTION_ADD',
		suggestion = {
			name = name,
			help = help,
			params = params or nil
		}
	})
end)
AddEventHandler('chat:addSuggestions', function(suggestions)
	for _, suggestion in ipairs(suggestions) do
		SendNUIMessage({
			type = 'ON_SUGGESTION_ADD',
			suggestion = suggestion
		})
	end
end)
AddEventHandler('chat:toggleChat',function()
	chatVisibilityToggle = not chatVisibilityToggle
	local state = (chatVisibilityToggle == true) and "^1disabled" or "^2enabled"
	SendNUIMessage({
		type = 'ON_MESSAGE',
		message = {
				color = {255,255,255},
				multiline = true,
				args = {"Chat Visibility has been "..state}
			}
		})
end)
RegisterCommand("togglechat",function()
	TriggerEvent('chat:toggleChat')
end)

RegisterCommand("clear",function()
	TriggerEvent('chat:clear')
end)

AddEventHandler('chat:removeSuggestion', function(name)
	SendNUIMessage({
		type = 'ON_SUGGESTION_REMOVE',
		name = name
	})
end)

AddEventHandler('chat:addTemplate', function(id, html)
	SendNUIMessage({
		type = 'ON_TEMPLATE_ADD',
		template = {
			id = id,
			html = html
		}
	})
end)

AddEventHandler('chat:clear', function(name)
	SendNUIMessage({
		type = 'ON_CLEAR'
	})
end)

RegisterNUICallback('chatResult', function(data, cb)
	chatInputActive = false
	SetNuiFocus(false)
	if not data.canceled then
		local id = PlayerId()
		local r, g, b = 0, 0x99, 255
		if data.message:sub(1, 1) == '/' then
			ExecuteCommand(data.message:sub(2))
		else
			TriggerServerEvent('_chat:messageEntered', GetPlayerName(id), { r, g, b }, data.message)
		end
	end
	cb('ok')
end)

local function refreshCommands()
	if GetRegisteredCommands then
		local registeredCommands = GetRegisteredCommands()
		local suggestions = {}
		for _, command in ipairs(registeredCommands) do
				if IsAceAllowed(('command.%s'):format(command.name)) then
						table.insert(suggestions, {
								name = '/' .. command.name,
								help = ''
						})
				end
		end
		TriggerEvent('chat:addSuggestions', suggestions)
	end
end
local function refreshThemes()
	local themes = {}
	for resIdx = 0, GetNumResources() - 1 do
		local resource = GetResourceByFindIndex(resIdx)
		if GetResourceState(resource) == 'started' then
			local numThemes = GetNumResourceMetadata(resource, 'chat_theme')
			if numThemes > 0 then
				local themeName = GetResourceMetadata(resource, 'chat_theme')
				local themeData = json.decode(GetResourceMetadata(resource, 'chat_theme_extra') or 'null')
				if themeName and themeData then
					themeData.baseUrl = 'nui://' .. resource .. '/'
					themes[themeName] = themeData
				end
			end
		end
	end
	SendNUIMessage({
		type = 'ON_UPDATE_THEMES',
		themes = themes
	})
end
AddEventHandler('onClientResourceStart', function(resName)
	Wait(500)
	refreshCommands()
	refreshThemes()
end)
AddEventHandler('onClientResourceStop', function(resName)
	Wait(500)
	refreshCommands()
	refreshThemes()
end)
RegisterNUICallback('loaded', function(data, cb)
	TriggerServerEvent('chat:init');
	refreshCommands()
	refreshThemes()
	chatLoaded = true
	cb('ok')
end)

Citizen.CreateThread(function()
	SetTextChatEnabled(false)
	SetNuiFocus(false)
	
	local function keybind(name, key, cb)
		RegisterCommand("+" .. name, function()
			cb()
		end)
		RegisterCommand("-" .. name, function()
			cb()
		end)
		RegisterKeyMapping("+" .. name, name, 'keyboard', key)
	end

	keybind("chatOpen", "t", function()
		if not chatInputActive then
			if IsControlPressed(0, 245) --[[ INPUT_MP_TEXT_CHAT_ALL ]] then
				chatInputActive = true
				chatInputActivating = true

				SendNUIMessage(
					{
						type = "ON_OPEN"
					}
				)
			end
		end
	end)
		
	while true do
		Citizen.Wait(250)
		if chatLoaded then
			local shouldBeHidden = false
			
			if (shouldBeHidden and not chatHidden) or (not shouldBeHidden and chatHidden) then
				chatHidden = shouldBeHidden
				SendNUIMessage(
					{
						type = "ON_SCREEN_STATE_CHANGE",
						shouldHide = shouldBeHidden
					}
				)
			end
			if chatInputActivating then
				if not IsControlPressed(0, 245) then
					SetNuiFocus(true)
					chatInputActivating = false
				end
			end
		else
			Citizen.Wait(500)
		end
	end
end)
