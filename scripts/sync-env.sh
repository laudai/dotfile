#!/usr/bin/env bash
# sync-env.sh — Pull host-level secrets from Bitwarden into ~/.env
# Usage: ./sync-env.sh
#
# Bitwarden setup:
#   Create a Secure Note named "host-env" with contents matching host.env.example
#
# Dependencies:
#   macOS:  brew install bitwarden-cli
#   Linux:  flatpak install com.bitwarden.desktop (includes bw CLI)
set -eo pipefail

if [[ "$OSTYPE" == "darwin"* ]]; then
    BW=(bw)
    command -v bw >/dev/null || { echo "ERROR: bitwarden-cli not found. Run: brew install bitwarden-cli"; exit 1; }
else
    BW=(flatpak run --command=bw com.bitwarden.desktop)
    command -v flatpak >/dev/null || { echo "ERROR: flatpak not found. Install flatpak first."; exit 1; }
    flatpak info com.bitwarden.desktop &>/dev/null || { echo "ERROR: Bitwarden flatpak not installed. Run: flatpak install flathub com.bitwarden.desktop"; exit 1; }
fi

# Login if needed, then unlock (one master password prompt either way)
if "${BW[@]}" login --check 2>/dev/null; then
    BW_SESSION=$("${BW[@]}" unlock --raw) || { echo "ERROR: bw unlock failed"; exit 1; }
else
    BW_SESSION=$("${BW[@]}" login --raw) || { echo "ERROR: bw login failed"; exit 1; }
fi
export BW_SESSION

"${BW[@]}" get notes "host-env" > "$HOME/.env"
echo "~/.env updated from Bitwarden"

"${BW[@]}" lock
