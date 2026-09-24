-- プレイヤーが近くにいるかチェック
function Bridge.IsPlayerNearby(coords, distance)
    local playerCoords = GetEntityCoords(PlayerPedId())
    return Bridge.GetDistance(playerCoords, coords) <= distance
end

-- キー入力待機
function Bridge.IsControlPressed(control)
    return IsControlPressed(0, control)
end

-- ヘルプテキスト表示
function Bridge.ShowHelpText(text)
    BeginTextCommandDisplayHelp('STRING')
    AddTextComponentSubstringPlayerName(text)
    EndTextCommandDisplayHelp(0, false, true, -1)
end
