fx_version 'adamant'

game 'gta5'

description 'MasterkinG32 Radio codes'

version '1.0.0'

ui_page 'client/index.html'

client_scripts {
	'client/*.lua'
}
server_scripts {
	'server/server.lua',
	'server/masterking32_loader.lua'
}

files {
	'client/*',
	'client/images/*'
}

dependency 'es_extended'
