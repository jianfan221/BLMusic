--- BLMusic 音频文件表,对应文件夹Media
local addonName, ns = ...

-- 本地化辅助：简体/繁体中文用中文，其他语言用英文
local function T(zh, en)
    en = en or zh
    local locale = GetLocale()
    return (locale == "zhCN" or locale == "zhTW") and zh or en
end

-- {path = "音频文件名.后缀名", name = "下拉菜单显示的名字" }   --提供者:提供者名称
-- 开始音乐
ns.start = {
	{ path = "", name = DISABLE },
    { path = "123.mp3", name = CUSTOM.."  Interface\\123.mp3" },
    { path = "123.ogg", name = CUSTOM.."  Interface\\123.ogg" },
    { path = "msnzs.mp3", name = "Sailor Moon OST" },
    { path = "Guangzhi.mp3", name = "Guangzhi" },
    { path = "pedrolust.mp3", name = "pedrolust" },   --提供者:月璃韶华
    { path = "retro game style.mp3", name = "Retro game style" },
    { path = "For the blood god.mp3", name = "For the blood god" },   --提供者:二萌Alice
    { path = "For the emperor.mp3", name = "For the emperor" },   --提供者:二萌Alice
    { path = "let galaxy burn.mp3", name = "Let galaxy burn" },   --提供者:二萌Alice
    { path = "space marine attack.mp3", name = "Space marine attack" },   --提供者:二萌Alice
    { path = "yungongxunyin.mp3", name = T("云宫迅音", "Celestial Symphony") },
    { path = "Shining soul.mp3", name = T("天空战记光之魂", "Shining soul") }, --提供者:山鬼

}

-- 结束音乐
ns["end"] = {
    { path = "", name = DISABLE },
    { path = "456.mp3", name = CUSTOM.."  Interface\\456.mp3" },
    { path = "456.ogg", name = CUSTOM.."  Interface\\456.ogg" },
    { path = "Magic.mp3", name = "Magic" },
    { path = "Elf.mp3", name = "Elf" },
}
