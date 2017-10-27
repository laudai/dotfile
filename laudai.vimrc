" Author : laudai
"
"
" Use Vim settings, rather than Vi settings (much better!).
" " This must be first, because it changes other options as a side effect.
set nocompatible


"設定狀態

set number
set autoindent "自動縮排"
set laststatus=2
set t_Co=256
set ruler

"設定背景
set bg =dark

"設定軟體狀態
set shiftwidth=4 ""bcz I write python , 
set tabstop=4 ""bcz I write python
set softtabstop=4

"設定插入模式中斷快速鍵
imap jk <ESC>
" It's mean insert map jk to ESC

"設定命令模式中斷快速鍵
cmap jk <ESC>
" It's mean insert map jk to ESC

"設定搜尋顏色
set hlsearch " it can set hls 

"將vim中的0開頭數字視為10進制，這樣就可以直接用快鍵加減
"number<C-a> or number<C-x>
set nrformats=


" This is copy from vim74 example

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
