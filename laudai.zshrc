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

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
source "$HOME/.dotfile/color.txt"

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
    nvm
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
# You can use C-v in your shell to check what key combinaiton you press
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
bindkey '^[.' insert-last-word # alt-.
# How to switch comfortably to vi command mode on the zsh command line?
# https://superuser.com/questions/351499/how-to-switch-comfortably-to-vi-command-mode-on-the-zsh-command-line
bindkey -M viins 'jk' vi-cmd-mode
bindkey -M viins '^[e' _select-emacs
bindkey -M vicmd '^[e' _select-emacs
bindkey -M emacs '^[v' _select-vi
bindkey -M viins '\ec' _select-emacs
bindkey -M emacs '\ec' _select-vi
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

# display setting for monitor
function screen_to_monitor(){
	xrandr --output eDP-1 --mode 1920x1080
}

# display setting for panel
function screen_to_panel(){
	xrandr --output eDP-1 --mode 1600x900
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

# toggle your gnome desktop screensaver lock-enabled & ubuntu-lock-on-suspend
# 切換自動鎖定螢幕、暫停時鎖定螢幕
toggle-sll() {
  local lock_enabled=$(gsettings get org.gnome.desktop.screensaver lock-enabled)
  local ubuntu_lock_on_suspend=$(gsettings get org.gnome.desktop.screensaver ubuntu-lock-on-suspend)

  if [[ $lock_enabled == true && $ubuntu_lock_on_suspend == true ]]; then
	  gsettings set org.gnome.desktop.screensaver lock-enabled false
	  gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend false
	  echo -e "Your screen lock_enabled and ubuntu_lock_on_suspend are all ${BOLD_GREEN}True${RESET}."
	  echo -e "Trun screen lock_enabled and ubuntu_lock_on_suspend to ${BOLD_RED}False${RESET}."

  else
	  gsettings set org.gnome.desktop.screensaver lock-enabled true
	  gsettings set org.gnome.desktop.screensaver ubuntu-lock-on-suspend true
	  echo -e "Your screen lock_enabled or ubuntu_lock_on_suspend is ${BOLD_RED}False${RESET}."
	  echo -e "Trun screen lock_enabled and ubuntu_lock_on_suspend all ${BOLD_GREEN}True${RESET}."
  fi
}

# toggle your gnome app-switcher current-workspace-only
# 切換是否可以透過'切換相同程式'切換不同 workspace 的視窗
toggle-app-switcher_workspace-only() {
  local app_switcher_workspace=$(gsettings get org.gnome.shell.app-switcher current-workspace-only)
  if [[ $app_switcher_workspace == true ]]; then
	  gsettings set org.gnome.shell.app-switcher current-workspace-only false
	  echo -e "Change app-switcher current-workspace-only to ${BOLD_RED}False${RESET}."
  elif [[ $app_switcher_workspace == false ]]; then
	  gsettings set org.gnome.shell.app-switcher current-workspace-only true
	  echo -e "Change app-switcher current-workspace-only to ${BOLD_GREEN}True${RESET}."
  fi
}

# toggle your gnome window-switcher current-workspace-only
# 切換是否可以透過'切換視窗'切換不同 workspace 的視窗
toggle-window-switcher_workspace-only() {
  local window_switcher_workspace=$(gsettings get org.gnome.shell.window-switcher current-workspace-only)
  if [[ $window_switcher_workspace == true ]]; then
	  gsettings set org.gnome.shell.window-switcher current-workspace-only false
	  echo -e "Change window-switcher current-workspace-only to ${BOLD_RED}False${RESET}."
  elif [[ $window_switcher_workspace == false ]]; then
	  gsettings set org.gnome.shell.window-switcher current-workspace-only true
	  echo -e "Change window-switcher current-workspace-only to ${BOLD_GREEN}True${RESET}."
  fi
}

# toggle your gnome interface animations
# 切換 gnome 特效動畫
toggle-gnome-interface_animations() {
  local gnome_interface_animations=$(gsettings get org.gnome.desktop.interface enable-animations)
  if [[ $gnome_interface_animations == true ]]; then
	  gsettings set org.gnome.desktop.interface enable-animations false
	  echo -e "Change gnome interface animations to ${BOLD_RED}False${RESET}."
  elif [[ $gnome_interface_animations == false ]]; then
	  gsettings set org.gnome.desktop.interface enable-animations true
	  echo -e "Change gnome interface animations to ${BOLD_GREEN}True${RESET}."
  fi
}

# toggle your gnome workspace only with primary monitor
# 只在主螢幕切換 workspace
toggle-workspace-primary-monitor-only() {
  local workspace_primary_monitor_only=$(gsettings get org.gnome.mutter workspaces-only-on-primary)
  if [[ $workspace_primary_monitor_only == true ]]; then
	  gsettings set org.gnome.mutter workspaces-only-on-primary false
	  echo -e "Change gnome workspace only on primary monitor to ${BOLD_RED}False${RESET}."
  elif [[ $workspace_primary_monitor_only == false ]]; then
	  gsettings set org.gnome.mutter workspaces-only-on-primary true
	  echo -e "Change gnome workspace only on primary monitor to ${BOLD_GREEN}True${RESET}."
  fi
}


#    ______                      __
#   / ____/  ______  ____  _____/ /_
#  / __/ | |/_/ __ \/ __ \/ ___/ __/
# / /____>  </ /_/ / /_/ / /  / /_
#/_____/_/|_/ .___/\____/_/   \__/
#          /_/

# export
export EDITOR="vim"
export VISUAL="$EDITOR"
export MYVIMRC="$HOME/.vimrc"
export DOTFILE="$HOME/.dotfile"

# let urlview to use firefox browser to show
if [ -e '/usr/bin/firefox' ] ; then
  export BROWSER='/usr/bin/firefox'
fi


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
alias kagt="killall gnome-terminal-server"
alias kagc="killall gnome-calculator"
alias less="less -r" # in raw-control-chars for default

# line alias
alias line="chromium-browser chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html#popout > /dev/null 2>&1 &"
# git alias
alias glodsd="glods --date=local" # must use with zsh git plugin
alias grf="git reflog"

# oh-my-zsh plugin git alias
alias gmd="less ~/.oh-my-zsh/plugins/git/README.md 2> /dev/null || echo 'File not founded.'"

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
alias -s {md,py,txt,vimrc,zshrc,conf,toml}=vim
alias -s sh=bash

# global alais
# https://thorsten-hans.com/5-types-of-zsh-aliases
# e.g. cd && ls -l G do
alias -g G=" | grep -i"
alias -g xc=" | sed -z 's/\n$//' | xclip -selection clipboard"
alias -g ca=" | cat"

# edit and source config
alias ez="$EDITOR $HOME/.zshrc"
alias et="$EDITOR $HOME/.tmux.conf"
alias ev="$EDITOR $HOME/.vimrc"
alias es="$EDITOR $HOME/.config/starship.toml"
alias sz="source $HOME/.zshrc"


#    ____      _ __
#   /  _/___  (_) /_
#   / // __ \/ / __/
# _/ // / / / / /_
#/___/_/ /_/_/\__/

# nvm
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm

# starship
eval "$(starship init zsh)"

# https://superuser.com/questions/117841/when-reading-a-file-with-less-or-more-how-can-i-get-the-content-in-colors
#export LESS="-r" #useful for raw-control-chars, but can't like alias to escape via backslash \
