# Dotfiles
ln -s ~/.dotfile/laudai.zshrc ~/.zshrc
ln -s ~/.dotfile/laudai.vimrc ~/.vimrc
ln -s ~/.dotfile/laudai.tmux.conf ~/.tmux.conf
ln -s ~/.dotfile/laudai.gitconfig ~/.gitconfig
ln -s ~/.dotfile/laudai.gitignore_global ~/.gitignore_global
sudo ln -s ~/.dotfile/workspace.sh /usr/local/bin/workspace

# initalize zsh settings
source ~/.zshrc
