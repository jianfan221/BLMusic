--- BLMusic 音频文件表,对应文件夹Media
local addonName, ns = ...
-- {path = "音频文件名.后缀名", name = "下拉菜单显示的名字" }   --来源:作者名
-- 开始音乐
ns.start = {
	{ path = "", name = DISABLE },
    { path = "msnzs.mp3", name = "Sailor Moon OST" ,},
    { path = "Guangzhi.mp3", name = "Guangzhi" },
    { path = "retro game style.mp3", name = "Retro game style" },
    { path = "For the blood god.mp3", name = "For the blood god" },   --来源:二萌Alice
    { path = "For the emperor.mp3", name = "For the emperor" },   --来源:二萌Alice
    { path = "let galaxy burn.mp3", name = "Let galaxy burn" },   --来源:二萌Alice
    { path = "space marine attack.mp3", name = "Space marine attack" },   --来源:二萌Alice
}

-- 结束音乐
ns["end"] = {
    { path = "", name = DISABLE },
    { path = "Magic.mp3", name = "Magic" },
    { path = "Elf.mp3", name = "Elf" },
}
