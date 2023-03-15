# Dotfiles symlinks
ln -sf ~/.dotfile/laudai.zshrc ~/.zshrc
ln -sf ~/.dotfile/laudai.vimrc ~/.vimrc
ln -sf ~/.dotfile/laudai.tmux.conf ~/.tmux.conf
ln -sf ~/.dotfile/laudai.gitconfig ~/.gitconfig
ln -sf ~/.dotfile/laudai.gitignore_global ~/.gitignore_global
ln -sf ~/.dotfile/laudai.starship.toml ~/.config/starship.toml
sudo ln -sf ~/.dotfile/linux_script/workspace.sh /usr/local/bin/workspace
sudo ln -sf ~/.dotfile/linux_script/whatismyip.sh /usr/local/bin/whatismyip

# setup the personal user ssh config
if [[ $(grep "Subject: SSH personal settings" "$HOME/.ssh/config") ]]; then
    echo "Pass for checking append the ssh config. You already added it."
else
    cat "$HOME/.dotfile/laudai.ssh.config" >> "$HOME/.ssh/config" &> /dev/null && echo "Append the ssh confg to $HOME/.ssh/config successfully" || echo "Something exception happend."
fi

# initalize zsh settings
source ~/.zshrc
