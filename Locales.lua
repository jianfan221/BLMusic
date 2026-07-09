--- BLMusic 本地化
local addonName, ns = ...

-- 默认简体中文
ns.L = {
    -- 插件描述
    ["简单便捷的嗜血播放音频插件"] = "简单便捷的嗜血播放音频插件",
    ["/bl 或 /blm 打开此界面"] = "/bl 或 /blm 打开此界面",

    -- 音量与通道
    ["当前通道音量"] = "当前通道音量",
    ["当前音频通道的音量和快捷调整"] = "当前音频通道的音量和快捷调整",
    ["音频通道"] = "音频通道",
    ["选择音频播放的通道"] = "选择音频播放的通道",

    -- 试听
    ["试听"] = "试听",
    ["试听开始"] = "试听开始",
    ["试听可用"] = "试听可用",

    -- 停止播放
    ["停止播放"] = "停止播放",

    -- 选择音频
    ["选择音频"] = "选择音频",

    -- 嗜血开始音频
    ["嗜血开始音频持续时间"] = "嗜血开始音频持续时间",
    ["嗜血开始音频最多播放多少秒后自动停止"] = "嗜血开始音频最多播放多少秒后自动停止",
    ["嗜血开始音频"] = "嗜血开始音频",
    ["嗜血开始音频播放的音频文件"] = "嗜血开始音频播放的音频文件",

    -- 嗜血好了音频
    ["嗜血好了音频持续时间"] = "嗜血好了音频持续时间",
    ["嗜血好了音频最多播放多少秒后自动停止"] = "嗜血好了音频最多播放多少秒后自动停止",
    ["嗜血好了音频"] = "嗜血好了音频",
    ["嗜血好了音频播放的音频文件"] = "嗜血好了音频播放的音频文件",

    -- 多选
    ["已选择"] = "已选择",
    ["多选提示"] = "选择多个时随机播放",

    -- 能量灌注
    ["能量灌注音频"] = "能量灌注音频",
    ["能量灌注音频播放的音频文件"] = "获得能量灌注时播放的音频文件",

    -- 自定义音频
    ["自定义音频"] = "自定义音频",

    -- 联系作者
    ["联系作者"] = "联系作者",
    ["打开"] = "打开",

    -- 联系弹窗内容
    ["联系弹窗内容"] = [[
GitHub:https://github.com/jianfan221/BLMusic
附件请带上音频文件
电子邮箱:32655163@qq.com
文件名称:一定要英文或者数字(中文会乱码失效)
显示名称:如果是文本音频注明作者
音频用途:开始时or可用时?
附加信息:你的名字?"]],
}

-- 英语（非中文环境使用）
if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then
    ns.L = {
        -- 插件描述
        ["简单便捷的嗜血播放音频插件"] = "Simple Bloodlust music addon",
        ["/bl 或 /blm 打开此界面"] = "/bl or /blm to open settings",

        -- 音量与通道
        ["当前通道音量"] = "Current Channel Volume",
        ["当前音频通道的音量和快捷调整"] = "Volume of the current audio channel",
        ["音频通道"] = "Audio Channel",
        ["选择音频播放的通道"] = "Select audio output channel",

        -- 试听
        ["试听"] = "Preview",
        ["试听开始"] = "Preview Start",
        ["试听可用"] = "Preview End",

        -- 停止播放
        ["停止播放"] = "Stop Playing",

        -- 选择音频
        ["选择音频"] = "Select Audio",

        -- 嗜血开始音频
        ["嗜血开始音频持续时间"] = "BL Start Audio Duration",
        ["嗜血开始音频最多播放多少秒后自动停止"] = "Max seconds for Bloodlust start audio before auto-stop",
        ["嗜血开始音频"] = "BL Start Audio",
        ["嗜血开始音频播放的音频文件"] = "Audio file for Bloodlust start",

        -- 嗜血好了音频
        ["嗜血好了音频持续时间"] = "BL Ready Audio Duration",
        ["嗜血好了音频最多播放多少秒后自动停止"] = "Max seconds for Bloodlust ready audio before auto-stop",
        ["嗜血好了音频"] = "BL Ready Audio",
        ["嗜血好了音频播放的音频文件"] = "Audio file for Bloodlust ready",

        -- 多选
        ["已选择"] = "Selected",
        ["多选提示"] = "Random play when multiple selected",

        -- 能量灌注
        ["能量灌注音频"] = "Power Infusion Audio",
        ["能量灌注音频播放的音频文件"] = "Audio file played when Power Infusion is received",

        -- 自定义音频
        ["自定义音频"] = "Custom Audio",

        -- 联系作者
        ["联系作者"] = "Contact Author",
        ["打开"] = "Open",

        -- 联系弹窗内容
        ["联系弹窗内容"] = [[
GitHub:https://github.com/jianfan221/BLMusic
Please attach the audio file
Email: 32655163@qq.com
File name:
Display name:
Usage: Start or End?
Extra info: Your name?]],
    }
end
