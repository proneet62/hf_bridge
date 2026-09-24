-- 所持金取得
function Bridge.GetMoney(source, moneyType)
    local Player = Bridge.GetPlayer(source)
    if not Player then return 0 end
    
    moneyType = moneyType or 'cash'
    
    if Player.PlayerData then -- QB-Core
        if moneyType == 'cash' then
            return Player.PlayerData.money.cash or 0
        elseif moneyType == 'bank' then
            return Player.PlayerData.money.bank or 0
        end
    elseif Player.getAccount then -- ESX
        local account = Player.getAccount(moneyType)
        return account and account.money or 0
    end
    return 0
end

-- お金を追加
function Bridge.AddMoney(source, amount, moneyType, reason)
    local Player = Bridge.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or 'cash'
    
    if Player.Functions then -- QB-Core
        Player.Functions.AddMoney(moneyType, amount, reason)
        return true
    elseif Player.addAccountMoney then -- ESX
        Player.addAccountMoney(moneyType, amount)
        return true
    end
    return false
end

-- お金を削除
function Bridge.RemoveMoney(source, amount, moneyType, reason)
    local Player = Bridge.GetPlayer(source)
    if not Player then return false end
    
    moneyType = moneyType or 'cash'
    
    if Player.Functions then -- QB-Core
        return Player.Functions.RemoveMoney(moneyType, amount, reason)
    elseif Player.removeAccountMoney then -- ESX
        Player.removeAccountMoney(moneyType, amount)
        return true
    end
    return false
end
