


fx_version 'cerulean'
game 'gta5'

author 'DiVouz'
description 'Mechanic | lualua.tebex.io'
version '1.1.3'

lua54 'on'

ui_page 'client/ui/index.html'
files {
	'client/ui/index.html',
	'client/ui/js/**/*.js',
	'client/ui/css/**/*.css',
	'client/ui/img/**/*.png',
	'client/ui/sounds/**/*.ogg'
}

client_scripts {
	'@ox_lib/init.lua',
	'config/core.lua',
	'config/prices.lua',
	
	'config/client_functions.lua',
	
	'client/menus.lua',
	'client/labels.lua',
	'client/helper.lua',
	'client/job.lua',
	'client/api.lua',
	'client/core.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua', -- uncomment if you using [mysql-async] and want to auto save vehicle properties (enable `Config.AutoSaveVehiclePropertiesOnApply` in file `config/core.lua`)
	'@ox_lib/init.lua',
	'config/core.lua',

	'config/server_functions.lua',

	'server/version.lua',
	'server/core.lua'
}