local Config = Zen.Config.Chat

RegisterServerEvent('chat:init')
RegisterServerEvent('chat:addTemplate')
RegisterServerEvent('chat:addMessage')
RegisterServerEvent('chat:addSuggestion')
RegisterServerEvent('chat:removeSuggestion')
RegisterServerEvent('_chat:messageEntered')
RegisterServerEvent('chat:clear')
RegisterServerEvent('__cfx_internal:commandFallback')

AddEventHandler('_chat:messageEntered', function(author, color, message)
    if not message or not author then return end
    TriggerEvent('chatMessage', source, author, message)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, author,  { 255, 255, 255 }, message)
    end
end)

AddEventHandler('__cfx_internal:commandFallback', function(command)
    local name = GetPlayerName(source)

    TriggerEvent('chatMessage', source, name, '/' .. command)

    if not WasEventCanceled() then
        TriggerClientEvent('chatMessage', -1, name, { 255, 255, 255 }, '/' .. command) 
    end

    CancelEvent()
end)

AddEventHandler('playerJoining', function(source)
    Config.ChatMessages.OnJoin({ name = GetPlayerName(source), server = Zen.Config.Server.ServerName })
end)

local function refreshCommands(player)
    if GetRegisteredCommands then
        local registeredCommands = GetRegisteredCommands()

        local suggestions = {}

        for _, command in ipairs(registeredCommands) do
            if IsPlayerAceAllowed(player, ('command.%s'):format(command.name)) then
                table.insert(suggestions, {
                    name = '/' .. command.name,
                    help = ''
                })
            end
        end

        TriggerClientEvent('chat:addSuggestions', player, suggestions)
    end
end

AddEventHandler('chat:init', function()
    local source = source
    refreshCommands(source)
end)

function stringsplit(inputstr, sep)
    if sep == nil then sep = "%s" end
    local t={} ; i=1
    for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
        t[i] = str
        i = i + 1
    end
    return t
end

local ChatAntiSpam = {}

local function DontSend(player, args)
    local run = false
    local currentTime = os.time()

    if (not ChatAntiSpam[player] or currentTime - ChatAntiSpam[player] >= Config.AntiSpam) then 
        ChatAntiSpam[player] = currentTime
        run = true
    end

    if (not run) then
        local remainingTime = Config.AntiSpam - (currentTime - ChatAntiSpam[player])
        TriggerClientEvent("showNotification", player, "You Must Wait " .. remainingTime .. " Seconds.", 'clock', '#FF0000')
    else
        local message = table.concat(args, " ")

        for _, blacklistedWord in pairs(Zen.Config.Server.BlacklistedWords) do
            if string.match(message, blacklistedWord) then
                TriggerClientEvent("showNotification", player, "You Used A Blacklisted Word Kid...", 'ban', '#FF0000')
                return true
            end
        end

        if (string.len(message) > Config.MaxCharacters) then
            TriggerClientEvent("showNotification", player, "Message is too long...", 'xmark', '#FF0000')
            return true
        end
    end

    return not run
end

local function AllowedChatTag(source, CT)
    local ChatTagMenu = Zen.Config.F5Menu.ChatTagMenu
    local CustomTag = ChatTagMenu.CustomChatTag.tag

    if CT.tag == ChatTagMenu.Default.tag then 
        return true
    end

    local tag = stringsplit(CT.tag)

    for i = 1, #Zen.Config.Server.BlacklistedWords do 
        if string.match(string.lower(table.concat(tag, " ")), string.lower(Zen.Config.Server.BlacklistedWords[i])) then
            return false
        end
    end

    return true
end

AddEventHandler('chatMessage', function(source, name, msg)
	CancelEvent()
	
	local message = stringsplit(msg)
	if DontSend(source, message) then return CancelEvent() end
	
	if not string.find(message[1], "/") then
		local CT = Player(source).state.currentChatTag or Zen.Config.F5Menu.ChatTagMenu.Default

        if not AllowedChatTag(source, CT) then return CancelEvent() end

        Config.ChatMessages.Message({
            avatar = Zen.Functions.Discord.Data(source).avatar,
            tag = '['..source..'] <text style="color: rgb('..CT.color..')"> '..CT.tag..'</text> | '..GetPlayerName(source),
            message = msg
        })
	end
end)

for i = 1, #Config.Commands.Twitter do
    RegisterCommand(Config.Commands.Twitter[i], function(source, args, rawCommand)
        if DontSend(source, args) then return CancelEvent() end
        Config.ChatMessages.Twitter({player = "["..source.."] - "..GetPlayerName(source), message = table.concat(args, " ")})
    end)
end

for i = 1, #Config.Commands.Advertisment do
    RegisterCommand(Config.Commands.Advertisment[i], function(source, args, rawCommand)
        if DontSend(source, args) then return CancelEvent() end
        Config.ChatMessages.Advertisment({player = "["..source.."] - "..GetPlayerName(source), message = table.concat(args, " ")})
    end)
end