--=========================================================================================================
--                                    CALLBACK SYSTEM (CLIENT)
--=========================================================================================================

Bridge.ClientCallbacks = {}
Bridge.ServerCallbacks = {}
Bridge.CurrentRequestId = 0

--- サーバーコールバックを呼び出し
--- @param name string
--- @param callback function
--- @param ... any
function Bridge.TriggerCallback(name, callback, ...)
    Bridge.CurrentRequestId = Bridge.CurrentRequestId + 1
    local requestId = Bridge.CurrentRequestId
    
    Bridge.ClientCallbacks[requestId] = callback
    
    TriggerServerEvent('bridge:server:triggerCallback', name, requestId, ...)
end

--- コールバックレスポンスを受信
RegisterNetEvent('bridge:client:triggerCallback', function(requestId, ...)
    if Bridge.ClientCallbacks[requestId] then
        Bridge.ClientCallbacks[requestId](...)
        Bridge.ClientCallbacks[requestId] = nil
    end
end)

--- クライアントコールバックを登録
--- @param name string
--- @param callback function
function Bridge.RegisterClientCallback(name, callback)
    Bridge.ServerCallbacks[name] = callback
end

--- クライアントコールバックを呼び出し
RegisterNetEvent('bridge:client:executeCallback', function(name, requestId, ...)
    if Bridge.ServerCallbacks[name] then
        Bridge.ServerCallbacks[name](function(...)
            TriggerServerEvent('bridge:server:callbackResponse', requestId, ...)
        end, ...)
    end
end)
