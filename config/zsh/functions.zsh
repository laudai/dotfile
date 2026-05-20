#    ______                 __  _
#   / ____/_  ______  _____/ /_(_)___  ____
#  / /_  / / / / __ \/ ___/ __/ / __ \/ __ \
# / __/ / /_/ / / / / /__/ /_/ / /_/ / / / /
#/_/    \__,_/_/ /_/\___/\__/_/\____/_/ /_/

# function
# Function name with an underscore to not user-callable function.

# To remove any command from the zsh history file
# this method is from https://goo.gl/sTPu62
function histrm() {
  LC_ALL=C sed --in-place '/$1/d' $HISTFILE
}

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

# trace a symlink chain layer by layer until it resolves to a real path or dead end
# note: trailing slash (path/) causes kernel to resolve symlink before reaching this function (POSIX path/. semantics)
# usage: trace_symlink ~/.kiro/skills
function trace_symlink() {
  local p="$1"
  if [[ -z "$p" ]]; then
    echo "usage: trace_symlink <path>" >&2
    return 1
  fi
  while [[ -L "$p" ]]; do
    local t=$(readlink "$p")
    echo "  $p → $t"
    [[ "$t" != /* ]] && t="$(dirname $p)/$t"
    p="$t"
  done
  if [[ -e "$p" ]]; then
    echo "  $p (real)"
  else
    echo "  $p (DEAD)"
    return 2
  fi
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

# generate the timestamp in format ISO 8601 and copy to the clipboard
function dateISO8601ToClip() {
  if [[ "$OSTYPE" =~ [Dd]arwin* ]]; then
    date -Iseconds -u | tr -d "\n" | clipcopy
  elif [[ "$OSTYPE" =~ [Ll]inux* ]]; then
    date -Isec -u | clipcopy
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
    date -v "${Dayoffset}${DayoffsetNum}d" -v "${Houroffset}${HouroffsetNum}H" -Iseconds -u | tr -d "\n" | tee >(clipcopy)

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
    date -d "$(date) ${Dayoffset} ${DayoffsetNum} day ${Houroffset} ${HouroffsetNum} hour" -Isec -u | tr -d "\n" | tee >(clipcopy)

  else
    echo "can't match the os type." 1>&2
  fi
}

# generate the epoch UNIX time from the ISO8601 time (%Y-%m-%d %H:%M:%S)(cloud-init)
function dateISO8601_to_epoch(){
  local timestamp="${*%,*}"  # merge all args and remove milliseconds
  case "$OSTYPE" in
    "linux-gnu"*)
        date -d "$timestamp" +%s
        ;;
    "darwin"*)
        date -j -f "%Y-%m-%d %H:%M:%S" "$timestamp" +%s
        ;;
    *)
      echo "Not support OSTYPE." 1>&2
      ;;
  esac
}

# generate timestamp in journalctl format and copy to clipboard
function dateJournalctl() {
  local ts=$(date -u +"%Y-%m-%d %H:%M:%S")
  echo -n "$ts" | clipcopy
  echo "Copied: $ts"
}

# generate the Epoch Time (Linux and MacOS)
function epochTimeDate_get() {
  date +%s
}

# generate the timestamp by ISO8601 by two epoch UNIX time
function epochTimetoDate_transfer() {
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
function epochTimetoDate_calcuate() {
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
      ;;
    "darwin"*)
      command -v gsed &>/dev/null || { echo "can't find gsed" >&2; return 1; }
      new_url=$(gsed "s/\/[a-z_]\+_[a-z]\+//g" <<< $original_url)
      ;;
  esac
  echo $new_url | clipcopy
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

# Show weather by city supported by wttr via cli command
function wttr_city() {
  # printf '\033c'
  clear
  curl wttr.in/$1
}

function count_characters() {
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

# Fuzzy search file contents with ripgrep and open selection in vim at matching line
# usage: rgvim
# requires: rg, fzf (>=0.38 for become()), vim
function rgvim() {
  (( ! $+commands[node] )) && _zsh_nvm_load
  rg --line-number . |
       fzf --delimiter : --nth 3.. --bind 'enter:become(vim {1} +{2})'
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

function kiro-agent-select() {
  local dotai_agents="$HOME/.dotai/agents"
  local built_agents="$HOME/.kiro/agents"
  local list=""
  for f in "$dotai_agents"/*.yaml(N); do
    local name="${${f:t}%.yaml}"
    [[ "$name" == _* ]] && continue
    if [[ -f "$built_agents/$name.json" ]]; then
      list+="$name"$'\n'
    else
      list+="$name  [BUILD FAILED]"$'\n'
    fi
  done
  [[ -n "$list" ]] || return
  local selected=$(echo "$list" | fzf --prompt='kiro agent> ' --header='enter: chat | ctrl-t: chat --tui' --expect=ctrl-t)
  [[ -n "$selected" ]] || return
  local key="${selected%%$'\n'*}"
  local entry="${selected#*$'\n'}"
  local name="${entry%%  \[*}"
  [[ -n "$name" ]] || return
  if [[ "$entry" == *"[BUILD FAILED]"* ]]; then
    BUFFER=" # agent '$name' failed to build — run: cd ~/.dotai && python3 scripts/build.py"
    CURSOR=$#BUFFER
    zle redisplay
    return
  fi
  BUFFER="kiro-cli chat --agent \"${name}\""
  [[ "$key" == "ctrl-t" ]] && BUFFER+=" --tui"
  CURSOR=$#BUFFER
  zle redisplay
}
zle -N kiro-agent-select

# Check dirty git repos and open them in tmux windows or Ghostty tabs
# --newtab: use Ghostty AppleScript to open tabs (macOS only, requires Ghostty 1.3.0+)
# default: use tmux to open windows (cross-platform, requires active tmux session)
function OpenDirtyRepository() {
  local check_unpushed=false no_cmd=false use_newtab=false
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --unpushed|-u) check_unpushed=true ;;
      --no-cmd|--silent|-s) no_cmd=true ;;
      --newtab|-t) use_newtab=true ;;
    esac
    shift
  done

  local repos=(
    ~/Documents/projects/*/*
    ~/.dotfile
    ~/.dotai
  )
  local dirty=() unpushed=() clean=() skipped=()

  for repo in "${repos[@]}"; do
    if [[ ! -d "$repo/.git" ]]; then
      skipped+=("$repo")
    elif git -C "$repo" status --porcelain | grep -q .; then
      dirty+=("$repo")
    elif $check_unpushed && git -C "$repo" log --oneline @{u}..HEAD 2>/dev/null | grep -q .; then
      unpushed+=("$repo")
    else
      clean+=("$repo")
    fi
  done

  echo "=== Summary ==="
  echo "Dirty:    ${#dirty[@]}"
  $check_unpushed && echo "Unpushed: ${#unpushed[@]}"
  echo "Clean:    ${#clean[@]}"
  echo "Skipped:  ${#skipped[@]} (not a git repo)"
  echo ""
  (( ${#clean[@]} )) && printf "  [clean]     %s\n" "${clean[@]}"
  (( ${#skipped[@]} )) && printf "  [skip]      %s\n" "${skipped[@]}"
  (( ${#unpushed[@]} )) && printf "  [unpushed]  %s\n" "${unpushed[@]}"
  (( ${#dirty[@]} )) && printf "  [dirty]     %s\n" "${dirty[@]}"

  local targets=("${dirty[@]}" "${unpushed[@]}")
  if [[ ${#targets[@]} -eq 0 ]]; then
    echo ""
    echo "Nothing to open."
    return 0
  fi

  # Validate backend
  if $use_newtab; then
    [[ "$OSTYPE" != darwin* ]] && echo "--newtab is macOS only." >&2 && return 1
  elif [[ -z "$TMUX" ]]; then
    echo "Not in a tmux session. Starting one and re-running..."
    local _args=()
    $check_unpushed && _args+=(--unpushed)
    $no_cmd && _args+=(--silent)
    tmux new-session -s "dirty-repos-$$" "zsh -ic 'OpenDirtyRepository ${_args[*]}; exec zsh'"
    return
  fi

  echo ""
  local _open_repo
  if $use_newtab; then
    echo "Opening ${#targets[@]} tab(s) in Ghostty..."
    function _open_repo() {
      local repo=$1 cmd=$2
      osascript -e "tell application \"Ghostty\"
        set t to new tab in front window
        set term to focused terminal of t
        input text \"cd '${repo}' && clear${cmd:+ && $cmd}\n\" to term
      end tell"
    }
  else
    echo "Opening ${#targets[@]} window(s) in tmux..."
    function _open_repo() {
      local repo=$1 cmd=$2
      if [[ -n "$cmd" ]]; then
        tmux new-window -c "$repo" "zsh -ic '$cmd; exec zsh'"
      else
        tmux new-window -c "$repo"
      fi
    }
  fi

  for repo in "${dirty[@]}"; do
    $no_cmd && _open_repo "$repo" "" || _open_repo "$repo" "gd"
  done
  for repo in "${unpushed[@]}"; do
    $no_cmd && _open_repo "$repo" "" || _open_repo "$repo" "glup"
  done
  unfunction _open_repo 2>/dev/null
}

# run-help wrapper: clear autosuggestion before invoking run-help,
# otherwise the grey suggestion text gets included in the command buffer
function _run-help-clean() {
  zle autosuggest-clear
  zle run-help
}
zle -N _run-help-clean

# suffix alias helper: executable files run, others open in vim
function _suffix_open_or_exec() {
  if [[ -x "$1" ]]; then
    ./"$1"
  else
    vim "$1"
  fi
}
