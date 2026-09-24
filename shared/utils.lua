--=========================================================================================================
--                                        UTILS MODULE (統合版)
--=========================================================================================================

--=========================================================================================================
--                                     DISTANCE & COORDINATE FUNCTIONS
--=========================================================================================================

--- 距離計算
--- @param coords1 vector3|table
--- @param coords2 vector3|table
--- @return number
function Bridge.GetDistance(coords1, coords2)
    return #(vector3(coords1.x, coords1.y, coords1.z) - vector3(coords2.x, coords2.y, coords2.z))
end

--=========================================================================================================
--                                     ERROR HANDLING (Try-Catch)
--=========================================================================================================

--- Try-Catch-Finally パターン実装
--- @param func function - 実行する関数
--- @return table - catch と finally メソッドを持つオブジェクト
function Bridge.Try(func)
    local self = {}
    self.func = func
    self._catch = nil
    self._finally = nil

    --- エラーハンドラーを設定
    --- @param handler function
    --- @return table
    function self.catch(handler)
        self._catch = handler
        return self
    end

    --- 最終処理を設定
    --- @param handler function
    --- @return table
    function self.finally(handler)
        self._finally = handler
        return self
    end

    -- 実行
    local status, result = pcall(self.func)
    
    if not status and self._catch then
        self._catch(result) -- result はエラーメッセージ
    end

    if self._finally then
        self._finally()
    end
    
    return self
end

--- pcall のラッパー (シンプル版)
--- @param func function
--- @param ... any - 関数の引数
--- @return boolean, any - success, result or error
function Bridge.SafeCall(func, ...)
    return pcall(func, ...)
end

--=========================================================================================================
--                                     TABLE UTILITIES
--=========================================================================================================

--- テーブルが空かチェック
--- @param tbl table
--- @return boolean
function Bridge.IsTableEmpty(tbl)
    if type(tbl) ~= "table" then return true end
    return next(tbl) == nil
end

--- テーブルのディープコピー
--- @param orig table
--- @return table
function Bridge.DeepCopy(orig)
    local orig_type = type(orig)
    local copy
    if orig_type == 'table' then
        copy = {}
        for orig_key, orig_value in next, orig, nil do
            copy[Bridge.DeepCopy(orig_key)] = Bridge.DeepCopy(orig_value)
        end
        setmetatable(copy, Bridge.DeepCopy(getmetatable(orig)))
    else
        copy = orig
    end
    return copy
end

--- テーブルに値が含まれているかチェック
--- @param tbl table
--- @param value any
--- @return boolean
function Bridge.TableContains(tbl, value)
    if type(tbl) ~= "table" then return false end
    for _, v in pairs(tbl) do
        if v == value then return true end
    end
    return false
end

--- テーブルのキーを取得
--- @param tbl table
--- @return table
function Bridge.GetTableKeys(tbl)
    if type(tbl) ~= "table" then return {} end
    local keys = {}
    for k, _ in pairs(tbl) do
        table.insert(keys, k)
    end
    return keys
end

--=========================================================================================================
--                                     STRING UTILITIES
--=========================================================================================================

--- 文字列を分割
--- @param str string
--- @param delimiter string
--- @return table
function Bridge.SplitString(str, delimiter)
    local result = {}
    delimiter = delimiter or "%s"
    for match in (str .. delimiter):gmatch("(.-)" .. delimiter) do
        table.insert(result, match)
    end
    return result
end

--- 文字列をトリム
--- @param str string
--- @return string
function Bridge.Trim(str)
    if type(str) ~= "string" then return "" end
    return str:match("^%s*(.-)%s*$")
end

--- 文字列の最初の文字を大文字に
--- @param str string
--- @return string
function Bridge.Capitalize(str)
    if type(str) ~= "string" or str == "" then return "" end
    return str:sub(1, 1):upper() .. str:sub(2)
end

--=========================================================================================================
--                                     NUMBER UTILITIES
--=========================================================================================================

--- 数値を指定範囲内にクランプ
--- @param value number
--- @param min number
--- @param max number
--- @return number
function Bridge.Clamp(value, min, max)
    if value < min then return min end
    if value > max then return max end
    return value
end

--- 数値を丸める
--- @param value number
--- @param decimals number
--- @return number
function Bridge.Round(value, decimals)
    decimals = decimals or 0
    local mult = 10 ^ decimals
    return math.floor(value * mult + 0.5) / mult
end

--- ランダムな数値を生成
--- @param min number
--- @param max number
--- @return number
function Bridge.Random(min, max)
    return math.random(min, max)
end

--=========================================================================================================
--                                     TIME UTILITIES
--=========================================================================================================

--- ミリ秒を時分秒に変換
--- @param ms number
--- @return number, number, number - hours, minutes, seconds
function Bridge.MsToTime(ms)
    local seconds = math.floor(ms / 1000)
    local minutes = math.floor(seconds / 60)
    local hours = math.floor(minutes / 60)
    
    seconds = seconds % 60
    minutes = minutes % 60
    
    return hours, minutes, seconds
end

--- 時分秒を文字列に変換
--- @param hours number
--- @param minutes number
--- @param seconds number
--- @return string
function Bridge.FormatTime(hours, minutes, seconds)
    return string.format("%02d:%02d:%02d", hours, minutes, seconds)
end

--=========================================================================================================
--                                     MATH UTILITIES
--=========================================================================================================

--- 線形補間
--- @param a number
--- @param b number
--- @param t number - 0.0 to 1.0
--- @return number
function Bridge.Lerp(a, b, t)
    return a + (b - a) * t
end

--- 2点間の角度を計算
--- @param x1 number
--- @param y1 number
--- @param x2 number
--- @param y2 number
--- @return number - ラジアン
function Bridge.GetAngleBetweenPoints(x1, y1, x2, y2)
    return math.atan2(y2 - y1, x2 - x1)
end

--=========================================================================================================
--                                     LOCALE FUNCTIONS (多言語対応)
--=========================================================================================================

--- ローカライズされたテキストを取得
--- @param key string - ロケールキー
--- @param ... any - フォーマット引数（オプション）
--- @return string
function Bridge.GetLocaleText(key, ...)
    local lang = Config.Lang or 'en'
    local text = nil
    
    -- 指定言語から取得
    if Locales[lang] and Locales[lang][key] then
        text = Locales[lang][key]
    -- フォールバック: 英語
    elseif Locales['en'] and Locales['en'][key] then
        text = Locales['en'][key]
    -- 見つからない場合
    else
        return "Missing locale: " .. key
    end
    
    -- 変数置換（%s, %d など）
    if select('#', ...) > 0 then
        local success, result = pcall(string.format, text, ...)
        if success then
            return result
        end
    end
    
    return text
end

--- 短縮エイリアス
--- @param key string
--- @param ... any
--- @return string
function Bridge.L(key, ...)
    return Bridge.GetLocaleText(key, ...)
end

--- 現在の言語を取得
--- @return string
function Bridge.GetCurrentLang()
    return Config.Lang or 'en'
end

--- 言語を変更
--- @param lang string
function Bridge.SetLang(lang)
    if Locales[lang] then
        Config.Lang = lang
        print('[Bridge] Language changed to: ' .. lang)
    else
        print('[Bridge ERROR] Language not found: ' .. lang)
    end
end

--- 利用可能な言語一覧を取得
--- @return table
function Bridge.GetAvailableLanguages()
    local langs = {}
    for lang, _ in pairs(Locales) do
        table.insert(langs, lang)
    end
    return langs
end

--- カスタムロケールを追加
--- @param lang string
--- @param key string
--- @param value string
function Bridge.AddLocale(lang, key, value)
    if not Locales[lang] then
        Locales[lang] = {}
    end
    Locales[lang][key] = value
end

--- 複数のカスタムロケールを一括追加
--- @param lang string
--- @param locales table
function Bridge.AddLocales(lang, locales)
    if not Locales[lang] then
        Locales[lang] = {}
    end
    for key, value in pairs(locales) do
        Locales[lang][key] = value
    end
end
