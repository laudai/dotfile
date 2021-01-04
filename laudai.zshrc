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
plugins=(git pip python systemd tmux docker docker-compose encode64 zsh-autosuggestions autojump zsh-syntax-highlighting sudo vscode vi-mode)

# Default ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
# See more document via man zshzle
# use colour 0~7 avoid terminal only supports 8 colors
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=5,bg=none,bold,underline"

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

# Keybindings
bindkey '^[\' autosuggest-toggle # alt-\
# How to switch comfortably to vi command mode on the zsh command line?
# https://superuser.com/questions/351499/how-to-switch-comfortably-to-vi-command-mode-on-the-zsh-command-line
bindkey -M viins 'jk' vi-cmd-mode
# keybindings reference
# https://github.com/ohmyzsh/ohmyzsh/blob/master/lib/key-bindings.zsh
# https://github.com/ThiefMaster/zsh-config/blob/master/zshrc.d/keybinds.zsh


# SETTING
HIST_STAMPS="yyyy-mm-dd"

# To remove any command from the zsh history file
# this method is from https://goo.gl/sTPu62
histrm() { LC_ALL=C sed --in-place '/$1/d' $HISTFILE }

# let urlview to use firefox browser to show
if [ -e '/usr/bin/firefox' ] ; then
  export BROWSER='/usr/bin/firefox'
fi


# cd folder and ls item at the same time
# this method is from https://goo.gl/92NCHU
function cdls() {
  cd $1 ;
  ls
}

function mkcdf() {
  mkdir $1 
  cd $1
  # new folder and enter the folder
}

# docker alias
alias dcp="docker-compose"
alias dcls="docker container ls"
alias dclsa="docker container ls -a"

# operating alias
alias cls="printf '\033c'"
alias gquit="gnome-session-quit"
alias gquit--no-prompt="gnome-session-quit --no-prompt"
alias dotfile="cd ~/.dotfile"

# git alias
alias glodsd="glods --date=local" # must use with zsh git plugin
alias grf="git reflog"

# python alias
#alias python="/usr/bin/python3"
#alias pip="/usr/bin/pip3"

# curl alias
alias wttrk="curl wttr.in/kaohsiung"
alias wttrt="curl wttr.in/taipei"

# export
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

# pyenv , pyenv virtualenv initalize
if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
eval "$(pyenv virtualenv-init -)"
