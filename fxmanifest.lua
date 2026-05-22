fx_version 'cerulean'
game 'gta5'

author 'R1 Scripts'
description 'R1 Personal Menu - Información, ropa, vehículo, radio, reload skin y utilidades'
version '1.0.0'

lua54 'yes'

shared_scripts {
    '@ox_lib/init.lua',
    'shared/config.lua',
    'shared/locales.lua'
}

client_scripts {
    'client/main.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

ui_page 'html/index.html'

files {
    'sql.sql',
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'shared/locales.lua',
    'html/img/default_photo.png',
    'html/icons/*.svg'
}
