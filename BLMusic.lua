--- BLMusic - 嗜血/英勇/时间扭曲时自动播放音频
local _, ns = ...

-- ==================== 嗜血DEBUFF列表 ====================
local BLOODLUST_DEBUFFS = {
    [57723] = true,  -- 疲劳（联盟嗜血后）
    [57724] = true,  -- 心满意足（部落嗜血后）
    [80354] = true,  -- 时间错乱（法师时间扭曲）
    [95809] = true,  -- 癫狂（猎人远古狂乱）
    [160455] = true, -- 疲劳（猎人原始狂怒）
    [264689] = true, -- 疲劳（猎人原始狂怒变体）
    [390435] = true, -- 疲劳（唤魔师巨龙之怒）
}


local MUSIC_PATH = "Interface\\AddOns\\BLMusic\\Media\\"

-- 当前播放的音频句柄
local soundHandle
-- 自动停止计时器
local stopTimer

-- 停止当前播放的音频
function ns.StopCurrentMusic()
    if stopTimer then
        stopTimer:Cancel()
        stopTimer = nil
    end
    if soundHandle then
        StopSound(soundHandle)
        soundHandle = nil
    end
end

--死亡时停止
EventRegistry:RegisterFrameEventAndCallback("PLAYER_DEAD", function()
    ns.StopCurrentMusic()
end)

-- 重载/退出时立即停止音频
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LEAVING_WORLD", function()
    ns.StopCurrentMusic()
end)

--关闭设置界面时停止,防止存在试听
if SettingsPanel then
    SettingsPanel:HookScript("OnHide", function()
        ns.StopCurrentMusic()
    end)
end

-- 从选中的音频 table 中随机取一个路径
function ns.GetRandomPathFromSelected(selectedTbl)
    if not selectedTbl then return nil end
    local paths = {}
    for path in pairs(selectedTbl) do
        tinsert(paths, path)
    end
    if #paths == 0 then return nil end
    return paths[math.random(#paths)]
end

-- 播放指定音频文件（用于预览）
function ns.PlayMusicFile(file, duration)
    if not file or file == "" then return end
    ns.StopCurrentMusic()

    local path
    if file == "123.mp3" then
        path = "Interface\\123.mp3"
    elseif file == "123.ogg" then
        path = "Interface\\123.ogg"
    elseif file == "456.mp3" then
        path = "Interface\\456.mp3"
    elseif file == "456.ogg" then
        path = "Interface\\456.ogg"
    else
        path = MUSIC_PATH .. file
    end

    local _, handle = PlaySoundFile(path, BLMusicDB.channel or "Master")
    if handle then
        soundHandle = handle
        if duration and duration > 0 then
            stopTimer = C_Timer.NewTimer(duration, function()
                ns.StopCurrentMusic()
            end)
        end
    end
end

-- 播放开始音频（从选中的音频中随机选取）
function ns.PlayStartMusic()
    if not BLMusicDB.enabled then
        return
    end
    local file = ns.GetRandomPathFromSelected(BLMusicDB.startMusicFiles)
    if file then
        ns.PlayMusicFile(file, BLMusicDB.startDuration)
    end
end

-- 播放结束音频（从选中的音频中随机选取）
function ns.PlayEndMusic()
    if not BLMusicDB.enabled then
        return
    end
    local file = ns.GetRandomPathFromSelected(BLMusicDB.endMusicFiles)
    if file then
        ns.PlayMusicFile(file, BLMusicDB.endDuration)
    end
end

-- 当前是否有嗜血 debuff
local hasBloodlust = nil  -- nil=未知, true=有, false=无

local function CheckBloodlustExpiration()
    for spellID in pairs(BLOODLUST_DEBUFFS) do
        local aura = C_UnitAuras.GetPlayerAuraBySpellID(spellID)
        if aura and aura.expirationTime then
            return aura.expirationTime - GetTime()
        end
    end
    return nil
end

-- 注册能量灌注声音提醒
local haspisound    -- 已注册的音频 ID，用于移除旧注册
local pisoundDeferred  -- 战斗中已推迟注册的标志
function ns.pisound(test)
    if not C_UnitAuras.AddAuraSound then return end

    --战斗中推迟到脱战后执行
    if not pisoundDeferred and UnitAffectingCombat("player") then
        pisoundDeferred = true
        EventRegistry:RegisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", function(self)
            EventRegistry:UnregisterFrameEventAndCallback("PLAYER_REGEN_ENABLED", self)
            pisoundDeferred = false
            ns.pisound(test)
        end)
        return
    end

    -- 先移除旧注册
    if haspisound then
        C_UnitAuras.RemoveAuraSound(haspisound)
        haspisound = nil
    end

    local pipath = BLMusicDB.piMusicFile
    if not pipath or pipath == "" then
        return
    end

    local fullPath = MUSIC_PATH .. pipath
    if test then
        PlaySoundFile(fullPath, BLMusicDB.channel or "Master")
    end
    haspisound = C_UnitAuras.AddAuraSound(Enum.UnitAuraSoundTrigger.Added, {
        unitToken = "player",
        spellID = 10060,  -- 能量灌注 (Power Infusion)
        soundFileName = fullPath,
        outputChannel = BLMusicDB.channel or "Master",
    })
end

-- 初始扫描：检查是否已有嗜血 debuff
EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function()
    local remaining = CheckBloodlustExpiration()
    hasBloodlust = remaining ~= nil
    ns.pisound()
end)

-- UNIT_AURA 回调（12.1 起不读取 updateInfo 载荷）
EventRegistry:RegisterFrameEventAndCallback("UNIT_AURA", function(event, unit)
    if unit ~= "player" then
        return
    end

    local remaining = CheckBloodlustExpiration()
    local now = remaining ~= nil
    if now == hasBloodlust then
        return
    end

    hasBloodlust = now
    if now and remaining and remaining > 595 then
        ns.PlayStartMusic()
    elseif not now then
        ns.PlayEndMusic()
    end
end)