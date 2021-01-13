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
set nocompatible
set background=dark "bg"
set t_Co=256 "number of colors"
set laststatus=2 "ls, 下方的狀態橫Bar。Default is 1"
set ruler "ru, 狀態列最右邊的資訊，共有Top, Bot, All, %"
set shiftwidth=4 "sw, 使用>>的字元寬度，如果是0會使用tabstop設定"
set softtabstop=4 "sts"
set tabstop=4 "ts"
"set expandtab=4 "et, 還不確定是什麼功能"
set hlsearch "hls, highlith all its matches."
" 將vim中的0開頭數字視為10進制，這樣就可以直接用快鍵加減
" number<C-a> or number<C-x>
set nrformats=
" works likes bash shell
" set wildmode=longest,list
" works likes zsh
set wildmenu "wmnu, default is off"
set wildmode=full "wim, default is full"
set history=200 "set history number, default is 50
set incsearch "is, 即時前往符合搜尋條件的字,default is off"
set pastetoggle=<F7> "pt, toggle vim paste mode"
" enable X11-based-system clipboard, In Ubuntu & Debian, u need install vim-gtk3
set clipboard=unnamedplus


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
nmap <C-]> <ESC>:e<CR> "re-edit this file in normal mode"
" Insert newline without entering insert mode
" https://vim.fandom.com/wiki/Insert_newline_without_entering_insert_mode
nn o o<Esc>k
nn O O<Esc>j
" Shifting blocks visually
" https://vim.fandom.com/wiki/Shifting_blocks_visually
vnoremap > >gv
vnoremap < <gv
inoremap <S-Tab> <C-D>
vnoremap <Tab> >v
vnoremap <S-Tab> <v

"  VIM学习笔记 键盘映射 (Map)
" http://yyq123.blogspot.com/2010/12/vim-map.html
" 快捷鍵設定教學
" 中文版	http://haoxiang.org/2011/09/vim-modes-and-mappin/
" 英文版	https://medium.com/vim-drops/understand-vim-mappings-and-create-your-own-shortcuts-f52ee4a6b8ed


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


" Python header
autocmd BufNewFile *.py 0put =\"#!/usr/bin/env python\<nl>\"|$
autocmd BufNewFile *.py 1put =\"# encoding: utf8\<nl>\"|$
autocmd BufNewFile *.py 2put =\"# Author : laudai\<nl>\"|$
autocmd BufNewFile *.py 3put =\"\<nl>\"|$

" Vim’s absolute, relative and hybrid line numbers
" https://jeffkreeftmeijer.com/vim-number/
augroup numbertoggle
  autocmd!
  autocmd BufEnter,FocusGained,InsertLeave * set relativenumber
  autocmd BufLeave,FocusLost,InsertEnter   * set norelativenumber
augroup END
