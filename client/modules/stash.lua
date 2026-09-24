--=========================================================================================================
--                                    STASH/STORAGE SYSTEM (CLIENT)
--=========================================================================================================

--- スタッシュを開く (クライアント側)
--- @param id string
function Bridge.OpenStash(id)
    if Bridge.Inventory == 'ox_inventory' then
        exports.ox_inventory:openInventory('stash', id)
    elseif Bridge.Inventory == 'qb-inventory' then
        TriggerServerEvent('inventory:server:OpenInventory', 'stash', id)
    elseif Bridge.Inventory == 'qs-inventory' then
        TriggerServerEvent('qs-inventory:server:OpenInventory', 'stash', id)
    end
end
