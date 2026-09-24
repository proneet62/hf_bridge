Bridge = {}
Bridge.Framework = nil
Bridge.Inventory = nil
Bridge.Ready = false

function Bridge.Init()
    -- フレームワーク検出
    if GetResourceState('qb-core') == 'started' then
        Bridge.Framework = exports['qb-core']:GetCoreObject()
        Bridge.FrameworkName = 'qbcore'
        if Config.Debug then print('[Bridge] QB-Core が検出されました') end
    elseif GetResourceState('es_extended') == 'started' then
        Bridge.Framework = exports['es_extended']:getSharedObject()
        Bridge.FrameworkName = 'esx'
        if Config.Debug then print('[Bridge] ESX が検出されました') end
    else
        Bridge.FrameworkName = 'standalone'
        if Config.Debug then print('[Bridge] フレームワークが検出されませんでした (スタンドアロンモード)') end
    end

    -- インベントリシステム検出
    if GetResourceState('ox_inventory') == 'started' then
        Bridge.Inventory = 'ox_inventory'
        if Config.Debug then print('[Bridge] ox_inventory が検出されました') end
    elseif GetResourceState('qb-inventory') == 'started' then
        Bridge.Inventory = 'qb-inventory'
        if Config.Debug then print('[Bridge] qb-inventory が検出されました') end
    elseif GetResourceState('qs-inventory') == 'started' then
        Bridge.Inventory = 'qs-inventory'
        if Config.Debug then print('[Bridge] qs-inventory が検出されました') end
    else
        if Config.Debug then print('[Bridge] インベントリシステムが検出されませんでした') end
    end

    Bridge.Ready = true
    if Config.Debug then print('[Bridge] 初期化完了') end
end

-- Configのバリデーション
function Bridge.ValidateConfig()
    if not Config or not Config.DefaultSettings then
        print('[Bridge] WARNING: Config が見つかりません。デフォルト設定を使用します。')
        Config = {
            DefaultSettings = {
                notify = "standalone",
                textui = "standalone"
            }
        }
    end
end

-- 初期化を待つ関数
function Bridge.WaitForReady()
    while not Bridge.Ready do
        Wait(100)
    end
end

-- 初期化実行（同期的に行う）
Bridge.ValidateConfig()
Bridge.Init()

-- エクスポート（サーバーとクライアント共通）
if IsDuplicityVersion() then
    -- Server側
    exports('GetBridge', function()
        return Bridge
    end)
else
    -- Client側
    exports('GetBridge', function()
        return Bridge
    end)
end
