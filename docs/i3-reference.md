# i3 Reference

`config/i3.config` 所有設定與快捷鍵的完整參考。Mod 鍵為 `Super`（Windows 鍵）。

---

## General Settings

| Setting | 說明 | Description |
|---------|------|-------------|
| `set $mod Mod4` | Mod 鍵設為 Super（Mod1 = Alt） | Mod key is Super (Windows key) |
| `font pango:JetBrainsMono NL Nerd Font 10` | 視窗標題列字體 | Window title bar font |
| `default_border normal 3` | 預設視窗邊框 3px（含標題列） | Default window border with title bar |
| `default_floating_border normal 3` | 浮動視窗邊框 3px | Floating window border |
| `gaps top 26` | 頂部留 26px 給 polybar | Top gap for polybar |
| `workspace_auto_back_and_forth yes` | 按同一個 workspace 鍵會切回上一個 | Press same workspace key to toggle back |
| `floating_modifier $mod` | 按住 Super + 滑鼠拖動浮動視窗 | Hold Super + mouse to drag floating windows |
| `tiling_drag modifier titlebar` | 拖動標題列或按住 Mod 拖動 tiling 視窗 | Drag title bar or hold Mod to move tiling windows |

---

## Appearance (Nord Theme)

| Setting | 說明 | Description |
|---------|------|-------------|
| `client.focused #88c0d0 ...` | 焦點視窗：青色邊框 | Focused window: cyan border |
| `client.focused_inactive #4c566a ...` | 非焦點但曾焦點：灰色邊框 | Inactive focused: gray border |
| `client.unfocused #4c566a ...` | 完全無焦點：灰色邊框（可見） | Unfocused: visible gray border |
| `client.urgent #bf616a ...` | 緊急視窗：紅色邊框 | Urgent: red border |
| `client.background #2e3440` | 視窗背景色 | Window background |

Theme reference: https://www.nordtheme.com/docs/colors-and-palettes

---

## Bar

| Setting | 說明 | Description |
|---------|------|-------------|
| `status_command i3status` | 使用 i3status 提供狀態資訊 | Status info from i3status |
| `mode hide` | 預設隱藏，按 $mod 顯示 | Hidden by default, show with $mod |
| `position bottom` | 顯示在底部 | Bar at bottom |
| `tray_output primary` | 系統托盤顯示在主螢幕 | System tray on primary monitor |
| `separator_symbol "│"` | 模組分隔符 | Module separator |

---

## Workspaces

| 變數 | 名稱 | Icon |
|------|------|------|
| `$ws1` - `$ws10` | 1: - 10: | Nerd Font icons |
| `$Maximum_ws` | Maximum | 全螢幕工作用 |

---

## Keybindings: General

> `$mod` = Super, `mod1` = Alt

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `$mod+Return` | 開啟終端機 | Open terminal |
| `Ctrl+Alt+t` | 開啟終端機（備用） | Open terminal (alternative) |
| `$mod+Shift+q` | 關閉焦點視窗 | Kill focused window |
| `Alt+Shift+q` | 關閉焦點視窗（備用） | Kill focused (alternative) |
| `Alt+w` | 關閉焦點視窗（備用） | Kill focused (alternative) |
| `$mod+d` | 開啟 Vicinae launcher | Open Vicinae launcher |
| `Alt+Space` | 開啟 Vicinae launcher（備用） | Open launcher (alternative) |
| `Shift+Alt+1` | Vicinae launcher | Vicinae |
| `Shift+Alt+2` | Rofi launcher | Rofi (run/window/drun/keys) |
| `Shift+Alt+3` | dmenu launcher | dmenu |
| `$mod+Ctrl+Shift+c` | Vicinae 剪貼簿歷史 | Vicinae clipboard history |

---

## Keybindings: Navigation

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `$mod+h/j/k/l` | 切換焦點（vim 方向） | Change focus (vim-style) |
| `$mod+Arrow` | 切換焦點（方向鍵） | Change focus (arrow keys) |
| `Alt+Tab` | 切換到上一個視窗（i3-swap-focus） | Toggle last focused window |
| `$mod+Shift+h/j/k/l` | 移動視窗 | Move focused window |
| `$mod+Alt+h/j/k/l` | 浮動視窗移到螢幕邊緣 | Move floating to screen edge |
| `$mod+Alt+0` | 重置浮動視窗位置 | Reset floating position |
| `$mod+p` | 焦點到父容器 | Focus parent container |
| `$mod+c` | 焦點到子容器 | Focus child container |
| `$mod+Space` | 切換 tiling/floating 焦點 | Toggle focus tiling/floating |

---

## Keybindings: Workspace

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `$mod+1-9,0` | 切換到 workspace 1-10 | Switch to workspace |
| `Ctrl+1-9` | 切換到 workspace（備用） | Switch to workspace (alt) |
| `$mod+m` | 切換到 Maximum workspace | Switch to Maximum |
| `$mod+Shift+1-9,0` | 移動視窗到 workspace | Move container to workspace |
| `$mod+Ctrl+Shift+1-9,0` | 移動視窗並跟著切換 | Move container and follow |
| `Ctrl+Shift+Alt+h/l` | 移動視窗到前/後 workspace | Move container to prev/next |
| `$mod+b` | 切回上一個 workspace | Toggle back_and_forth |
| `$mod+Shift+b` | 移動視窗到上一個 workspace | Move to back_and_forth |
| `Ctrl+Alt+Right/l` | 下一個 workspace（同螢幕） | Next workspace on output |
| `Ctrl+Alt+Left/h` | 上一個 workspace（同螢幕） | Prev workspace on output |
| `Ctrl+Alt+p` | 移動 workspace 到主螢幕 | Move workspace to primary output |

---

## Keybindings: Layout

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `$mod+f` | 全螢幕切換 | Toggle fullscreen |
| `$mod+s` | 堆疊佈局 | Stacking layout |
| `$mod+w` | 分頁佈局 | Tabbed layout |
| `$mod+e` | 切換分割方向 | Toggle split |
| `$mod+%` | 水平分割 | Split horizontal |
| `$mod+Ctrl+Alt+%Ctrl+Alt+` | 垂直標題分割 | Title vertical |
| `$mod+Shift+f` | 切換浮動 | Toggle floating |
| `$mod+Shift+Space` | 切換浮動（備用） | Toggle floating (alt) |
| `Shift+Alt+-` | 視窗寬度設為 30% | Resize width 30% |
| `Shift+Alt++` | 視窗寬度設為 50% | Resize width 50% |
| `$mod+-` / `$mod+n` | 移到 scratchpad | Move to scratchpad |
| `$mod+Shift+-` / `$mod+Shift+n` | 顯示/隱藏 scratchpad | Show/hide scratchpad |

---

## Keybindings: Volume

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `XF86AudioRaiseVolume` | 音量 +5% | Volume up |
| `XF86AudioLowerVolume` | 音量 -5% | Volume down |
| `XF86AudioMute` | 靜音切換 | Toggle mute |
| `XF86AudioMicMute` | 麥克風靜音切換 | Toggle mic mute |

---

## Keybindings: Apps

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `Shift+Alt+b` | 切換 i3bar 顯示 | Toggle bar visibility |
| `Shift+Alt+a` | 顯示上一則通知（dunst） | Show last notification |
| `Shift+Alt+d` | 關閉所有通知（dunst） | Close all notifications |
| `Alt+y` | 切換 conky 顯示 | Toggle conky |
| `$mod+Shift+s` | Flameshot 截圖 | Flameshot screenshot |

---

## Keybindings: System

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `$mod+Shift+c` | 重新載入設定檔 | Reload config |
| `$mod+Shift+r` | 重啟 i3（保留 session） | Restart i3 in-place |
| `$mod+Ctrl+Shift+l` | 退出 i3（確認） | Exit i3 (with confirmation) |
| `Ctrl+Shift+Alt+x` | 手動 xrandr --auto | Manual xrandr reset |

---

## Mode: Resize (`$mod+r`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `h/j/k/l` | 縮小/放大視窗（10px） | Shrink/grow window |
| `=` | 放大（置中） | Grow and center |
| `-` | 縮小（置中） | Shrink and center |
| `Arrow` | 微調（4px） | Fine adjust |
| `Return/Esc/Space/Q` | 退出 resize 模式 | Exit resize mode |

---

## Mode: System (`Ctrl+Alt+q`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `q` | 鎖定螢幕 | Lock screen |
| `l` | 登出 session | Logout |
| `s` | 暫停（suspend） | Suspend |
| `r` | 重新開機 | Reboot |
| `Shift+s` | 關機 | Shutdown |

---

## Mode: Monitor Display (`Ctrl+Alt+i`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `0` | 關閉其他螢幕，只用主螢幕 | Close other monitors |
| `1` | 雙外接螢幕 | Two external monitors |
| `2` | 主外接 + 內建螢幕 | Primary external + internal |

---

## Mode: Border (`Ctrl+Shift+Alt+b`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `u` | 無邊框 | No border |
| `t` | 3px 邊框（可用滑鼠調整大小） | 3px border (mouse resize) |
| `n` | 正常邊框（含標題列） | Normal border with title |

---

## Mode: Gaps (`$mod+Shift+g`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `o` | 進入外部間距模式 | Enter outer gaps mode |
| `i` | 進入內部間距模式 | Enter inner gaps mode |
| `+/-/0` | 增加/減少/歸零（當前 workspace） | Increase/decrease/reset (current) |
| `Shift + +/-/0` | 增加/減少/歸零（全部 workspace） | Increase/decrease/reset (global) |

---

## Mode: i3-resurrect

### Save (`Alt+=`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `1-9,0` | 儲存對應 workspace 的佈局和程式 | Save workspace layout + programs |

### Restore (`Alt+-`)

| Keybinding | 說明 | Description |
|------------|------|-------------|
| `1-9,0` | 還原對應 workspace（佈局+程式） | Restore workspace (layout + programs) |
| `$mod+1-9,0` | 只還原程式 | Restore programs only |
| `Alt+1-9,0` | 只還原佈局 | Restore layout only |
| `Alt+s` | 透過 dmenu 選擇還原 | Restore via dmenu picker |

---

## Window Rules

| Rule | 說明 | Description |
|------|------|-------------|
| `[urgent=latest] focus` | 自動焦點到有 urgent 標記的視窗 | Auto-focus urgent windows |
| `[class="firefox_firefox" title="PressPlay"]` | PressPlay 移到 workspace 5 | Move PressPlay to ws5 |
| `[class="Gnome-terminal"]` | 寬度設為 40% | Width 40% |
| `[class="com.mitchellh.ghostty"]` | 寬度設為 40% | Width 40% |

---

## Autostart

| Program | 說明 | Description |
|---------|------|-------------|
| `dex --autostart` | XDG autostart 應用程式 | XDG autostart apps |
| `xss-lock + lock.sh` | 螢幕鎖定（suspend 前自動鎖） | Screen lock before suspend |
| `xset dpms 900 900 900` | 15 分鐘後螢幕待機 | DPMS: standby after 15min |
| `nm-applet` | NetworkManager 托盤 | Network manager tray |
| `fcitx5 -d` | 輸入法（daemon 模式） | Input method daemon |
| `blueman-applet` | 藍牙管理托盤 | Bluetooth tray |
| `vicinae server` | Vicinae launcher 背景服務 | Vicinae launcher daemon |
| `dunst` | 通知 daemon | Notification daemon |
| `autostart.sh` | picom + nitrogen + conky | Compositor + wallpaper + monitor |
| `render_i3_monitor.sh` | 自動偵測螢幕配置 | Auto-detect monitor layout |
| `polybar_launch.sh` | 啟動 polybar | Launch polybar |
| `i3-swap-focus` | Alt+Tab 切換上一個視窗 | Last window toggle daemon |

---

## Variables

| Variable | Value | 說明 |
|----------|-------|------|
| `$mod` | Mod4 (Super) | 主修飾鍵 |
| `$up/$down/$left/$right` | k/j/h/l | Vim 方向鍵 |
| `$ws1` - `$ws10` | `1:` - `10:` | Workspace 名稱（含 icon） |
| `$Maximum_ws` | Maximum | 全螢幕 workspace |
| `$LAPTOP_INTERNAL_OUTPUT` | eDP-1 | 筆電內建螢幕 |
| `$EXTERNAL_OUTPUT_PRIMARY` | HDMI-2 | 主外接螢幕 |
| `$EXTERNAL_OUTPUT_SECONDARY` | DP-1-3 | 副外接螢幕 |
| `$Locker` | loginctl lock-session | 鎖定指令 |
| `$i3_resurrect` | i3-resurrect | Workspace 儲存/還原工具 |
