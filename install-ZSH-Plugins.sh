#!/usr/bin/env zsh
# =============================================================================
# install-ZSH-Plugins.sh — Install oh-my-zsh custom plugins
#
# Usage:
#   ./install-ZSH-Plugins.sh
#   zsh install-ZSH-Plugins.sh
# =============================================================================

ZSH_CUSTOM="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}"

plugins=(
	"zsh-users/zsh-autosuggestions"
	"zsh-users/zsh-syntax-highlighting"
	"paulirish/git-open"
	"zsh-users/zsh-history-substring-search"
	"lukechilds/zsh-nvm"
)

for repo in "${plugins[@]}"; do
	name="${repo##*/}"
	dest="$ZSH_CUSTOM/plugins/$name"
	if [[ -d "$dest" ]]; then
		echo "✓ $name already installed, skipping"
	else
		echo "Installing $name..."
		git clone "https://github.com/$repo.git" "$dest"
	fi
done

# zsh-navigation-tools (separate installer)
if [[ -d "$HOME/.config/znt" ]]; then
	echo "✓ zsh-navigation-tools already installed, skipping"
else
	echo "Installing zsh-navigation-tools..."
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zsh-navigation-tools/master/doc/install.sh)"
fi

echo "ZSH plugins setup complete."
