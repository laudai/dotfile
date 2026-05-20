#     __    _
#    / /   (_)___  __  ___  __
#   / /   / / __ \/ / / / |/_/
#  / /___/ / / / / /_/ />  <
# /_____/_/_/ /_/\__,_/_/|_|

# linux
# Linux-only functions — sourced only when $OSTYPE == linux*

# display setting for monitor (X11)
function screen_to_monitor() {
  xrandr --output eDP-1 --mode 1920x1080
}

# display setting for panel (X11)
function screen_to_panel() {
  xrandr --output eDP-1 --mode 1600x900
}

# toggle your gnome desktop screensaver lock-enabled & ubuntu-lock-on-suspend
# 切換自動鎖定螢幕、暫停時鎖定螢幕
function toggle-sll() {
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
function toggle-app-switcher_workspace-only() {
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
function toggle-window-switcher_workspace-only() {
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
function toggle-gnome-interface_animations() {
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
function toggle-workspace-primary-monitor-only() {
  local workspace_primary_monitor_only=$(gsettings get org.gnome.mutter workspaces-only-on-primary)
  if [[ $workspace_primary_monitor_only == true ]]; then
    gsettings set org.gnome.mutter workspaces-only-on-primary false
    echo -e "Change gnome workspace only on primary monitor to ${BOLD_RED}False${RESET}."
  elif [[ $workspace_primary_monitor_only == false ]]; then
    gsettings set org.gnome.mutter workspaces-only-on-primary true
    echo -e "Change gnome workspace only on primary monitor to ${BOLD_GREEN}True${RESET}."
  fi
}

# Show weather by city supported by wttr via ImageMagick (X11)
# TODO: fix the senario when the city not in the supported list
function wttr_to_png() {
  city=$1
  curl wttr.in/"$city".png --output /tmp/weather.png &> /dev/null
  if which display &> /dev/null; then
    display -resize $(xrandr | fgrep '*' | awk '{print $1}') /tmp/weather.png
  else
  echo 'You could use ImageMagick to show this image.'
  fi
}

# fzf interactive systemd journal viewer (Linux only, requires jq)
# usage: fjl [pattern]
#   pattern  optional, filter unit names (default: all units)
# preview: systemctl status, enter: open full journal
function fjl() {
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
  local unit=${1:-$(systemctl list-units --output json | jq -r '.[].unit' | fzf)} || return
  local query="${2:-}"
  [[ "$query" == "-" ]] && query=""
  journalctl --no-pager -u "$unit" -n "${3:-500}" |
    fzf --raw --query "$query"
}
