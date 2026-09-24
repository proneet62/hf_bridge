--=========================================================================================================
--                                    STASH/STORAGE SYSTEM (統合版)
--=========================================================================================================

--- スタッシュを登録
--- @param id string
--- @param data table
function Bridge.RegisterStash(id, data)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:RegisterStash(id, data.label, data.slots, data.weight, data.owner)
    elseif Bridge.Inventory == 'qb-inventory' then
        -- QB-Inventory は動的にスタッシュを作成
    elseif Bridge.Inventory == 'qs-inventory' then
        exports['qs-inventory']:RegisterStash(id, data.slots, data.weight)
    end
end

--- スタッシュを開く
--- @param source number
--- @param id string
--- @param data table|nil
function Bridge.OpenStash(source, id, data)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:forceOpenInventory(source, 'stash', id)
    elseif Bridge.Inventory == 'qb-inventory' then
        TriggerClientEvent('inventory:client:SetCurrentStash', source, id)
        TriggerClientEvent('qb-inventory:client:OpenInventory', source, 'stash', {
            maxweight = data and data.weight or 100000,
            slots = data and data.slots or 50,
        }, {stashid = id})
    elseif Bridge.Inventory == 'qs-inventory' then
        exports['qs-inventory']:OpenInventory(source, id)
    end
end

--- スタッシュの中身を取得
--- @param id string
--- @return table
function Bridge.GetStashItems(id)
    if Bridge.Inventory == 'ox_inventory' then
        return exports.ox_inventory:GetInventory(id)
    elseif Bridge.Inventory == 'qb-inventory' then
        -- QB-Inventory のスタッシュデータ取得
        return {}
    elseif Bridge.Inventory == 'qs-inventory' then
        return exports['qs-inventory']:GetStashItems(id)
    end
    return {}
end

--- スタッシュをクリア
--- @param id string
function Bridge.ClearStash(id)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:ClearInventory(id)
    elseif Bridge.Inventory == 'qb-inventory' then
        -- QB-Inventory のクリア処理
    elseif Bridge.Inventory == 'qs-inventory' then
        exports['qs-inventory']:ClearStash(id)
    end
end

--- トランクを開く
--- @param source number
--- @param plate string
function Bridge.OpenTrunk(source, plate)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:forceOpenInventory(source, 'trunk', plate)
    elseif Bridge.Inventory == 'qb-inventory' then
        TriggerClientEvent('qb-inventory:client:OpenInventory', source, 'trunk', {
            netid = plate
        })
    elseif Bridge.Inventory == 'qs-inventory' then
        exports['qs-inventory']:OpenInventory(source, 'trunk_' .. plate)
    end
end

--- グローブボックスを開く
--- @param source number
--- @param plate string
function Bridge.OpenGlovebox(source, plate)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:forceOpenInventory(source, 'glovebox', plate)
    elseif Bridge.Inventory == 'qb-inventory' then
        TriggerClientEvent('qb-inventory:client:OpenInventory', source, 'glovebox', {
            netid = plate
        })
    elseif Bridge.Inventory == 'qs-inventory' then
        exports['qs-inventory']:OpenInventory(source, 'glovebox_' .. plate)
    end
end
