# Tmux Reference

`config/tmux.conf` 所有設定與快捷鍵的完整參考。Prefix 鍵為 `Ctrl-a`。

---

## General Settings

| Setting | 說明 | Description |
|---------|------|-------------|
| `prefix ^a` | Prefix 鍵改為 Ctrl-a（預設是 Ctrl-b） | Change prefix from Ctrl-b to Ctrl-a |
| `escape-time 1` | 減少 prefix 和指令間的延遲，避免與 vim 衝突 | Reduce delay between prefix and command |
| `default-terminal "tmux-256color"` | 終端類型設為 tmux-256color | Set terminal type for proper color support |
| `terminal-overrides ",*256col*:Tc"` | 啟用 24-bit true color | Enable true color override |
| `history-limit 5000` | 捲動回溯歷史設為 5000 行（預設 2000） | Scrollback buffer size |
| `repeat-time 600` | 可重複按鍵的間隔時間（毫秒，預設 500） | Time window for repeatable key bindings |
| `display-panes-time 1000` | 顯示窗格編號的持續時間（毫秒） | Duration of pane number display |
| `display-time 1500` | 訊息顯示持續時間（毫秒） | Duration of status messages |
| `set-titles off` | 不更新終端視窗標題 | Don't update terminal window title |
| `set-clipboard on` | 啟用 OSC 52 剪貼簿整合 | Enable clipboard integration via OSC 52 |
| `base-index 1` | 視窗編號從 1 開始（而非 0） | Windows start at index 1 |
| `pane-base-index 1` | 窗格編號從 1 開始 | Panes start at index 1 |
| `automatic-rename on` | 自動用執行中的程式名稱命名視窗 | Auto-rename window to current program |
| `renumber-windows on` | 關閉視窗後自動重新編號 | Renumber windows when one is closed |
| `monitor-activity on` | 監控視窗活動（有輸出時標記） | Monitor windows for activity |
| `visual-activity on` | 有活動時在狀態列顯示提醒 | Show activity alert in status bar |
| `status-keys vi` | 狀態列命令列使用 vi 鍵位 | Use vi keys in status line command mode |
| `mode-keys vi` | copy mode 使用 vi 鍵位 | Use vi keys in copy mode |

---

## Custom Keybindings

> `prefix` = `Ctrl-a`，`-r` = 可重複按，`-n` = 不需要 prefix

### Config

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix r` | 重新載入 tmux 設定檔 | Reload tmux config |

### Split Panes

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix |` | 水平分割 | Split horizontally |
| `prefix _` | 垂直分割 | Split vertically |
| `prefix -` | 垂直分割，保留目前路徑 | Split vertically, keep current path |
| `prefix \` | 水平分割，保留目前路徑 | Split horizontally, keep current path |

### Pane Navigation

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix h` | 移到左邊窗格（可重複） | Move to left pane |
| `prefix j` | 移到下方窗格（可重複） | Move to pane below |
| `prefix k` | 移到上方窗格（可重複） | Move to pane above |
| `prefix l` | 移到右邊窗格（可重複） | Move to right pane |
| `prefix O` | 循環到下一個窗格（可重複） | Cycle to next pane |
| `Alt-0` ~ `Alt-9` | 直接跳到指定編號的窗格（無需 prefix） | Jump to pane by number (no prefix) |

### Pane Resizing

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix H` | 向左擴大 5 格（可重複） | Resize left by 5 |
| `prefix J` | 向下擴大 5 格（可重複） | Resize down by 5 |
| `prefix K` | 向上擴大 5 格（可重複） | Resize up by 5 |
| `prefix L` | 向右擴大 5 格（可重複） | Resize right by 5 |
| `Ctrl-Shift-Up` | 向上擴大 50 格（無需 prefix） | Resize up by 50 (no prefix) |
| `Ctrl-Shift-Down` | 向下擴大 50 格（無需 prefix） | Resize down by 50 (no prefix) |
| `Ctrl-Shift-Left` | 向左擴大 50 格（無需 prefix） | Resize left by 50 (no prefix) |
| `Ctrl-Shift-Right` | 向右擴大 50 格（無需 prefix） | Resize right by 50 (no prefix) |

### Pane Swapping

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix {` | 與上一個窗格交換（可重複） | Swap with previous pane |
| `prefix }` | 與下一個窗格交換（可重複） | Swap with next pane |
| `prefix Alt-v` | 與上次造訪的窗格交換 | Swap with last visited pane |
| `prefix Ctrl-Right` | 與右邊窗格交換（可重複） | Swap with right pane |
| `prefix Ctrl-Left` | 與左邊窗格交換（可重複） | Swap with left pane |
| `prefix Ctrl-Up` | 與上方窗格交換（可重複） | Swap with upper pane |
| `prefix Ctrl-Down` | 與下方窗格交換（可重複） | Swap with lower pane |

### Pane Joining

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix Ctrl-t` | 選擇視窗並將目前窗格加入 | Choose window and join current pane to it |
| `prefix Ctrl-j` | 輸入視窗編號，將其窗格拉到這裡 | Pull a pane from another window here |

### Window Navigation

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix Ctrl-p` | 上一個視窗（可重複） | Previous window |
| `prefix Ctrl-n` | 下一個視窗（可重複） | Next window |
| `prefix Tab` | 下一個視窗（可重複） | Next window (alternative) |
| `prefix /` | 上一個使用的視窗 | Last window (toggle) |

### Window Management

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix C` | 在目前路徑建立新視窗 | New window at current path |
| `prefix T` | 將視窗移到下一個未使用的編號 | Move window to next unused index |
| `prefix @` | 輸入編號，移動視窗到該位置 | Move window to specific index |
| `prefix Alt-s` | 輸入編號，與該視窗交換位置 | Swap window with specific index |
| `prefix Ctrl-k` | 確認後關閉視窗 | Kill window (with confirmation) |
| `prefix Alt-k` | 確認後關閉 session | Kill session (with confirmation) |

### Window/Pane Rotation

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix Ctrl-o` | 順時鐘旋轉窗格（可重複） | Rotate panes clockwise |
| `prefix Alt-o` | 逆時鐘旋轉窗格（可重複） | Rotate panes counter-clockwise |

### Layouts

| Keybinding | 說明 | Description |
|------------|------|--------|
| `Alt-\|` | 主視窗在左，其他在右排列（無需 prefix） | Main-vertical layout |
| `Alt-_` | 主視窗在上，其他在下排列（無需 prefix） | Main-horizontal layout |
| `Ctrl-\` | 所有窗格等寬水平排列（無需 prefix） | Even-horizontal layout |
| `Ctrl-_` | 所有窗格等高垂直排列（無需 prefix） | Even-vertical layout |
| `Ctrl-t` | 所有窗格平鋪排列（無需 prefix） | Tiled layout |

### Session

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix S` | 建立新 session（提示輸入名稱） | Create new session with name prompt |

### Kill/Clear

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix o` | 關閉其他所有窗格，只留目前的 | Kill all panes except current |
| `prefix Ctrl-b` | 清除終端畫面和 tmux 歷史紀錄 | Clear terminal screen and tmux history |

### Mouse

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix m` | 開啟滑鼠模式 | Enable mouse |
| `prefix M` | 關閉滑鼠模式 | Disable mouse |

### Synchronize Panes

| Keybinding | 說明 | Description |
|------------|------|--------|
| `Alt-s` | 切換窗格同步輸入（無需 prefix） | Toggle synchronize-panes |

### Copy Mode & Buffers

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix =` | 選擇並貼上 buffer | Choose buffer to paste |

### Profile Presets

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix Alt-f` | 快速模式：repeat 0.6s, titles off, display 0.75s | Fast preset |
| `prefix Alt-n` | 正常模式：repeat 1s, titles on, display 1.5s | Normal preset |

---

## Frequently Used Built-in Keybindings

> 這些是 tmux 預設的快捷鍵（不在 tmux.conf 中），但日常使用很常用。

### Session

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix d` | 脫離目前 session（背景執行） | Detach from session |
| `prefix s` | 列出所有 session 並切換 | List sessions and switch |
| `prefix $` | 重新命名目前 session | Rename current session |
| `prefix (` | 切換到上一個 session | Switch to previous session |
| `prefix )` | 切換到下一個 session | Switch to next session |

### Window

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix c` | 建立新視窗 | Create new window |
| `prefix &` | 關閉目前視窗（確認） | Kill current window (confirm) |
| `prefix ,` | 重新命名目前視窗 | Rename current window |
| `prefix w` | 列出所有視窗並切換 | List windows and switch |
| `prefix 0-9` | 跳到指定編號的視窗 | Switch to window by number |
| `prefix f` | 搜尋視窗名稱 | Find window by name |

### Pane

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix z` | 放大/還原目前窗格（zoom toggle） | Toggle pane zoom (fullscreen) |
| `prefix x` | 關閉目前窗格（確認） | Kill current pane (confirm) |
| `prefix q` | 顯示窗格編號（在 display-panes-time 內按數字跳轉） | Show pane numbers (press number to jump) |
| `prefix !` | 將目前窗格拆成獨立視窗 | Break pane into its own window |
| `prefix Space` | 循環切換 layout | Cycle through layouts |

### Copy Mode (vi keys)

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix [` | 進入 copy mode | Enter copy mode |
| `q` | 離開 copy mode | Exit copy mode |
| `Space` | 開始選取 | Start selection |
| `Enter` | 複製選取內容並離開 | Copy selection and exit |
| `v` | 開始選取（vi 風格，需 tmux-yank 插件） | Start selection (vi-style) |
| `/` | 向下搜尋 | Search forward |
| `?` | 向上搜尋 | Search backward |
| `n` | 下一個搜尋結果 | Next search match |
| `N` | 上一個搜尋結果 | Previous search match |

### Misc

| Keybinding | 說明 | Description |
|------------|------|--------|
| `prefix t` | 顯示時鐘 | Show clock |
| `prefix ?` | 列出所有快捷鍵 | List all key bindings |
| `prefix :` | 進入 tmux 命令列 | Enter tmux command prompt |

---

## Plugins

| Plugin | 說明 | Description |
|--------|------|---------|
| `tpm` | Tmux Plugin Manager | Plugin manager |
| `tmux-sensible` | 合理的預設設定 | Sensible default settings |
| `tmux-yank` | 在 copy mode 中複製到系統剪貼簿 | Copy to system clipboard in copy mode |
| `tmux-urlview` | 顯示並開啟 pane 中的 URL | Extract and open URLs from pane |
| `tmux-resurrect` | 儲存/還原 tmux session（重開機後恢復） | Save/restore sessions across restarts |
| `tmux-open` | 在 copy mode 中開啟選取的檔案/URL | Open selected file/URL from copy mode |
| `tmux2k` | Status bar 主題和模組管理 | Status bar theme and module manager |

---

## Command-line Quick Reference

| Command | 說明 | Description |
|---------|------|-------------|
| `tmux` | 建立新 session | Start new session |
| `tmux new -s name` | 建立命名 session | Start named session |
| `tmux ls` | 列出所有 session | List sessions |
| `tmux a` | 接回上一個 session | Attach to last session |
| `tmux a -t name` | 接回指定 session | Attach to named session |
| `tmux kill-session -t name` | 刪除指定 session | Kill named session |
| `tmux kill-server` | 關閉 tmux server（所有 session） | Kill tmux server (all sessions) |
