#     _                    ____
#  \_|_)                  (|   \       o
#    |     __,             |    | __,
#   _|    /  |  |   |     _|    |/  |  |
#  (/\___/\_/|_/ \_/|_/  (/\___/ \_/|_/|_/
#
#  Github : https://github.com/laudai
#  Medium : https://laudaihe.medium.com/

# If you come from bash you might have to change your $PATH.
# export PATH=$HOME/bin:/usr/local/bin:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/.oh-my-zsh

# Set name of the theme to load. Optionally, if you set this to "random"
# it'll load a random theme each time that oh-my-zsh is loaded.
# See https://github.com/robbyrussell/oh-my-zsh/wiki/Themes
#ZSH_THEME="robbyrussell"
#ZSH_THEME="random"
ZSH_THEME="cloud"

#I like the THEME:
#cloud.zsh-theme
#gentoo.zsh-theme
#steeef.zsh-theme
#powerlevel10k/powerlevel10k # need install

#if [ "$HOST"="raspberrypi" ]
#then
#	ZSH_THEME="robbyrussell"
#fi
#
#if [ "$HOST"="ldv" ]
#then
#	ZSH_THEME="cloud"
#fi

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(
    git
    pip
    python
    systemd
    tmux
    docker
    docker-compose
    encode64
    autojump
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    vscode
    vi-mode
    zsh-navigation-tools
    git-open
)
# plugin history-substring-search should load before zsh-syntax-highlighting to avoid syantax error


source $ZSH/oh-my-zsh.sh

# User configuration

# export MANPATH="/usr/local/man:$MANPATH"

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/rsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

#    __ __           __    _           ___
#   / //_/__  __  __/ /_  (_)___  ____/ (_)___  ____ ______
#  / ,< / _ \/ / / / __ \/ / __ \/ __  / / __ \/ __ `/ ___/
# / /| /  __/ /_/ / /_/ / / / / / /_/ / / / / / /_/ (__  )
#/_/ |_\___/\__, /_.___/_/_/ /_/\__,_/_/_/ /_/\__, /____/
#          /____/                            /____/

# keybindings
bindkey '^[\' autosuggest-toggle # alt-\
bindkey -s '^[d' '^Uexit^M'
bindkey '^P' history-substring-search-up
bindkey '^N' history-substring-search-down
bindkey -M menuselect 'j' vi-down-line-or-history
bindkey -M menuselect 'k' vi-up-line-or-history
bindkey -M menuselect 'l' vi-forward-char
bindkey -M menuselect 'h' vi-backward-char
bindkey '^Y^Y' undo # bind ^Y^Y undo like emacs ^Y keymaps
bindkey '^[l' forward-word # alt-l
bindkey '^[h' backward-word # alt-h
# How to switch comfortably to vi command mode on the zsh command line?
# https://superuser.com/questions/351499/how-to-switch-comfortably-to-vi-command-mode-on-the-zsh-command-line
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^[e' _select-emacs
bindkey -M vicmd '^[e' _select-emacs
bindkey -M emacs '^[v' _select-vi
bindkey -M vicmd " e" end-of-line
bindkey -M vicmd " a" beginning-of-line
# zsh-navigation-tools  keybindings
zle -N znt-cd-widget
bindkey "^B" znt-cd-widget
zle -N znt-kill-widget
bindkey "^Y" znt-kill-widget
# keybindings reference
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
# https://github.com/ThiefMaster/zsh-config/blob/master/zshrc.d/keybinds.zsh


#   _____      __  __  _
#  / ___/___  / /_/ /_(_)___  ____ _
#  \__ \/ _ \/ __/ __/ / __ \/ __ `/
# ___/ /  __/ /_/ /_/ / / / / /_/ /
#/____/\___/\__/\__/_/_/ /_/\__, /
#                          /____/

# setting
HIST_STAMPS="yyyy-mm-dd"

# Default ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
# See more document via man zshzle
# use colour 0~7 avoid terminal only supports 8 colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5,bg=none,bold,underline"

# [zsh comments nearly invisible on command-line](https://unix.stackexchange.com/questions/577586/zsh-comments-nearly-invisible-on-command-line)
# https://github.com/zsh-users/zsh-syntax-highlighting/tree/master/highlighters/main
# Declare the variable
typeset -A ZSH_HIGHLIGHT_STYLES
ZSH_HIGHLIGHT_STYLES[comment]="fg=white,bold,underline"
ZSH_HIGHLIGHT_STYLES[builtin]="bg=green"
ZSH_HIGHLIGHT_STYLES[single-quoted-argument-unclosed]="bg=magenta"
ZSH_HIGHLIGHT_STYLES[double-quoted-argument-unclosed]="bg=magenta"

VI_MODE_RESET_PROMPT_ON_MODE_CHANGE=true
VI_MODE_SET_CURSOR=true
MODE_INDICATOR='%B%F{blue}<%b<<%f'


#    ______                 __  _
#   / ____/_  ______  _____/ /_(_)___  ____
#  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \
# / __/ / /_/ / / / / /__/ /_/ / /_/ / / / /
#/_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/

# function
# Function name with an underscore to not user-callable function.
# To remove any command from the zsh history file
# this method is from https://goo.gl/sTPu62
histrm() { LC_ALL=C sed --in-place '/$1/d' $HISTFILE }

# cd folder and ls item at the same time
# this method is from https://goo.gl/92NCHU
function cdls() {
  cd $1 ;
  ls
}

# new folder and enter the folder
function mkcdf() {
  mkdir $1
  cd $1
}

# change to vim insert mode and use emacs keymap
function _select-emacs() {
  zle vi-insert
  set -o emacs
}
zle -N _select-emacs

# use vi keymap
function _select-vi() {
  set -o vi
}
zle -N _select-vi

#     ___    ___
#    /   |  / (_)___ ______
#   / /| | / / / __ `/ ___/
#  / ___ |/ / / /_/ (__  )
# /_/  |_/_/_/\__,_/____/

# alias
# docker alias
alias dcp="docker-compose"
alias dcls="docker container ls"
alias dclsa="docker container ls -a"

# operating alias
alias cls="printf '\033c'"
alias gquit="gnome-session-quit"
alias gquit--no-prompt="gnome-session-quit --no-prompt"
alias dotfile="cd ~/.dotfile"
alias li="set -o | grep 'emacs\|^vi'"
alias di="dirs -v"

# git alias
alias glodsd="glods --date=local" # must use with zsh git plugin
alias grf="git reflog"

# python alias
#alias python="/usr/bin/python3"
#alias pip="/usr/bin/pip3"

# curl alias
alias wttrk="curl wttr.in/kaohsiung"
alias wttrt="curl wttr.in/taipei"

# zsh-navigation-tools plugin alias
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help

# suffix alias
alias -s {md,py,txt,vimrc,zshrc,conf}=vim
alias -s sh=bash

# global alais
# https://thorsten-hans.com/5-types-of-zsh-aliases
# e.g. cd && ls -l G do
alias -g G=" | grep -i"
alias -g xc=" | xclip -selection clipboard"

# edit and source config
alias ez="$EDITOR $HOME/.zshrc"
alias et="$EDITOR $HOME/.tmux.conf"
alias ev="$EDITOR $HOME/.vimrc"
alias sz="source $HOME/.zshrc"

#    ______                      __
#   / ____/  ______  ____  _____/ /_
#  / __/ | |/_/ __ \/ __ \/ ___/ __/
# / /____>  </ /_/ / /_/ / /  / /_
#/_____/_/|_/ .___/\____/_/   \__/

# export
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"
export EDITOR="vim"
export VISUAL="$EDITOR"
export MYVIMRC="$HOME/.vimrc"

# let urlview to use firefox browser to show
if [ -e '/usr/bin/firefox' ] ; then
  export BROWSER='/usr/bin/firefox'
fi

# pyenv , pyenv virtualenv initalize
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
eval "$(pyenv virtualenv-init -)"
