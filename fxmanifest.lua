fx_version 'cerulean'
game 'gta5'

author 'Your Team'
description 'FiveM Universal Bridge System - QB-Core, ESX, QBox対応'
version '2.1.1'
lua54 'yes'

-- Shared (両方で使う)
shared_scripts {
    '@ox_lib/init.lua', -- ox_lib を使う場合
    'shared/config.lua',
    'shared/locales.lua',
    'shared/main.lua',
    'shared/utils.lua',
}

-- Server側
server_scripts {
    '@oxmysql/lib/MySQL.lua', -- MySQL を使う場合
    'server/modules/callback.lua',
    'server/modules/player.lua',
    'server/modules/money.lua',
    'server/modules/inventory.lua',
    'server/modules/logger.lua',
    'server/modules/stash.lua',
    'server/modules/society.lua',
    'server/modules/vehicle_extras.lua',
}

-- Client側
client_scripts {
    'client/modules/callback.lua',
    'client/modules/notify.lua',
    'client/modules/inventory.lua',
    'client/modules/vehicles.lua',
    'client/modules/draw.lua',
    'client/modules/utils.lua',
    'client/modules/target.lua',
    'client/modules/progressbar.lua',
    'client/modules/input.lua',
    'client/modules/stash.lua',
    'client/modules/vehicle_extras.lua',
}

-- 依存関係
dependencies {
    '/server:5848',  -- 最小サーバーバージョン
    '/onesync',      -- OneSync推奨
    'ox_lib',
    'oxmysql',
    'qb-core',
}

-- エクスポート
server_exports {
    'GetBridge'
}

client_exports {
    'GetBridge'
}
