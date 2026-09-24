-- 車両スポーン
function Bridge.SpawnVehicle(model, coords, heading, callback)
    local modelHash = type(model) == 'string' and GetHashKey(model) or model
    
    RequestModel(modelHash)
    while not HasModelLoaded(modelHash) do
        Wait(10)
    end
    
    local vehicle = CreateVehicle(modelHash, coords.x, coords.y, coords.z, heading, true, false)
    SetModelAsNoLongerNeeded(modelHash)
    
    if callback then
        callback(vehicle)
    end
    
    return vehicle
end

-- 車両削除
function Bridge.DeleteVehicle(vehicle)
    if DoesEntityExist(vehicle) then
        DeleteEntity(vehicle)
        return true
    end
    return false
end

-- プレイヤーの車両取得
function Bridge.GetPlayerVehicle()
    local ped = PlayerPedId()
    if IsPedInAnyVehicle(ped, false) then
        return GetVehiclePedIsIn(ped, false)
    end
    return nil
end

-- 最も近い車両を取得
function Bridge.GetClosestVehicle(coords, maxDistance)
    coords = coords or GetEntityCoords(PlayerPedId())
    maxDistance = maxDistance or 5.0
    
    local vehicles = GetGamePool('CVehicle')
    local closestVehicle = nil
    local closestDistance = maxDistance
    
    for _, vehicle in pairs(vehicles) do
        local vehicleCoords = GetEntityCoords(vehicle)
        local distance = Bridge.GetDistance(coords, vehicleCoords)
        
        if distance < closestDistance then
            closestVehicle = vehicle
            closestDistance = distance
        end
    end
    
    return closestVehicle, closestDistance
end
