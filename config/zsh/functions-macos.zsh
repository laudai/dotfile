#                          ____  _____
#    ____ ___  ____ ______/ __ \/ ___/
#   / __ `__ \/ __ `/ ___/ / / /\__ \
#  / / / / / / /_/ / /__/ /_/ /___/ /
# /_/ /_/ /_/\__,_/\___/\____//____/

# macos
# macOS-only functions — sourced only when $OSTYPE == darwin*

# 切換 MacOS 的"依據應用程式將視窗分組" "Group windows by application"
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
  ! which gawk >/dev/null && echo "Please install awk(gawk) first" && return

  local displaysleep=$(sudo pmset -g | gawk '/displaysleep/ { print $2 }')
  local dst=${1:-$(( displaysleep != 0 ? 0 : 5 ))}
  local st=$((dst == 0 ? 0 : dst + 10))

  echo "Modify the DisplaySleep time to $( ((dst)) && echo "$dst mins" || echo "Never" )"
  sudo pmset -b sleep $st displaysleep $dst
  sudo pmset -c sleep $st displaysleep $dst
}

function toggle-auto-brightness() {
  local current=$(defaults read /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" 2>/dev/null)
  if [[ "$current" == "0" ]]; then
    sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool true
    echo "turn on 'Automatically adjust brightness'"
  else
    sudo defaults write /Library/Preferences/com.apple.iokit.AmbientLightSensor "Automatic Display Enabled" -bool false
    echo "turn off 'Automatically adjust brightness'"
  fi
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

  if ls -l /Applications | grep "Alfred [4-5]" &> /dev/null; then
    # test grep in version: MacOS 13.3
    echo -n "Will delete below files to reset the Alfred
Please quit Alfred and agree this request, re-launch Alfred after delete those files.\n
"
    for item in ${Alfred_file_array[@]}; do echo $item; done
    echo
    echo -n "[Yes/No]: "
      read AGREEMENT
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
    echo "Didn't find Alfred 4/5 in the /Applications folder."
  fi
}
