--- BLMusic 音频文件表,对应文件夹Media
local addonName, ns = ...
local locale = GetLocale() == "zhCN" or GetLocale() == "zhTW"
-- 本地化辅助：简体/繁体中文用中文，其他语言用英文
local function T(zh, en)
    en = en or zh
    return locale and zh or en
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
    { path = "luffy attack.mp3", name = "Luffy attack" },   --提供者:蘑菇小射手-无尽之海
    { path = "luffy's fierce attack.mp3", name = "Luffy's fierce attack" },   --提供者:蘑菇小射手-无尽之海
    { path = "shumabaobei.mp3", name = T("数码宝贝 Brave Heart", "Digimon Brave Heart") },
    { path = "ikun.mp3", name = "ikun" },
    { path = "manboNomore.mp3", name = "manboNomore" },--提供者Sins
    { path = "Sway to My Beat in Cosmos.mp3", name = T("在银河中孤独摇摆", "Sway to My Beat in Cosmos") },--提供者lzy
    { path = "Samurai Heart.mp3", name = T("魔神坛斗士", "Samurai Heart") },--提供者Nathan
    { path = "Break up!.mp3", name = "Break up!" },--提供者潘常乐
    { path = "A Call to Arms.mp3", name = "A Call to Arms" },   --提供者:金色平原-溯回之尾
    { path = "GANGTIEHONGLIU .mp3", name = T("钢铁洪流进行曲", "Steel Torrent March") },
    { path = "GUANLANGAOSHOU.mp3", name = T("灌篮高手", "Slam Dunk") },
    { path = "usagiiiii.mp3", name = "Invincible usagi" },   --提供者:CCeci W
    { path = "GUAIWULIEREN.ogg", name = T("怪物猎人英雄之证", "Proof of a Hero") },  --提供者MINE TOSHIKURA
    { path = "2026821.mp3", name = T("巨人的苏醒", "Awakening of the Giant") }, --提供者Guetse
    { path = "ximan.mp3", name = T("宇宙巨人希曼", "He-Man") },   --提供者:大马虎
    { path = "dabaichui.mp3", name = T("大摆锤", "The Pendulum") },   --提供者:大马虎
}
--中文开始音频仅对中文用户显示
if locale then
    tinsert(ns.start, { path = "lulustar.ogg", name = "【露露】恶龙咆哮，嗷呜~" })
    tinsert(ns.start, { path = "nana7mistar.ogg", name = "【Nana7mi】嗷呜~嗷呜~" })
    tinsert(ns.start, { path = "xin2sq.mp3", name = "新二神曲" })
    tinsert(ns.start, { path = "elong.ogg", name = "将军小曲" })
end

-- 结束音乐
ns["end"] = {
    { path = "", name = DISABLE },
    { path = "456.mp3", name = CUSTOM.."  Interface\\456.mp3" },
    { path = "456.ogg", name = CUSTOM.."  Interface\\456.ogg" },
    { path = "Magic.mp3", name = "Magic" },
    { path = "Elf.mp3", name = "Elf" },
    { path = "didi.mp3", name = "didi" },
    { path = "bonus time.mp3", name = "Bonus time" },
}
--中文结束音频仅对中文用户显示
if locale then
    tinsert(ns["end"], { path = "luluend.ogg", name = "【露露】嗜血好啦" })
    tinsert(ns["end"], { path = "nana7miend.ogg", name = "【Nana7mi】嗜血好啦" })
end

-- 能量灌注音频
ns.pi = {
    { path = "", name = DISABLE },
    { path = "pi-powerinfusion.mp3", name = "Power Infusion" },
    { path = "pi-lulu-Pirorirorin.ogg", name = T("【露露】Pirorirorin", "lulu - Pirorirorin") },
    { path = "pi-lulu-Wakuwaku.ogg", name = T("【露露】Wakuwaku", "lulu - Wakuwaku") },
}
if locale then
    tinsert(ns.pi, { path = "pi-jingjing.mp3", name = "【静静】能量灌注" })
end

