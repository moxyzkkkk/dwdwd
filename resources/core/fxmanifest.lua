fx_version 'cerulean'

game 'gta5'
description 'ES Extended'
lua54 'yes'
version '1.10.2'

shared_scripts {
	'@ox_lib/init.lua',
	'locale.lua',
	'locales/*.lua',
	'config.lua',
	'config.weapons.lua',
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'config.logs.lua',
	'server/common.lua',
	'server/modules/callback.lua',
	'server/classes/player.lua',
	'server/classes/overrides/*.lua',
	'server/functions.lua',
	'server/onesync.lua',
	'server/paycheck.lua',

	'server/main.lua',
	'server/commands.lua',

	'common/modules/*.lua',
	'common/functions.lua',
	'server/modules/actions.lua',
	'server/modules/npwd.lua'
}

client_scripts {
	'client/common.lua',
	'client/functions.lua',
	'client/wrapper.lua',
	'client/modules/callback.lua',

	'client/main.lua',

	'common/modules/*.lua',
	'common/functions.lua',

	'common/functions.lua',
	'client/modules/actions.lua',
	'client/modules/death.lua',
	'client/modules/npwd.lua',
	'client/modules/scaleform.lua',
	'client/modules/streaming.lua',
}

files {
	'imports.lua',
	'locale.js',
}

dependencies {
	'/native:0x6AE51D4B',
	'oxmysql',
}
