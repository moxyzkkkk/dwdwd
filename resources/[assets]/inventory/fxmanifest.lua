fx_version 'cerulean'
game 'gta5' lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua'
    , 'config.lua'
}
client_script 'client.lua'

ui_page( 'html/index.html' )

files {
    'html/*.otf'
    , 'html/styles.css'
    , 'html/script.js'
    , 'html/img/*.png'
	, 'html/index.html'
}

dependency 'scripts'

escrow_ignore {
    'config.lua'
}