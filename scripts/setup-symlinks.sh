#!/usr/bin/env zsh
# =============================================================================
# setup-symlinks.sh — Create dotfile symlinks and OS-specific configs
#
# Usage:
#   ./scripts/setup-symlinks.sh
#   zsh scripts/setup-symlinks.sh
# =============================================================================

# --- Common dotfile symlinks ---
ln -sf "$HOME/.dotfile/config/zshrc" "$HOME/.zshrc"
ln -sf "$HOME/.dotfile/config/vimrc" "$HOME/.vimrc"
ln -sf "$HOME/.dotfile/config/tmux.conf" "$HOME/.tmux.conf"
ln -sf "$HOME/.dotfile/config/gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/.dotfile/config/gitignore_global" "$HOME/.gitignore_global"
ln -sf "$HOME/.dotfile/config/starship.toml" "$HOME/.config/starship.toml"
ln -sf "$HOME/.dotfile/config/ghostty" "$HOME/.config/ghostty/config"
# Ghostty host-specific overrides: copy template if not yet customized
[[ -f "$HOME/.config/ghostty/platform-specific" ]] || cp "$HOME/.dotfile/config/ghostty-platform-specific.example" "$HOME/.config/ghostty/platform-specific"
ln -sf "$HOME/.dotfile/config/pet.config.toml" "$HOME/.config/pet/config.toml"

# --- SSH helper scripts ---
ln -sf "$HOME/.dotfile/scripts/ssh/ssh-match-date.sh" "$HOME/.ssh/ssh-match-date.sh"
ln -sf "$HOME/.dotfile/scripts/ssh/ssm-private-ec2-proxy.sh" "$HOME/.ssh/ssm-private-ec2-proxy.sh"

# --- OS-specific symlinks ---
if [[ "$OSTYPE" == "darwin"* ]]; then
	mkdir -p "$HOME/.config/karabiner/assets/complex_modifications"
	ln -sf "$HOME/.dotfile/config/karabiner_bash_emacs.json" "$HOME/.config/karabiner/assets/complex_modifications/bash_emacs.json"

elif [[ "$OSTYPE" == "linux"* ]]; then
	ln -sf "$HOME/.dotfile/config/i3.config" "$HOME/.config/i3/config"
	ln -sf "$HOME/.dotfile/config/conky.conf" "$HOME/.config/conky/conky.conf"
	ln -sf "$HOME/.dotfile/config/polybar.config.ini" "$HOME/.config/polybar/config.ini"
fi

# --- SSH config ---
# SSH config: use Include instead of append (machine-specific settings stay in ~/.ssh/config)
if [[ -f "$HOME/.ssh/config" ]] && grep -q 'Include ~/.dotfile/config/ssh.config' "$HOME/.ssh/config"; then
	echo "SSH config Include already present. Skipping."
else
	echo 'Include ~/.dotfile/config/ssh.config' >> "$HOME/.ssh/config" 2>/dev/null \
		&& echo "Added Include to $HOME/.ssh/config" \
		|| echo "Failed to add Include (missing .ssh directory?)"
fi

echo "Symlinks setup complete."
