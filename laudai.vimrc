"     _                    ____
"  \_|_)                  (|   \       o
"    |     __,             |    | __,
"   _|    /  |  |   |     _|    |/  |  |
"  (/\___/\_/|_/ \_/|_/  (/\___/ \_/|_/|_/
"
"  Github : https://github.com/laudai
"  Medium : https://laudaihe.medium.com/

" Use Vim settings, rather than Vi settings (much better!).
" " This must be first, because it changes other options as a side effect.

" VI Setting
set number "nu"
set relativenumber "rnu"
"ai, 自動縮排，如果此行從第四字元開始，按下Enter後，下行就會從第四字元開始。Default is noai"
set autoindent


" VIM Setting
"nocp, no compatible to vi,can use vim plugin.Default is nocp"
set nocompatible "disable backwards compatibility with vi
set background=dark "bg"
set t_Co=256 "number of colors"
set laststatus=2 "ls, 下方的狀態橫Bar。Default is 1"
set ruler "ru, 狀態列最右邊的資訊，共有Top, Bot, All, %"
set shiftwidth=4 "sw, 使用>>的字元寬度，如果是0會使用tabstop設定"
set softtabstop=4 "sts"
set tabstop=4 "ts"
"set expandtab=4 "et, 還不確定是什麼功能"
" search-setting
set hlsearch "hls, highlith all its matches."
set incsearch "is, 即時前往符合搜尋條件的字
set ignorecase "ic, 忽略大小寫
set smartcase "scs, 智慧搜尋
" works likes bash shell
" set wildmode=longest,list
" works likes zsh
set wildmenu "wmnu, default is off"
set wildmode=full "wim, default is full"
" need try later
" https://www.reddit.com/r/vim/comments/vvtz3v/comment/ifocpxd/?utm_source=share&utm_medium=web2x&context=3
" set wildoptions+=fuzzy
set history=200 "set history number, default is 50
set pastetoggle=<F7> "pt, toggle vim paste mode"
" edit-setting
" enable X11-based-system clipboard, In Ubuntu & Debian, u need install vim-gtk3
" https://stackoverflow.com/questions/3961859/how-to-copy-to-clipboard-in-vim
set clipboard^=unnamedplus,unnamed " this setting run on both Linux, and MacOS M1
filetype plugin indent on " enable filetype plugins and indent
set undofile
set autochdir " acd, 當開啟多個不同資料夾檔案時，會自動切換到目前編輯檔案路徑
set autoread " ar, 當文件僅在vim外部進行修改，可進行自動讀檔(有焦點使用限制）
" misc-setting
" 將vim中的0開頭數字視為10進制，這樣就可以直接用快鍵加減
" number<C-a> or number<C-x>
set nrformats=bin,hex,alpha

" Highlight setting
highlight CursorLine cterm=bold,underline ctermbg=black ctermfg=None

" Abbreviations setting ,ab
iab [] []()<left><left><left>


" Keybindings
" map-modes
":map   :noremap  :unmap     Normal, Visual, Select, Operator-pending
":nmap  :nnoremap :nunmap    Normal
":vmap  :vnoremap :vunmap    Visual and Select
":smap  :snoremap :sunmap    Select
":xmap  :xnoremap :xunmap    Visual
":omap  :onoremap :ounmap    Operator-pending
":map!  :noremap! :unmap!    Insert and Command-line
":imap  :inoremap :iunmap    Insert
":lmap  :lnoremap :lunmap    Insert, Command-line, Lang-Arg
":cmap  :cnoremap :cunmap    Command-line
":tmap  :tnoremap :tunmap    Terminal-Job
" nnoremap : Normal no recursion map
map! jk <ESC>
imap <C-]> <ESC>:e<CR> "re-edit this file in insert mode"
inoremap <C-v><C-v> <C-v>
inoremap <C-d> <Del>
" Insert newline without entering insert mode
" https://vim.fandom.com/wiki/Insert_newline_without_entering_insert_mode
nnoremap oo o<Esc>k
nnoremap OO O<Esc>j
" Shifting blocks visually
" https://vim.fandom.com/wiki/Shifting_blocks_visually
vnoremap > >gv
vnoremap < <gv
inoremap <S-Tab> <C-D>
vnoremap <Tab> >v
vnoremap <S-Tab> <v
map <ESC>n <M-n>
map <ESC>p <M-p>
nnoremap <M-n> :tabn<CR> \| :echo 'Change to next tab'<CR>
nnoremap <M-p> :tabp<CR> \| :echo 'Change to previous tab'<CR>
nnoremap <C-p> :bp<CR> \| :echo 'Change to previous buffer'<CR>
nnoremap <C-n> :bn<CR> \| :echo 'Change to next buffer'<CR>
nnoremap ` '
nnoremap ' `
" onoremap ' `
" onoremap ` '
" you can modified operator pending mode to use y'' d''
" also can use operatorPendingModeKeyBindings in VSCode vim keymap
" https://vi.stackexchange.com/questions/12576/how-to-remap-backtick-mark-with-single-quote-mark-globally
nmap qq :q<CR>
nmap q; q:
map <ESC>j <M-j>
map <ESC>k <M-k>
nn <M-j> :.m+1<CR>
nn <M-k> :.m-2<CR>
" You can't send C-j to vim in gnome-terminal. It will parse to C-M.
" But you can use it in Windows terminal, guake terminal.
nn <C-j> <C-w>j
nn <C-k> <C-w>k
nn <C-l> <C-w>l
nn <C-h> <C-w>h
nn <C-\> <C-w>w
nn a; :
nn aj 5j \| :echo 'Downward 5 linewise.'<CR>
nn ak 5k \| :echo 'Upward 5 linewise.'<CR>
nn H ^
nn L g_
nn Y y$
nn <C-v><C-v> <C-v>
" set manual store/restore vim session
set <S-F4>=[1;2S
nn <S-F4> :mksession! ~/.vim_manual_session.vim<CR> \| :echo 'stores session to ~/.vim_manual_session.vim'<CR>
nn <F4> :source ~/.vim_manual_session.vim<CR> \| :echo 'restores session from ~/.vim_manual_session.vim'<CR>
" break undo sequence, start new change for the Ctrl-w, Ctrl-u, Ctrl-h, Ctrl-d
" https://vim.fandom.com/wiki/Recover_from_accidental_Ctrl-U
inoremap <C-u> <C-g>u<C-u>
inoremap <C-w> <C-g>u<C-w>
inoremap <C-h> <C-g>u<C-h>
inoremap <C-d> <C-g>u<Del>


" Toggle Cursorline on/off with one key press
" https://stackoverflow.com/questions/1497404/toggle-cursorline-on-off-with-one-key-press
" Mapping 'fast' keycodes
" https://vim.fandom.com/wiki/Mapping_fast_keycodes_in_terminal_Vim
" You should test keystroke in VIM ex mode via :{C-v}{C-S-F2}
" There is a <S-F2> keycodes but no <C-S-F2>. You should map keystroke to <C-S-F2>
" :h keycodes, :h terminal-key-codes
" <ESC> equal ^[
set <S-F2>=[1;2Q
map <S-F2> :set cursorline!<CR>
map <ESC>[1;5Q <C-F2>
map <C-F2> :set cursorcolumn!<CR>
map <ESC>[1;6Q <C-S-F2>
map <C-S-F2> :set cursorcolumn!<Bar>set cursorline!<CR>
" Toggle relativenumber
map <ESC>[1;6R <C-S-F3>
map <C-S-F3> :set rnu!<CR>

" <leader> mapleader, <leader> key default is '\'
let mapleader="\<space>"
nmap <leader>n :noh<CR>
nmap <leader>w <ESC>:w<CR>
nmap <leader>d ^dg_ \| :echo "Delete whole line without linewise from
    \ non-block to non-block char!"<CR>
nmap <leader>bd :bd<CR>
" buffer only can mapping via keybinding or use plugin BufOnly.vim
" https://stackoverflow.com/questions/4545275/vim-close-all-buffers-but-this-one
nmap <leader>bo :%bd\|e#<CR>
nmap <leader>qq <ESC>:cq<CR>
nnoremap <leader>ev :vsp ~/.vimrc<CR>
nnoremap <leader>r :reg<CR>
nnoremap <leader>rr :source ~/.vimrc<CR>
nmap <leader>tt :tabe<CR>
nmap <leader>te :tabe<space>
nmap <leader>to :tabo<CR>
nmap <leader>tc <ESC>:tabc<CR>
nmap <leader>ma :marks<CR>
nmap <leader>ju :jumps<CR>
nn <leader>H H
nn <leader>M M
nn <leader>L L

" use system clipboard, also u can use xsel,xclip command.
noremap <Leader>y "+y
noremap <Leader>p "0p
noremap <Leader>P "+P
noremap <Leader>x "_x
noremap <Leader>dd "_dd
noremap <Leader>dw "_dw
inoremap <C-v> <ESC>"+pa
vnoremap <C-c> "+y
vnoremap <C-d> "+d
"  VIM学习笔记 键盘映射 (Map)
" http://yyq123.blogspot.com/2010/12/vim-map.html
" 快捷鍵設定教學
" 中文版	http://haoxiang.org/2011/09/vim-modes-and-mappin/
" 英文版	https://medium.com/vim-drops/understand-vim-mappings-and-create-your-own-shortcuts-f52ee4a6b8ed

" coc.nvim <TAB>, <CR> map
" https://github.com/neoclide/coc.nvim
" Use tab for trigger completion with characters ahead and navigate
" NOTE: There's always complete item selected by default, you may want to enable
" no select by `"suggest.noselect": true` in your configuration file
" NOTE: Use command ':verbose imap <tab>' to make sure tab is not mapped by
" other plugin before putting this into your config
inoremap <silent><expr> <TAB>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ CheckBackspace() ? "\<Tab>" :
      \ coc#refresh()
inoremap <expr><S-TAB> coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"
" Make <CR> to accept selected completion item or notify coc.nvim to format
" <C-g>u breaks current undo, please make your own choice
inoremap <silent><expr> <CR> coc#pum#visible() ? coc#pum#confirm()
                              \: "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
function! CheckBackspace() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction


" Plugin
" vim-plug automatic installation
" https://github.com/junegunn/vim-plug/wiki/tips#automatic-installation
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
    \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
"
" airline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
" https://python.libhunt.com/compare-python-mode-vs-jedi-vim
" Developing python with vim, what plugin to choose? (python-mode vs. jedi-vim)
Plug 'davidhalter/jedi-vim'
" Plug 'python-mode/python-mode', { 'for': 'python', 'branch': 'develop' }
" edit file more smoothly
Plug 'tpope/vim-surround'
Plug 'wellle/targets.vim'
Plug 'easymotion/vim-easymotion'
Plug 'justinmk/vim-sneak'
Plug 'yggdroot/indentline'
" coc, vim auto complete. Use release branch (recommended)
Plug 'neoclide/coc.nvim', {'branch': 'release'}
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'
Plug 'berdandy/ansiesc.vim'
" Pending
" 'jiangmiao/auto-pairs'
" 'preservim/nerdtree'
"
"
" Initialize plugin system
call plug#end()

" Plugin setting
" airline plugin
let g:airline_theme='base16_google'
let g:airline_powerline_fonts = 1
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = '‧'
let g:airline#extensions#tabline#left_alt_sep = '┊'
let g:airline#extensions#tabline#formatter = 'unique_tail'
" jedi-vim plugin
let g:jedi#goto_command = "<leader>d"
let g:jedi#goto_assignments_command = "<leader>g"
let g:jedi#goto_stubs_command = "<leader>s"
let g:jedi#goto_definitions_command = ""
let g:jedi#documentation_command = "K"
let g:jedi#usages_command = "<leader>u"
let g:jedi#completions_command = "<C-Space>"
let g:jedi#auto_initialization = 1
let g:jedi#popup_on_dot = 0
autocmd FileType python setlocal completeopt-=preview
" indentLine plugin
let g:indentLine_enabled = 1
let g:indentLine_setColors = 1
let g:indentLine_color_term = 214
"let g:indentLine_bgcolor_term = 240
let g:indentLine_defaultGroup = 'SpecialKey'
let g:indentLine_char = '§'
let g:indentLine_char_list = ['|', '¦', '┆', '┊']

""" This is copy from vim74 example

" Only do this part when compiled with support for autocommands.
if has("autocmd")

  " Enable file type detection.
  " Use the default filetype settings, so that mail gets 'tw' set to 72,
  " 'cindent' is on in C files, etc.
  " Also load indent files, to automatically do language-dependent indenting.
  filetype plugin indent on

  " Put these in an autocmd group, so that we can delete them easily.
  augroup vimrcEx
  au!

  " For all text files set 'textwidth' to 78 characters.
  autocmd FileType text setlocal textwidth=78

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") >= 1 && line("'\"") <= line("$") |
    \   exe "normal! g`\"" |
    \ endif

  augroup END

else

  set autoindent		" always set autoindenting on

endif " has("autocmd")

" This is copy from vim74 example


" Bash Script header
autocmd BufNewFile *.sh 0put =\"#!/usr/bin/env bash\<nl>\"|$
autocmd BufNewFile *.sh 1put =\"# Author : laudai\<nl>\"|$
autocmd BufNewFile *.sh 2put =\"\<nl>\"|$

" Python header
autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl>\"|$
autocmd BufNewFile *.py 1put =\"# encoding: utf8\<nl>\"|$
autocmd BufNewFile *.py 2put =\"# Author : laudai\<nl>\"|$
autocmd BufNewFile *.py 3put =\"\<nl>\"|$

" Vim’s absolute, relative and hybrid line numbers
" https://jeffkreeftmeijer.com/vim-number/
augroup displaytoggle
  autocmd!

  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
    \| set cursorline
    \| highlight LineNr ctermfg=darkgray

  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
    \| set nocursorline
    \| highlight LineNr ctermfg=yellow
augroup END
