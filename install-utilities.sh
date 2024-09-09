# TODO, remember install the apt package if need

# install cross-shell prompt starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
mkdir -p ~/.config
echo
echo "Download Nerd Fonts from web for starship:"
echo "https://www.nerdfonts.com/font-downloads"
echo

# install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm

# install oh-my-zsh framework
# modify the original install script to non-interactive way
#sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh | bash

# install homebrew for MacOS
[[ "$OSTYPE" == "darwin"* ]] && ! which brew >/dev/null && /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# for mac
if [[ "$OSTYPE" == "darwin"* ]]; then
	if which brew >/dev/null ; then
		# setup font
		brew tap homebrew/cask-fonts && brew install --cask font-caskaydia-cove-nerd-font font-fira-code font-cascadia-code
		brew install glances htop autojump mos gawk cloc tmux
		brew install --cask easy-move-plus-resize # similar or alternative to move window in the Gnome way
		brew install --cask background-music # not work in M1 MacOS
		brew install --cask rectangle # open source window manager in MacOS
		brew install --cask flameshot # cross platform screeshot tools
		brew install --cask karabiner-elements
		# if OS is MacOS
		ln -sf ~/.dotfile/laudai.karabiner_bash_emacs.json ~/.config/karabiner/assets/complex_modifications/bash_emacs.json
	else
		echo "Didn't find brew package management. Please restinall and running it again."
	fi
else
	echo "Not MacOS, skip it."
fi
