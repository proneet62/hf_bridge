-- プレイヤーデータ取得
function Bridge.GetPlayer(source)
    if not Bridge.Framework then return nil end
    
    local success, player = pcall(function()
        if Bridge.Framework.Functions then -- QB-Core
            return Bridge.Framework.Functions.GetPlayer(source)
        elseif Bridge.Framework.GetPlayerFromId then -- ESX
            return Bridge.Framework.GetPlayerFromId(source)
        end
    end)
    
    if success then
        return player
    else
        print('[Bridge] ERROR: プレイヤーデータの取得に失敗しました - ' .. tostring(source))
        return nil
    end
end

-- プレイヤー識別子取得
function Bridge.GetIdentifier(source)
    local Player = Bridge.GetPlayer(source)
    if not Player then return nil end
    
    if Player.PlayerData and Player.PlayerData.citizenid then -- QB-Core
        return Player.PlayerData.citizenid
    elseif Player.identifier then -- ESX
        return Player.identifier
    end
    return nil
end

-- プレイヤーライセンス取得
function Bridge.GetLicense(source)
    local Player = Bridge.GetPlayer(source)

    -- Player 生成済みならフレームワークのデータを優先(playerConnecting の仮 source やキャラ選択中は Player が nil)
    if Player then
        -- QB-Core
        if Player.PlayerData then
            -- QB-Core はライセンスを PlayerData.license に格納している場合が多い
            if Player.PlayerData.license then
                return Player.PlayerData.license
            end
            -- metadata 内に格納されているケース
            if Player.PlayerData.metadata and Player.PlayerData.metadata.license then
                return Player.PlayerData.metadata.license
            end
        end

        -- ESX
        if Player.identifier then
            -- ESX の identifier は通常 "license:xxxx" 形式
            if string.find(Player.identifier, "license:") then
                return Player.identifier
            end
        end
    end

    -- フォールバック: GetPlayerIdentifiers でライセンスを直接取得(Player 未生成でも取得できる)
    for i = 0, GetNumPlayerIdentifiers(source) - 1 do
        local id = GetPlayerIdentifier(source, i)
        if string.find(id, "license:") then
            return id
        end
    end

    return nil
end

-- プレイヤー名取得
function Bridge.GetPlayerName(source)
    local Player = Bridge.GetPlayer(source)
    
    if Player then
        if Player.PlayerData and Player.PlayerData.charinfo then -- QB-Core
            local charinfo = Player.PlayerData.charinfo
            return ('%s %s'):format(charinfo.firstname or '', charinfo.lastname or ''):gsub('^%s+', '')
        elseif Player.getName then -- ESX
            local success, name = pcall(Player.getName, Player)
            if success then return name end
        end
    end
    
    -- フォールバック
    return GetPlayerName(source) or 'Unknown'
end

-- ジョブ取得
function Bridge.GetJob(source)
    local Player = Bridge.GetPlayer(source)
    if not Player then return nil, nil, false end
    
    if Player.PlayerData and Player.PlayerData.job then -- QB-Core
        local job = Player.PlayerData.job
        return job.name, job.grade.level, job.onduty or false
    elseif Player.job then -- ESX
        return Player.job.name, Player.job.grade, Player.job.onDuty or false
    end
    return nil, nil, false
end

-- ジョブチェック
function Bridge.HasJob(source, jobName, minGrade)
    local job, grade = Bridge.GetJob(source)
    minGrade = minGrade or 0
    
    if not job then return false end
    
    -- 複数のジョブをチェック
    if type(jobName) == 'table' then
        for _, name in ipairs(jobName) do
            if job == name and grade >= minGrade then
                return true
            end
        end
        return false
    end
    
    return job == jobName and grade >= minGrade
end

-- ギャング取得 (QB-Core専用)
function Bridge.GetGang(source)
    local Player = Bridge.GetPlayer(source)
    if not Player then return nil, nil end
    
    if Player.PlayerData and Player.PlayerData.gang then -- QB-Core
        return Player.PlayerData.gang.name, Player.PlayerData.gang.grade.level
    end
    return nil, nil
end

-- プレイヤーが存在するかチェック
function Bridge.DoesPlayerExist(source)
    return Bridge.GetPlayer(source) ~= nil
end

-- 全プレイヤー取得
function Bridge.GetPlayers()
    local players = {}
    
    if Bridge.Framework and Bridge.Framework.Functions and Bridge.Framework.Functions.GetPlayers then -- QB-Core
        return Bridge.Framework.Functions.GetPlayers()
    elseif Bridge.Framework and Bridge.Framework.GetPlayers then -- ESX
        local xPlayers = Bridge.Framework.GetPlayers()
        for _, xPlayer in pairs(xPlayers) do
            table.insert(players, xPlayer.source)
        end
        return players
    else
        -- フォールバック
        for _, player in ipairs(GetPlayers()) do
            table.insert(players, tonumber(player))
        end
        return players
    end
end

-- gtaライセンスでアドミンチェック
function Bridge.IsAdmin(source, ids)
    local license = Bridge.GetLicense(source)
    if not license then return false end

    -- ids 未指定なら ri_admins convar(スペース区切りの license 列)を admin リストとして使う
    if not ids then
        ids = {}
        for lic in (GetConvar('ri_admins', '')):gmatch('%S+') do
            ids[#ids + 1] = lic
        end
    end

    for _, id in pairs(ids) do
        if id == license then return true end
    end
    return false
end