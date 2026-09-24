--=========================================================================================================
--                                    PROGRESS BAR (統合版)
--=========================================================================================================

--- プログレスバーを表示
--- @param data table
--- @return boolean - 成功したかどうか
function Bridge.ShowProgress(data)
    local success = false
    
    -- ox_lib progressbar
    if Config.DefaultSettings.progressbar == "ox" and lib and lib.progressBar then
        success = lib.progressBar({
            duration = data.duration,
            label = data.label,
            useWhileDead = data.useWhileDead or false,
            canCancel = data.canCancel ~= false,
            disable = data.disable or {
                move = true,
                car = true,
                combat = true,
                mouse = false,
            },
            anim = data.animation and {
                dict = data.animation.dict,
                clip = data.animation.anim,
                flag = data.animation.flag or 49,
                blendIn = data.animation.blendIn or 3.0,
                blendOut = data.animation.blendOut or 1.0,
            },
            prop = data.prop and {
                model = data.prop.model,
                bone = data.prop.bone,
                pos = data.prop.pos or vector3(0.0, 0.0, 0.0),
                rot = data.prop.rot or vector3(0.0, 0.0, 0.0),
            },
        })
    
    -- progressbar
    elseif Config.DefaultSettings.progressbar == "progressbar" then
        success = exports['progressbar']:Progress({
            name = data.name or "progress",
            duration = data.duration,
            label = data.label,
            useWhileDead = data.useWhileDead or false,
            canCancel = data.canCancel ~= false,
            controlDisables = data.disable or {
                disableMovement = true,
                disableCarMovement = true,
                disableMouse = false,
                disableCombat = true,
            },
            animation = data.animation and {
                animDict = data.animation.dict,
                anim = data.animation.anim,
                flags = data.animation.flag or 49,
            },
            prop = data.prop and {
                model = data.prop.model,
                bone = data.prop.bone,
                coords = data.prop.pos or vector3(0.0, 0.0, 0.0),
                rotation = data.prop.rot or vector3(0.0, 0.0, 0.0),
            },
        }, function(cancelled)
            success = not cancelled
        end)
        Wait(data.duration)
    
    -- qb-core progressbar
    elseif Bridge.FrameworkName == 'qbcore' and Config.DefaultSettings.progressbar == "qb" then
        Bridge.Framework.Functions.Progressbar(data.name or "progress", data.label, data.duration, data.useWhileDead or false, data.canCancel ~= false, {
            disableMovement = data.disable and data.disable.move ~= false or true,
            disableCarMovement = data.disable and data.disable.car ~= false or true,
            disableMouse = false,
            disableCombat = data.disable and data.disable.combat ~= false or true,
        }, data.animation and {
            animDict = data.animation.dict,
            anim = data.animation.anim,
            flags = data.animation.flag or 49,
        }, data.prop and {
            model = data.prop.model,
            bone = data.prop.bone,
            coords = data.prop.pos or vector3(0.0, 0.0, 0.0),
            rotation = data.prop.rot or vector3(0.0, 0.0, 0.0),
        }, {}, function()
            success = true
        end, function()
            success = false
        end)
        Wait(data.duration)
    
    -- esx progressbar
    elseif Bridge.FrameworkName == 'esx' and exports['esx_progressbar'] then
        exports['esx_progressbar']:Progressbar(data.label, data.duration, {
            FreezePlayer = data.disable and data.disable.move ~= false or true,
            animation = data.animation and {
                type = "anim",
                dict = data.animation.dict,
                lib = data.animation.anim,
            },
            onFinish = function()
                success = true
            end,
            onCancel = function()
                success = false
            end
        })
        Wait(data.duration)
    
    -- フォールバック (シンプルな待機)
    else
        if data.animation then
            local ped = PlayerPedId()
            RequestAnimDict(data.animation.dict)
            while not HasAnimDictLoaded(data.animation.dict) do
                Wait(10)
            end
            TaskPlayAnim(ped, data.animation.dict, data.animation.anim, 3.0, 3.0, -1, data.animation.flag or 49, 0, false, false, false)
        end
        
        Wait(data.duration)
        
        if data.animation then
            ClearPedTasks(PlayerPedId())
        end
        
        success = true
    end
    
    return success
end

--- プログレスバーをキャンセル
function Bridge.CancelProgress()
    if Config.DefaultSettings.progressbar == "ox" and lib and lib.cancelProgress then
        lib.cancelProgress()
    elseif Config.DefaultSettings.progressbar == "progressbar" then
        exports['progressbar']:Cancel()
    elseif Config.DefaultSettings.progressbar == "qb" then
        TriggerEvent('progressbar:client:cancel')
    end
end

--- プログレスバーが実行中かチェック
--- @return boolean
function Bridge.IsProgressActive()
    if Config.DefaultSettings.progressbar == "ox" and lib and lib.progressActive then
        return lib.progressActive()
    elseif Config.DefaultSettings.progressbar == "progressbar" then
        return exports['progressbar']:isDoingSomething()
    end
    return false
end
