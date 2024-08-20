fx_version 'cerulean'
game 'gta5' lua54 'yes'

version '2.0.8'
author 'discord.gg/imaskid'

shared_scripts {
    '@core/imports.lua'
    , '@ox_lib/init.lua'
    , 'utilities/shared/*.lua'
    , 'config.lua'
    , 'resources/**/config.lua'
}

client_scripts { 
    'utilities/client/*.lua'
    , 'resources/**/client/*.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua'
    , 'sconfig.lua'
    , 'resources/**/sconfig.lua'
    , 'utilities/server/*.lua'
    , 'resources/**/server/*.lua'
}

ui_page 'web/build/index.html'

files {
    'web/build/index.html'
    , 'web/build/assets/*.ttf'
    , 'web/build/assets/*.otf'
    , 'web/build/assets/*.css'
    , 'web/build/assets/*.js'
}

escrow_ignore {
    'config.lua'
    , 'sconfig.lua'
    , 'resources/**/config.lua'
    , 'utilities/shared/*.lua'
    , 'resources/**/config.lua'
    , 'resources/**/sconfig.lua'
}