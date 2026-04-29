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
#   2. OS-detected install plan (macOS: brew formula+cask | Linux: apt/manual)
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

# These are now auto-detected at runtime in the "Build install plan" section.
# --check-apt and --check-brew are kept for manual verification.
# brew_name_map is used on macOS to translate apt-based keys to brew names.

# --- Runtime state ---
# Collects packages that failed during batch_install fallback
install_failed=()
# Collects packages that were skipped (already installed outside package manager)
install_skipped=()

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
# On macOS, translates apt-based keys to brew names via brew_name_map.
# Requires brew_all to be set before calling.
# -cx instead of -qx: grep -q with pipefail causes SIGPIPE false failures
function brew_classify() {
	local target_name=$1; shift
	for pkg in "$@"; do
		local brew_pkg="${brew_name_map[$pkg]:-$pkg}"
		if echo "$brew_all" | grep -cx "$brew_pkg" >/dev/null; then
			eval "${target_name}+=(\"$brew_pkg\")"
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
			if ! eval "$cmd $pkg" 2>&1; then
				# Check if already installed outside package manager (e.g. manual .dmg)
				# Replace hyphens with .* for fuzzy match (brave-browser → Brave Browser)
				local pattern
				pattern=$(echo "$pkg" | sed 's/-/.*/g')
				if ls /Applications/ 2>/dev/null | grep -qi "$pattern"; then
					install_skipped+=("$pkg")
				else
					install_failed+=("$pkg")
				fi
			fi
		done
	}
}

# Tier 5: auto-detect unknown packages in flatpak/snap
# Can be called multiple times (e.g. after apt installs flatpak).
# Clears and rebuilds pkg_flatpak_auto/pkg_snap_auto from pkg_unknown.
function run_auto_detect() {
	pkg_flatpak_auto=()
	pkg_snap_auto=()
	flatpak_auto_id=()
	snap_auto_info=()

	if [[ ${#pkg_unknown[@]} -gt 0 ]] && command -v flatpak >/dev/null; then
		local remaining=()
		for pkg in "${pkg_unknown[@]}"; do
			local fid
			fid=$(flatpak search --columns=application "$pkg" 2>/dev/null | grep -v "^No matches" | head -1 || true)
			if [[ -n "$fid" ]]; then
				pkg_flatpak_auto+=("$pkg")
				flatpak_auto_id[$pkg]="$fid"
			else
				remaining+=("$pkg")
			fi
		done
		pkg_unknown=("${remaining[@]}")
	fi
	if [[ ${#pkg_unknown[@]} -gt 0 ]] && command -v snap >/dev/null; then
		local remaining=()
		for pkg in "${pkg_unknown[@]}"; do
			local snap_name confinement
			snap_name=$(snap info "$pkg" 2>/dev/null | grep "^name:" | awk '{print $2}' || true)
			if [[ -n "$snap_name" ]]; then
				confinement=$(snap info "$pkg" 2>/dev/null | grep "^confinement:" | awk '{print $2}' || true)
				pkg_snap_auto+=("$pkg")
				snap_auto_info[$pkg]="${snap_name}::${confinement:-strict}"
			else
				remaining+=("$pkg")
			fi
		done
		pkg_unknown=("${remaining[@]}")
	fi
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
	for pkg in "${common_pkgs[@]}" "${cross_platform_gui[@]}" "${macos_only_gui[@]}"; do
		local brew_pkg="${brew_name_map[$pkg]:-$pkg}"
		if echo "$brew_all" | grep -cx "$brew_pkg" >/dev/null; then
			brew_yes+=("$brew_pkg")
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
	# Fetch all apt package names once into temp file for fast grep lookup
	# (avoids per-package apt-cache show which is ~30ms each × 115 packages = ~3s)
	apt_cache_file=$(mktemp)
	apt-cache pkgnames 2>/dev/null > "$apt_cache_file"
	apt_yes=()
	apt_no=()
	for pkg in "${common_pkgs[@]}" "${linux_only_pkgs[@]}" "${cross_platform_gui[@]}"; do
		if grep -qx "$pkg" "$apt_cache_file"; then
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
	rm -f "$apt_cache_file"
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
pkg_install_gui=()
pkg_install_fonts=()
pkg_manual=()

if [[ "$OSTYPE" == "darwin"* ]]; then
	OS="macOS"

	if command -v brew >/dev/null; then
		# auto-detect: fetch all available brew formulae and casks (~0.3s)
		brew_all=$(brew formulae; brew casks)

		pkg_install_fonts=()
		for f in "${fonts[@]}"; do
			brew_font="${font_brew_map[$f]}"
			if [[ -n "$brew_font" ]] && echo "$brew_all" | grep -cx "$brew_font" >/dev/null; then
				pkg_install_fonts+=("$brew_font")
			fi
		done
		brew_classify pkg_install       $(filter_skip "${common_pkgs[@]}")
		# Cannot merge formula + cask arrays: Linuxbrew only supports formula.
		# macOS uses separate install commands: brew install (formula) vs brew install --cask (cask).
		brew_classify pkg_install_gui   $(filter_skip "${cross_platform_gui[@]}" "${macos_only_gui[@]}")
	else
		echo "brew not found. Install Homebrew first:"
		echo '  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"'
		exit 1
	fi

elif [[ "$OSTYPE" == "linux"* ]]; then
	OS="Linux"
	if command -v brew >/dev/null; then
		PKG_MGR="brew"
		# Linuxbrew — formula only (no cask support on Linux)
		brew_all=$(brew formulae)

		brew_classify pkg_install $(filter_skip "${common_pkgs[@]}" "${linux_only_pkgs[@]}")
		# GUI apps → manual install on Linux (Linuxbrew has no cask support)
		pkg_manual+=($(filter_skip "${cross_platform_gui[@]}"))

	elif command -v apt >/dev/null; then
		PKG_MGR="apt"
		# auto-detect: check each package against apt-cache
		# Packages not in apt are further classified by Tier 1-4 definitions
		pkg_apt_repo=()      # Tier 1: extra apt repo
		pkg_official=()      # Tier 2: official recommended
		pkg_flatpak=()       # Tier 3: flatpak
		pkg_snap=()          # Tier 4: snap
		pkg_unknown=()       # not defined anywhere
		# Tier 5 auto-detect: populated later (after apt install in --install mode,
		# or using current system state in dry-run mode).
		# Auto-detected packages are found in flatpak/snap but not pre-defined in maps.
		# They are marked [auto-detected] in output to remind the user to review
		# and add them to the appropriate map.
		pkg_flatpak_auto=()
		pkg_snap_auto=()
		declare -A flatpak_auto_id=()
		declare -A snap_auto_info=()

		# Fetch all available apt packages in one call, store in temp file for fast lookup
		apt_cache_file=$(mktemp)
		apt-cache pkgnames 2>/dev/null > "$apt_cache_file"

		for pkg in $(filter_skip "${common_pkgs[@]}" "${linux_only_pkgs[@]}" "${cross_platform_gui[@]}"); do
			if grep -qx "$pkg" "$apt_cache_file"; then
				pkg_install+=("$pkg")
			elif [[ -n "${extra_apt_repos[$pkg]+x}" ]]; then
				pkg_apt_repo+=("$pkg")
			elif [[ -n "${official_install[$pkg]+x}" ]]; then
				pkg_official+=("$pkg")
			elif [[ -n "${flatpak_pkgs[$pkg]+x}" ]]; then
				pkg_flatpak+=("$pkg")
			elif [[ -n "${snap_pkgs[$pkg]+x}" ]]; then
				pkg_snap+=("$pkg")
			else
				pkg_unknown+=("$pkg")
			fi
		done
		rm -f "$apt_cache_file"

		# Run auto-detect for unknown packages (Tier 5)
		# In dry-run: uses current system state (may be incomplete on fresh install)
		# In --install: called again after apt install when flatpak is available
		run_auto_detect
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
	print_section "CLI tools (brew)" "${pkg_install[@]}"
	print_section "GUI apps (brew --cask)" "${pkg_install_gui[@]}"
	if [[ ${#pkg_manual[@]} -gt 0 ]]; then
		echo "--- Not in brew (manual install) ---"
		for pkg in "${pkg_manual[@]}"; do
			if [[ -n "${official_install[$pkg]+x}" ]]; then
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				url="${val#*::}"
				echo "  - $pkg  ($method: $url)"
			else
				echo "  - $pkg"
			fi
		done
		echo ""
	fi
elif [[ "$OS" == "Linux" ]]; then
	# Show fonts first (same order as macOS)
	if [[ ${#fonts[@]} -gt 0 ]]; then
		echo "--- Nerd Fonts (GitHub download) ---"
		for nf in "${fonts[@]}"; do
			echo "  - $nf"
		done
		echo ""
	fi
	print_section "Will be installed via $PKG_MGR" "${pkg_install[@]}"
	if [[ "$PKG_MGR" == "apt" ]]; then
		defined_total=$(( ${#pkg_apt_repo[@]} + ${#pkg_official[@]} + ${#pkg_flatpak[@]} + ${#pkg_snap[@]} + ${#pkg_flatpak_auto[@]} + ${#pkg_snap_auto[@]} ))
		if [[ $defined_total -gt 0 ]]; then
			echo "--- Not in apt — will be installed ($defined_total) ---"
			echo ""
			if [[ ${#pkg_apt_repo[@]} -gt 0 ]]; then
				echo "  Tier 1: apt repo (${#pkg_apt_repo[@]})"
				for pkg in "${pkg_apt_repo[@]}"; do
					val="${extra_apt_repos[$pkg]}"
					repo_url="${val#*::}"; repo_url="${repo_url%%::*}"
					echo "    - $pkg  ($repo_url)"
				done
				echo ""
			fi
			if [[ ${#pkg_official[@]} -gt 0 ]]; then
				echo "  Tier 2: official (${#pkg_official[@]})"
				for pkg in "${pkg_official[@]}"; do
					val="${official_install[$pkg]}"
					method="${val%%::*}"
					echo "    - $pkg  ($method)"
				done
				echo ""
			fi
			flatpak_total=${#pkg_flatpak[@]}
			if [[ $flatpak_total -gt 0 ]]; then
				echo "  Tier 3: flatpak ($flatpak_total)"
				for pkg in "${pkg_flatpak[@]}"; do
					echo "    - $pkg  (${flatpak_pkgs[$pkg]})"
				done
				echo ""
			fi
			if [[ ${#pkg_snap[@]} -gt 0 ]]; then
				echo "  Tier 4: snap (${#pkg_snap[@]})"
				for pkg in "${pkg_snap[@]}"; do
					val="${snap_pkgs[$pkg]}"
					confinement="${val#*::}"
					echo "    - $pkg  ($confinement)"
				done
				echo ""
			fi
			auto_total=$(( ${#pkg_flatpak_auto[@]} + ${#pkg_snap_auto[@]} ))
			if [[ $auto_total -gt 0 ]]; then
				echo "  Tier 5: auto-detected ($auto_total)"
				for pkg in "${pkg_flatpak_auto[@]}"; do
					echo "    - $pkg  (flatpak: ${flatpak_auto_id[$pkg]}) [auto-detected]"
				done
				for pkg in "${pkg_snap_auto[@]}"; do
					val="${snap_auto_info[$pkg]}"
					confinement="${val#*::}"
					echo "    - $pkg  (snap: $confinement) [auto-detected]"
				done
				echo ""
			fi
		fi
		if [[ ${#pkg_unknown[@]} -gt 0 ]]; then
			print_section "Not in apt — need manual install (${#pkg_unknown[@]})" "${pkg_unknown[@]}"
		fi
		# Note for dry-run on fresh systems
		if ! $DO_INSTALL && [[ ${#pkg_unknown[@]} -gt 0 ]] && ! command -v flatpak >/dev/null; then
			echo "  Note: flatpak not yet installed. Some packages above may move from"
			echo "        'need manual install' to Tier 5 auto-detected after --install."
			echo ""
		fi
	else
		if [[ ${#pkg_manual[@]} -gt 0 ]]; then
			print_section "Need manual install" "${pkg_manual[@]}"
		fi
	fi
	echo "--- macOS-only apps (NOT installable on Linux) ---"
	echo "  (see macos_only_gui in install-utilities.lists.sh)"
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
		batch_install "brew install --cask" "${pkg_install_gui[@]}"
	else
		echo "Didn't find brew. Please reinstall and run again."
		exit 1
	fi

elif [[ "$OS" == "Linux" ]]; then
	# --- Nerd Fonts (before packages, same order as macOS brew cask fonts) ---
	echo -e "\n${TC_CYAN}>>> Installing Nerd Fonts${TC_RESET}"
	FONT_DIR="$HOME/.local/share/fonts"
	mkdir -p "$FONT_DIR"
	for nf in "${fonts[@]}"; do
		if ls "$FONT_DIR"/${nf}NerdFont* &>/dev/null; then
			echo "  $nf Nerd Font already installed, skipping"
		else
			echo -e "${TC_CYAN}  Downloading $nf Nerd Font${TC_RESET}"
			curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${nf}.tar.xz" -o "/tmp/${nf}.tar.xz" \
				&& tar xf "/tmp/${nf}.tar.xz" -C "$FONT_DIR" \
				&& rm -f "/tmp/${nf}.tar.xz" \
				|| echo "  Failed to download $nf Nerd Font"
		fi
	done
	fc-cache -f "$FONT_DIR"

	if [[ "$PKG_MGR" == "brew" ]]; then
		batch_install "brew install" "${pkg_install[@]}"
	elif [[ "$PKG_MGR" == "apt" ]]; then
		# Pre-requisite: ~/.local/bin for uv, tokei, bw wrapper, etc.
		mkdir -p "$HOME/.local/bin"

		# --- Batch apt install ---
		batch_install "sudo DEBIAN_FRONTEND=noninteractive apt install -y" "${pkg_install[@]}"

		# --- Tier 1: Extra apt repos ---
		if [[ ${#pkg_apt_repo[@]} -gt 0 ]]; then
			echo -e "\n${TC_CYAN}>>> Tier 1: Setting up extra apt repos${TC_RESET}"
			codename=$(lsb_release -cs)
			added_repos=""
			for pkg in "${pkg_apt_repo[@]}"; do
				val="${extra_apt_repos[$pkg]}"
				IFS='::' read -r key_url _ repo_url _ suite _ components _ dearmor <<< "$val"
				suite="${suite//\{codename\}/$codename}"
				key_url="${key_url//\{codename\}/$codename}"

				# Skip if repo already added (e.g. docker-ce and docker-ce-cli share same repo)
				if echo "$added_repos" | grep -qx "$repo_url"; then
					echo -e "${TC_CYAN}  Repo already added for: $pkg (shared repo)${TC_RESET}"
					continue
				fi
				added_repos="$added_repos
$repo_url"

				echo -e "${TC_CYAN}  Setting up repo for: $pkg${TC_RESET}"
				keyring="/usr/share/keyrings/${pkg}-archive-keyring.gpg"
				if [[ "$dearmor" == "yes" ]]; then
					curl -fsSL "https://$key_url" | sudo gpg --dearmor -o "$keyring"
				else
					sudo curl -fsSL "https://$key_url" -o "$keyring"
				fi

				sudo tee "/etc/apt/sources.list.d/${pkg}.sources" > /dev/null <<-SOURCES
				Types: deb
				URIs: https://$repo_url
				Suites: $suite
				Components: $components
				Signed-By: $keyring
				SOURCES

				# Syncthing: pin official repo to override Ubuntu's older version
				if [[ "$pkg" == "syncthing" ]]; then
					printf "Package: *\nPin: origin apt.syncthing.net\nPin-Priority: 990\n" | sudo tee /etc/apt/preferences.d/syncthing.pref > /dev/null
				fi
			done
			sudo apt update
			apt_repo_pkgs=("${pkg_apt_repo[@]}")
			batch_install "sudo DEBIAN_FRONTEND=noninteractive apt install -y" "${apt_repo_pkgs[@]}"
		fi

		# --- Tier 2: Official recommended ---
		if [[ ${#pkg_official[@]} -gt 0 ]]; then
			echo -e "\n${TC_CYAN}>>> Tier 2: Official recommended installs${TC_RESET}"

			# 2a. curl script (uv must be first for dependencies)
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "curl" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (curl script)${TC_RESET}"
				curl -LsSf "$args" | sh
			done

			# 2b. uv tool install
			# Use full path because bash scripts don't read .zshrc/.bashrc,
			# so ~/.local/bin is not in PATH when run via `bash script.sh`.
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "uv" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (uv tool)${TC_RESET}"
				"$HOME/.local/bin/uv" tool install "$args" || install_failed+=("$pkg")
			done

			# 2c. script download
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "script" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (script)${TC_RESET}"
				curl -fsSL "$args" -o "$HOME/.local/bin/$pkg" && chmod +x "$HOME/.local/bin/$pkg" || install_failed+=("$pkg")
			done

			# 2c. github binary
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				[[ "$method" == "github_binary" ]] || continue
				rest="${val#*::}"
				repo="${rest%%::*}"
				asset="${rest#*::}"
				echo -e "${TC_CYAN}  Installing $pkg (github binary)${TC_RESET}"
				url=$(curl -fsSL "https://api.github.com/repos/$repo/releases/latest" | grep -o "https://.*$asset" | head -1)
				if [[ -n "$url" ]]; then
					curl -fsSL "$url" -o "/tmp/$asset"
					tar xf "/tmp/$asset" -C "$HOME/.local/bin/" 2>/dev/null || cp "/tmp/$asset" "$HOME/.local/bin/$pkg"
					chmod +x "$HOME/.local/bin/$pkg"
					rm -f "/tmp/$asset"
				else
					install_failed+=("$pkg")
				fi
			done

			# 2c. url binary (fixed URL, no GitHub API)
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "url_binary" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (url binary)${TC_RESET}"
				filename=$(basename "$args")
				curl -fsSL "$args" -o "/tmp/$filename"
				tar xf "/tmp/$filename" -C "$HOME/.local/bin/" 2>/dev/null || cp "/tmp/$filename" "$HOME/.local/bin/$pkg"
				chmod +x "$HOME/.local/bin/$pkg"
				rm -f "/tmp/$filename"
			done

			# 2c. wrapper
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "wrapper" ]] || continue
				echo -e "${TC_CYAN}  Creating wrapper for $pkg${TC_RESET}"
				cat > "$HOME/.local/bin/$pkg" <<-WRAPPER
				#!/bin/sh
				exec $args "\$@"
				WRAPPER
				chmod +x "$HOME/.local/bin/$pkg"
			done

			# 2d. github .deb
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "github_deb" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (github .deb)${TC_RESET}"
				url=$(curl -fsSL "https://api.github.com/repos/$args/releases/latest" | grep -o 'https://.*amd64\.deb' | head -1)
				if [[ -n "$url" ]]; then
					curl -fsSL "$url" -o "/tmp/${pkg}.deb"
					sudo DEBIAN_FRONTEND=noninteractive dpkg -i "/tmp/${pkg}.deb" || sudo apt install -f -y
					rm -f "/tmp/${pkg}.deb"
				else
					install_failed+=("$pkg")
				fi
			done

			# 2d. url .deb
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				args="${val#*::}"
				[[ "$method" == "url_deb" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg (url .deb)${TC_RESET}"
				curl -fsSL "$args" -o "/tmp/${pkg}.deb"
				sudo DEBIAN_FRONTEND=noninteractive dpkg -i "/tmp/${pkg}.deb" || sudo apt install -f -y
				rm -f "/tmp/${pkg}.deb"
			done

			# 2e. pre-deps for manual packages
			for pkg in "${pkg_official[@]}"; do
				val="${official_install[$pkg]}"
				method="${val%%::*}"
				[[ "$method" == "manual" ]] || continue
				if [[ -n "${pre_deps[$pkg]+x}" ]]; then
					echo -e "${TC_CYAN}  Installing pre-dependency for $pkg: ${pre_deps[$pkg]}${TC_RESET}"
					sudo DEBIAN_FRONTEND=noninteractive apt install -y "${pre_deps[$pkg]}"
				fi
			done
		fi

		# --- Tier 3: Flatpak ---
		if [[ ${#pkg_flatpak[@]} -gt 0 || ${#pkg_flatpak_auto[@]} -gt 0 ]]; then
			echo -e "\n${TC_CYAN}>>> Tier 3: Flatpak installs${TC_RESET}"
			flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo
			# Install bitwarden first (bw wrapper depends on it)
			for pkg in bitwarden "${pkg_flatpak[@]}"; do
				[[ "$pkg" == "bitwarden" ]] || continue
				fid="${flatpak_pkgs[$pkg]}"
				[[ -n "$fid" ]] || continue
				echo -e "${TC_CYAN}  Installing $pkg ($fid)${TC_RESET}"
				flatpak install -y flathub "$fid" || install_failed+=("$pkg")
			done
			for pkg in "${pkg_flatpak[@]}"; do
				[[ "$pkg" == "bitwarden" ]] && continue
				fid="${flatpak_pkgs[$pkg]}"
				echo -e "${TC_CYAN}  Installing $pkg ($fid)${TC_RESET}"
				flatpak install -y flathub "$fid" || install_failed+=("$pkg")
			done
		fi

		# --- Tier 4: Snap ---
		if [[ ${#pkg_snap[@]} -gt 0 || ${#pkg_snap_auto[@]} -gt 0 ]]; then
			echo -e "\n${TC_CYAN}>>> Tier 4: Snap installs${TC_RESET}"
			for pkg in "${pkg_snap[@]}"; do
				val="${snap_pkgs[$pkg]}"
				snap_name="${val%%::*}"
				confinement="${val#*::}"
				snap_flags=""
				[[ "$confinement" == "classic" ]] && snap_flags="--classic"
				echo -e "${TC_CYAN}  Installing $pkg ($snap_name $confinement)${TC_RESET}"
				sudo snap install "$snap_name" $snap_flags || install_failed+=("$pkg")
			done
		fi

		# --- Tier 5: Auto-detect (re-run after apt installed flatpak) ---
		if [[ ${#pkg_unknown[@]} -gt 0 ]]; then
			echo -e "\n${TC_CYAN}>>> Tier 5: Auto-detect for unknown packages${TC_RESET}"
			# Ensure flatpak appstream index is up to date for search
			if command -v flatpak >/dev/null; then
				flatpak update --appstream 2>/dev/null || true
			fi
			run_auto_detect

			for pkg in "${pkg_flatpak_auto[@]}"; do
				fid="${flatpak_auto_id[$pkg]}"
				echo -e "${TC_CYAN}  Installing $pkg ($fid) [auto-detected]${TC_RESET}"
				flatpak install -y flathub "$fid" || install_failed+=("$pkg")
			done
			for pkg in "${pkg_snap_auto[@]}"; do
				val="${snap_auto_info[$pkg]}"
				snap_name="${val%%::*}"
				confinement="${val#*::}"
				snap_flags=""
				[[ "$confinement" == "classic" ]] && snap_flags="--classic"
				echo -e "${TC_CYAN}  Installing $pkg ($snap_name $confinement) [auto-detected]${TC_RESET}"
				sudo snap install "$snap_name" $snap_flags || install_failed+=("$pkg")
			done
		fi

		# --- Post-install ---
		echo -e "\n${TC_CYAN}>>> Post-install steps${TC_RESET}"
		post_install_msgs=()

		# tailscale
		if printf '%s\n' "${pkg_apt_repo[@]}" "${pkg_install[@]}" | grep -qx tailscale; then
			sudo systemctl enable --now tailscaled
			post_install_msgs+=("tailscale:\n    Run 'sudo tailscale up' to join your Tailnet, then open the URL to authorize.\n    Docs: https://tailscale.com/kb/1017/install")
		fi

		# docker-ce
		if printf '%s\n' "${pkg_install[@]}" | grep -qx docker-ce; then
			sudo systemctl enable --now docker
			sudo usermod -aG docker "$USER"
			post_install_msgs+=("docker-ce:\n    Log out and back in for docker group to take effect.\n    Docs: https://docs.docker.com/engine/install/linux-postinstall/")
		fi

		# flatpak (first-time install)
		if printf '%s\n' "${pkg_install[@]}" | grep -qx flatpak; then
			post_install_msgs+=("flatpak:\n    Reboot or re-login for XDG desktop portal to take effect (file picker, notifications).\n    Docs: https://flatpak.org/setup/Ubuntu")
		fi

		# fcitx5
		if printf '%s\n' "${pkg_install[@]}" | grep -q '^fcitx5'; then
			mkdir -p "$HOME/.config/environment.d"
			if [[ ! -f "$HOME/.config/environment.d/im.conf" ]]; then
				cat > "$HOME/.config/environment.d/im.conf" <<-'IMCONF'
				GTK_IM_MODULE=fcitx
				QT_IM_MODULE=fcitx
				XMODIFIERS=@im=fcitx
				IMCONF
			fi
			post_install_msgs+=("fcitx5:\n    Created ~/.config/environment.d/im.conf (GTK_IM_MODULE, QT_IM_MODULE, XMODIFIERS)\n    Re-login for input method to take effect.\n    Note: On Wayland, GTK_IM_MODULE=fcitx may cause candidate window flickering.\n          Remove GTK_IM_MODULE line from im.conf after migrating away from X11/i3.\n    Docs: https://fcitx-im.org/wiki/Using_Fcitx_5_on_Wayland")
		fi

		# syncthing
		if printf '%s\n' "${pkg_install[@]}" | grep -qx syncthing; then
			systemctl --user enable --now syncthing.service
			post_install_msgs+=("syncthing:\n    Web GUI available at http://127.0.0.1:8384\n    Docs: https://docs.syncthing.net/users/autostart.html#linux")
		fi

		# chsh to zsh
		if [[ "$(basename "$SHELL")" != "zsh" ]] && command -v zsh >/dev/null; then
			echo -e "${TC_CYAN}  Setting zsh as default shell${TC_RESET}"
			sudo chsh -s "$(command -v zsh)" "$USER"
		fi
	fi
fi

# --- Common setup (both macOS and Linux) ---
# Runs after package install to ensure git/curl are available

echo -e "\n${TC_CYAN}>>> Common setup${TC_RESET}"
mkdir -p "$HOME/.config"
mkdir -p "$HOME/.config/"{i3,conky,polybar,pet,ghostty}

# massCode vault is git-cloned into this directory
mkdir -p "$HOME/Documents/projects/Personal"

# install cross-shell prompt starship (install to ~/.local/bin to avoid sudo)
mkdir -p "$HOME/.local/bin"
curl -sS https://starship.rs/install.sh | sh -s -- --yes --bin-dir "$HOME/.local/bin"



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
zsh "$HOME/.dotfile/scripts/setup-symlinks.sh"

echo -e "\n${TC_CYAN}>>> ZSH plugins${TC_RESET}"
# Delegate to install-ZSH-Plugins.sh
zsh "$HOME/.dotfile/scripts/install-ZSH-Plugins.sh"

# Set zsh as default shell (Linux only, macOS already defaults to zsh)
# Moved to post-install section in Linux apt path

# --- Summary ---
echo ""

# Show manual install URLs
if [[ "$OS" == "Linux" && "$PKG_MGR" == "apt" ]]; then
	has_manual=false
	for pkg in "${pkg_official[@]}"; do
		val="${official_install[$pkg]}"
		method="${val%%::*}"
		if [[ "$method" == "manual" ]]; then
			if ! $has_manual; then
				echo "--- Manual install needed ---"
				has_manual=true
			fi
			url="${val#*::}"
			echo "  - $pkg: $url"
		fi
	done
	$has_manual && echo ""

	if [[ ${#pkg_unknown[@]} -gt 0 ]]; then
		echo "--- Unknown (no install method defined) ---"
		for pkg in "${pkg_unknown[@]}"; do
			echo "  - $pkg"
		done
		echo ""
	fi

	# Show post-install messages
	if [[ ${#post_install_msgs[@]} -gt 0 ]]; then
		echo "--- Post-install steps ---"
		for msg in "${post_install_msgs[@]}"; do
			echo -e "  $msg"
		done
		echo ""
	fi
fi

if [[ ${#install_skipped[@]} -gt 0 ]]; then
	echo "--- Already installed (not managed by package manager) ---"
	for pkg in "${install_skipped[@]}"; do
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
