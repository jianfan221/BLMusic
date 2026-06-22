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
EventRegistry:RegisterFrameEventAndCallback("PLAYER_DEAD", function()
    ns.StopCurrentMusic()
end)

-- 重载/退出时立即停止音频
EventRegistry:RegisterFrameEventAndCallback("PLAYER_LEAVING_WORLD", function()
    ns.StopCurrentMusic()
end)

-- 播放开始音频
function ns.PlayStartMusic()
    if not BLMusicDB.enabled then
        return
    end

    ns.StopCurrentMusic()

    local file = BLMusicDB.startMusicFile
    if not file or file == "" then
        return
    end

    local _, handle = PlaySoundFile(MUSIC_PATH .. file, BLMusicDB.channel or "Master")
    if handle then
        soundHandle = handle
        if BLMusicDB.startDuration and BLMusicDB.startDuration > 0 then
            stopTimer = C_Timer.NewTimer(BLMusicDB.startDuration, function()
                ns.StopCurrentMusic()
            end)
        end
    end
end

-- 播放结束音频
function ns.PlayEndMusic()
    if not BLMusicDB.enabled then
        return
    end

    ns.StopCurrentMusic()

    local file = BLMusicDB.endMusicFile
    if not file or file == "" then
        return
    end

    local _, handle = PlaySoundFile(MUSIC_PATH .. file, BLMusicDB.channel or "Master")
    if handle then
        soundHandle = handle
        if BLMusicDB.endDuration and BLMusicDB.endDuration > 0 then
            stopTimer = C_Timer.NewTimer(BLMusicDB.endDuration, function()
                ns.StopCurrentMusic()
            end)
        end
    end
end
-- 当前活跃的嗜血 auraInstanceID（同一时间只会存在一个）
local activeAuraInstanceID

-- UNIT_AURA 回调: 检测嗜血类 buff 到达/结束
EventRegistry:RegisterFrameEventAndCallback("UNIT_AURA", function(event, unit, updateInfo)
    if unit ~= "player" or not updateInfo then
        return
    end

    -- isFullUpdate: 只刷新缓存
    if updateInfo.isFullUpdate then
        activeAuraInstanceID = nil
        for spellID in pairs(BLOODLUST_DEBUFFS) do
            local aura = C_UnitAuras.GetUnitAuraBySpellID(unit, spellID)
            if aura then
                activeAuraInstanceID = aura.auraInstanceID
                return
            end
        end
        return
    end

    -- 新增 debuff → 播开始音频（跳过秘密值 spellId，无法判断）
    if updateInfo.addedAuras then
        for _, aura in ipairs(updateInfo.addedAuras) do
            if (not issecretvalue or not issecretvalue(aura.spellId)) and BLOODLUST_DEBUFFS[aura.spellId] then
                activeAuraInstanceID = aura.auraInstanceID
                ns.PlayStartMusic()
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
