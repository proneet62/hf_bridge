-- アイテム追加
function Bridge.AddItem(source, item, amount, slot, metadata)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:AddItem(source, item, amount, metadata, slot)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.AddItem(item, amount, slot, metadata)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:AddItem(source, item, amount, slot, metadata)
    end
    return false
end

-- アイテム削除
function Bridge.RemoveItem(source, item, amount, slot, metadata)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:RemoveItem(source, item, amount, metadata, slot)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.RemoveItem(item, amount, slot)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:RemoveItem(source, item, amount, slot)
    end
    return false
end

-- アイテム所持チェック
function Bridge.HasItem(source, item, amount)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        local count = exports.ox_inventory:Search(source, 'count', item)
        return count >= amount
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            local playerItem = Player.Functions.GetItemByName(item)
            return playerItem and playerItem.amount >= amount
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        local hasItem = exports['qs-inventory']:GetItemTotalAmount(source, item)
        return hasItem >= amount
    end
    return false
end

-- アイテム情報取得
function Bridge.GetItem(source, item)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:GetItem(source, item)
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            return Player.Functions.GetItemByName(item)
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetItem(source, item)
    end
    return nil
end

-- アイテム所持数取得
function Bridge.GetItemCount(source, item)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:Search(source, 'count', item) or 0
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            local playerItem = Player.Functions.GetItemByName(item)
            return playerItem and playerItem.amount or 0
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetItemTotalAmount(source, item) or 0
    end
    return 0
end

-- アイテムを持てるかチェック
--- @param source number プレイヤーソース
--- @param item string アイテム名
--- @param amount number 数量
--- @return boolean canCarry 持てるかどうか
--- @return number maxCanCarry 持てる最大数
function Bridge.CanCarryItem(source, item, amount)
    amount = amount or 1
    
    if Bridge.Inventory == 'ox_inventory' then
        local canCarry = exports.ox_inventory:CanCarryItem(source, item, amount)
        if canCarry then
            return true, amount
        else
            -- 持てる最大数を二分探索で計算
            local low, high = 0, amount - 1
            local maxCanCarry = 0
            while low <= high do
                local mid = math.floor((low + high) / 2)
                if mid == 0 then
                    break
                end
                if exports.ox_inventory:CanCarryItem(source, item, mid) then
                    maxCanCarry = mid
                    low = mid + 1
                else
                    high = mid - 1
                end
            end
            return false, maxCanCarry
        end
        
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if not Player then return false, 0 end
        
        -- QB-Coreのアイテム情報取得
        local itemInfo = nil
        if Bridge.Framework.Shared and Bridge.Framework.Shared.Items then
            itemInfo = Bridge.Framework.Shared.Items[item]
        end
        
        if not itemInfo then
            -- アイテム情報がない場合は持てると仮定
            return true, amount
        end
        
        local itemWeight = itemInfo.weight or 0
        local totalWeight = itemWeight * amount
        
        -- 現在の重量を計算
        local currentWeight = 0
        local items = Player.PlayerData.items or {}
        for _, invItem in pairs(items) do
            if invItem then
                local invItemInfo = Bridge.Framework.Shared.Items[invItem.name]
                if invItemInfo then
                    currentWeight = currentWeight + ((invItemInfo.weight or 0) * (invItem.amount or 1))
                end
            end
        end
        
        -- 最大重量（デフォルト120kg）
        local maxWeight = 120000
        if Player.PlayerData and Player.PlayerData.maxweight then
            maxWeight = Player.PlayerData.maxweight
        end
        
        local availableWeight = maxWeight - currentWeight
        
        if availableWeight >= totalWeight then
            return true, amount
        else
            local canCarryCount = 0
            if itemWeight > 0 then
                canCarryCount = math.floor(availableWeight / itemWeight)
            end
            return false, canCarryCount
        end
        
    elseif Bridge.Inventory == 'qs-inventory' then
        local canCarry = exports['qs-inventory']:CanCarryItem(source, item, amount)
        if canCarry then
            return true, amount
        else
            -- 持てる最大数を二分探索で計算
            local low, high = 0, amount - 1
            local maxCanCarry = 0
            while low <= high do
                local mid = math.floor((low + high) / 2)
                if mid == 0 then
                    break
                end
                if exports['qs-inventory']:CanCarryItem(source, item, mid) then
                    maxCanCarry = mid
                    low = mid + 1
                else
                    high = mid - 1
                end
            end
            return false, maxCanCarry
        end
    end
    
    -- フォールバック: 常にtrue
    return true, amount
end

-- インベントリの空きスロット数を取得
function Bridge.GetFreeSlots(source)
    if Bridge.Inventory == 'ox_inventory' then
        local slots = exports.ox_inventory:GetSlots(source)
        local freeSlots = 0
        if slots then
            for _, slot in pairs(slots) do
                if not slot or not slot.name then
                    freeSlots = freeSlots + 1
                end
            end
        end
        return freeSlots
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            local items = Player.PlayerData.items or {}
            local maxSlots = 41 -- デフォルトスロット数
            local usedSlots = 0
            for _, invItem in pairs(items) do
                if invItem then
                    usedSlots = usedSlots + 1
                end
            end
            return maxSlots - usedSlots
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetFreeSlots(source) or 0
    end
    return 0
end

-- 現在の重量を取得
function Bridge.GetCurrentWeight(source)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:GetCurrentWeight(source) or 0
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player then
            local currentWeight = 0
            local items = Player.PlayerData.items or {}
            for _, invItem in pairs(items) do
                if invItem then
                    local itemInfo = Bridge.Framework.Shared.Items[invItem.name]
                    if itemInfo then
                        currentWeight = currentWeight + ((itemInfo.weight or 0) * (invItem.amount or 1))
                    end
                end
            end
            return currentWeight
        end
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetCurrentWeight(source) or 0
    end
    return 0
end

-- 最大重量を取得
function Bridge.GetMaxWeight(source)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:GetMaxWeight(source) or 120000
    elseif Bridge.Inventory == 'qb-inventory' then
        local Player = Bridge.GetPlayer(source)
        if Player and Player.PlayerData and Player.PlayerData.maxweight then
            return Player.PlayerData.maxweight
        end
        return 120000
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetMaxWeight(source) or 120000
    end
    return 120000
end
