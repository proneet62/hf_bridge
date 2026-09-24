--=========================================================================================================
--                                    SOCIETY & GANG MONEY SYSTEM
--=========================================================================================================

--- ソサエティ(会社)の資金を取得
--- @param society string
--- @param callback function
function Bridge.GetSocietyMoney(society, callback)
    if Bridge.FrameworkName == 'esx' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
            if account then
                callback(account.money)
            else
                callback(0)
            end
        end)
    elseif Bridge.FrameworkName == 'qbcore' then
        local result = exports['qb-management']:GetAccount(society)
        callback(result or 0)
    else
        callback(0)
    end
end

--- ソサエティに資金を追加
--- @param society string
--- @param amount number
--- @return boolean
function Bridge.AddSocietyMoney(society, amount)
    if Bridge.FrameworkName == 'esx' then
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
            if account then
                account.addMoney(amount)
            end
        end)
        return true
    elseif Bridge.FrameworkName == 'qbcore' then
        exports['qb-management']:AddMoney(society, amount)
        return true
    end
    return false
end

--- ソサエティから資金を削除
--- @param society string
--- @param amount number
--- @return boolean
function Bridge.RemoveSocietyMoney(society, amount)
    if Bridge.FrameworkName == 'esx' then
        local success = false
        TriggerEvent('esx_addonaccount:getSharedAccount', 'society_' .. society, function(account)
            if account and account.money >= amount then
                account.removeMoney(amount)
                success = true
            end
        end)
        return success
    elseif Bridge.FrameworkName == 'qbcore' then
        return exports['qb-management']:RemoveMoney(society, amount)
    end
    return false
end

--- ギャングの資金を取得 (QB-Core専用)
--- @param gang string
--- @return number
function Bridge.GetGangMoney(gang)
    if Bridge.FrameworkName == 'qbcore' then
        local result = exports['qb-management']:GetGangAccount(gang)
        return result or 0
    end
    return 0
end

--- ギャングに資金を追加 (QB-Core専用)
--- @param gang string
--- @param amount number
--- @return boolean
function Bridge.AddGangMoney(gang, amount)
    if Bridge.FrameworkName == 'qbcore' then
        exports['qb-management']:AddGangMoney(gang, amount)
        return true
    end
    return false
end

--- ギャングから資金を削除 (QB-Core専用)
--- @param gang string
--- @param amount number
--- @return boolean
function Bridge.RemoveGangMoney(gang, amount)
    if Bridge.FrameworkName == 'qbcore' then
        return exports['qb-management']:RemoveGangMoney(gang, amount)
    end
    return false
end

--=========================================================================================================
--                                    BANKING SYSTEM
--=========================================================================================================

--- 銀行口座を取得
--- @param source number
--- @return number
function Bridge.GetBankMoney(source)
    return Bridge.GetMoney(source, 'bank')
end

--- 銀行口座に入金
--- @param source number
--- @param amount number
--- @param reason string|nil
--- @return boolean
function Bridge.AddBankMoney(source, amount, reason)
    return Bridge.AddMoney(source, amount, 'bank', reason)
end

--- 銀行口座から出金
--- @param source number
--- @param amount number
--- @param reason string|nil
--- @return boolean
function Bridge.RemoveBankMoney(source, amount, reason)
    return Bridge.RemoveMoney(source, amount, 'bank', reason)
end

--- プレイヤー間で送金
--- @param source number
--- @param target number
--- @param amount number
--- @param reason string|nil
--- @return boolean
function Bridge.TransferMoney(source, target, amount, reason)
    if Bridge.GetBankMoney(source) >= amount then
        if Bridge.RemoveBankMoney(source, amount, reason) then
            Bridge.AddBankMoney(target, amount, reason)
            return true
        end
    end
    return false
end

--- オフライン入金 (識別子ベース)
--- @param identifier string
--- @param amount number
--- @param moneyType string
--- @return boolean
function Bridge.AddMoneyOffline(identifier, amount, moneyType)
    moneyType = moneyType or 'bank'
    
    if Bridge.FrameworkName == 'qbcore' then
        local result = MySQL.scalar.await('SELECT money FROM players WHERE citizenid = ?', {identifier})
        if result then
            local money = json.decode(result)
            money[moneyType] = (money[moneyType] or 0) + amount
            MySQL.update.await('UPDATE players SET money = ? WHERE citizenid = ?', {json.encode(money), identifier})
            return true
        end
    elseif Bridge.FrameworkName == 'esx' then
        MySQL.update.await('UPDATE users SET bank = bank + ? WHERE identifier = ?', {amount, identifier})
        return true
    end
    return false
end
