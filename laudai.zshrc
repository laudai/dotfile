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

[[ "$OSTYPE" == "darwin"* ]] && export PATH=/opt/homebrew/sbin:/opt/homebrew/bin:$PATH # for m1 homebrew
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

SYMBOL_FILE="$HOME/.dotfile/symbol.txt"

#CURRENT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
test -e "$HOME/.dotfile/color.txt" && source "$HOME/.dotfile/color.txt"

# Version A: zsh glob (no fork, faster ~10-20ms)
_sz_function() {
  local -a folders=(
    $HOME/.dotfile/private
  )
  local -a exts=(sh function alias)
  local f
  for d in $folders; do
    # ${(j:|:)~exts} joins exts array with | → "sh|function|alias"
    # ~ enables glob expansion so the joined string is treated as a glob pattern
    # *.(pattern) matches files by extension, (N) suppresses error if no match
    for f in $d/*.(${(j:|:)~exts})(N); do
      source "$f"
    done
  done
}
_sz_function

# Version B: find (fork subprocess, more familiar syntax)
# _sz_function() {
#   local -a folders=(
#     $HOME/.dotfile/private
#   )
#   local f
#   for d in $folders; do
#     for f in $(find "$d" -maxdepth 1 -type f \( -name '*.sh' -o -name '*.function' -o -name '*.alias' \) 2>/dev/null); do
#       source "$f"
#     done
#   done
# }
# _sz_function

# export NVM_NO_USE in zsh-nvm before load plugin to avoid the autoload node
export NVM_LAZY_LOAD=true
export NVM_LAZY_LOAD_EXTRA_COMMANDS=("vim" "view")

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
    history-substring-search
    zsh-autosuggestions
    zsh-syntax-highlighting
    sudo
    vscode
    vi-mode
    zsh-navigation-tools
    git-open
    zsh-nvm
    aws
    zoxide
)
# plugin history-substring-search should load before zsh-syntax-highlighting to avoid syantax error


# Deduplicate fpath and path to keep them clean across multiple source calls
typeset -U fpath path
# Custom completions (must be before oh-my-zsh source, which calls compinit)
fpath=(~/.dotfile/completions $fpath)

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
# Set up fzf key bindings and fuzzy completion
source <(fzf --zsh) # 0.48.0 later
[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ] && source /usr/share/doc/fzf/examples/key-bindings.zsh
[ -f /usr/share/doc/fzf/examples/completion.zsh ] && source /usr/share/doc/fzf/examples/completion.zsh
# Rebind fzf cd widget from alt-c to alt-p (avoid conflict with vi/emacs toggle)
bindkey -M emacs '\ep' fzf-cd-widget
bindkey -M viins '\ep' fzf-cd-widget
bindkey -M vicmd '\ep' fzf-cd-widget
# pet query keybindings
bindkey '^s' pet-snippet-search # ctrl-s
# Bind Ctrl+U to .kill-whole-line instead of vi-kill-line:
# 1. Deletes entire line regardless of insert-mode entry point (vi-kill-line
#    does nothing after A, unlike vim's <C-g>u<C-u> remap in .vimrc)
# 2. Dot prefix bypasses vi-mode plugin's clipcopy wrapper that clears
#    system clipboard with empty CUTBUFFER
bindkey '^U' .kill-whole-line
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

# reset the Alfred 4/5 to factory mode
# How can I reset Alfred to defaults?
# https://www.alfredapp.com/help/troubleshooting/reset-alfred/
function resetAlfred() {
  declare -a Alfred_file_array=(
  "~/Library/Application Support/Alfred"
  "~/Library/Preferences/com.runningwithcrayons.Alfred-Preferences.plist"
  "~/Library/Preferences/com.alfredapp.Alfred.plist"
  "~/Library/Caches/com.runningwithcrayons.Alfred"
  )

  if [[ "$OSTYPE" =~ "[D|d]arwin"* ]]; then
    # test grep in version: MacOS 13.3
    if ls -l /Applications | grep "Alfred [4-5]" &> /dev/null; then
      echo -n "Will delete below files to reset the Alfred
Please quit Alfred and agree this request, re-launch Alfred after delete those files.\n
"
      for item in ${Alfred_file_array[@]}; do echo $item; done
      echo
      echo -n "[Yes/No]: "
        read AGREEMENT # can't use local, will not wait for input
        AGREEMENT=$(echo $AGREEMENT | tr "[:upper:]" "[:lower:]")
        echo

        if [[ "$AGREEMENT" == "yes" || "$AGREEMENT" == "y" ]]; then
          for item in ${Alfred_file_array[@]};
          do
            rm "$item"
          done
          echo "Remove the file list finished. Please re-launch the Alfred."
    else
      echo -n "\nPlease run it again and selete 'yes' to reset the Alfred configure."
    fi

  unset AGREEMENT
  else
  echo "Didn't find and Alfred 4/5 in the /Applications folder."
    fi

  else
    echo "Not in MacOS." 1>&2 && return
  fi
}


# TODO function or alias to count the total word in specific file
# TODO function to filter the csv or json via jq or other

# generate the timestamp in format ISO 8601 and copy to the clipboard
function dateISO8601ToClip() {
  if [[ "$OSTYPE" =~ [Dd]arwin* ]]; then
    date -Iseconds -u | tr -d "\n" | pbcopy
  elif [[ "$OSTYPE" =~ [Ll]inux* ]]; then
    date -Isec -u | xclip -selection clipboard
  else
    echo "can't match the os type." 1>&2
  fi
}

# generate the timestamp in format offset with day/Hour granularity from now
function offsetDayHourinISO8601(){
  if [[ "$OSTYPE" =~ [Dd]arwin* ]]; then
    read "?offset in Day (-/+)(default is -): " Dayoffset
    [[ ! ( $Dayoffset == "-" || $Dayoffset == "+") ]] && Dayoffset="-"
    read "?offset Num in Day (:digit:)(default is 0): " DayoffsetNum
    [[ ! $DayoffsetNum =~ ^[[:digit:]].*$ ]] && DayoffsetNum="0"
    read "?offset in Hour (-/+)(default is -): " Houroffset
    [[ ! ( $Houroffset == "-" || $Houroffset == "+") ]] && Houroffset="-"
    read "?offset Num in Hour (:digit:)(default is 0): " HouroffsetNum
    [[ ! $HouroffsetNum =~ ^[[:digit:]].*$ ]] && HouroffsetNum="0"
    echo "Result:"
    date -v "${Dayoffset}${DayoffsetNum}d" -v "${Houroffset}${HouroffsetNum}H" -Iseconds -u | tr -d "\n" | tee >(pbcopy)

  elif [[ "$OSTYPE" =~ [Ll]inux* ]]; then
    read -p "offset in Day (-/+)(default is -): " Dayoffset
    [[ ! ( $Dayoffset == "-" || $Dayoffset == "+") ]] && Dayoffset="-"
    read -p "offset Num in Day (:digit:)(default is 0): " DayoffsetNum
    [[ ! $DayoffsetNum =~ ^[[:digit:]].*$ ]] && DayoffsetNum="0"
    read -p "offset in Hour (-/+)(default is -): " Houroffset
    [[ ! ( $Houroffset == "-" || $Houroffset == "+") ]] && Houroffset="-"
    read -p "offset Num in Hour (:digit:)(default is 0): " HouroffsetNum
    [[ ! $HouroffsetNum =~ ^[[:digit:]].*$ ]] && HouroffsetNum="0"
    echo "Result:"
    date -d "$(date) ${Dayoffset} ${DayoffsetNum} day ${Houroffset} ${HouroffsetNum} hour" -Isec -u

  else
    echo "can't match the os type." 1>&2
  fi
}

# generate the Epoch Time (Linux and MacOS)
function epochTimeDate_get(){
  date +%s
}

# generate the timestamp by ISO8601 by two epoch UNIX time
function epochTimetoDate_transfer (){
  case "$OSTYPE" in
    "linux-gnu"*)
        date -d @${1} -Isec -u
        ;;
    "darwin"*)
        date -r ${1} -Iseconds -u
        ;;
    *)
      echo "Not support OSTYPE." 1>&2
      ;;
  esac
}

# generate the timestamp by ISO8601 by two epoch UNIX time
function epochTimetoDate_calcuate (){
  case "$OSTYPE" in
    "linux-gnu"*)
        date -d @$((${1}+${2})) -Isec -u
        ;;
    "darwin"*)
        date -Iseconds -r $((${1}+${2})) -u
        ;;
    *)
      echo "Not support OSTYPE." 1>&2
      ;;
  esac
}

# AWS Documents transfer to english ver
function trimdoc() {
  local original_url=$1
  case "$OSTYPE" in
    "linux-gnu"*)
      command -v sed &>/dev/null || { echo "can't find sed" >&2; return 1; }
      new_url=$(sed "s/\/[a-z_]\+_[a-z]\+//g" <<< $original_url)
      echo $new_url | xclip -selection clipboard
      ;;
    "darwin"*)
      command -v gsed &>/dev/null || { echo "can't find gsed" >&2; return 1; }
      new_url=$(gsed "s/\/[a-z_]\+_[a-z]\+//g" <<< $original_url)
      echo $new_url | pbcopy
      ;;
  esac
  echo $new_url
}


# open symbol.txt file with less
function lsymbol() {
  if [[ -e "$SYMBOL_FILE" ]]; then
    less "$SYMBOL_FILE"
  else
	echo "can't find $SYMBOL_FILE" 1>&2
  fi
}

# edit symbol.txt file with vim editor
function esymbol() {
  [[ ! -e "$SYMBOL_FILE" ]] && echo "can't find $SYMBOL_FILE" >&2 && return 1
  command -v vim &>/dev/null || { echo "vim not found" >&2; return 1; }
  vim "$SYMBOL_FILE"
}

# go to folder path by zoxide command, and use the VSCode to open this folder
function gfv() {
  command -v zoxide &>/dev/null || { echo "zoxide not found" >&2; return 1; }
  command -v code &>/dev/null || { echo "code not found" >&2; return 1; }
  z "$1" || return
  code -n .
}

# 切換 MacOS 的“依據應用程式將視窗分組” "Group windows by application"
function toggle-expose-apps() {
  local expose_group_apps=$(defaults read com.apple.dock expose-group-apps)
  if [[ $expose_group_apps -eq 1 ]]; then
    defaults write com.apple.dock expose-group-apps -boolean false; killall Dock
    echo "turn off 'Group windows by application'"
  else
    defaults write com.apple.dock expose-group-apps -boolean true; killall Dock
    echo "turn on 'Group windows by application'"
  fi
}

# leverage the pmset need root privilege
# modify the displaysleep & sleep settings in battery/charging
function toggle-or-setting-displaysleep() {
  [[ ! "$OSTYPE" == "darwin"* ]] && echo "This function only run on MacOS" && return
  ! which gawk >/dev/null && echo "Please install awk(gawk) first" && return

  local displaysleep=$(sudo pmset -g | gawk '/displaysleep/ { print $2 }')
  local dst=${1:-$(( displaysleep != 0 ? 0 : 5 ))}
  local st=$((dst == 0 ? 0 : dst + 10))

  echo "Modify the DisplaySleep time to $( ((dst)) && echo "$dst mins" || echo "Never" )"
  sudo pmset -b sleep $st displaysleep $dst
  sudo pmset -c sleep $st displaysleep $dst
}

# Toggle between headphones and MacBook Pro Speakers
# If External Headphones available, use it instead of Plantronics
function toggle-AudioSource() {
  ! command -v SwitchAudioSource >/dev/null && echo "Install: brew install switchaudio-osx" && return 1

  local headphone_ext="External Headphones"
  local headphone_plt="Plantronics Blackwire 5220 Series"
  local speaker_mbp="MacBook Pro Speakers"
  local current=$(SwitchAudioSource -c)
  local available=$(SwitchAudioSource -a -t output)
  local headphone=$(echo "$available" | grep -q "^$headphone_ext$" && echo "$headphone_ext" || echo "$headphone_plt")
  local target=$([[ "$current" == "$speaker_mbp" ]] && echo "$headphone" || echo "$speaker_mbp")
  echo "$available" | grep -q "^$target$" || { echo "Device not found: $target"; return 1; }

  SwitchAudioSource -s "$target" && echo "✓ $current → $target" || { echo "✗ Failed"; return 1; }
}

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

# Show weather by city supported by wttr via ImageMagick
# TODO: fix the senario when the city not in the supported list
funciton wttr_to_png() {
  city=$1
  curl wttr.in/"$city".png --output /tmp/weather.png &> /dev/null
  if which display &> /dev/null; then
    display -resize $(xrandr | fgrep '*' | awk '{print $1}') /tmp/weather.png
  else
	echo 'You could use ImageMagick to show this image.'
  fi
}

# Show weather by city supported by wttr via cli command
funciton wttr_city() {
  # printf '\033c'
  clear
  curl wttr.in/$1
}


funciton count_characters() {
  printf $1 | wc -m
}

# fzf interactive git diff preview
# usage: fgd (unstaged) | fgd --cached (staged) | fgd HEAD~3 | fgd main
function fgd() {
  git diff --name-only "$@" |
    fzf --height=100% \
        --preview "git diff --color=always $* -- {}" \
        --preview-window down:80%
}

# fzf interactive git log preview
# usage: fgl (all) | fgl -20 (recent 20) | fgl --all | fgl -- path/to/file
function fgl() {
  git log --oneline --color=always "$@" |
    fzf --ansi --height=100% \
        --preview 'git show --color=always {1}' \
        --preview-window down:80%
}

# fzf interactive git log with stat → file drill-down
# usage: fgls (all) | fgls -20 | fgls --all | fgls -- path/to/file
#        fgls --print (output commit hash and file path)
# 1st layer: select commit (preview: modified files)
# 2nd layer: select file (preview: diff of that file), ESC to go back
function fgls() {
  local print=false commit file
  [[ "$1" == "--print" ]] && print=true && shift
  while true; do
    commit=$(git log --oneline --color=always "$@" |
      fzf --ansi --height=100% \
          --preview 'git show --stat --color=always {1}' \
          --preview-window down:80%) || return
    commit=${commit%% *}
    file=$(git diff-tree --no-commit-id --name-only -r "$commit" |
      fzf --height=100% \
          --preview "git show --color=always $commit -- {}" \
          --preview-window down:80%)
    [[ -z "$file" ]] && continue
    $print && echo "$commit" && echo "$file"
    break
  done
}

# fzf interactive systemd journal viewer (Linux only, requires jq)
# usage: fjl [pattern]
#   pattern  optional, filter unit names (default: all units)
# preview: systemctl status, enter: open full journal
function fjl() {
  [[ "$OSTYPE" != linux* ]] && echo "fjl: Linux only (systemd)" >&2 && return 1
  systemctl list-units --output json |
    jq '.[].unit | select(test($pattern))' --arg pattern "${1:-.}" --raw-output |
    fzf --height=100% \
        --preview "systemctl status {}" \
        --preview-window down:80% \
        --bind "enter:execute(journalctl -u {})"
}

# fzf interactive systemd journal raw log viewer (Linux only)
# usage: fjlr [service] [query] [lines]
#   service  optional, systemd unit name; if omitted, fzf select from active units
#   query    optional, pre-fill fzf search (default: empty, use - to skip)
#   lines    optional, number of recent log lines (default: 500)
# raw mode: all lines visible, matches highlighted, ctrl-p/n to jump between matches
function fjlr() {
  [[ "$OSTYPE" != linux* ]] && echo "fjlr: Linux only (systemd)" >&2 && return 1
  local unit=${1:-$(systemctl list-units --output json | jq -r '.[].unit' | fzf)} || return
  local query="${2:-}"
  [[ "$query" == "-" ]] && query=""
  journalctl --no-pager -u "$unit" -n "${3:-500}" |
    fzf --raw --query "$query"
}

# pet related function
function pet() {
  case "$1" in
    edit|configure)
      # Load nvm only if node is not yet in PATH, so coc.nvim can find node.
      # _zsh_nvm_load (from zsh-nvm plugin) loads nvm and unsets all lazy
      # functions at once, avoiding double nvm loading when pet spawns vim.
      (( ! $+commands[node] )) && _zsh_nvm_load
      ;;
  esac
  command pet "$@"
}

function prev_pet_add() {
  PREV=$(fc -lrn | head -n 1)
  sh -c "pet new `printf %q "$PREV"`"
}

function pet-snippet-search() {
  BUFFER=$(pet search --query "$LBUFFER")
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N pet-snippet-search
stty -ixon


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
# Custom dotfile scripts
export PATH="$HOME/.dotfile/bin:$PATH"



# let urlview to use firefox browser to show
if [ -e '/usr/bin/firefox' ] ; then
  #export BROWSER='/usr/bin/firefox'
  # comment this block to use xdg-settings set default-web-browser firefox_firefox.desktop
fi

# fzf global defaults
# note: ctrl-y is fzf built-in yank (emacs style: paste back killed text),
#       overridden in FZF_CTRL_R_OPTS to copy selection to system clipboard
export FZF_DEFAULT_OPTS="
  --reverse
  --cycle
  --height=60%
  --highlight-line
  --border
  --preview-window down
  --bind 'ctrl-b:half-page-up,ctrl-f:half-page-down'
  --bind 'shift-page-up:preview-page-up,shift-page-down:preview-page-down'
  --bind '?:toggle-preview'
  --bind 'ctrl-\:change-preview-window(right:50%|hidden|)'
  --header 'ctrl+y (emacs yank/recover) | ? (preview) | ctrl+\\ (preview pos) | ctrl+/ (line wrap) | shift+pgup/dn (preview page)'"

# Ctrl+T: search files and paste path to command line
# Based on fzf official config, added: --walker-root (search from home)
export FZF_CTRL_T_OPTS="
  --walker-skip .git,node_modules,target
  --preview '[ -d {} ] && tree -C {} || bat -n --color=always {}'"

# Print tree structure in the preview window
# Alt+P (rebound from Alt+C): cd into selected directory
# Env var names must stay as FZF_ALT_C_* — fzf hardcodes these names
# regardless of which key triggers fzf-cd-widget (see bindkey above)
export FZF_ALT_C_OPTS="--preview 'tree -C {}'"
export FZF_ALT_C_COMMAND="fd --type d --hidden --exclude .git --exclude node_modules --exclude target"

# bind alt-o to save to pet, ctrl-y to copy to clipboard in fzf history search
# fzf action: +accept = close fzf and output selection to terminal
#             +abort  = close fzf without output (silent operation)
export FZF_CTRL_R_OPTS="
  --info=right
  --height=80%
  --no-multi-line
  --color header:italic:bold
  --color 'fg:#bbccdd,fg+:#ddeeff,bg:#334455,preview-bg:#223344,border:#778899'
  --header 'alt+o (pet new) | ctrl+y (copy to clipboard) | ctrl+s (sort: +S relevance, -S recency)'
  --preview 'echo {}' --preview-window hidden:50%:wrap
  --bind 'ctrl-\:change-preview-window(down:50%|right:50%|)'
  --bind 'ctrl-s:toggle-sort'
  --bind 'ctrl-y:execute-silent(echo -n {} | sed \"s/^[[:space:]]*[0-9]*\\t//\" | if command -v pbcopy >/dev/null; then pbcopy; else xclip -selection clipboard; fi)+accept'
  --bind 'alt-o:execute(pet new --tag {2..})+abort'"


#     ___    ___
#    /   |  / (_)___ ______
#   / /| | / / / __ `/ ___/
#  / ___ |/ / / /_/ (__  )
# /_/  |_/_/_/\__,_/____/

# TODO
# add new alias for case folder in internal alias .alias file
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
alias ez="$EDITOR $HOME/.zshrc"
alias et="$EDITOR $HOME/.tmux.conf"
alias ev="$EDITOR $HOME/.vimrc"
alias es="$EDITOR $HOME/.config/starship.toml"
alias eg="$EDITOR $HOME/.config/ghostty/config"
alias ei="$EDITOR $HOME/.config/i3/config"
alias sz="source $HOME/.zshrc"

# suffix alias
alias -s {md,py,txt,vimrc,zshrc,conf,toml}=vim
alias -s sh=bash

# global alias
# https://thorsten-hans.com/5-types-of-zsh-aliases
# e.g. cd && ls -l G do
alias -g G=" | grep -i"
alias -g lxc=" | sed -z 's/\n$//' | xclip -selection clipboard"
alias -g mxc=" | gsed -z 's/\n$//' | pbcopy"
alias -g ca=" | cat"
alias -g pa=" | less"
alias -g ppa=" | \less" # purge pager

# managent related alias
# make usb port 1-3 wakeup from s3 situation
# please make sure the XHC in /proc/acpi/wakeup is enabled
alias usb_s3_wakeup="echo 'enabled' | sudo tee /sys/bus/usb/devices/1-3/power/wakeup"

#    ____      _ __
#   /  _/___  (_) /_
#   / // __ \/ / __/
# _/ // / / / / /_
#/___/_/ /_/_/\__/

# nvm
# export NVM_DIR="$HOME/.nvm"
# export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
# [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
#
export NVM_DIR="$([ -z "${XDG_CONFIG_HOME-}" ] && printf %s "${HOME}/.nvm" || printf %s "${XDG_CONFIG_HOME}/nvm")"
# https://medium.com/@ankitbabber/how-i-improved-my-shell-load-time-with-a-lazy-load-3acd89f8c4a3
# manually lazy load the nvm if needed
# _nvm_lazy_load() {
#   unset -f nvm node npm npx yarn pnpm node_modules vim &> /dev/null
#   [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" # This loads nvm
#   [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
# }
# nvm()  { _nvm_lazy_load; nvm  "$@"; }
# node() { _nvm_lazy_load; node "$@"; }
# npm()  { _nvm_lazy_load; npm  "$@"; }
# npx()  { _nvm_lazy_load; npx  "$@"; }
# vim()  { _nvm_lazy_load; vim  "$@"; }
# other way to node lazy load
# https://sumercip.com/posts/lazyload-zsh/
# https://github.com/qoomon/zsh-lazyload

# starship
eval "$(starship init zsh)"

# https://superuser.com/questions/117841/when-reading-a-file-with-less-or-more-how-can-i-get-the-content-in-colors
#export LESS="-r" #useful for raw-control-chars, but can't like alias to escape via backslash \
