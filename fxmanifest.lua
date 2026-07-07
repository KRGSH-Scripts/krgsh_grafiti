fx_version 'cerulean'
game 'gta5'

name 'graffiti_tags'
version '0.1.0-wip'
description 'AI-Generated Graffiti Tags - Work in Progress'

author 'KRGSH-Scripts (AI-Slop)'

lua54 'yes'

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/style.css',
    'html/script.js',
    'html/graffiti.html',
    'html/images/**'
}

client_scripts {
    'shared/config.lua',
    'shared/framework.lua',
    'client/main.lua'
}

server_scripts {
    'shared/config.lua',
    'shared/framework.lua',
    '@mysql-async/lib/MySQL.lua',
    '@oxmysql/lib/MySQL.lua',
    'server/main.lua'
}

dependencies {
    'mysql-async',
    'oxmysql'
}