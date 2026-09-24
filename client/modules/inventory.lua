--=========================================================================================================
--                                    INVENTORY MODULE (CLIENT)
--=========================================================================================================

--- アイテム所持数を取得
--- @param itemName string アイテム名
--- @return number 所持数
function Bridge.GetItemCount(itemName)
    -- ox_inventory
    if Config.DefaultSettings.inventory == "ox" then
        local result = exports.ox_inventory:Search('count', itemName)
        if type(result) == 'number' then
            return result
        elseif type(result) == 'table' then
            -- テーブルの場合は合計を計算
            local count = 0
            for _, v in pairs(result) do
                if type(v) == 'number' then
                    count = count + v
                end
            end
            return count
        end
        return 0
    end
    
    -- qb-inventory / qb-core
    if Config.DefaultSettings.inventory == "qb" or (Bridge.FrameworkName and Bridge.FrameworkName == 'qbcore') then
        local PlayerData = nil
        if Bridge.Framework and Bridge.Framework.Functions then
            PlayerData = Bridge.Framework.Functions.GetPlayerData()
        end
        
        if PlayerData and PlayerData.items then
            local totalAmount = 0
            for _, item in pairs(PlayerData.items) do
                if item and item.name == itemName then
                    totalAmount = totalAmount + (item.amount or 1)
                end
            end
            return totalAmount
        end
        return 0
    end
    
    -- qs-inventory
    if Config.DefaultSettings.inventory == "qs" then
        return exports['qs-inventory']:GetItemTotalAmount(itemName) or 0
    end
    
    return 0
end

--- アイテムを所持しているかチェック
--- @param itemName string アイテム名
--- @param amount number 必要数（デフォルト1）
--- @return boolean
function Bridge.HasItem(itemName, amount)
    amount = amount or 1
    return Bridge.GetItemCount(itemName) >= amount
end

--- プレイヤーのインベントリを取得
--- @return table|nil
function Bridge.GetInventory()
    -- ox_inventory
    if Config.DefaultSettings.inventory == "ox" then
        return exports.ox_inventory:GetPlayerItems()
    end
    
    -- qb-inventory / qb-core
    if Config.DefaultSettings.inventory == "qb" or (Bridge.FrameworkName and Bridge.FrameworkName == 'qbcore') then
        if Bridge.Framework and Bridge.Framework.Functions then
            local PlayerData = Bridge.Framework.Functions.GetPlayerData()
            return PlayerData and PlayerData.items or {}
        end
    end
    
    -- qs-inventory
    if Config.DefaultSettings.inventory == "qs" then
        return exports['qs-inventory']:GetPlayerInventory() or {}
    end
    
    return {}
end

--- 特定のアイテムを取得
--- @param itemName string アイテム名
--- @return table|nil
function Bridge.GetItem(itemName)
    -- ox_inventory
    if Config.DefaultSettings.inventory == "ox" then
        local items = exports.ox_inventory:Search('slots', itemName)
        if items and #items > 0 then
            return items[1]
        end
        return nil
    end
    
    -- qb-inventory / qb-core
    if Config.DefaultSettings.inventory == "qb" or (Bridge.FrameworkName and Bridge.FrameworkName == 'qbcore') then
        if Bridge.Framework and Bridge.Framework.Functions then
            local PlayerData = Bridge.Framework.Functions.GetPlayerData()
            if PlayerData and PlayerData.items then
                for _, item in pairs(PlayerData.items) do
                    if item and item.name == itemName then
                        return item
                    end
                end
            end
        end
    end
    
    -- qs-inventory
    if Config.DefaultSettings.inventory == "qs" then
        return exports['qs-inventory']:GetItemByName(itemName)
    end
    
    return nil
end
