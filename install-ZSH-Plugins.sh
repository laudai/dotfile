# Install Zsh Plugins

# autojump
git clone git://github.com/wting/autojump.git && cd autojump
./install.py
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#  zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh-navigation-tools
sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zsh-navigation-tools/master/doc/install.sh)"
