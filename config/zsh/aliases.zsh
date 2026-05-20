#     ___    ___
#    /   |  / (_)___ ______
#   / /| | / / / __ `/ ___/
#  / ___ |/ / / /_/ (__  )
# /_/  |_/_/_/\__,_/____/

# alias

# operating alias
alias cls="printf '\033c'"
alias gquit="gnome-session-quit"
alias gquit--no-prompt="gnome-session-quit --no-prompt"
alias dotfile="cd ~/.dotfile"
alias li="set -o | grep 'emacs\|^vi'"
alias kagt="killall gnome-terminal-server"
alias kagc="killall gnome-calculator"
alias less="less -N --RAW-CONTROL-CHARS --quit-if-one-screen" # in RAW-CONTROL-CHARS for default, recommend in the manual.

# git alias
alias glodsd="glods --date=local" # must use with zsh git plugin
alias glolar="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar, %aI) %C(bold blue)<%an>%Creset'" # show the git log without --all flag to run commit to commit
alias glolara="git log --graph --pretty='%Cred%h%Creset -%C(auto)%d%Creset %s %Cgreen(%ar, %aI) %C(bold blue)<%an>%Creset' --all" # show the git log in relative/absolute timestamp
alias grf="git reflog"
alias gdst="git diff --stat"
alias gsa="git show --all --shortstat --stat"
alias glup='git log @{u}..HEAD --oneline'

# ssh alias
alias sshr="ssh-keygen -R " # to remove specify ssh key by name

# curl alias
alias wttrhelp="curl wttr.in/:help | less"

# python alias
#alias python="/usr/bin/python3"
#alias pip="/usr/bin/pip3"

# oh-my-zsh plugin git alias
alias gmd="less ~/.oh-my-zsh/plugins/git/README.md 2> /dev/null || echo 'File not founded.'"

# zsh-navigation-tools plugin alias
alias naliases=n-aliases ncd=n-cd nenv=n-env nfunctions=n-functions nhistory=n-history
alias nkill=n-kill noptions=n-options npanelize=n-panelize nhelp=n-help

# line alias
alias line="chromium-browser chrome-extension://ophjlpahpchlmihnnnihgmmeilfjmjjc/index.html#popout > /dev/null 2>&1 &"

# docker alias
alias dcp="docker-compose"
alias dcls="docker container ls"
alias dclsa="docker container ls -a"

# edit and source config
alias ez="vim -c 'call timer_start(50, {-> execute(\"Files ~/.dotfile/config/zsh/\")})'"
alias et="$EDITOR $HOME/.tmux.conf"
alias ev="$EDITOR $HOME/.vimrc"
alias es="$EDITOR $HOME/.config/starship.toml"
alias eg="$EDITOR $HOME/.config/ghostty/config"
alias ei="$EDITOR $HOME/.config/i3/config"
alias sz="source $HOME/.zshrc"

# suffix alias
# executable files run, others open in vim
alias -s {md,py,txt,vimrc,zshrc,conf,toml}=_suffix_open_or_exec

# global alias
# https://thorsten-hans.com/5-types-of-zsh-aliases
# e.g. cd && ls -l G do
alias -g G=" | grep -i"
alias -g xc=" | perl -pe 'chomp if eof' | clipcopy" # strip trailing newline only (cross-platform, replaces sed -z)
alias -g ca=" | cat"
alias -g pa=" | less"
alias -g ppa=" | \less" # purge pager

# managent related alias
# make usb port 1-3 wakeup from s3 situation
# please make sure the XHC in /proc/acpi/wakeup is enabled
alias usb_s3_wakeup="echo 'enabled' | sudo tee /sys/bus/usb/devices/1-3/power/wakeup"
