--=========================================================================================================
--                                    INPUT & MENU SYSTEM (統合版)
--=========================================================================================================

--- 入力ダイアログを表示
--- @param data table
--- @return table|nil - 入力された値
function Bridge.ShowInput(data)
    local result = nil
    local inputDefs = data.inputs or data.rows or {}

    -- nb (Ri_ui) — NookBaseデザイン実体。未起動時は pcall で握りつぶし nil を返す
    if Config.DefaultSettings.input == "nb" then
        local ok, raw = pcall(function()
            return exports.Ri_ui:Input({ header = data.header, rows = inputDefs })
        end)
        if not ok then print('[hf_bridge] Ri_ui:Input 呼び出しに失敗しました') return nil end
        if raw then
            result = {}
            for i, def in ipairs(inputDefs) do
                result[def.name or ('input' .. i)] = raw[i]
            end
        end
        return result
    end

    -- ox_lib input
    if Config.DefaultSettings.input == "ox" and lib and lib.inputDialog then
        local rawInput = lib.inputDialog(data.header, inputDefs)
        
        -- ox_libは配列で結果を返すので、名前付きテーブルに変換
        if rawInput then
            result = {}
            for i, def in ipairs(inputDefs) do
                local fieldName = def.name or ('input' .. i)
                result[fieldName] = rawInput[i]
            end
        end
    
    -- qb-input
    elseif Config.DefaultSettings.input == "qb" then
        local inputs = {}
        for i, row in ipairs(inputDefs) do
            table.insert(inputs, {
                text = row.label,
                name = row.name or "input" .. i,
                type = row.type or "text",
                isRequired = row.required or false,
                default = row.default,
            })
        end
        
        local dialog = exports['qb-input']:ShowInput({
            header = data.header,
            submitText = data.submitText or "Submit",
            inputs = inputs
        })
        
        if dialog then
            result = {}
            for i, row in ipairs(inputDefs) do
                local fieldName = row.name or ("input" .. i)
                result[fieldName] = dialog[fieldName]
            end
        end
    end
    
    return result
end

--- メニューを表示
--- @param data table
--- @return table|nil
function Bridge.ShowMenu(data)
    -- nb (Ri_ui) — NookBaseデザイン実体。exports跨ぎで funcref を渡せないため
    -- onSelect 方式でなく「選択された 1始まり index」を返す(ox/qb とは戻り値が異なる点に注意)
    if Config.DefaultSettings.context == "nb" then
        local ok, idx = pcall(function() return exports.Ri_ui:Menu(data) end)
        if not ok then print('[hf_bridge] Ri_ui:Menu 呼び出しに失敗しました') return nil end
        return idx
    end

    -- ox_lib context menu
    if Config.DefaultSettings.context == "ox" and lib and lib.registerContext then
        local menuId = data.id or 'bridge_menu_' .. math.random(100000, 999999)
        
        lib.registerContext({
            id = menuId,
            title = data.header or data.title,
            options = data.options
        })
        
        lib.showContext(menuId)
        return true
    
    -- qb-menu
    elseif Config.DefaultSettings.context == "qb" then
        local menuData = {
            {
                header = data.header or data.title,
                isMenuHeader = true
            }
        }
        
        for _, option in ipairs(data.options or {}) do
            table.insert(menuData, {
                header = option.title or option.label,
                txt = option.description,
                params = {
                    event = option.event,
                    isServer = option.serverEvent or false,
                    args = option.args
                }
            })
        end
        
        exports['qb-menu']:openMenu(menuData)
        return true
    end
    
    return nil
end

--- コンテキストメニューを閉じる
function Bridge.CloseMenu()
    if Config.DefaultSettings.context == "ox" and lib and lib.hideContext then
        lib.hideContext()
    elseif Config.DefaultSettings.context == "qb" then
        exports['qb-menu']:closeMenu()
    end
end

--- 確認ダイアログを表示
--- @param data table
--- @return boolean
function Bridge.ShowConfirm(data)-- ox_lib alert
    if Config.DefaultSettings.confirm == "ox" and lib and lib.alertDialog then
        local alert = lib.alertDialog({
            header = data.header or data.title,
            content = data.message or data.description,
            centered = true,
            cancel = true,
            labels = {
                confirm = data.confirm or 'Confirm',
                cancel = data.cancel or 'Cancel'
            }
        })
        return alert == 'confirm'
    end
    
    -- フォールバック
    return true
end

--- スキルチェックを表示
--- @param difficulty string|table - 'easy'|'medium'|'hard' or custom
--- @return boolean
function Bridge.ShowSkillCheck(difficulty)
    -- ox_lib skillcheck
    if Config.DefaultSettings.skillcheck == "ox" and lib and lib.skillCheck then
        local config = difficulty
        if type(difficulty) == 'string' then
            if difficulty == 'easy' then
                config = {'easy', 'easy'}
            elseif difficulty == 'medium' then
                config = {'easy', 'medium'}
            elseif difficulty == 'hard' then
                config = {'medium', 'hard', 'hard'}
            end
        end
        return lib.skillCheck(config)
    
    -- ps-ui skillcheck
    elseif Config.DefaultSettings.skillcheck == "ps" then
        local success = false
        exports['ps-ui']:Circle(function(result)
            success = result
        end, 2, 10) -- 2 rounds, 10 seconds
        return success
    end
    
    -- フォールバック
    return true
end
