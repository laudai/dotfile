#!/usr/bin/env zsh
# =============================================================================
# install-utilities.lists.sh
#
# Package lists sourced by install-utilities.sh.
# This file is NOT executable on its own — it is loaded via `source`.
# Edit this file to add/remove packages; no changes to install-utilities.sh
# are required unless install logic itself changes.
# =============================================================================

# --- Cross-platform CLI tools ---
# Package names use apt convention (the key is the apt package name).
# On macOS, brew_name_map translates to the correct brew name where they differ.
# For packages that only exist or only make sense on Linux, use linux_only_pkgs.
#
# Note: "formula" and "cask" array names are kept because Linuxbrew (Linux)
# only supports formula, not cask. The distinction is needed so the Linux
# Linuxbrew path knows which packages it can install vs. skip to manual.
common_pkgs=(
	# System monitoring
	htop
	glances
	btop
	iftop
	speedtest-cli

	# File / Text search
	bat                              # cat alternative with syntax highlighting
	fd-find                          # find alternative (brew: fd)
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
	urlview                          # tmux-urlview dependency

	# Development / System admin
	git

	# Network / Security
	mtr
	nmap
	iperf3                           # network bandwidth test
	httpie                           # human-friendly HTTP client
	sqlmap                           # SQL injection testing
	sshfs                            # mount remote dir via SSH
	mosh                             # mobile SSH (auto-reconnect)
	sshuttle                         # poor man's VPN via SSH
	tailscale                        # mesh VPN (needs extra repo on Linux)

	# Media
	ffmpeg                           # audio/video converter
	imagemagick                      # image processing

	# File management
	czkawka                          # duplicate file finder (macOS: CLI+GUI via brew; Linux: manual/flatpak)
	mc                               # terminal file manager (brew: midnight-commander)
	ncdu                             # disk usage analyzer

	# Linter
	ruff

	# Python
	uv                               # Python package manager (Astral)
	ipython3                         # interactive Python (brew: ipython)

	# Security
	bw                               # Bitwarden CLI (brew: bitwarden-cli)

	# Entertainment / Eye candy
	screenfetch                      # system info display
	cowsay
	cmatrix
	lolcat                           # rainbow text
	fortunes                         # random quotes (brew: fortune)
	toilet                           # ASCII art text
	figlet                           # ASCII art text
)

# --- Linux-only CLI tools ---
# Packages that are either Linux-exclusive (Wayland/X11/systemd-specific) or
# where the macOS equivalent differs enough that brew install is not meaningful
# (e.g., strace → dtrace, gdb → lldb). Installed only when OS is Linux.
linux_only_pkgs=(
	# System / Debug
	build-essential                  # gcc/g++/make (Linux only, macOS uses Xcode CLT)
	openssh-server                   # Linux only (macOS built-in)
	bind9-dnsutils                   # dig/nslookup (macOS built-in)
	hping3                           # TCP/IP packet tool
	gparted                          # disk partition tool
	gnome-tweaks                     # GNOME advanced settings
	ltrace                           # library call tracer
	strace                           # syscall tracer (macOS uses dtrace)
	gdb                              # GNU debugger (macOS uses lldb)
	llvm                             # compiler infrastructure
	graphviz                         # graph drawing tool (dot)
	flatpak                          # Linux package manager (snap is preinstalled)
	screenkey                        # screencast keystroke display
	hollywood

	# Linux desktop / Notification
	dunst                            # notification daemon (Wayland compatible)
	pavucontrol                      # PulseAudio volume control
	mako-notifier                    # sway notifier
	sway-notification-center         # sway notification center

	# Docker (Linux native — needs extra repo)
	docker-ce                        # Docker Engine
	docker-ce-cli                    # Docker CLI (shares docker-ce repo)

	# --- X11 / Wayland transition (keep both during migration) ---

	# Clipboard / Automation
	xdotool                          # x11 only → ydotool
	ydotool                          # wayland, replaces xdotool
	wl-clipboard                     # wayland, replaces xclip/xsel

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

	# i3 utilities (Sway compatibility TBD)
	i3-get-window-criteria           # uv: i3 window criteria helper
	i3-resurrect                     # uv: i3 session save/restore
	i3-swap-focus                    # uv: i3 focus swap

	# Wine / Compatibility
	bottles                          # flatpak: Wine prefix manager
)

# --- Cross-platform GUI apps (cask on macOS, apt/manual on Linux) ---
# Kept separate from common_pkgs because Linuxbrew does not support --cask.
# On macOS: brew --cask (auto-detected at runtime)
# On Linux + apt: auto-detected via apt-cache
# On Linux + Linuxbrew: all go to manual install (no cask support)
cross_platform_gui=(
	# Productivity / Notes / Development / Terminal / Editor / IDE
	anytype
	joplin
	obsidian
	code                             # VS Code (apt: code, brew: visual-studio-code)
	codium                           # open-source VS Code (apt: codium, brew: vscodium)
	masscode
	ghostty
	gitkraken
	wireshark

	# Browser
	chromium-browser                 # brew: chromium (Ubuntu snap stub)
	firefox                          # Ubuntu snap stub
	brave-browser

	# Communication / Sync
	thunderbird
	syncthing
	telegram                         # no native apt; needs PPA or manual
	rambox                           # multi-messenger (Linux: manual)
	pcloud                           # cloud storage (both: manual)
	dropbox                          # cloud storage (Linux: .deb from official site)

	# Security
	bitwarden

	# VPN
	surfshark

	# Finance
	mmex                             # Money Manager Ex

	# Media / Graphics
	flameshot
	gimp                             # image editor (replaces pinta)
	balenaetcher                     # USB boot disk creator
	screenrec                        # screen recorder (both: manual, https://screenrec.com/)

	# Other
	anki
)

# --- macOS-only GUI apps (cask) ---
# These are macOS-exclusive and cannot run on Linux, even with Linuxbrew.
# Linux alternatives: i3/sway (window mgmt), rofi (launcher), keyd (key remap)
macos_only_gui=(
	# Terminal
	iterm2

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
macos_fonts=(
	font-caskaydia-cove-nerd-font
	font-fira-code
	font-cascadia-code
)

# --- Skip list ---
# Packages to keep in lists but not install automatically.
# Remove from here when you want to install them.
skip_pkgs=(
	wireshark
	code
	joplin
	gitkraken
	anki
	gnome-tweaks
	llvm
	httpie
	cowsay
	lolcat
	fortunes
	hollywood
	balenaetcher
	screenkey
	screenrec
)

# --- Platform-specific skip lists ---
# Packages to skip only on a specific platform.
# Combines with skip_pkgs (which skips on all platforms).
skip_on_mac=(
	nmap
	iperf3
	sqlmap
	ipython3
	screenfetch
	cmatrix
	toilet
	chromium-browser
	telegram
	rambox
	surfshark
	mmex
	dropbox
	sshfs                            # brew formula requires Linux; macOS needs macfuse + separate sshfs
)

skip_on_linux=(
	# e.g., ... — Linux has native alternatives
)

# --- Brew name mapping ---

# apt name (key) → brew name (only list where names differ)
# On macOS, the script queries this map to get the correct brew package name.
# On Linux, the key is used directly as the apt package name.
# Only add formula packages here. Cask packages must stay in cross_platform_gui
# (Linuxbrew cannot install casks).
# Note: declare -A requires bash 4.0+ or zsh. macOS default bash is 3.2 — use zsh instead.
declare -A brew_name_map=(
	[fd-find]="fd"
	[mc]="midnight-commander"
	[fortunes]="fortune"
	[ipython3]="ipython"
	[chromium-browser]="chromium"
	[bw]="bitwarden-cli"
	[code]="visual-studio-code"
	[codium]="vscodium"
)

# =============================================================================
# Linux non-apt install definitions (Layer 1-4)
# These maps define how to install packages not available in default apt repos.
# Separator: :: (double colon) between fields.
# =============================================================================

# --- Layer 1: Extra apt repos ---
# format: key_url::repo_url::suite::components::dearmor
declare -A extra_apt_repos=(
	[tailscale]="pkgs.tailscale.com/stable/ubuntu/{codename}.noarmor.gpg::pkgs.tailscale.com/stable/ubuntu::{codename}::main::no"
	[brave-browser]="brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg::brave-browser-apt-release.s3.brave.com/::stable::main::no"
	[code]="packages.microsoft.com/keys/microsoft.asc::packages.microsoft.com/repos/code::stable::main::yes"
	[codium]="gitlab.com/paulcarroty/vscodium-deb-rpm-repo/raw/master/pub.gpg::download.vscodium.com/debs::vscodium::main::yes"
	[docker-ce]="download.docker.com/linux/ubuntu/gpg::download.docker.com/linux/ubuntu::{codename}::stable::yes"
	[docker-ce-cli]="download.docker.com/linux/ubuntu/gpg::download.docker.com/linux/ubuntu::{codename}::stable::yes"
	# syncthing: Ubuntu apt has v1.27.2 (config version 37) which is too old.
	# Official repo provides latest stable (config version 51+).
	# On existing machines, manually add repo + pinning to override Ubuntu version.
	# On new machines, apt installs Ubuntu version first (no config conflict),
	# then Tier 1 adds official repo + pinning, apt upgrade gets latest.
	[syncthing]="syncthing.net/release-key.gpg::apt.syncthing.net/::syncthing::stable-v2::no"
)

# --- Layer 2: Official recommended install methods ---
# format: method::arg1::arg2
# methods:
#   curl          — curl install script, pipe to sh. arg1=url
#   uv            — uv tool install. arg1=package_spec
#   script        — curl script to ~/.local/bin/. arg1=url
#   github_binary — curl binary to ~/.local/bin/ from GitHub latest release. arg1=owner/repo, arg2=asset_pattern
#   url_binary    — curl binary to ~/.local/bin/ from fixed URL. arg1=url
#   wrapper       — create wrapper script in ~/.local/bin/. arg1=command
#   github_deb    — .deb from GitHub latest release. arg1=owner/repo
#   url_deb       — .deb from fixed URL. arg1=url
#   manual        — show URL in summary. arg1=url
declare -A official_install=(
	# 2a. curl script
	[uv]="curl::https://astral.sh/uv/install.sh"

	# 2b. uv tool install (depends on uv)
	[ruff]="uv::ruff"
	[i3-resurrect]="uv::i3-resurrect"
	[i3-swap-focus]="uv::git+https://codeberg.org/olivierlm/i3-swap-focus"

	# 2c. curl download / wrapper
	[i3-get-window-criteria]="script::https://gist.githubusercontent.com/jottr/8645010/raw"
	[tokei]="url_binary::https://github.com/XAMPPRocky/tokei/releases/download/v12.1.2/tokei-x86_64-unknown-linux-gnu.tar.gz"
	[bw]="wrapper::flatpak run --command=bw com.bitwarden.desktop"

	# 2d. GitHub .deb
	[pet]="github_deb::knqyf263/pet"
	[anytype]="github_deb::anyproto/anytype-ts"
	[obsidian]="github_deb::obsidianmd/obsidian-releases"
	[joplin]="github_deb::laurent22/joplin"
	[balenaetcher]="github_deb::balena-io/etcher"
	[gitkraken]="url_deb::https://release.gitkraken.com/linux/gitkraken-amd64.deb"
	[dropbox]="url_deb::https://linux.dropbox.com/packages/ubuntu/dropbox_2024.04.17_amd64.deb"

	# 2e. manual (show URL only)
	[pcloud]="manual::https://www.pcloud.com/how-to-install-pcloud-drive-linux.html"
	[masscode]="manual::https://masscode.io/download/"
	[screenrec]="manual::https://screenrec.com/download/"
)

# --- Layer 3: Flatpak (all officially maintained) ---
# format: flatpak_id
declare -A flatpak_pkgs=(
	[bitwarden]="com.bitwarden.desktop"
	[czkawka]="com.github.qarmin.czkawka"
	[bottles]="com.usebottles.bottles"
	[telegram]="org.telegram.desktop"
	[mmex]="org.moneymanagerex.MMEX"
)

# --- Layer 4: Snap ---
# format: snap_name::confinement
declare -A snap_pkgs=(
	[ghostty]="ghostty::classic"
	[rambox]="rambox::strict"
	[surfshark]="surfshark::strict"
)

# --- Pre-dependencies (apt packages needed before install) ---
# format: apt_package
declare -A pre_deps=(
	[pcloud]="libfuse2t64"
)
