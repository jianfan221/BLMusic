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
SettingsPanel:HookScript("OnHide", function()
    ns.StopCurrentMusic()
end)

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
-- 当前活跃的嗜血 auraInstanceID（同一时间只会存在一个）
local activeAuraInstanceID

-- 初始扫描：进入世界时检查是否已有嗜血 debuff（如重载前就在）
EventRegistry:RegisterFrameEventAndCallback("PLAYER_ENTERING_WORLD", function()
    activeAuraInstanceID = nil
    for spellID in pairs(BLOODLUST_DEBUFFS) do
        local aura = C_UnitAuras.GetUnitAuraBySpellID("player", spellID)
        if aura and (not issecretvalue or not issecretvalue(aura.spellId)) then
            activeAuraInstanceID = aura.auraInstanceID
            return
        end
    end
end)

-- UNIT_AURA 回调: 检测嗜血类 buff 到达/结束
EventRegistry:RegisterFrameEventAndCallback("UNIT_AURA", function(event, unit, updateInfo)
    if unit ~= "player" or not updateInfo then
        return
    end

    -- 新增 debuff → 播开始音频（跳过秘密值 spellId，无法判断）
    if updateInfo.addedAuras then
        for _, aura in ipairs(updateInfo.addedAuras) do
            if (not issecretvalue or not issecretvalue(aura.spellId)) and BLOODLUST_DEBUFFS[aura.spellId] then
                activeAuraInstanceID = aura.auraInstanceID
                if (aura.expirationTime - GetTime()) > 595 then
                    ns.PlayStartMusic()
                end
                return
            end
        end
    end

    -- 移除 debuff → 播结束音频
    if updateInfo.removedAuraInstanceIDs and activeAuraInstanceID then
        for _, id in ipairs(updateInfo.removedAuraInstanceIDs) do
            if id == activeAuraInstanceID then
                activeAuraInstanceID = nil
                ns.PlayEndMusic()
                return
            end
        end
    end
end)
