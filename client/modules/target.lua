--=========================================================================================================
--                                    TARGET SYSTEM (統合版)
--=========================================================================================================

--- ターゲットを追加 (Entity)
--- @param entity number
--- @param options table
function Bridge.AddTargetEntity(entity, options)
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:addLocalEntity(entity, options)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:AddTargetEntity(entity, {
            options = options,
            distance = 2.5
        })
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:AddTargetEntity(entity, {
            options = options,
            distance = 2.5
        })
    end
end

--- ターゲットを削除 (Entity)
--- @param entity number
--- @param labels table|string|nil
function Bridge.RemoveTargetEntity(entity, labels)
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:removeLocalEntity(entity, labels)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:RemoveTargetEntity(entity, labels)
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:RemoveTargetEntity(entity, labels)
    end
end

--- ターゲットを追加 (Model)
--- @param models table|string
--- @param options table
function Bridge.AddTargetModel(models, options)
    if type(models) == 'string' then
        models = {models}
    end
    
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:addModel(models, options)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:AddTargetModel(models, {
            options = options,
            distance = 2.5
        })
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:AddTargetModel(models, {
            options = options,
            distance = 2.5
        })
    end
end

--- ターゲットを削除 (Model)
--- @param models table|string
--- @param labels table|string|nil
function Bridge.RemoveTargetModel(models, labels)
    if type(models) == 'string' then
        models = {models}
    end
    
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:removeModel(models, labels)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:RemoveTargetModel(models, labels)
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:RemoveTargetModel(models, labels)
    end
end

--- ターゲットゾーンを追加 (Box Zone)
--- @param data table
--- @return string|number - zone id
function Bridge.AddBoxZone(data)
    local id = data.name or 'zone_' .. math.random(100000, 999999)
    
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:addBoxZone({
            name = id,   -- ox_target は name を渡さないと RemoveZone(文字列id) で削除できない
            coords = data.coords,
            size = data.size or vector3(2.0, 2.0, 2.0),
            rotation = data.rotation or 0.0,
            debug = data.debug or false,
            options = data.options
        })
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:AddBoxZone(id, data.coords, data.size.x, data.size.y, {
            name = id,
            heading = data.rotation or 0.0,
            debugPoly = data.debug or false,
            minZ = data.coords.z - (data.size.z / 2),
            maxZ = data.coords.z + (data.size.z / 2),
        }, {
            options = data.options,
            distance = 2.5
        })
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:AddBoxZone(id, data.coords, data.size.x, data.size.y, {
            name = id,
            heading = data.rotation or 0.0,
            debugPoly = data.debug or false,
            minZ = data.coords.z - (data.size.z / 2),
            maxZ = data.coords.z + (data.size.z / 2),
        }, {
            options = data.options,
            distance = 2.5
        })
    end
    
    return id
end

--- ターゲットゾーンを削除
--- @param id string|number
function Bridge.RemoveZone(id)
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:removeZone(id)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:RemoveZone(id)
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:RemoveZone(id)
    end
end

--- グローバルプレイヤーターゲットを追加
--- @param options table
function Bridge.AddGlobalPlayer(options)
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:addGlobalPlayer(options)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:AddGlobalPlayer({
            options = options,
            distance = 2.5
        })
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:AddGlobalPlayer({
            options = options,
            distance = 2.5
        })
    end
end

--- グローバル車両ターゲットを追加
--- @param options table
function Bridge.AddGlobalVehicle(options)
    if Config.DefaultSettings.target == "ox" then
        exports.ox_target:addGlobalVehicle(options)
    elseif Config.DefaultSettings.target == "qb" then
        exports['qb-target']:AddGlobalVehicle({
            options = options,
            distance = 2.5
        })
    elseif Config.DefaultSettings.target == "q" then
        exports.qtarget:AddGlobalVehicle({
            options = options,
            distance = 2.5
        })
    end
end
