--- BLMusic 音频文件表,对应文件夹Media
local addonName, ns = ...
-- {path = "音频文件名.后缀名",name = "下拉菜单显示的名字",tip = "鼠标悬停提示",}
-- 开始音乐
ns.start = {
	{ path = "", name = DISABLE },
    { path = "msnzs.mp3", name = "Sailor Moon OST" ,},
    { path = "Guangzhi.mp3", name = "Guangzhi" },
}

-- 结束音乐
ns["end"] = {
    { path = "", name = DISABLE },
    { path = "Magic.mp3", name = "Magic" },
    { path = "Elf.mp3", name = "Elf" },
}
