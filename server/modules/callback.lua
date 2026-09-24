--=========================================================================================================
--                                    CALLBACK SYSTEM (統合版)
--=========================================================================================================

Bridge.ServerCallbacks = {}
Bridge.CurrentRequestId = 0

-- ========== SERVER SIDE ==========

--- コールバックを登録
--- @param name string
--- @param callback function
function Bridge.RegisterCallback(name, callback)
    Bridge.ServerCallbacks[name] = callback
end

--- コールバックリクエストを受信
RegisterNetEvent('bridge:server:triggerCallback', function(name, requestId, ...)
    local src = source
    
    if Bridge.ServerCallbacks[name] then
        Bridge.ServerCallbacks[name](src, function(...)
            TriggerClientEvent('bridge:client:triggerCallback', src, requestId, ...)
        end, ...)
    else
        print('[Bridge ERROR] Callback not found: ' .. name)
        TriggerClientEvent('bridge:client:triggerCallback', src, requestId, nil)
    end
end)

-- SERVER側: クライアントコールバックを呼び出す
Bridge.ClientRequests = {}

--- クライアントコールバックを呼び出し
--- @param source number
--- @param name string
--- @param callback function
--- @param ... any
function Bridge.TriggerClientCallback(source, name, callback, ...)
    Bridge.CurrentRequestId = Bridge.CurrentRequestId + 1
    local requestId = Bridge.CurrentRequestId

    Bridge.ClientRequests[requestId] = {callback = callback, source = source}

    TriggerClientEvent('bridge:client:executeCallback', source, name, requestId, ...)
end

--- クライアントからのレスポンスを受信
RegisterNetEvent('bridge:server:callbackResponse', function(requestId, ...)
    local src = source
    local request = Bridge.ClientRequests[requestId]
    if request then
        -- レスポンス元がリクエスト先と一致するか検証
        if request.source ~= src then
            print('[Bridge ERROR] Callback response source mismatch: expected ' .. tostring(request.source) .. ', got ' .. tostring(src))
            return
        end
        request.callback(...)
        Bridge.ClientRequests[requestId] = nil
    end
end)
