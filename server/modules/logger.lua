--=========================================================================================================
--                                        LOGGER MODULE (統合版)
--=========================================================================================================

-- ========== Helper Functions ==========
local function toDiscordColor(color)
    if type(color) == "number" then return color end
    if type(color) ~= "string" then return nil end
    
    -- 0xRRGGBB / #RRGGBB どちらも許容
    local hex = color:gsub("^0x", ""):gsub("^#", "")
    local n = tonumber(hex, 16)
    return n
end

local function toFields(payload)
    -- 文字列だけ来たら1フィールドに包む
    if type(payload) == "string" then
        return { { name = "Info", value = payload, inline = false } }
    end
    -- 既に fields 配列を想定
    if type(payload) == "table" then return payload end
    return nil
end

--=========================================================================================================
--                                     BASIC LOG FUNCTION
--=========================================================================================================

--- 基本的なログ記録
--- @param source number
--- @param action string
--- @param message string
--- @param data table|nil
function Bridge.Log(source, action, message, data)
    local logData = {
        source = source,
        identifier = Bridge.GetIdentifier(source),
        playerName = Bridge.GetPlayerName(source),
        action = action,
        message = message,
        data = data or {},
        timestamp = os.date('%Y-%m-%d %H:%M:%S')
    }
    
    -- qb-logs連携
    if GetResourceState('qb-logs') == 'started' then
        TriggerEvent('qb-log:server:CreateLog', 'default', action, 'green', message, false)
    end
    
    print(('[Bridge Log] %s - %s: %s'):format(logData.timestamp, action, message))
    
    return logData
end

--=========================================================================================================
--                                  DISCORD WEBHOOK (強化版)
--=========================================================================================================

--- Discord Webhook送信 (シンプル版 - 後方互換性維持)
--- @param webhook string
--- @param title string
--- @param message string
--- @param color number|string
function Bridge.SendWebhook(webhook, title, message, color)
    if not webhook or webhook == "" then
        print("[Bridge ERROR] Discord Webhook が設定されていません")
        return
    end
    
    color = toDiscordColor(color) or 3447003
    
    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        embeds = {{
            title = title,
            description = message,
            color = color,
            footer = {
                text = os.date('%Y-%m-%d %H:%M:%S')
            }
        }}
    }), { ['Content-Type'] = 'application/json' })
end

--- Discord Embed ログ送信 (高機能版)
--- @param webhook string
--- @param botName string
--- @param title string
--- @param fields_or_message table|string - { {name=..., value=..., inline=?}, ... } or plain string
--- @param color number|string - 0xRRGGBB or "#RRGGBB" or number
function Bridge.SendDiscordLog(webhook, botName, title, fields_or_message, color)
    if not webhook or webhook == "" or webhook == "YOUR_WEBHOOK_HERE" then
        print("[Bridge ERROR] Discord Webhook が設定されていません")
        return
    end

    local fields = toFields(fields_or_message)
    local rgb = toDiscordColor(color) or 0x2F3136

    local embed = {
        {
            title = title or "",
            timestamp = os.date('!%Y-%m-%dT%H:%M:%SZ'),
            fields = fields,
            color = rgb
        }
    }

    PerformHttpRequest(webhook, function(err, text, headers) end, 'POST', json.encode({
        username = botName or "Bridge Logger",
        embeds = embed
    }), { ['Content-Type'] = 'application/json' })
end

--- プレイヤーアクションをDiscordにログ送信
--- @param source number
--- @param webhook string
--- @param action string
--- @param details string|table
--- @param color number|string|nil
function Bridge.LogPlayerAction(source, webhook, action, details, color)
    local playerName = Bridge.GetPlayerName(source)
    local identifier = Bridge.GetIdentifier(source)
    local job, grade = Bridge.GetJob(source)
    
    local fields = {
        { name = "プレイヤー", value = playerName, inline = true },
        { name = "識別子", value = identifier or "N/A", inline = true },
        { name = "ジョブ", value = job and string.format("%s (Grade %s)", job, grade) or "N/A", inline = true },
    }
    
    -- details が文字列の場合
    if type(details) == "string" then
        table.insert(fields, { name = "詳細", value = details, inline = false })
    -- details がテーブルの場合
    elseif type(details) == "table" then
        for _, field in ipairs(details) do
            table.insert(fields, field)
        end
    end
    
    Bridge.SendDiscordLog(webhook, "Player Actions", action, fields, color or 0x3498DB)
end
