--=========================================================================================================
--                                    VEHICLE KEYS SYSTEM (SERVER)
--=========================================================================================================

--- 車両キーを付与
--- @param source number
--- @param plate string
function Bridge.GiveVehicleKeys(source, plate)
    if Config.DefaultSettings.vehiclekey == "qb" then
        TriggerClientEvent('vehiclekeys:client:SetOwner', source, plate)
    elseif Config.DefaultSettings.vehiclekey == "qs" then
        exports['qs-vehiclekeys']:GiveKeys(source, plate)
    elseif Config.DefaultSettings.vehiclekey == "cd" then
        TriggerClientEvent('cd_garage:AddKeys', source, plate)
    elseif Config.DefaultSettings.vehiclekey == "wasabi" then
        exports.wasabi_carlock:GiveKey(source, plate)
    end
end

--- 車両キーを削除
--- @param source number
--- @param plate string
function Bridge.RemoveVehicleKeys(source, plate)
    if Config.DefaultSettings.vehiclekey == "qb" then
        TriggerClientEvent('qb-vehiclekeys:client:RemoveKeys', source, plate)
    elseif Config.DefaultSettings.vehiclekey == "qs" then
        exports['qs-vehiclekeys']:RemoveKeys(source, plate)
    elseif Config.DefaultSettings.vehiclekey == "wasabi" then
        exports.wasabi_carlock:RemoveKey(source, plate)
    end
end

--- 車両キーを持っているかチェック
--- @param source number
--- @param plate string
--- @return boolean
function Bridge.HasVehicleKeys(source, plate)
    if Config.DefaultSettings.vehiclekey == "qb" then
        -- QB VehicleKeys はクライアント側でチェック
        local hasKeys = false
        Bridge.TriggerClientCallback(source, 'bridge:client:hasVehicleKeys', function(result)
            hasKeys = result
        end, plate)
        Wait(100)
        return hasKeys
    elseif Config.DefaultSettings.vehiclekey == "qs" then
        return exports['qs-vehiclekeys']:HasKeys(source, plate)
    end
    return true -- デフォルトは true
end
