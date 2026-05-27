#!/usr/bin/env zsh
set -eo pipefail

# setup-vscode.sh — Symlink settings + install extensions for VS Code / VSCodium / Kiro IDE
# Supports macOS and Linux. Detects available IDEs via CLI or app bundle.
#
# MacOS high CPU culprit (historical reference)
# https://github.com/shanalikhan/code-settings-sync
# https://code.visualstudio.com/docs/editor/settings-sync

DOTFILE_VSCODE="$HOME/.dotfile/VSCode"

# --- Extension list (shared across all IDEs) ---
declare -a shared_extensions=(
    # --- Python ---
    "ms-python.python"
    "charliermarsh.ruff"
    "ms-toolsai.jupyter"

    # --- Markdown ---
    "yzhang.markdown-all-in-one"
    "DavidAnson.vscode-markdownlint"
    "shd101wyy.markdown-preview-enhanced"

    # --- Git ---
    "eamodio.gitlens"
    "mhutchie.git-graph"
    "donjayamanne.githistory"
    "github.vscode-pull-request-github"

    # --- Debug ---
    "vadimcn.vscode-lldb"

    # --- Editor enhancement ---
    "vscodevim.vim"
    "aaron-bond.better-comments"
    "alefragnani.bookmarks"
    "leodevbro.blockman"
    "patbenatar.advanced-new-file"
    "formulahendry.auto-rename-tag"
    "gruntfuggly.todo-tree"

    # --- Formatter / Linter ---
    "esbenp.prettier-vscode"
    "editorconfig.editorconfig"
    "brokenbonesdd.opencclint"

    # --- Stats / Counter ---
    "uctakeoff.vscode-counter"

    # --- Theme / Appearance ---
    "BeardedBear.beardedtheme"
    "pkief.material-icon-theme"
    "vscode-icons-team.vscode-icons"

    # --- Web / Preview ---
    "ritwickdey.liveserver"
    "techer.open-in-browser"
    "formulahendry.code-runner"
    "ArthurLobo.easy-codesnap"

    # --- Language / i18n ---
    "ms-ceintl.vscode-language-pack-zh-hant"

    # --- Config / Env ---
    "mikestead.dotenv"

    # --- AI ---
    "anthropic.claude-code"
)

# Extensions only for VS Code (Marketplace-exclusive)
declare -a vscode_only_extensions=(
    "ms-vscode-remote.remote-ssh"
    "j4ng5y.charactercount"
    "hediet.debug-visualizer"
    "hoovercj.vscode-settings-cycler"
    "druideinformatique.antidote"
)

# Extensions only for VSCodium / Kiro IDE (Open VSX alternatives)
declare -a openvsx_only_extensions=(
    "jeanp413.open-remote-ssh"
    "worisur.wordcount-cjk"
)

# --- Helper functions ---

function link_settings() {
  local user_path="$1"
  local ide_name="$2"

  [[ ! -d "$user_path" ]] && mkdir -p "$user_path"

  ln -sf "$DOTFILE_VSCODE/settings.json" "$user_path/settings.json"
  ln -sf "$DOTFILE_VSCODE/keybindings.json" "$user_path/keybindings.json"

  [[ ! -d "$user_path/snippets" ]] && mkdir -p "$user_path/snippets"
  ln -sf "$DOTFILE_VSCODE/python.json" "$user_path/snippets/python.json"

  echo "[$ide_name] Linked: settings + keybindings + snippets → $user_path"
}

function install_extensions() {
  local cli="$1"
  local ide_name="$2"
  shift 2
  local -a exts=("$@")

  echo "[$ide_name] Installing ${#exts[@]} extensions..."
  for ext in "${exts[@]}"; do
    "$cli" --install-extension "$ext" --force || echo "  WARNING: failed to install $ext"
  done
}

function setup_ide() {
  local cli="$1"
  local user_path="$2"
  local ide_name="$3"
  local ide_type="$4"  # "vscode" | "openvsx" | "kiro"

  echo
  echo "=== $ide_name ==="

  # Symlink settings
  link_settings "$user_path" "$ide_name"

  # Install extensions
  local -a exts=("${shared_extensions[@]}")

  case "$ide_type" in
    vscode)
      exts+=("${vscode_only_extensions[@]}")
      ;;
    openvsx)
      exts+=("${openvsx_only_extensions[@]}")
      ;;
    kiro)
      exts+=("${openvsx_only_extensions[@]}")
      ;;
  esac

  install_extensions "$cli" "$ide_name" "${exts[@]}"
}

# --- macOS: key repeat for vim extension ---
function setup_macos_key_repeat() {
  defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false
  defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false
  defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false
  defaults delete -g ApplePressAndHoldEnabled 2>/dev/null || true
  echo "[macOS] Key repeat enabled for vim extension"
}

# --- Main ---

# Verify dotfile source exists
[[ ! -d "$DOTFILE_VSCODE" ]] && echo "Error: $DOTFILE_VSCODE not found" >&2 && exit 1

# Determine OS-specific paths
case "$OSTYPE" in
  darwin*)
    code_user="$HOME/Library/Application Support/Code/User"
    codium_user="$HOME/Library/Application Support/VSCodium/User"
    kiro_user="$HOME/Library/Application Support/Kiro/User"
    kiro_cli="/Applications/Kiro.app/Contents/Resources/app/bin/code"
    ;;
  linux*)
    code_user="$HOME/.config/Code/User"
    codium_user="$HOME/.config/VSCodium/User"
    kiro_user=""  # Linux: not supported yet
    kiro_cli=""
    ;;
  *)
    echo "Unsupported OS: $OSTYPE" >&2 && exit 1
    ;;
esac

found=0

# VS Code
if command -v code &>/dev/null; then
  setup_ide "code" "$code_user" "VS Code" "vscode"
  found=1
fi

# VSCodium
if command -v codium &>/dev/null; then
  setup_ide "codium" "$codium_user" "VSCodium" "openvsx"
  found=1
fi

# Kiro IDE (macOS only, detect by app bundle)
if [[ "$OSTYPE" == darwin* ]] && [[ -x "$kiro_cli" ]]; then
  setup_ide "$kiro_cli" "$kiro_user" "Kiro IDE" "kiro"
  found=1
fi

# macOS key repeat
[[ "$OSTYPE" == darwin* ]] && setup_macos_key_repeat

# Summary
if [[ $found -eq 0 ]]; then
  echo "Error: No IDE found (code/codium/kiro). Install one first." >&2
  exit 1
fi

echo
echo "Done."
