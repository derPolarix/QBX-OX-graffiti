fx_version 'cerulean'
game 'gta5'

author 'Kalajiqta - Matrix Development, JP5M Scripts'
description 'QBCore/OX Graffiti'
version '1.0'

data_file 'DLC_ITYP_REQUEST' 'stream/spray_propsfw.ytyp'

shared_scripts {
    '@qb-core/shared/locale.lua',
    '@ox_lib/init.lua',
    'locales/en.lua',
    'config.lua'
}

client_scripts {
    'client/client_main.lua',
    'client/client_functions.lua'
}

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    'server/server_main.lua',
    'server/server_functions.lua'
}

dependencies {
    'ox_lib'
}

lua54 'yes'