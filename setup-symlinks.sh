# Dotfiles symlinks
ln -fs ~/.dotfile/laudai.zshrc ~/.zshrc
ln -s ~/.dotfile/laudai.vimrc ~/.vimrc
ln -s ~/.dotfile/laudai.tmux.conf ~/.tmux.conf
ln -s ~/.dotfile/laudai.gitconfig ~/.gitconfig
ln -s ~/.dotfile/laudai.gitignore_global ~/.gitignore_global
ln -s ~/.dotfile/laudai.starship.toml ~/.config/starship.toml
sudo ln -s ~/.dotfile/workspace.sh /usr/local/bin/workspace

# initalize zsh settings
source ~/.zshrc
