# install oh-my-zsh framework
sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"

# install cross-shell prompt starship
sh -c "$(curl -fsSL https://starship.rs/install.sh)"
mkdir -p ~/.config
echo "Download Nerd Fonts from web for starship:"
echo "https://www.nerdfonts.com/font-downloads"
echo

# install TPM (Tmux Plugin Manager)
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
