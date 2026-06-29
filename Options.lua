--- BLMusic 设置界面
local addonName, ns = ...

-- 弹出可复制文字的小窗
do
    local frame
    function ns.ShowContactPopup()
        if frame and frame:IsShown() then
            frame:Raise()
            return
        end
        if not frame then
            frame = CreateFrame("Frame", nil, UIParent, "BackdropTemplate")
            frame:SetSize(420, 220)
            frame:SetBackdrop({
                bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
                edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
                tile = true, tileSize = 16, edgeSize = 16,
                insets = { left = 4, right = 4, top = 4, bottom = 4 },
            })
            frame:SetBackdropColor(0, 0, 0, 0.8)
            frame:SetBackdropBorderColor(0, 0, 0, 1)
            frame:SetPoint("CENTER")
            frame:SetFrameStrata("DIALOG")
            frame:EnableMouse(true)

            -- 标题
            local title = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
            title:SetPoint("TOP", 0, -20)
            title:SetText(ns.L["联系作者"])

            -- 可复制文本框（ScrollFrame + InputScrollFrameTemplate，自带滚动条）
            local scrollFrame = CreateFrame("ScrollFrame", nil, frame, "InputScrollFrameTemplate")
            scrollFrame:SetPoint("TOPLEFT", 20, -50)
            scrollFrame:SetPoint("BOTTOMRIGHT", -20, 50)
            scrollFrame.EditBox:SetFontObject(GameFontHighlightSmall)
            scrollFrame.EditBox:SetMultiLine(true)
            scrollFrame.EditBox:SetMaxLetters(0)
            scrollFrame.EditBox:SetText(ns.L["联系弹窗内容"])
            scrollFrame.EditBox:SetAutoFocus(true)
            scrollFrame.EditBox:SetScript("OnEditFocusGained", function(self)
                self:HighlightText()
            end)
            scrollFrame.EditBox:SetScript("OnTextChanged", function(self)
                if self:GetText() ~= scrollFrame.EditBoxText then
                    self:SetText(scrollFrame.EditBoxText)
                    self:HighlightText()
                end
            end)
            scrollFrame.EditBoxText = scrollFrame.EditBox:GetText()

            -- 关闭按钮
            local closeBtn = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            closeBtn:SetSize(80, 25)
            closeBtn:SetPoint("BOTTOM", 0, 20)
            closeBtn:SetText(CLOSE)
            closeBtn:SetScript("OnClick", function()
                frame:Hide()
            end)
        end
        frame:Show()
    end
end

-- 默认配置
local defaults = {
    enabled = true,
    channel = "Master",
    startMusicFiles = {},
    endMusicFiles = {},
    startDuration = 40,
    endDuration = 10,
}

-- 初始化 DB
local function InitDB()
    if type(BLMusicDB) ~= "table" then
        BLMusicDB = {}
    end
    for k, v in pairs(defaults) do
        if BLMusicDB[k] == nil then
            BLMusicDB[k] = v
        end
    end
end
EventRegistry:RegisterFrameEventAndCallback("ADDON_LOADED", function(event, loadedAddonName)
    if loadedAddonName ~= addonName then
        return
    end
    InitDB()
end)

local category, layout = Settings.RegisterVerticalLayoutCategory("BLMusic")
Settings.RegisterAddOnCategory(category)

-- 隐藏"恢复默认"按钮（插件设置不需要重置 CVar）
do
    local catID = category:GetID()
    hooksecurefunc(SettingsPanel, "DisplayCategory", function(self, cat)
        local btn = self:GetSettingsList().Header.DefaultsButton
        if btn then
            btn:Show()
            if cat and cat:GetID() == catID then
                btn:Hide()
            end
        end
    end)
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(
    ns.L["简单便捷的嗜血播放音频插件"], ns.L["/bl 或 /blm 打开此界面"]))


local channelOptions = {
    { value = "Master", text = MASTER_VOLUME },
    { value = "Music", text = MUSIC_VOLUME },
    { value = "SFX", text = FX_VOLUME },
    { value = "Ambience", text = AMBIENCE_VOLUME },
    { value = "Dialog", text = DIALOG_VOLUME },
}

--#region 音频通道和音量设置
local volumeSetting, volumeInitializer
local channelVolumeCVars = {
    Master  = "Sound_MasterVolume",
    Music   = "Sound_MusicVolume",
    SFX     = "Sound_SFXVolume",
    Ambience = "Sound_AmbienceVolume",
    Dialog  = "Sound_DialogVolume",
}
-- 音量滑块（直接读写当前通道的 CVar）
do
    local options = Settings.CreateSliderOptions(0, 100, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return ("%d%%"):format(value)
    end)

    local function GetVolume()
        local cvar = channelVolumeCVars[BLMusicDB.channel]
        return cvar and tonumber(C_CVar.GetCVar(cvar)) * 100 or 80
    end

    volumeSetting = Settings.RegisterProxySetting(category, "BLMUSIC_VOLUME",
        Settings.VarType.Number, ns.L["当前通道音量"], 80,
        GetVolume,
        function(value)
            local cvar = channelVolumeCVars[BLMusicDB.channel]
            if cvar then
                C_CVar.SetCVar(cvar, value / 100)
            end
        end)
    volumeInitializer = Settings.CreateSlider(category, volumeSetting, options, ns.L["当前音频通道的音量和快捷调整"])
end
--音频通道
do
    local function GetOptions()
        local container = Settings.CreateControlTextContainer()
        for _, v in ipairs(channelOptions) do
            container:Add(v.value, v.text)
        end
        return container:GetData()
    end

    local channelSetting = Settings.RegisterProxySetting(category, "BLMUSIC_CHANNEL",
        Settings.VarType.String, ns.L["音频通道"], defaults.channel,
        function() return BLMusicDB.channel end,
        function(value)
            BLMusicDB.channel = value
        end)
    channelSetting:SetValueChangedCallback(function()
        local cvar = channelVolumeCVars[BLMusicDB.channel]
        if cvar and volumeSetting then
            volumeSetting:SetValue(tonumber(GetCVar(cvar)) * 100)
            if volumeInitializer and volumeInitializer.RefreshDisplay then
                volumeInitializer:RefreshDisplay()
            end
        end
    end)
    Settings.CreateDropdown(category, channelSetting, GetOptions, ns.L["选择音频播放的通道"])
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(ns.L["试听"]))

-- 试听（一行两个按钮）
local previewInit = CreateSettingsButtonInitializer(
    ns.L["试听"],
    " ",
    function() end,
    nil, true)
if previewInit.InitFrame then
    hooksecurefunc(previewInit, "InitFrame", function(_, frame)
        if not frame.Button then return end
        frame.Button:Hide()
        if not frame.blmPreviewRow then
            frame.blmPreviewRow = true
            frame.btn1 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            frame.btn1:SetPoint("LEFT", 277, 0)
            frame.btn1:SetSize(100, 24)
            frame.btn1:SetText(ns.L["试听开始"])
            frame.btn1:SetScript("OnClick", function() ns.PlayStartMusic() end)
            frame.btn2 = CreateFrame("Button", nil, frame, "UIPanelButtonTemplate")
            frame.btn2:SetPoint("LEFT", 377, 0)
            frame.btn2:SetSize(100, 24)
            frame.btn2:SetText(ns.L["试听可用"])
            frame.btn2:SetScript("OnClick", function() ns.PlayEndMusic() end)
            -- 框架回收时隐藏按钮，防止挂到别的选项上
            frame:HookScript("OnHide", function()
                if frame.btn1 then frame.btn1:Hide() end
                if frame.btn2 then frame.btn2:Hide() end
            end)
        end
        -- 每次展示时重新显示
        frame.btn1:Show()
        frame.btn2:Show()
    end)
end
layout:AddInitializer(previewInit)

local stopBtnInit = CreateSettingsButtonInitializer(
    ns.L["停止播放"],
    ns.L["停止播放"],
    function() ns.StopCurrentMusic() end,
    nil, true)
if stopBtnInit.InitFrame then
    hooksecurefunc(stopBtnInit, "InitFrame", function(_, frame)
        if frame.Button then
                frame.Button:SetText(ns.L["停止播放"])
                frame.Button:Show()
            end
        end)
    end
layout:AddInitializer(stopBtnInit)

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(ns.L["选择音频"]))

do
    local options = Settings.CreateSliderOptions(1, 50, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return GARRISON_DURATION_SECONDS:format(value)
    end)

    local setting = Settings.RegisterProxySetting(category, "BLMUSIC_DURATION",
        Settings.VarType.Number, ns.L["开始音频持续时间"], defaults.startDuration,
        function() return BLMusicDB.startDuration end,
        function(value) BLMusicDB.startDuration = value end)
    Settings.CreateSlider(category, setting, options, ns.L["开始时音频最多播放多少秒后自动停止"])
end

-- 创建多选下拉按钮（Blizzard_Menu DropdownButton + CreateCheckboxMenu）
local function CreateMultiSelectDropdown(frame, dbKey, audioList, durationField)
    local dropdown = CreateFrame("DropdownButton", nil, frame, "WowStyle1DropdownTemplate")
    dropdown:SetPoint("LEFT", 245, 0)
    dropdown:SetWidth(260)
    dropdown:SetHeight(24)
    dropdown:SetDefaultText(DISABLE)
    dropdown:SetScript("OnEnter", function(self)
        GameTooltip:SetOwner(self, "ANCHOR_TOP")
        GameTooltip:SetText(ns.L["多选提示"])
        GameTooltip:Show()
    end)
    dropdown:SetScript("OnLeave", function()
        GameTooltip:Hide()
    end)

    -- 自定义选中文本显示
    dropdown:SetSelectionText(function()
        local count = 0
        local tbl = BLMusicDB[dbKey]
        if tbl then
            for _ in pairs(tbl) do count = count + 1 end
        end
        if count == 0 then return DISABLE end
        return ns.L["已选择"] .. " " .. count
    end)

    -- 组装条目列表
    local entries = {}
    for _, v in ipairs(audioList) do
        if v.path ~= "" then
            tinsert(entries, {v.name, v.path})
        end
    end

    -- 用 SetupMenu 替代 CreateCheckboxMenu，支持滚动模式限制最大显示行数
    dropdown:SetupMenu(function(_, rootDescription)
        rootDescription:SetScrollMode(260)

        for _, item in ipairs(entries) do
            local name, path = item[1], item[2]
            rootDescription:CreateCheckbox(name,
                function() return BLMusicDB[dbKey] and BLMusicDB[dbKey][path] end,
                function()
                    local wasChecked = BLMusicDB[dbKey] and BLMusicDB[dbKey][path]
                    if wasChecked then
                        BLMusicDB[dbKey][path] = nil
                        if next(BLMusicDB[dbKey]) == nil then
                            BLMusicDB[dbKey] = nil
                        end
                        ns.StopCurrentMusic()
                    else
                        if not BLMusicDB[dbKey] then
                            BLMusicDB[dbKey] = {}
                        end
                        BLMusicDB[dbKey][path] = true
                        ns.PlayMusicFile(path, BLMusicDB[durationField])
                    end
                end,
                path)
        end
    end)

    return dropdown
end

-- 开始音乐多选
do
    local init = CreateSettingsButtonInitializer(
        ns.L["选择开始音频"],
        " ",
        function() end,
        ns.L["嗜血开始时播放的音频文件"],
        true)
    if init.InitFrame then
        hooksecurefunc(init, "InitFrame", function(_, frame)
            if not frame.Button then return end
            frame.Button:Hide()
            if not frame.blmDropdown then
                frame.blmDropdown = CreateMultiSelectDropdown(frame, "startMusicFiles", ns.start, "startDuration")
                frame:HookScript("OnHide", function()
                    if frame.blmDropdown then frame.blmDropdown:Hide() end
                end)
            end
            frame.blmDropdown:Show()
        end)
    end
    layout:AddInitializer(init)
end

-- 可用时音频持续时间
do
    local options = Settings.CreateSliderOptions(1, 10, 1)
    options:SetLabelFormatter(MinimalSliderWithSteppersMixin.Label.Right, function(value)
        return GARRISON_DURATION_SECONDS:format(value)
    end)

    local setting = Settings.RegisterProxySetting(category, "BLMUSIC_ENDDURATION",
        Settings.VarType.Number, ns.L["可用音频持续时间"], defaults.endDuration,
        function() return BLMusicDB.endDuration end,
        function(value) BLMusicDB.endDuration = value end)
    Settings.CreateSlider(category, setting, options, ns.L["可用时音频最多播放多少秒后自动停止"])
end

-- 可用时音频多选
do
    local init = CreateSettingsButtonInitializer(
        ns.L["选择可用音频"],
        " ",
        function() end,
        ns.L["嗜血可用时播放的音频文件"],
        true)
    if init.InitFrame then
        hooksecurefunc(init, "InitFrame", function(_, frame)
            if not frame.Button then return end
            frame.Button:Hide()
            if not frame.blmDropdown then
                frame.blmDropdown = CreateMultiSelectDropdown(frame, "endMusicFiles", ns["end"], "endDuration")
                frame:HookScript("OnHide", function()
                    if frame.blmDropdown then frame.blmDropdown:Hide() end
                end)
            end
            frame.blmDropdown:Show()
        end)
    end
    layout:AddInitializer(init)
end

layout:AddInitializer(CreateSettingsListSectionHeaderInitializer(ns.L["自定义音频"]))

do
    local btnInit = CreateSettingsButtonInitializer(
        ns.L["联系作者"],
        ns.L["打开"],
        function() ns.ShowContactPopup() end,
        nil, true)
    if btnInit.InitFrame then
        hooksecurefunc(btnInit, "InitFrame", function(_, frame)
            if frame.Button then
                frame.Button:SetText(ns.L["打开"])
                frame.Button:Show()
            end
        end)
    end
    layout:AddInitializer(btnInit)
end

SLASH_BLMUSIC1 = "/bl"
SLASH_BLMUSIC2 = "/blm"
SlashCmdList["BLMUSIC"] = function()
    Settings.OpenToCategory(category:GetID())
end