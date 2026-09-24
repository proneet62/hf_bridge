function Bridge.Notify(title, message, type, duration)
    type = type or 'info'
    duration = duration or 5000
    
    if Config.DefaultSettings.notify == "qb" then
        Bridge.Framework.Functions.Notify(message, type, duration)
    elseif Config.DefaultSettings.notify == "esx" then -- ESX
        Bridge.Framework.ShowNotification(message)
    elseif Config.DefaultSettings.notify == "ox" then
        lib.notify({
            title = title,
            description = message,
            type = type
        })
    elseif Config.DefaultSettings.notify == "okok" then
        exports['okokNotify']:Alert(title, message, duration, type)
    elseif Config.DefaultSettings.notify == "hf" then
        exports["hf_notify"]:Notify(title, message, type, duration)
    else
        -- フォールバック
        BeginTextCommandThefeedPost('STRING')
        AddTextComponentSubstringPlayerName(message)
        EndTextCommandThefeedPostTicker(false, true)
    end
end
