--=========================================================================================================
--                                    VEHICLE KEYS & FUEL SYSTEM (CLIENT)
--=========================================================================================================

--- 車両キーを持っているかチェック (クライアント側)
--- @param plate string
--- @return boolean
function Bridge.HasVehicleKeys(plate)
    if Config.DefaultSettings.vehiclekey == "qb" then
        return exports['qb-vehiclekeys']:HasKeys()
    elseif Config.DefaultSettings.vehiclekey == "qs" then
        return exports['qs-vehiclekeys']:HasKeys(plate)
    elseif Config.DefaultSettings.vehiclekey == "wasabi" then
        return exports.wasabi_carlock:HasKey(plate)
    end
    return true
end

--- クライアント側のキーチェックコールバック
Bridge.RegisterClientCallback('bridge:client:hasVehicleKeys', function(cb, plate)
    cb(Bridge.HasVehicleKeys(plate))
end)

--=========================================================================================================
--                                    FUEL SYSTEM (CLIENT SIDE)
--=========================================================================================================

--- 車両の燃料を取得
--- @param vehicle number
--- @return number
function Bridge.GetVehicleFuel(vehicle)
    if Config.DefaultSettings.fuel == "legacy" then
        return exports['LegacyFuel']:GetFuel(vehicle)
    elseif Config.DefaultSettings.fuel == "ox" then
        return GetVehicleFuelLevel(vehicle)
    elseif Config.DefaultSettings.fuel == "ps" then
        return exports['ps-fuel']:GetFuel(vehicle)
    elseif Config.DefaultSettings.fuel == "cdn" then
        return exports['cdn-fuel']:GetFuel(vehicle)
    elseif Config.DefaultSettings.fuel == "qs" then
        return exports['qs-fuelstations']:GetFuel(vehicle)
    else
        return GetVehicleFuelLevel(vehicle)
    end
end

--- 車両の燃料を設定
--- @param vehicle number
--- @param fuel number
function Bridge.SetVehicleFuel(vehicle, fuel)
    if Config.DefaultSettings.fuel == "legacy" then
        exports['LegacyFuel']:SetFuel(vehicle, fuel)
    elseif Config.DefaultSettings.fuel == "ox" then
        Entity(vehicle).state.fuel = fuel
    elseif Config.DefaultSettings.fuel == "ps" then
        exports['ps-fuel']:SetFuel(vehicle, fuel)
    elseif Config.DefaultSettings.fuel == "cdn" then
        exports['cdn-fuel']:SetFuel(vehicle, fuel)
    elseif Config.DefaultSettings.fuel == "qs" then
        exports['qs-fuelstations']:SetFuel(vehicle, fuel)
    else
        SetVehicleFuelLevel(vehicle, fuel + 0.0)
    end
end
