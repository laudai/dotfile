# Vimrc Reference

`config/vimrc` 所有設定與快捷鍵的完整參考。

---

## General

| Setting | 說明 | Description |
|---------|------|-------------|
| `set nocompatible` | 關閉 vi 相容模式，啟用所有 vim 功能 | Disable vi compatibility, enable all vim features |
| `set background=dark` | 告訴 vim 終端背景是深色的（影響配色方案顯示） | Tell vim the terminal background is dark (affects color schemes) |
| `set t_Co=256` | 啟用 256 色模式（termguicolors 不可用時的備用） | Enable 256 color mode (fallback when termguicolors unavailable) |
| `set termguicolors` | 啟用 24-bit 真彩色（需終端支援） | Enable 24-bit true color (requires terminal support) |
| `set number` | 顯示絕對行號 | Show absolute line numbers in the gutter |
| `set relativenumber` | 顯示相對行號（與游標的距離） | Show relative line numbers (distance from cursor) |
| `set autoindent` | 新行繼承目前行的縮排 | New lines inherit indentation from current line |
| `set laststatus=2` | 永遠顯示狀態列（0=不顯示, 1=有分割才顯示, 2=永遠） | Always show the status bar (0=never, 1=only with splits, 2=always) |
| `set ruler` | 在狀態列右下角顯示游標位置（行:列） | Show cursor position (line:column) in bottom-right of status bar |
| `set history=200` | 記住 200 筆指令/搜尋歷史（預設 50） | Remember 200 commands/searches in history (default is 50) |
| `set pastetoggle=<F7>` | F7 切換貼上模式（關閉自動縮排以便貼上外部文字） | F7 toggles paste mode (disables auto-indent when pasting) |
| `set clipboard^=unnamedplus,unnamed` | 複製/刪除自動同步到系統剪貼簿（Linux 用 `+`、macOS 用 `*`） | Yank/delete syncs with system clipboard on both Linux (`+`) and macOS (`*`) |
| `set undofile` | 將 undo 歷史存到磁碟，關檔重開還能復原 | Persist undo history to disk — can undo after closing and reopening a file |
| `set autochdir` | 自動將 vim 工作目錄切換到目前檔案所在資料夾 | Auto-change vim's working directory to the current file's folder |
| `set autoread` | 檔案被外部程式修改時自動重新載入（需取得焦點） | Auto-reload file if modified externally (triggers on window focus) |
| `set nrformats=bin,hex,alpha` | `<C-a>`/`<C-x>` 加減數字時支援二進位、十六進位、字母（不含八進位，所以 `007` 視為十進位 7） | `<C-a>`/`<C-x>` increment/decrement treats numbers as binary, hex, and letters (not octal, so `007` = decimal 7) |
| `filetype plugin indent on` | 啟用檔案類型偵測、對應插件和自動縮排 | Enable filetype detection, plugins, and automatic indentation per language |

## Tabs & Indentation

| Setting | 說明 | Description |
|---------|------|-------------|
| `set shiftwidth=4` | `>>`、`<<` 和自動縮排使用的空格數 | Number of spaces used by `>>`, `<<`, and auto-indent |
| `set softtabstop=4` | 按 Tab 時插入的空格數 | Number of spaces a Tab key press inserts |
| `set tabstop=4` | `\t` 字元的顯示寬度 | Display width of a `\t` character |

## Search

| Setting | 說明 | Description |
|---------|------|-------------|
| `set hlsearch` | 高亮所有搜尋匹配結果 | Highlight all matches of the search pattern |
| `set incsearch` | 輸入時即時跳到匹配位置（漸進式搜尋） | Jump to match as you type (incremental search) |
| `set ignorecase` | 搜尋時忽略大小寫 | Case-insensitive search |
| `set smartcase` | 如果搜尋包含大寫字母則區分大小寫 | Override ignorecase if pattern contains uppercase letters |

## Wildmenu (Command-line Completion)

| Setting | 說明 | Description |
|---------|------|-------------|
| `set wildmenu` | 命令列 Tab 補全時顯示候選選單 | Show completion candidates in a menu bar above command line |
| `set wildmode=full` | Tab 逐一循環所有候選項（另一種 `longest,list` 類似 bash） | Tab cycles through all candidates one by one (alternative: `longest,list` for bash-like) |

## Highlight

| Setting | 說明 | Description |
|---------|------|-------------|
| `highlight CursorLine ...` | 游標所在行的樣式：粗體+底線、黑色背景 | Style the cursorline with bold + underline, black background |

## Abbreviations

| Abbreviation | 說明 | Description |
|-------------|------|-------------|
| `iab [] []()<left><left><left>` | 打 `[]` 自動展開成 `[]()` 並將游標放到括號內（Markdown 連結快捷） | Type `[]` to get `[]()` with cursor inside parens (markdown link shortcut) |

---

## Keybindings

### Escape & Mode Switching

| Mapping | Mode | 說明 | Description |
|---------|------|------|--------|
| `jk` | Insert + Cmd-line | 退出到 Normal 模式（替代 Esc） | Exit to Normal mode (alternative to Esc) |
| `<C-]>` | Insert | 重新載入目前檔案 | Re-edit current file (reload from disk) |
| `<C-v><C-v>` | Insert | 插入字面 `<C-v>`（因為終端可能攔截單次 `<C-v>`） | Insert literal `<C-v>` (terminal may intercept single `<C-v>`) |

### Insert Mode Editing

| Mapping | 說明 | Description |
|---------|------|--------|
| `<C-d>` | 向前刪除一個字元（如 Delete 鍵） | Delete character forward (like Delete key) |
| `<S-Tab>` | 減少縮排 | Reduce indent (un-indent) |
| `<C-u>` | 刪除到行首，帶 undo 斷點（可單獨復原） | Delete to start of line, with undo breakpoint |
| `<C-w>` | 刪除前一個字，帶 undo 斷點 | Delete previous word, with undo breakpoint |
| `<C-h>` | 刪除前一個字元，帶 undo 斷點 | Delete previous character, with undo breakpoint |

### Newline Without Insert Mode

| Mapping | 說明 | Description |
|---------|------|--------|
| `oo` | 在下方插入空行，留在 Normal 模式 | Insert blank line below, stay in Normal mode |
| `OO` | 在上方插入空行，留在 Normal 模式 | Insert blank line above, stay in Normal mode |

### Visual Mode Shifting

| Mapping | 說明 | Description |
|---------|------|--------|
| `>` | 縮排並重新選取（不丟失選取） | Indent and re-select (don't lose selection) |
| `<` | 取消縮排並重新選取 | Un-indent and re-select |
| `<Tab>` | 縮排選取區域 | Indent selection |
| `<S-Tab>` | 取消縮排選取區域 | Un-indent selection |

### Line Movement

| Mapping | 說明 | Description |
|---------|------|--------|
| `<M-j>` (Alt-j) | 將目前行下移一行 | Move current line down one line |
| `<M-k>` (Alt-k) | 將目前行上移一行 | Move current line up one line |
| `aj` | 向下跳 5 行 | Jump down 5 lines |
| `ak` | 向上跳 5 行 | Jump up 5 lines |

### Navigation Shortcuts

| Mapping | 說明 | Description |
|---------|------|--------|
| `H` | 跳到行首非空白字元（取代原本的螢幕頂部） | Jump to first non-blank character of line |
| `L` | 跳到行尾非空白字元（取代原本的螢幕底部） | Jump to last non-blank character of line |
| `Y` | 複製到行尾（與 `D`、`C` 行為一致） | Yank to end of line (consistent with `D` and `C`) |
| `<C-v><C-v>` | 進入 Visual Block 模式（終端攔截 `<C-v>` 的替代方案） | Enter Visual Block mode (workaround for terminal intercepting `<C-v>`) |
| `` ` `` | 跳到 mark 所在行（與 `'` 互換） | Jump to mark line (swapped with `'`) |
| `'` | 跳到 mark 的精確位置（與 `` ` `` 互換） | Jump to exact mark position (swapped with `` ` ``) |

### Window Navigation

| Mapping | 說明 | Description |
|---------|------|--------|
| `<C-j>` | 移到下方視窗 | Move to window below |
| `<C-k>` | 移到上方視窗 | Move to window above |
| `<C-l>` | 移到右方視窗 | Move to window right |
| `<C-h>` | 移到左方視窗 | Move to window left |
| `<C-\>` | 循環到下一個視窗 | Cycle to next window |

### Buffer Navigation

| Mapping | 說明 | Description |
|---------|------|--------|
| `<C-p>` | 上一個 buffer | Previous buffer |
| `<C-n>` | 下一個 buffer | Next buffer |

### Tab Navigation

| Mapping | 說明 | Description |
|---------|------|--------|
| `<M-n>` (Alt-n) | 下一個分頁 | Next tab |
| `<M-p>` (Alt-p) | 上一個分頁 | Previous tab |

### Quick Commands

| Mapping | 說明 | Description |
|---------|------|--------|
| `qq` | 關閉目前視窗（`:q`） | Quit current window |
| `q;` | 開啟命令列歷史視窗 | Open command-line history window |
| `a;` | 進入命令模式（等同 `:`） | Enter command mode (same as `:`) |

### Session Save/Restore

| Mapping | 說明 | Description |
|---------|------|--------|
| `<S-F4>` | 儲存 session 到 `~/.vim_manual_session.vim` | Save session to file |
| `<F4>` | 從 `~/.vim_manual_session.vim` 還原 session | Restore session from file |

### Toggle Options

| Mapping | 說明 | Description |
|---------|------|--------|
| `<S-F2>` | 切換游標行高亮 | Toggle cursorline on/off |
| `<C-F2>` | 切換游標列高亮 | Toggle cursorcolumn on/off |
| `<C-S-F2>` | 同時切換游標行+列高亮 | Toggle both cursorline + cursorcolumn |
| `<C-S-F3>` | 切換相對行號 | Toggle relative line numbers |

### Leader Key (`<Space>`)

| Mapping | 說明 | Description |
|---------|------|--------|
| `<leader>n` | 清除搜尋高亮 | Clear search highlights (`:noh`) |
| `<leader>w` | 存檔 | Save file |
| `<leader>d` | 刪除行內容但保留行（不含行尾換行） | Delete line content without linewise |
| `<leader>bd` | 關閉目前 buffer | Close current buffer |
| `<leader>bo` | 關閉所有其他 buffer | Close all buffers except current |
| `<leader>qq` | 以非零結束碼退出（用於中止 git commit） | Quit with non-zero exit code (`:cq`) |
| `<leader>ev` | 在垂直分割視窗編輯 vimrc | Edit vimrc in vertical split |
| `<leader>r` | 顯示 registers | Show registers |
| `<leader>rr` | 重新載入 vimrc | Reload vimrc |
| `<leader>tt` | 新空白分頁 | New empty tab |
| `<leader>te` | 新分頁並提示檔名 | New tab + prompt for filename |
| `<leader>to` | 關閉所有其他分頁 | Close all other tabs |
| `<leader>tc` | 關閉目前分頁 | Close current tab |
| `<leader>ma` | 顯示 marks | Show marks |
| `<leader>ju` | 顯示跳轉清單 | Show jump list |
| `<leader>H` | 原始 `H`（跳到螢幕頂部，因為 `H` 已重新映射） | Original `H` (screen top) |
| `<leader>M` | 原始 `M`（跳到螢幕中間） | Original `M` (screen middle) |
| `<leader>L` | 原始 `L`（跳到螢幕底部，因為 `L` 已重新映射） | Original `L` (screen bottom) |

### Clipboard Operations (System Clipboard)

| Mapping | Mode | 說明 | Description |
|---------|------|------|--------|
| `<Leader>y` | Normal/Visual | 複製到系統剪貼簿 | Yank to system clipboard |
| `<Leader>p` | Normal/Visual | 從 yank register 貼上（不受 delete 污染） | Paste from yank register (`"0p`) |
| `<Leader>P` | Normal/Visual | 從系統剪貼簿貼到游標前 | Paste from system clipboard before cursor |
| `<Leader>x` | Normal/Visual | 刪除字元但不存入 register（黑洞） | Delete char without storing in register |
| `<Leader>dd` | Normal/Visual | 刪除整行但不存入 register | Delete line without storing in register |
| `<Leader>dw` | Normal/Visual | 刪除一個 word 但不存入 register | Delete word without storing in register |
| `<C-v>` | Insert | 從系統剪貼簿貼上 | Paste from system clipboard |
| `<C-c>` | Visual | 複製選取區域到系統剪貼簿 | Copy selection to system clipboard |
| `<C-d>` | Visual | 剪下選取區域到系統剪貼簿 | Cut selection to system clipboard |

### coc.nvim Completion

| Mapping | 說明 | Description |
|---------|------|--------|
| `<Tab>` | 下一個補全項目（或觸發補全） | Next completion item (or trigger completion) |
| `<S-Tab>` | 上一個補全項目 | Previous completion item |
| `<CR>` | 確認選取的補全項目 | Confirm selected completion item |

---

## Plugins

| Plugin | 說明 | Description |
|--------|------|---------|
| `vim-airline` | 增強版狀態列，顯示模式/分支/檔案資訊 | Enhanced status bar with mode/branch/file info |
| `vim-airline-themes` | airline 主題集合 | Theme collection for airline |
| `jedi-vim` | Python 自動補全和跳轉定義 | Python autocompletion and go-to-definition |
| `vim-surround` | 新增/修改/刪除包圍字元（如 `cs"'` 把 `"` 換成 `'`） | Add/change/delete surrounding chars |
| `targets.vim` | 額外文字物件（如 `ci,` 修改逗號分隔的內容） | Additional text objects |
| `vim-easymotion` | 快速跳到畫面上任何字元 | Jump to any visible character |
| `vim-sneak` | 兩字元搜尋跳轉（`s{char}{char}`） | Two-character find motion |
| `indentline` | 顯示垂直縮排參考線 | Display vertical indent guides |
| `coc.nvim` | 基於 LSP 的自動補全引擎（類似 IDE 的 intellisense） | LSP-based autocompletion engine |
| `fzf` + `fzf.vim` | 模糊搜尋檔案、buffer、grep 等 | Fuzzy finder for files, buffers, grep |
| `ansiesc.vim` | 在 vim 中渲染 ANSI 顏色碼 | Render ANSI escape color codes in vim buffers |
| `material.vim` | Material Design 配色方案 | Material Design colorscheme |

## Colorscheme

| Setting | 說明 | Description |
|---------|------|-------------|
| `material_terminal_italics = 1` | 啟用斜體字（用於註解/關鍵字） | Enable italic font in comments/keywords |
| `material_theme_style = 'default'` | 使用藍灰底變體（`#263238`）。可選：`default`, `palenight`, `ocean`, `darker`, `lighter` | Blue-gray variant |
| `colorscheme material` | 啟用 material 配色 | Activate the material colorscheme |

## Airline Settings

| Setting | 說明 | Description |
|---------|------|-------------|
| `airline_theme='material'` | 使用 material.vim 內建的 airline 主題 | Use material.vim's native airline theme |
| `airline_powerline_fonts = 1` | 啟用 powerline 符號（需要 Nerd Font） | Enable powerline symbols (requires Nerd Font) |
| `tabline#enabled = 1` | 在頂部顯示開啟的 buffer/tab 列表 | Show open buffers/tabs as a tab bar at the top |
| `tabline#left_sep = '‧'` | 分頁之間的分隔字元 | Separator character between tabs |
| `tabline#left_alt_sep = '┊'` | 非活動分頁的替代分隔字元 | Alternative separator for inactive tabs |
| `tabline#formatter = 'unique_tail'` | 只顯示檔名中唯一的部分 | Show only unique filename portion in tab |

## Jedi-vim Settings

| Setting | 說明 | Description |
|---------|------|-------------|
| `jedi#goto_command = "<leader>d"` | `空格+d` 跳到定義 | Jump to definition |
| `jedi#goto_assignments_command = "<leader>g"` | `空格+g` 跳到賦值處 | Jump to assignment |
| `jedi#goto_stubs_command = "<leader>s"` | `空格+s` 跳到 stub | Jump to stub |
| `jedi#documentation_command = "K"` | `K` 顯示文件 | Show documentation |
| `jedi#usages_command = "<leader>u"` | `空格+u` 查找所有使用處 | Find all usages |
| `jedi#completions_command = "<C-Space>"` | `Ctrl-Space` 觸發補全 | Trigger completion |
| `jedi#auto_initialization = 1` | 開啟 Python 檔案時自動初始化 | Auto-initialize jedi on Python files |
| `jedi#popup_on_dot = 0` | 打 `.` 時不自動彈出補全 | Don't auto-popup completion after typing `.` |

## IndentLine Settings

| Setting | 說明 | Description |
|---------|------|-------------|
| `vim_json_conceal=0` | 不隱藏 JSON 檔案中的雙引號（修正 indentLine 的副作用） | Don't hide quotes in JSON files |
| `indentLine_enabled = 1` | 啟用縮排參考線 | Enable indent guides |
| `indentLine_setColors = 1` | 讓插件自行設定顏色 | Let plugin set its own colors |
| `indentLine_color_term = 214` | 256 色模式下參考線的顏色（金橘色） | Indent guide color in 256-color mode (gold/orange) |
| `indentLine_defaultGroup = 'SpecialKey'` | 備用高亮群組 | Fallback highlight group |
| `indentLine_char = '§'` | 預設縮排字元 | Default indent character |
| `indentLine_char_list` | 每層縮排用不同字元：`|` `¦` `┆` `┊` | Cycle different chars per indent level |

---

## Autocmds

| Autocmd | 說明 | Description |
|---------|------|-------------|
| `FileType text setlocal textwidth=78` | 純文字檔案自動在 78 字元處換行 | Wrap text files at 78 columns |
| `BufReadPost * ... g\`"` | 重新開啟檔案時跳回上次游標位置 | Jump to last cursor position when reopening a file |
| `BufNewFile *.sh ...` | 新建 `.sh` 檔案自動加入 shebang + 作者標頭 | New `.sh` files get shebang + author header |
| `BufNewFile *.py ...` | 新建 `.py` 檔案自動加入 shebang + 作者標頭 | New `.py` files get shebang + author header |
| `BufEnter,FocusGained,InsertLeave` | 取得焦點/離開 Insert 模式時啟用相對行號 + 游標行高亮 | Enable relative numbers + cursorline when focused/normal mode |
| `BufLeave,FocusLost,InsertEnter` | 失去焦點/進入 Insert 模式時關閉相對行號 + 游標行高亮 | Disable relative numbers + cursorline when unfocused/insert mode |
