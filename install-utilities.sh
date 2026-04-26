#!/usr/bin/env zsh
# =============================================================================
# install-utilities.sh
#
# Usage:
#   ./install-utilities.sh              Show what will be installed (dry-run)
#   ./install-utilities.sh --install    Actually install everything
#   ./install-utilities.sh --check-apt  Check which packages are available in apt
#   ./install-utilities.sh --check-brew Check which packages are available in brew
#   ./install-utilities.sh --help       Show usage
#
# Dry-run (default) shows:
#   1. All packages and which are skipped
#   2. OS-detected install plan (macOS: brew formula/cask | Linux: apt/manual)
#   3. No actual installation happens
#
# --install flag triggers actual installation
# =============================================================================

# -e: exit immediately on error | -o pipefail: catch errors in piped commands
set -eo pipefail

# =============================================================================
# Parse arguments
# =============================================================================
DO_INSTALL=false
CHECK_APT=false
CHECK_BREW=false
for arg in "$@"; do
	case "$arg" in
		--install) DO_INSTALL=true ;;
		--check-apt) CHECK_APT=true ;;
		--check-brew) CHECK_BREW=true ;;
		--help|-h)
			echo "Usage: $0 [--install] [--check-apt] [--check-brew]"
			echo ""
			echo "  (no args)      Dry-run: show what will be installed"
			echo "  --install      Actually install packages"
			echo "  --check-apt    Check which packages are available in apt (run on Linux)"
			echo "  --check-brew   Check which packages are available in brew (run on macOS)"
			exit 0
			;;
	esac
done

# =============================================================================
# Constants (package lists — edit these to add/remove packages)
# =============================================================================

# --- Cross-platform CLI tools (formula) ---
# Works on both macOS (brew) and Linux (brew/apt)
# Linux-only CLI packages should also go here; availability is auto-detected at runtime
common_formula=(
	# System monitoring
	htop
	glances
	btop
	iftop
	speedtest-cli

	# File / Text search
	bat                              # cat alternative with syntax highlighting
	fd                               # find alternative
	ripgrep                          # grep alternative

	# Code stats / Editor
	cloc
	tokei
	vim

	# Shell utilities
	zsh
	coreutils
	gawk
	tmux
	fzf
	zoxide
	pet
	tree
	jq
	midnight-commander               # terminal file manager (apt: mc)
	urlview                          # tmux-urlview dependency

	# Development / System admin
	git
	build-essential                  # gcc/g++/make (Linux only, macOS uses Xcode CLT)
	openssh-server                   # Linux only (macOS built-in)
	flatpak                          # Linux package manager (Linux only, snap is preinstalled)
	gparted                          # disk partition tool (Linux only)
	gnome-tweaks                     # GNOME advanced settings (Linux desktop)
	llvm                             # compiler infrastructure

	# Network / Security
	mtr
	nmap
	bind9-dnsutils                   # dig/nslookup (Linux only, macOS built-in)
	hping3                           # TCP/IP packet tool (Linux only)
	iperf3                           # network bandwidth test
	httpie                           # human-friendly HTTP client
	sqlmap                           # SQL injection testing
	sshfs                            # mount remote dir via SSH
	mosh                             # mobile SSH (auto-reconnect)
	sshuttle                         # poor man's VPN via SSH
	tailscale                        # mesh VPN (needs extra repo on Linux)

	# System / Debug
	strace                           # syscall tracer (Linux only in practice)
	ltrace                           # library call tracer (Linux only)
	gdb                              # GNU debugger (Linux only in practice)
	graphviz                         # graph drawing tool (dot)

	# Linter
	ruff

	# Python
	uv                               # Python package manager (Astral)
	ipython                          # interactive Python (apt: ipython3)

	# Security
	bitwarden-cli

	# Entertainment / Eye candy
	screenfetch                      # system info display
	cowsay
	lolcat                           # rainbow text
	cmatrix                          # Matrix screen effect
	fortune                          # random quotes (apt: fortunes)
	hollywood                        # fake hacker screen (Linux only)
	toilet                           # ASCII art text
	figlet                           # ASCII art text

	# Media
	ffmpeg                           # audio/video converter
	imagemagick                      # image processing
	screenkey                        # screencast keystroke display (Linux only)

	# Linux desktop
	dunst                            # notification daemon (Wayland compatible)
	pavucontrol                      # PulseAudio volume control (Linux only)
	mako-notifier                    # sway notifier (Linux only)
	sway-notification-center         # sway notification center (Linux only)

	# Docker
	docker-ce                        # Docker Engine (needs extra repo on Linux)
	docker-ce-cli                    # Docker CLI

	# --- X11 / Wayland transition (keep both during migration) ---

	# Clipboard / Automation
	xdotool                          # x11 only → ydotool
	wl-clipboard                     # wayland, replaces xclip/xsel (oh-my-zsh clipcopy auto-detects)
	ydotool                          # wayland, replaces xdotool

	# Window manager / Status bar
	i3                               # x11 only → sway
	sway                             # wayland, replaces i3
	polybar                          # x11 only → waybar
	waybar                           # wayland, replaces polybar

	# Desktop tools
	picom                            # x11 only (wayland compositor built-in)
	nitrogen                         # x11 only → swaybg
	swaybg                           # wayland, replaces nitrogen
	feh                              # x11 only → imv
	imv                              # wayland, replaces feh
	lxrandr                          # x11 only → wlr-randr/kanshi
	wlr-randr                        # wayland, replaces lxrandr
	kanshi                           # wayland, replaces lxrandr (auto profile)
	redshift                         # x11 only → gammastep
	gammastep                        # wayland, replaces redshift
	simplescreenrecorder             # x11 only → wf-recorder
	wf-recorder                      # wayland, replaces simplescreenrecorder

	# Input method (replaces fcitx 4.x / ibus-chewing)
	fcitx5-chewing                   # Zhuyin input
	fcitx5-rime                      # Rime input engine
	rime-data-bopomofo               # Rime Zhuyin data
	rime-data-double-pinyin          # Rime Shuangpin data
)

# --- Cross-platform GUI apps ---
# macOS: brew --cask (auto-detected at runtime)
# Linux: auto-detected via apt-cache; run --check-apt to verify manually
cross_platform_cask=(
	# Productivity / Notes / Development / Terminal / Editor / IDE
	anytype
	joplin
	obsidian
	visual-studio-code
	vscodium                         # open-source VS Code (testing, may replace visual-studio-code)
	masscode
	ghostty
	gitkraken
	wireshark

	# Communication / Sync
	thunderbird
	syncthing

	# Security
	bitwarden

	# Media / Graphics
	flameshot
	gimp                             # image editor (replaces pinta)
	balena-etcher                    # USB boot disk creator (Linux only)

	# Other
	anki
)

# --- macOS only GUI apps ---
# These are macOS-exclusive and cannot run on Linux, even with Linuxbrew.
# Linux alternatives: i3/sway (window mgmt), rofi (launcher), keyd (key remap)
macos_only_cask=(
	# Terminal
	iterm2

	# Browser
	# (Chrome, Brave, Vivaldi are not included — install manually if needed)

	# Productivity
	alfred

	# Window management / Desktop
	amethyst                         # Tiling window manager for macOS along the lines of xmonad
	easy-move+resize                 # Similar or alternative to move window in the Gnome way
	rectangle                        # Open source window manager in MacOS

	# Menu bar utilities
	clocker
	hiddenbar
	mos
	spaceid
	stats

	# Display / Monitor
	monitorcontrol                   # Control external monitor brightness/contrast/volume from menulet
	betterdisplay

	# Audio
	background-music                 # auto-pause music, per-app volume, record system audio

	# Keyboard / Peripherals
	karabiner-elements

	# Input method
	squirrel-app                     # 鼠鬚管 Rime input method engine

	# Other
	qr-journal
)

# --- macOS Fonts (cask) ---
font_casks=(
	font-caskaydia-cove-nerd-font
	font-fira-code
	font-cascadia-code
)

# --- Skip list ---
# Packages to keep in lists but not install automatically.
# Remove from here when you want to install them.
skip_pkgs=(
	wireshark
	visual-studio-code
	joplin
	gitkraken
	anki
	gnome-tweaks
	llvm
	httpie
	cowsay
	lolcat
	fortune
	hollywood
	balena-etcher
	screenkey
)

# --- Linux apt config ---

# brew name → apt name (only list where names differ)
# Note: declare -A requires bash 4.0+ or zsh. macOS default bash is 3.2 — use zsh instead.
declare -A apt_name_map=(
	[fd]="fd-find"
	[midnight-commander]="mc"
	[fortune]="fortunes"
	[ipython]="ipython3"
)

# --- Platform exclusion lists ---
# These are now auto-detected at runtime in the "Build install plan" section.
# --check-apt and --check-brew are kept for manual verification.
# apt_name_map is still needed for name translation (e.g., fd → fd-find).

# --- Runtime state ---
# Collects packages that failed during batch_install fallback
install_failed=()

# --- Colors ---
TC_CYAN="\033[1;36m"
TC_YELLOW="\033[1;33m"
TC_RESET="\033[0m"

# =============================================================================
# Utility functions
# =============================================================================

function filter_skip() {
	local -a result=()
	for pkg in "$@"; do
		local skip=false
		for s in "${skip_pkgs[@]}"; do
			[[ "$pkg" == "$s" ]] && skip=true && break
		done
		$skip || result+=("$pkg")
	done
	echo "${result[@]}"
}

function print_section() {
	local label="$1"; shift
	echo "--- $label ---"
	for pkg in "$@"; do
		echo "  - $pkg"
	done
	echo ""
}

# classify packages against brew_all: available → target array, unavailable → pkg_manual
# Requires brew_all to be set before calling.
# -cx instead of -qx: grep -q with pipefail causes SIGPIPE false failures
function brew_classify() {
	local target_name=$1; shift
	for pkg in "$@"; do
		if echo "$brew_all" | grep -cx "$pkg" >/dev/null; then
			eval "${target_name}+=(\"$pkg\")"
		else
			pkg_manual+=("$pkg")
		fi
	done
}

# batch install with fallback to one-by-one on failure
function batch_install() {
	local cmd="$1"; shift
	echo -e "\n${TC_CYAN}>>> Running: $cmd $*${TC_RESET}"
	eval "$cmd $*" || {
		echo -e "${TC_YELLOW}>>> Batch failed, retrying one-by-one...${TC_RESET}"
		for pkg in "$@"; do
			eval "$cmd $pkg" || install_failed+=("$pkg")
		done
	}
}

# =============================================================================
# --check-brew: verify brew availability (run on macOS)
# =============================================================================
if $CHECK_BREW; then
	if ! command -v brew >/dev/null; then
		echo "brew not found. Install Homebrew first."
		exit 1
	fi
	echo "Checking brew availability for all packages..."
	echo ""

	# fetch all available formulae and casks in one call each
	brew_all=$(brew formulae; brew casks)

	brew_yes=()
	brew_no=()
	for pkg in "${common_formula[@]}" "${cross_platform_cask[@]}" "${macos_only_cask[@]}"; do
		if echo "$brew_all" | grep -cx "$pkg" >/dev/null; then
			brew_yes+=("$pkg")
		else
			brew_no+=("$pkg")
		fi
	done
	echo "--- Available in brew (${#brew_yes[@]}) ---"
	for pkg in "${brew_yes[@]}"; do echo "  ✓ $pkg"; done
	echo ""
	echo "--- NOT in brew (${#brew_no[@]}) ---"
	for pkg in "${brew_no[@]}"; do echo "  ✗ $pkg"; done
	echo ""
	echo "Copy-paste for not_in_brew (if reverting to static list):"
	echo "not_in_brew=(${brew_no[*]})"
	echo ""
	echo "Note: build plan now auto-detects. This is for reference only."
	exit 0
fi

# =============================================================================
# --check-apt: verify apt availability (run on Linux)
# =============================================================================
if $CHECK_APT; then
	if ! command -v apt >/dev/null; then
		echo "apt not found. Run this on a Debian/Ubuntu system."
		exit 1
	fi
	echo "Checking apt availability for all packages..."
	echo ""
	apt_yes=()
	apt_no=()
	for pkg in "${common_formula[@]}" "${cross_platform_cask[@]}"; do
		apt_pkg="${apt_name_map[$pkg]:-$pkg}"
		if apt-cache show "$apt_pkg" &>/dev/null; then
			apt_yes+=("$pkg")
		else
			apt_no+=("$pkg")
		fi
	done
	echo "--- Available in apt (${#apt_yes[@]}) ---"
	for pkg in "${apt_yes[@]}"; do echo "  ✓ $pkg"; done
	echo ""
	echo "--- NOT in apt (${#apt_no[@]}) ---"
	for pkg in "${apt_no[@]}"; do echo "  ✗ $pkg"; done
	echo ""
	echo "Copy-paste for not_in_apt (if reverting to static list):"
	echo "not_in_apt=(${apt_no[*]})"
	echo ""
	echo "Note: build plan now auto-detects. This is for reference only."
	exit 0
fi


# =============================================================================
# Build install plan based on OS (auto-detect available packages)
# =============================================================================
pkg_install=()
pkg_install_cask=()
pkg_install_fonts=()
pkg_manual=()

if [[ "$OSTYPE" == "darwin"* ]]; then
	OS="macOS"

	if command -v brew >/dev/null; then
		# auto-detect: fetch all available brew formulae and casks (~0.3s)
		brew_all=$(brew formulae; brew casks)

		brew_classify pkg_install_fonts $(filter_skip "${font_casks[@]}")
		brew_classify pkg_install       $(filter_skip "${common_formula[@]}")
		# Cannot merge CLI + GUI: CLI → brew install, GUI → brew install --cask
		brew_classify pkg_install_cask  $(filter_skip "${cross_platform_cask[@]}" "${macos_only_cask[@]}")
	else
		echo "brew not found. Install Homebrew first:"
		echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
		exit 1
	fi

elif [[ "$OSTYPE" == "linux"* ]]; then
	OS="Linux"
	if command -v brew >/dev/null; then
		PKG_MGR="brew"
		# Linuxbrew — auto-detect available formulae
		brew_all=$(brew formulae)

		brew_classify pkg_install $(filter_skip "${common_formula[@]}")
		# all GUI apps need manual install on Linux (no brew cask)
		pkg_manual+=($(filter_skip "${cross_platform_cask[@]}"))

	elif command -v apt >/dev/null; then
		PKG_MGR="apt"
		# auto-detect: check each package against apt-cache
		for pkg in $(filter_skip "${common_formula[@]}" "${cross_platform_cask[@]}"); do
			# map the package name from formula to apt
			apt_pkg="${apt_name_map[$pkg]:-$pkg}"
			if apt-cache show "$apt_pkg" &>/dev/null; then
				pkg_install+=("$apt_pkg")
			else
				pkg_manual+=("$pkg")
			fi
		done
	else
		echo "No supported package manager found (brew/apt)."
		exit 1
	fi
else
	echo "Unsupported OS: $OSTYPE"
	exit 1
fi

# =============================================================================
# Show plan (always runs)
# =============================================================================
echo "============================================================"
echo " install-utilities.sh — Package Install Plan"
echo "============================================================"
echo ""
echo "OS detected: $OSTYPE"
echo "Mode: $( $DO_INSTALL && echo 'INSTALL' || echo 'DRY-RUN (use --install to execute)' )"
echo ""

if [[ ${#skip_pkgs[@]} -gt 0 ]]; then
	print_section "Skipped packages" "${skip_pkgs[@]}"
fi

if [[ "$OS" == "macOS" ]]; then
	print_section "Fonts (brew --cask)" "${pkg_install_fonts[@]}"
	print_section "CLI tools (brew formula)" "${pkg_install[@]}"
	print_section "GUI apps (brew --cask)" "${pkg_install_cask[@]}"
	if [[ ${#pkg_manual[@]} -gt 0 ]]; then
		print_section "Not in brew (manual install)" "${pkg_manual[@]}"
	fi
elif [[ "$OS" == "Linux" ]]; then
	print_section "Will be installed via $PKG_MGR" "${pkg_install[@]}"
	if [[ ${#pkg_manual[@]} -gt 0 ]]; then
		print_section "Need manual install (PPA/flatpak/snap/pip/official website)" "${pkg_manual[@]}"
	fi
	echo "--- macOS-only apps (NOT installable on Linux) ---"
	echo "  (see macos_only_cask in script)"
	echo ""
fi

# =============================================================================
# Actual install (only with --install)
# =============================================================================
if ! $DO_INSTALL; then
	echo "============================================================"
	echo " Dry-run complete. Run with --install to execute."
	echo "============================================================"
	exit 0
fi

echo "============================================================"
echo " Installing..."
echo "============================================================"
echo ""

# Pre-authenticate sudo to avoid password prompts during installation
sudo -v

# --- OS-specific package install (run first to ensure git/curl are available) ---

if [[ "$OS" == "macOS" ]]; then
	# Apple Silicon needs Rosetta 2 for x86 packages (e.g., background-music)
	[[ "$(uname -m)" == "arm64" ]] && softwareupdate --install-rosetta --agree-to-license 2>/dev/null || true

	command -v brew >/dev/null || /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

	if command -v brew >/dev/null; then
		batch_install "brew install --cask" "${pkg_install_fonts[@]}"
		batch_install "brew install" "${pkg_install[@]}"
		batch_install "brew install --cask" "${pkg_install_cask[@]}"
	else
		echo "Didn't find brew. Please reinstall and run again."
		exit 1
	fi

elif [[ "$OS" == "Linux" ]]; then
	if [[ "$PKG_MGR" == "brew" ]]; then
		batch_install "brew install" "${pkg_install[@]}"
	elif [[ "$PKG_MGR" == "apt" ]]; then
		batch_install "sudo DEBIAN_FRONTEND=noninteractive apt install -y" "${pkg_install[@]}"
	fi
fi

# --- Common setup (both macOS and Linux) ---
# Runs after package install to ensure git/curl are available

echo -e "\n${TC_CYAN}>>> Common setup${TC_RESET}"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/"{i3,conky,polybar,pet,ghostty}

# install cross-shell prompt starship (install to ~/.local/bin to avoid sudo)
mkdir -p "$HOME/.local/bin"
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"

# TODO: need to check is available automatically install in Linux
echo
echo "Download Nerd Fonts from web for starship:"
echo "https://www.nerdfonts.com/font-downloads"
echo

# install oh-my-zsh framework
# modify the original install script to non-interactive way
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
[[ -d "$HOME/.oh-my-zsh" ]] || curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# install TPM (Tmux Plugin Manager)
[[ -d "$HOME/.tmux/plugins/tpm" ]] || git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"

# install the latest nvm and lts nodejs for the vim plugin coc
NVM_VERSION=$(curl -s https://api.github.com/repos/nvm-sh/nvm/releases/latest | grep "tag_name" | cut -d\" -f4)
curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/${NVM_VERSION}/install.sh" | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install --lts

# --- OS-specific config (symlinks) ---

echo -e "\n${TC_CYAN}>>> Symlink setup${TC_RESET}"
# Delegate to setup-symlinks.sh (single source of truth for all symlinks)
zsh "$HOME/.dotfile/setup-symlinks.sh"

echo -e "\n${TC_CYAN}>>> ZSH plugins${TC_RESET}"
# Delegate to install-ZSH-Plugins.sh
zsh "$HOME/.dotfile/install-ZSH-Plugins.sh"

# Set zsh as default shell (Linux only, macOS already defaults to zsh)
if [[ "$OS" == "Linux" ]] && [[ "$(basename "$SHELL")" != "zsh" ]]; then
	echo -e "\n${TC_CYAN}>>> Setting zsh as default shell${TC_RESET}"
	chsh -s "$(command -v zsh)"
fi

# --- Summary ---
echo ""
if [[ ${#pkg_manual[@]} -gt 0 ]]; then
	echo "--- Need manual install ---"
	for pkg in "${pkg_manual[@]}"; do
		echo "  - $pkg"
	done
	echo ""
fi

if [[ ${#install_failed[@]} -gt 0 ]]; then
	echo "--- Failed to install ---"
	for pkg in "${install_failed[@]}"; do
		echo "  - $pkg"
	done
	echo ""
fi

echo "============================================================"
echo " Done!"
echo "============================================================"
