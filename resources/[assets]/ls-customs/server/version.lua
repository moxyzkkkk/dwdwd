--[[


    Do NOT CHANGE any of the code in this file,
    
    if you do so, do it on your own risk and no support will be given


]]

if (Config.EnableVersionChecker ~= true) then
    return
end

CreateThread( function()
    PerformHttpRequest('https://divouz.github.io/lua-lua_scripts/esx_mechanic/version', function(err, responseText, headers)
        local curVersion = GetResourceMetadata(GetCurrentResourceName(), 'version', 0)
        
        if (responseText ~= nil and curVersion ~= responseText) then
            print('\n############################################################')
            print('Lua-Lua Scripts [ lualua.tebex.io ]')
            print('[esx_mechanic] is not up to date')
            print('should be: \'' .. responseText .. '\' and it is: \'' .. curVersion .. '\'')
            print('please update it from the Keymaster dashboard [ keymaster.fivem.net ]')
            print('############################################################\n')
        end
    end, 'GET')
end)
