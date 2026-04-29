#!/usr/bin/env bash
# sync-env.sh — Pull host-level secrets from Bitwarden into ~/.env
# Usage: ./sync-env.sh
#
# Bitwarden setup:
#   Create a Secure Note named "host-env" with contents matching host.env.example
#
# Dependencies:
#   bw CLI must be in PATH
#   macOS:  brew install bitwarden-cli
#   Linux:  ~/.local/bin/bw wrapper (created by install-utilities.sh)
set -eo pipefail

command -v bw >/dev/null || { echo "ERROR: bw not found. Run install-utilities.sh first."; exit 1; }

# Login if needed, then unlock (one master password prompt either way)
if bw login --check 2>/dev/null; then
	BW_SESSION=$(bw unlock --raw) || { echo "ERROR: bw unlock failed"; exit 1; }
else
	BW_SESSION=$(bw login --raw) || { echo "ERROR: bw login failed"; exit 1; }
fi
export BW_SESSION

bw get notes "host-env" > "$HOME/.env"
echo "~/.env updated from Bitwarden"

bw lock
