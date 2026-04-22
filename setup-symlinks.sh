#!/usr/bin/env zsh
# =============================================================================
# setup-symlinks.sh — Create dotfile symlinks and OS-specific configs
#
# Usage:
#   ./setup-symlinks.sh
#   zsh setup-symlinks.sh
# =============================================================================

# --- Common dotfile symlinks ---
ln -sf "$HOME/.dotfile/laudai.zshrc" "$HOME/.zshrc"
ln -sf "$HOME/.dotfile/laudai.vimrc" "$HOME/.vimrc"
ln -sf "$HOME/.dotfile/laudai.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$HOME/.dotfile/laudai.gitconfig" "$HOME/.gitconfig"
ln -sf "$HOME/.dotfile/laudai.gitignore_global" "$HOME/.gitignore_global"
ln -sf "$HOME/.dotfile/laudai.starship.toml" "$HOME/.config/starship.toml"
ln -sf "$HOME/.dotfile/laudai.ghostty" "$HOME/.config/ghostty/config"
ln -sf "$HOME/.dotfile/laudai.pet.config.toml" "$HOME/.config/pet/config.toml"

# --- OS-specific symlinks ---
if [[ "$OSTYPE" == "darwin"* ]]; then
	mkdir -p "$HOME/.config/karabiner/assets/complex_modifications"
	ln -sf "$HOME/.dotfile/laudai.karabiner_bash_emacs.json" "$HOME/.config/karabiner/assets/complex_modifications/bash_emacs.json"

elif [[ "$OSTYPE" == "linux"* ]]; then
	ln -sf "$HOME/.dotfile/laudai.i3.config" "$HOME/.config/i3/config"
	ln -sf "$HOME/.dotfile/laudai.conky.conf" "$HOME/.config/conky/conky.conf"
	ln -sf "$HOME/.dotfile/laudai.polybar.config.ini" "$HOME/.config/polybar/config.ini"
	cp "$HOME/.dotfile/linux_script/start-conky.sh" "$HOME/.config/conky"
	mkdir -p "$HOME/.local/bin"
	ln -sf "$HOME/.dotfile/linux_script/workspace.sh" "$HOME/.local/bin/workspace"
	ln -sf "$HOME/.dotfile/linux_script/whatismyip.sh" "$HOME/.local/bin/whatismyip"
fi

# --- SSH config ---
if [[ -f "$HOME/.ssh/config" ]] && grep -q "Subject: SSH personal settings" "$HOME/.ssh/config"; then
	echo "SSH config already appended. Skipping."
else
	cat "$HOME/.dotfile/laudai.ssh.config" >> "$HOME/.ssh/config" 2>/dev/null \
		&& echo "Appended SSH config to $HOME/.ssh/config" \
		|| echo "Failed to append SSH config (missing .ssh directory?)"
fi

echo "Symlinks setup complete."
