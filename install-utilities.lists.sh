#!/usr/bin/env zsh
# =============================================================================
# install-utilities.lists.sh
#
# Package lists sourced by install-utilities.sh.
# This file is NOT executable on its own — it is loaded via `source`.
# Edit this file to add/remove packages; no changes to install-utilities.sh
# are required unless install logic itself changes.
# =============================================================================

# --- Cross-platform CLI tools (formula) ---
# Works on both macOS (brew) and Linux (brew/apt).
# For packages that only exist or only make sense on Linux, use linux_only_formula.
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
	midnight-commander               # terminal file manager (apt: mc)

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
	cmatrix
	lolcat                           # rainbow text
	fortune                          # random quotes (apt: fortunes)
	toilet                           # ASCII art text
	figlet                           # ASCII art text
)

# --- Linux-only CLI tools (formula) ---
# Packages that are either Linux-exclusive (Wayland/X11/systemd-specific) or
# where the macOS equivalent differs enough that brew install is not meaningful
# (e.g., strace → dtrace, gdb → lldb). Installed only when OS is Linux.
linux_only_formula=(
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
	docker-ce-cli                    # Docker CLI

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

	# Browser
	chromium                         # apt: chromium-browser (Ubuntu snap stub)
	firefox                          # apt: firefox (Ubuntu snap stub)

	# Communication / Sync
	thunderbird
	syncthing
	telegram                         # apt: telegram-desktop
	rambox                           # multi-messenger (Linux: manual)
	pcloud                           # cloud storage (both: manual)

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

# --- macOS only GUI apps ---
# These are macOS-exclusive and cannot run on Linux, even with Linuxbrew.
# Linux alternatives: i3/sway (window mgmt), rofi (launcher), keyd (key remap)
macos_only_cask=(
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
	balenaetcher
	screenkey
	screenrec
)

# --- Linux apt config ---

# brew name → apt name (only list where names differ)
# Note: declare -A requires bash 4.0+ or zsh. macOS default bash is 3.2 — use zsh instead.
declare -A apt_name_map=(
	[fd]="fd-find"
	[midnight-commander]="mc"
	[fortune]="fortunes"
	[ipython]="ipython3"
	[chromium]="chromium-browser"
	[telegram]="telegram-desktop"
)
