-- 3Dテキスト表示
function Bridge.DrawText3D(coords, text)
    local onScreen, x, y = World3dToScreen2d(coords.x, coords.y, coords.z)
    local camCoords = GetGameplayCamCoords()
    local distance = Bridge.GetDistance(camCoords, coords)
    local scale = (1 / distance) * 2
    local fov = (1 / GetGameplayCamFov()) * 100
    scale = scale * fov
    
    if onScreen then
        SetTextScale(0.0 * scale, 0.55 * scale)
        SetTextFont(4)
        SetTextProportional(1)
        SetTextColour(255, 255, 255, 215)
        SetTextDropshadow(0, 0, 0, 0, 255)
        SetTextEdge(2, 0, 0, 0, 150)
        SetTextDropShadow()
        SetTextOutline()
        SetTextEntry('STRING')
        SetTextCentre(1)
        AddTextComponentString(text)
        DrawText(x, y)
    end
end

-- マーカー表示
function Bridge.DrawMarker(type, coords, scale, color)
    type = type or 1
    scale = scale or vector3(1.0, 1.0, 1.0)
    color = color or {r = 255, g = 255, b = 255, a = 100}
    
    DrawMarker(
        type,
        coords.x, coords.y, coords.z,
        0.0, 0.0, 0.0,
        0.0, 0.0, 0.0,
        scale.x, scale.y, scale.z,
        color.r, color.g, color.b, color.a,
        false, true, 2, false, nil, nil, false
    )
end

-- textui
function Bridge.ShowTextUI(message, position)
    position = position or 'right'
    
    -- ox_lib TextUI
    if Config.DefaultSettings.textui == "ox" then
        lib.showTextUI(message, {
            position = position
        })
    -- okokTextUI
    elseif Config.DefaultSettings.textui == "okok" then
        exports['okokTextUI']:Open(message, 'darkblue', position)
    -- jg-textui
    elseif Config.DefaultSettings.textui == "jg" then
        exports['jg-textui']:DrawText(message)
    -- hf_textui
    elseif Config.DefaultSettings.textui == "in" then
        exports['hf_textui']:drawText(message, position, 5000)
    -- QB-Core TextUI
    elseif Config.DefaultSettings.textui == "qb" then
        Bridge.Framework.Functions.DrawText(message, position)
    -- ESX TextUI
    elseif Config.DefaultSettings.textui == "esx" then
        Bridge.Framework.TextUI(message)
    -- フォールバック (ヘルプテキスト)
    else
        Bridge.ShowHelpText(message)
    end
end

-- TextUI非表示
function Bridge.HideTextUI()
    -- ox_lib TextUI
    if Config.DefaultSettings.textui == "ox" then
        lib.hideTextUI()
    -- okokTextUI
    elseif Config.DefaultSettings.textui == "okok" then
        exports['okokTextUI']:Close()
    -- jg-textui
    elseif Config.DefaultSettings.textui == "jg" then
        exports['jg-textui']:HideText()
    -- hf_textui
    elseif Config.DefaultSettings.textui == "in" then
        exports['hf_textui']:hideText()
    -- QB-Core TextUI
    elseif Config.DefaultSettings.textui == "qb" then
        Bridge.Framework.Functions.HideText()
    -- ESX TextUI
    elseif Config.DefaultSettings.textui == "esx" then
        Bridge.Framework.HideUI()
    end
end
