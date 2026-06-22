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
    ["选择音频时试听"] = "选择音频时试听",
    ["在下拉菜单中选择音频文件时自动试听"] = "在下拉菜单中选择音频文件时自动试听",

    -- 停止播放
    ["停止播放"] = "停止播放",

    -- 选择音频
    ["选择音频"] = "选择音频",
    ["开始音频持续时间"] = "开始音频持续时间",
    ["开始时音频最多播放多少秒后自动停止"] = "开始时音频最多播放多少秒后自动停止",
    ["开始时音频"] = "开始时音频",
    ["嗜血开始时播放的音频文件"] = "嗜血开始时播放的音频文件",
    ["可用音频持续时间"] = "可用音频持续时间",
    ["可用时音频最多播放多少秒后自动停止"] = "可用时音频最多播放多少秒后自动停止",
    ["可用时音频"] = "可用时音频",
    ["嗜血可用时播放的音频文件"] = "嗜血可用时播放的音频文件",

    -- 自定义音频
    ["自定义音频"] = "自定义音频",

    -- 联系作者
    ["联系作者"] = "联系作者",
    ["打开"] = "打开",

    -- 联系弹窗内容
    ["联系弹窗内容"] = "GitHub:https://github.com/jianfan221/BLMusic\n附件请带上音频文件\n电子邮箱:32655163@qq.com\n文件名称:\n显示名称:\n音频用途:开始时or可用时?\n附加信息:你的名字?",
}

-- 英语（非中文环境使用）
if GetLocale() ~= "zhCN" and GetLocale() ~= "zhTW" then
    ns.L = {
        ["简单便捷的嗜血播放音频插件"] = "Simple Bloodlust music addon",
        ["/bl 或 /blm 打开此界面"] = "/bl or /blm to open settings",

        ["当前通道音量"] = "Current Channel Volume",
        ["当前音频通道的音量和快捷调整"] = "Volume of the current audio channel",
        ["音频通道"] = "Audio Channel",
        ["选择音频播放的通道"] = "Select audio output channel",

        ["试听"] = "Preview",
        ["选择音频时试听"] = "Preview on Select",
        ["在下拉菜单中选择音频文件时自动试听"] = "Auto-play audio when selecting from dropdown",

        ["停止播放"] = "Stop Playing",

        ["选择音频"] = "Select Audio",
        ["开始音频持续时间"] = "Start Music Duration",
        ["开始时音频最多播放多少秒后自动停止"] = "Max seconds to play start music before auto-stop",
        ["开始时音频"] = "Start Music",
        ["嗜血开始时播放的音频文件"] = "Audio to play when Bloodlust starts",
        ["可用音频持续时间"] = "End Music Duration",
        ["可用时音频最多播放多少秒后自动停止"] = "Max seconds to play end music before auto-stop",
        ["可用时音频"] = "End Music",
        ["嗜血可用时播放的音频文件"] = "Audio to play when Bloodlust fades",

        ["自定义音频"] = "Custom Audio",

        ["联系作者"] = "Contact Author",
        ["打开"] = "Open",

        ["联系弹窗内容"] = "GitHub:https://github.com/jianfan221/BLMusic\nPlease attach the audio file\nEmail: 32655163@qq.com\nFile name:\nDisplay name:\nUsage: Start or End?\nExtra info: Your name?",
    }
end
