# BLMusic

Auto-play music during Bloodlust / Heroism / Time Warp

---

## Features

- Automatically plays start music when Bloodlust, Heroism, Time Warp, or similar raid-wide haste buffs are cast
- Automatically plays end music when the buff fades away
- Supports all Bloodlust-family spells:
  - Bloodlust / Heroism
  - Time Warp (Mage)
  - Ancient Hysteria / Primal Rage (Hunter)
  - Fury of the Aspects (Evoker)
- Custom audio file support — use your own MP3 files (see [Custom Audio](#custom-audio))
- Independent duration control for start and end music
- Audio channel selection: Master, Music, SFX, Ambience, Dialog
- Built-in volume slider per channel
- Multi-select dropdown — choose multiple audio files, random playback each time
- Preview on click — instantly preview a file by selecting it in the dropdown
- Standalone preview buttons for start and end music
- Stops playback automatically on player death
- Stops playback on UI reload or logout
- Clean Blizzard settings panel (`/bl` or `/blm`)
- Lightweight, no unnecessary libraries or dependencies

## Commands

| Command | Description |
|---------|-------------|
| `/bl` or `/blm` | Open BLMusic settings panel |

## How to Use

1. Install the addon and type `/bl` to open settings
2. Select start and end music files from the multi-select dropdowns (choose multiple for random playback)
3. Set playback duration for each (how many seconds before auto-stop)
4. Optionally select audio channel and adjust volume
5. Next time Bloodlust/Heroism/Time Warp is cast in your group, the music plays automatically!

## Custom Audio

Simply dropping a file into the `Media/` folder is **not enough** — you must also register it in `MediaTable.lua` so it shows up in the in-game dropdown.

1. Put your audio file into the `Media/` folder
2. Open `MediaTable.lua` and register the file in the matching list:
   - `ns.start` — start music (Bloodlust/Heroism/Time Warp begins)
   - `ns["end"]` — end music (buff fades)
   - `ns.pi` — Power Infusion music (file name must start with `pi-`)
3. Add an entry in that list, e.g. `{ path = "yourfile.mp3", name = "Display Name" }`
4. `/reload` the UI — the file now appears in the dropdown for selection

Supported formats: MP3 / OGG.

---

# 中文说明

## 功能特色

- 施放**嗜血 / 英勇 / 时间扭曲**等团队加速技能时**自动播放开始音频**
- 效果消失时**自动播放结束音频**
- 支持所有嗜血系技能：嗜血、英勇、时间扭曲（法师）、远古狂乱/原始狂怒（猎人）、巨龙之怒（唤魔师）
- 支持**自定义音频文件**：放入 Media 文件夹并在 MediaTable.lua 登记后，即可在下拉菜单中选择（详见下方"自定义音频"）
- 开始音频和结束音频**可分别设置播放时长**
- 音频通道可选：主音量 / 音乐 / 音效 / 环境 / 对话
- **内置音量滑块**，快速调节当前通道音量
- **多选模式**：可同时选择多个音频文件，播放时随机选取
- **试听模式**：勾选时自动播放预览，也可通过独立试听按钮播放
- 死亡时自动停止播放，重载/退出时自动停止
- 使用暴雪原生设置面板，简洁轻量

## 使用方法

1. 安装插件后输入 `/bl` 打开设置界面
2. 从多选下拉菜单中分别选择开始/可用时音频（可多选，随机播放）
3. 设置各自的播放时长（多少秒后自动停止）
4. 可选音频通道和音量
5. 下次团队开嗜血/英勇时，音乐自动响起！

## 自定义音频

仅把音频文件放进 `Media/` 文件夹是**不够的**，还需要在 `MediaTable.lua` 中登记，才能在游戏内下拉菜单里显示出来。

1. 将音频文件放入 `Media/` 文件夹
2. 打开 `MediaTable.lua`，把文件登记到对应列表：
   - `ns.start` — 开始音乐（嗜血/英勇/时间扭曲施放时）
   - `ns["end"]` — 结束音乐（效果消失时）
   - `ns.pi` — 能量灌注音乐（文件名必须以 `pi-` 开头）
3. 在对应列表中新增一条，例如 `{ path = "你的文件.mp3", name = "显示名称" }`
4. 重载界面 `/reload`，即可在下拉菜单中选择

支持格式：MP3 / OGG。

## 作者

**简繁 — 无尽之海 (CN)**

如需自定义音频或反馈问题，请在 `/bl` 设置中点击"联系作者"，或发送邮件至 **32655163@qq.com**
