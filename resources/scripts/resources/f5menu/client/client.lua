local F5Menu = Zen.Config.F5Menu
local ChatTag = F5Menu.ChatTagMenu

local function setupTags()
    local chatTagsTable = {}
    local tagHasBeenSet = false

    local roles = lib.callback.await('discord:roles', false)

    if table.type(roles) ~= 'empty' then 
        for i = 1, #ChatTag.Tags do 
            for j = 1, #roles do 
                if tonumber(ChatTag.Tags[i].role) == tonumber(roles[j]) then 
                    if not tagHasBeenSet then
                        local data = json.decode(GetResourceKvpString("currentChatTag"))

                        if data then 
                            stateBag:set('currentChatTag', data, true)
                        else
                            stateBag:set('currentChatTag', ChatTag.Tags[i], true)
                        end
                        
                        tagHasBeenSet = true
                    end

                    chatTagsTable[#chatTagsTable+1] = {
                        icon = 'tag',
                        iconColor = 'rgb('..ChatTag.Tags[i].color..')',
                        label = ChatTag.Tags[i].tag,
                        args = ChatTag.Tags[i]
                    }
                end
            end
        end
    end

    if stateBag.gang then 
        local playerGang = Zen.Config.Gang.Gangs[stateBag.gang]
        if playerGang.tag ~= '' then 
            chatTagsTable[#chatTagsTable+1] = {
                icon = 'tag',
                iconColor = 'rgb('..playerGang.color[1]..', '..playerGang.color[2]..', '..playerGang.color[3]..')',
                label = playerGang.tag,
                args = {
                    tag = playerGang.tag,
                    color = playerGang.color[1]..', '..playerGang.color[2]..', '..playerGang.color[3]
                }
            }
        end
    end

    chatTagsTable[#chatTagsTable+1] = {
        icon = 'tag',
        iconColor = 'rgb('..ChatTag.Default.color..')',
        label = ChatTag.Default.tag,
        args = ChatTag.Default
    }

    if Zen.Functions.IsRolePresent(ChatTag.CustomChatTag.role) then 
        chatTagsTable[#chatTagsTable+1] = {
            icon = 'tags',
            label = 'Custom Chat Tag',
            args = {
                action = 'openCustomTagInput'
            }
        }
    end
    
    lib.setMenuOptions('f5ChatTagMenu', chatTagsTable)
end

lib.registerMenu({
    id = 'f5ChatTagMenu',
    title = 'F5 ChatTag Menu',
    position = 'bottom-right',
    options = {},
    onClose = function(keyPressed) 
        lib.showMenu('f5Menu')
    end,   
}, function(selected, scrollIndex, args)
    if args.action and args.action == 'openCustomTagInput' then 
        local input = lib.inputDialog('HUD COLOR', { 
            { type = 'input', label = 'Chat Tag Name', required = true,  min = ChatTag.CustomChatTag.tag.min, max = ChatTag.CustomChatTag.tag.max},
            { type = 'color', label = 'Chat Tag Color', required = true } ,
        })

        if not input then return end

        local inputWords = {}

        for word in input[1]:gmatch("%S+") do 
            inputWords[#inputWords+1] = word
        end

        for i = 1, #ChatTag.CustomChatTag.blacklisted do 
            if string.match(string.lower(table.concat(inputWords, " ")), string.lower(ChatTag.CustomChatTag.blacklisted[i])) then
                return Zen.Functions.Notify('The Tag You Tried Using Is Blacklisted!!')
            end
        end

        for i = 1, #Zen.Config.Server.BlacklistedWords do 
            if string.match(string.lower(table.concat(inputWords, " ")), string.lower(Zen.Config.Server.BlacklistedWords[i])) then
                return Zen.Functions.Notify('The Tag You Tried Using Is Blacklisted!!')
            end
        end

        for i = 1, #ChatTag.Tags do 
            if string.match(string.lower(table.concat(inputWords, " ")), string.lower(ChatTag.Tags[i].tag)) then
                return Zen.Functions.Notify('The Tag You Tried Using Is Already Being Used!!')
            end
        end
        
        local inputColor = Zen.Functions.HexToRGB(input[2])
        local chatTag = {
            tag = input[1],
            color = inputColor.r..', '..inputColor.g..', '..inputColor.b,
        }

        stateBag:set('currentChatTag', chatTag, true)
        SetResourceKvp("currentChatTag", json.encode(chatTag))
    else
        stateBag:set('currentChatTag', args, true)
        SetResourceKvp("currentChatTag", json.encode(args))
    end
end)

lib.registerMenu({
    id = 'f5Menu',
    title = 'F5 Menu',
    position = 'bottom-right',
    options = F5Menu.MainMenu
}, function(selected, scrollIndex, args)
    if args and args.menu then 
        if args.role then 
            if Zen.Functions.IsRolePresent(args.role) then
                lib.showMenu(args.menu)
            else
                Zen.Functions.Notify('You Don\'t Have Access To This Menu!', 'x', '#FF0000')
            end
        else
            if args.menu == 'f5ChatTagMenu' then 
                setupTags()
            elseif args.menu == 'f5CustomColors' then 
                return ExecuteCommand('colors')
            end

            lib.showMenu(args.menu)
        end
    end
end)

local weatherTable = { { icon = 'cloud', label = 'Weather', close = false, args = { action = 'changeWeather' }, values = { { label = 'Extra Sunny', value = 'EXTRASUNNY'}, { label = 'Clear',  value = 'CLEAR' }, { label = 'Neutral', value = 'NEUTRAL' }, { label = 'Smog', value = 'SMOG' }, { label = 'Foggy', value = 'FOGGY' }, { label = 'Overcast', value = 'OVERCAST' }, { label = 'Clouds', value = 'CLOUDS' }, { label = 'Clearing', value = 'CLEARING' }, { label = 'Rain', value = 'RAIN' }, { label = 'Thunder', value = 'THUNDER' }, { label = 'Snow', value = 'SNOW' }, { label = 'Blizzard', value = 'BLIZZARD' }, { label = 'Light Snow', value = 'SNOWLIGHT' }, { label = 'Xmas', value = 'XMAS'} } }, { icon = 'clock', label = 'Time', close = false, args = { action  = 'changeTime' }, values = { { label = '12 PM', value = '12' }, { label = '1 PM', value = '13' }, { label = '2 PM', value = '14' }, { label = '3 PM', value = '15' }, { label = '4 PM', value = '16' }, { label = '5 PM', value = '17' }, { label = '6 PM', value = '18' }, { label = '7 PM', value = '19' }, { label = '8 PM', value = '20' }, { label = '9 PM', value = '21' }, { label = '10 PM', value = '22' }, { label = '11 PM', value = '23' }, { label = '12 AM', value = '0' }, { label = '1 AM', value = '1' }, { label = '2 AM', value = '2' }, { label = '3 AM', value = '3' }, { label = '4 AM', value = '4' }, { label = '5 AM', value = '5' }, { label = '6 AM', value = '6' }, { label = '7 AM', value = '7' }, { label = '8 AM', value = '8' }, { label = '9 AM', value = '9' }, { label = '10 AM', value = '10' }, { label = '11 AM', value = '11' }, } }, }

lib.registerMenu({
    id = 'f5WeatherMenu',
    title = 'F5 Weather Menu',
    position = 'bottom-right',
    options = weatherTable,
    onClose = function(keyPressed) 
        lib.showMenu('f5Menu')
    end,   
}, function(selected, scrollIndex, args)
    local selection = weatherTable[selected].values[scrollIndex].value

    if args and args.action then 
        if args.action == 'changeWeather' then 
            ClearOverrideWeather() 
            ClearWeatherTypePersist() 
            SetWeatherTypePersist(selection) 
            SetWeatherTypeNow(selection) 
            SetWeatherTypeNowPersist(selection)
        elseif args.action == 'changeTime' then
            NetworkOverrideClockTime(tonumber(selection), 0, 0)
        end
    end
end)

lib.registerMenu({ 
    id = 'f5PedMenu', 
    title = 'Ped Menu', 
    position = 'bottom-right', 
    options = {}, 
    onClose = function(keyPressed) 
        if keyPressed then 
            lib.showMenu('f5Menu') 
        end 
    end,
}, function(selected, scrollIndex, args) 
    if args.role then 
        if Zen.Functions.IsRolePresent(args.role) then 
            local ped = args.peds[scrollIndex][2]
            if ped then 
                if not playerDead then
                    if IsModelValid(ped) and IsModelAPed(ped) then
                        RequestModel(ped)
                        while not HasModelLoaded(ped) do
                            Wait(1)
                        end
                        SetPlayerModel(PlayerId(), ped)
                        SetModelAsNoLongerNeeded(ped)
                    end
                else
                    Zen.Functions.Notify('Cannot Switch Peds While You Are Dead!!', 'user', '#FF0000')
                end
            end
        else
            Zen.Functions.Notify('You Do Not Have Access To This Ped!', 'x', '#FF0000')
            lib.hideMenu()
        end
    elseif args.action then 
        ExecuteCommand(args.action)
    end
end)

CreateThread(function()
    local pedsmenuTable = {}

    for i = 1, #F5Menu.PedMenu do 
        pedsmenuTable[#pedsmenuTable+1] = { 
            icon = 'user',
            label = F5Menu.PedMenu[i].label,
            close = false,
            values = {},
            args = {
                role = F5Menu.PedMenu[i].role,
                peds = F5Menu.PedMenu[i].options
            },
        }

        local currentTable = {}
        for j = 1, #F5Menu.PedMenu[i].options do 
            pedsmenuTable[#pedsmenuTable].values[#pedsmenuTable[#pedsmenuTable].values+1] = { 
                label = F5Menu.PedMenu[i].options[j][1], 
            }
        end
    end

    pedsmenuTable[#pedsmenuTable+1] = {  icon = 'user-xmark', label='Restore Ped',  close = false, args = { action='reloadskin' } }

    lib.setMenuOptions('f5PedMenu', pedsmenuTable)

    setupTags()
end)

lib.addKeybind({
    name = 'f5Menu',
    description = 'Open F5 Menu',
    defaultKey = 'F5',
    onReleased = function(self)
        if lib.getOpenMenu() == 'f5Menu' then return end
        if not playerDead then
            lib.showMenu('f5Menu')
        end
    end
})