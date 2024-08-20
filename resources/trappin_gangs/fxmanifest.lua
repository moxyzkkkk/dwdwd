shared_script '@trappin_headshots/shared_fg-obfuscated.lua'
shared_script '@trappin_headshots/ai_module_fg-obfuscated.lua'
shared_script '@trappin_headshots/ai_module_fg-obfuscated.js'
fx_version 'cerulean'
name 'TRP Gang System'
author 'Bong <3'
game 'gta5'
lua54 'yes'
description 'Gang system for TRP'
shared_scripts {
    '@ox_lib/init.lua',
    'package.config.lua'
}
server_scripts {
    
    'dist/server/**/*.js',
    '@oxmysql/lib/MySQL.lua',
    'lua/server/main.lua',
    'lua/server/*.lua',
}
client_script {
    'lua/main.lua',
    'lua/helpers/*.lua',
    'lua/gamemode/*.lua',
    'lua/ui/*.lua',
}
ui_page 'html/build/index.html'
files {
    'html/build/index.html',
    'html/build/**/*',
}

ox_libs {
    'callback',
    'interface',
    'zones',
    'table',
    'points',
}