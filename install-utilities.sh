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
# Load package lists (edit install-utilities.lists.sh to add/remove packages)
# =============================================================================
LISTS_FILE="$(dirname "$0")/install-utilities.lists.sh"
[[ -f "$LISTS_FILE" ]] || { echo "Error: package list file not found: $LISTS_FILE" >&2; exit 1; }
source "$LISTS_FILE"

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
	# Reads: $OS (set before calling), $skip_pkgs, $skip_on_mac, $skip_on_linux
	local -a os_skip=()
	case "$OS" in
		macOS) os_skip=("${skip_on_mac[@]}") ;;
		Linux) os_skip=("${skip_on_linux[@]}") ;;
	esac

	local -a result=()
	for pkg in "$@"; do
		local skip=false
		for s in "${skip_pkgs[@]}" "${os_skip[@]}"; do
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
	for pkg in "${common_formula[@]}" "${linux_only_formula[@]}" "${cross_platform_cask[@]}"; do
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

		brew_classify pkg_install $(filter_skip "${common_formula[@]}" "${linux_only_formula[@]}")
		# all GUI apps need manual install on Linux (no brew cask)
		pkg_manual+=($(filter_skip "${cross_platform_cask[@]}"))

	elif command -v apt >/dev/null; then
		PKG_MGR="apt"
		# auto-detect: check each package against apt-cache
		for pkg in $(filter_skip "${common_formula[@]}" "${linux_only_formula[@]}" "${cross_platform_cask[@]}"); do
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
	print_section "Skipped packages (all platforms)" "${skip_pkgs[@]}"
fi

if [[ "$OS" == "macOS" && ${#skip_on_mac[@]} -gt 0 ]]; then
	print_section "Skipped on macOS only" "${skip_on_mac[@]}"
elif [[ "$OS" == "Linux" && ${#skip_on_linux[@]} -gt 0 ]]; then
	print_section "Skipped on Linux only" "${skip_on_linux[@]}"
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
