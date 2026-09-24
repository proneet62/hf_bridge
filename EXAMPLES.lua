--=========================================================================================================
--                                    使用例サンプル
--=========================================================================================================

-- このファイルは Bridge システムの使用例を示すサンプルコードです
-- 実際のリソースで使用する場合は、このコードを参考にしてください

--=========================================================================================================
-- SERVER SIDE EXAMPLES
--=========================================================================================================

if IsDuplicityVersion() then
    
    -- ========== Callbackの登録例 ==========
    Bridge.RegisterCallback('example:getPlayerData', function(source, cb)
        local playerName = Bridge.GetPlayerName(source)
        local job, grade = Bridge.GetJob(source)
        local cash = Bridge.GetMoney(source, 'cash')
        local bank = Bridge.GetMoney(source, 'bank')
        
        cb({
            name = playerName,
            job = job,
            grade = grade,
            cash = cash,
            bank = bank
        })
    end)
    
    -- ========== アイテム購入の例 ==========
    RegisterNetEvent('example:buyItem', function(itemName, price)
        local source = source
        
        -- お金をチェック
        if Bridge.GetMoney(source, 'cash') >= price then
            -- お金を削除
            if Bridge.RemoveMoney(source, price, 'cash', 'アイテム購入') then
                -- アイテムを追加
                if Bridge.AddItem(source, itemName, 1) then
                    -- 通知 (クライアント側で表示)
                    TriggerClientEvent('bridge:client:notify', source, '購入完了', 'アイテムを購入しました', 'success')
                    
                    -- ログを記録
                    Bridge.Log(source, 'item_purchase', itemName .. ' を購入しました')
                else
                    -- 失敗時は返金
                    Bridge.AddMoney(source, price, 'cash', '購入失敗による返金')
                    TriggerClientEvent('bridge:client:notify', source, 'エラー', 'アイテムの追加に失敗しました', 'error')
                end
            end
        else
            TriggerClientEvent('bridge:client:notify', source, 'エラー', 'お金が足りません', 'error')
        end
    end)
    
    -- ========== 車両購入の例 ==========
    RegisterNetEvent('example:purchaseVehicle', function(model, price)
        local source = source
        local playerName = Bridge.GetPlayerName(source)
        local identifier = Bridge.GetIdentifier(source)
        
        -- 銀行残高をチェック
        if Bridge.GetBankMoney(source) >= price then
            if Bridge.RemoveBankMoney(source, price, '車両購入: ' .. model) then
                -- 車両をデータベースに追加 (実際の実装では適切なDB操作が必要)
                -- ...
                
                -- Discord ログ
                Bridge.LogPlayerAction(source, 'YOUR_WEBHOOK_URL', '車両購入', {
                    {name = '車両モデル', value = model, inline = true},
                    {name = '価格', value = '$' .. price, inline = true},
                    {name = 'プレイヤー', value = playerName, inline = true}
                }, 0x00FF00)
                
                TriggerClientEvent('bridge:client:notify', source, '購入完了', '車両を購入しました', 'success')
            end
        else
            TriggerClientEvent('bridge:client:notify', source, 'エラー', '銀行残高が不足しています', 'error')
        end
    end)
    
    -- ========== ジョブ限定アクションの例 ==========
    RegisterNetEvent('example:policeAction', function()
        local source = source
        
        -- 警察官かチェック (グレード2以上)
        if Bridge.HasJob(source, 'police', 2) then
            -- アクション実行
            TriggerClientEvent('example:executePoliceAction', source)
        else
            TriggerClientEvent('bridge:client:notify', source, 'エラー', '権限がありません', 'error')
        end
    end)
    
    -- ========== ソサエティ入金の例 ==========
    RegisterNetEvent('example:depositToSociety', function(amount)
        local source = source
        local job = Bridge.GetJob(source)
        
        if job and Bridge.GetMoney(source, 'cash') >= amount then
            if Bridge.RemoveMoney(source, amount, 'cash', 'ソサエティ入金') then
                Bridge.AddSocietyMoney(job, amount)
                TriggerClientEvent('bridge:client:notify', source, '入金完了', amount .. 'ドルを入金しました', 'success')
            end
        else
            TriggerClientEvent('bridge:client:notify', source, 'エラー', '現金が不足しています', 'error')
        end
    end)
    
    -- ========== スタッシュ登録の例 ==========
    CreateThread(function()
        -- 警察署の証拠品保管庫
        Bridge.RegisterStash('police_evidence', {
            label = '警察署 証拠品保管庫',
            slots = 100,
            weight = 500000,
            owner = false
        })
        
        -- ギャングの隠し倉庫
        Bridge.RegisterStash('gang_stash', {
            label = 'ギャング倉庫',
            slots = 50,
            weight = 250000,
            owner = false
        })
    end)

--=========================================================================================================
-- CLIENT SIDE EXAMPLES
--=========================================================================================================

else
    
    -- ========== 通知を受け取る ==========
    RegisterNetEvent('bridge:client:notify', function(title, message, type)
        Bridge.Notify(title, message, type)
    end)
    
    -- ========== インタラクションポイントの例 ==========
    CreateThread(function()
        local shopCoords = vector3(25.74, -1347.32, 29.5)
        
        -- Target を使用する場合
        if GetResourceState('ox_target') == 'started' or GetResourceState('qb-target') == 'started' then
            Bridge.AddBoxZone({
                name = 'example_shop',
                coords = shopCoords,
                size = vector3(2.0, 2.0, 2.0),
                rotation = 0.0,
                debug = false,
                options = {
                    {
                        name = 'open_shop',
                        label = 'ショップを開く',
                        icon = 'fas fa-shopping-cart',
                        onSelect = function()
                            -- ショップメニューを開く
                            OpenShopMenu()
                        end
                    }
                }
            })
        
        -- マーカー + TextUI を使用する場合
        else
            while true do
                local sleep = 1000
                local playerCoords = GetEntityCoords(PlayerPedId())
                local distance = Bridge.GetDistance(playerCoords, shopCoords)
                
                if distance < 10.0 then
                    sleep = 0
                    Bridge.DrawMarker(1, shopCoords, vector3(1.0, 1.0, 1.0), {r = 0, g = 255, b = 0, a = 100})
                    
                    if distance < 2.0 then
                        Bridge.ShowTextUI('[E] ショップを開く')
                        
                        if Bridge.IsControlPressed(38) then -- E key
                            Bridge.HideTextUI()
                            OpenShopMenu()
                        end
                    else
                        Bridge.HideTextUI()
                    end
                end
                
                Wait(sleep)
            end
        end
    end)
    
    -- ========== ショップメニューの例 ==========
    function OpenShopMenu()
        Bridge.ShowMenu({
            id = 'example_shop_menu',
            title = '24/7 ショップ',
            options = {
                {
                    title = '水',
                    description = '価格: $5',
                    icon = 'fas fa-tint',
                    onSelect = function()
                        TriggerServerEvent('example:buyItem', 'water', 5)
                    end
                },
                {
                    title = 'パン',
                    description = '価格: $3',
                    icon = 'fas fa-bread-slice',
                    onSelect = function()
                        TriggerServerEvent('example:buyItem', 'bread', 3)
                    end
                },
                {
                    title = '閉じる',
                    icon = 'fas fa-times',
                    onSelect = function()
                        Bridge.CloseMenu()
                    end
                }
            }
        })
    end
    
    -- ========== プログレスバーの使用例 ==========
    RegisterNetEvent('example:repairVehicle', function()
        local vehicle = Bridge.GetPlayerVehicle()
        
        if vehicle then
            local success = Bridge.ShowProgress({
                duration = 10000,
                label = '車両を修理中...',
                canCancel = true,
                disable = {
                    move = true,
                    car = true,
                    combat = true,
                },
                animation = {
                    dict = 'mini@repair',
                    anim = 'fixing_a_player',
                    flag = 49
                },
                prop = {
                    model = 'prop_tool_wrench',
                    bone = 57005,
                    pos = vector3(0.1, 0.0, 0.0),
                    rot = vector3(0.0, 0.0, 0.0)
                }
            })
            
            if success then
                SetVehicleFixed(vehicle)
                Bridge.Notify('修理完了', '車両を修理しました', 'success')
            else
                Bridge.Notify('キャンセル', '修理をキャンセルしました', 'error')
            end
        else
            Bridge.Notify('エラー', '車両に乗っていません', 'error')
        end
    end)
    
    -- ========== Inputダイアログの使用例 ==========
    RegisterNetEvent('example:sendMoney', function()
        local input = Bridge.ShowInput({
            header = '送金',
            inputs = {
                {
                    name = 'target_id',
                    label = '相手のID',
                    type = 'number',
                    required = true
                },
                {
                    name = 'amount',
                    label = '金額',
                    type = 'number',
                    required = true
                }
            }
        })
        
        if input then
            TriggerServerEvent('example:transferMoney', input.target_id, input.amount)
        end
    end)
    
    -- ========== Callbackの使用例 ==========
    RegisterNetEvent('example:showPlayerInfo', function()
        Bridge.TriggerCallback('example:getPlayerData', function(data)
            if data then
                local message = string.format(
                    '名前: %s\nジョブ: %s (Grade %s)\n現金: $%s\n銀行: $%s',
                    data.name, data.job, data.grade, data.cash, data.bank
                )
                
                Bridge.Notify('プレイヤー情報', message, 'info', 10000)
            end
        end)
    end)
    
    -- ========== 車両スポーンの例 ==========
    RegisterNetEvent('example:spawnVehicle', function(model)
        local playerPed = PlayerPedId()
        local coords = GetEntityCoords(playerPed)
        local heading = GetEntityHeading(playerPed)
        
        -- 少し前方にスポーン
        local spawnCoords = GetOffsetFromEntityInWorldCoords(playerPed, 0.0, 5.0, 0.0)
        
        Bridge.SpawnVehicle(model, spawnCoords, heading, function(vehicle)
            TaskWarpPedIntoVehicle(playerPed, vehicle, -1)
            
            -- 燃料を満タンに
            Bridge.SetVehicleFuel(vehicle, 100.0)
            
            -- キーを付与
            local plate = GetVehicleNumberPlateText(vehicle)
            TriggerServerEvent('example:giveVehicleKeys', plate)
            
            Bridge.Notify('車両スポーン', model .. ' をスポーンしました', 'success')
        end)
    end)
    
    -- ========== Target を使ったプレイヤーインタラクションの例 ==========
    CreateThread(function()
        Bridge.AddGlobalPlayer({
            {
                name = 'give_money',
                label = 'お金を渡す',
                icon = 'fas fa-hand-holding-usd',
                onSelect = function(data)
                    local targetId = GetPlayerServerId(NetworkGetPlayerIndexFromPed(data.entity))
                    
                    local input = Bridge.ShowInput({
                        header = 'お金を渡す',
                        inputs = {
                            {
                                name = 'amount',
                                label = '金額',
                                type = 'number',
                                required = true
                            }
                        }
                    })
                    
                    if input then
                        TriggerServerEvent('example:giveMoney', targetId, input.amount)
                    end
                end
            }
        })
    end)
end
