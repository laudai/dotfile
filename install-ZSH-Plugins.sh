# Install Zsh Plugins

# autojump
git clone git://github.com/wting/autojump.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autojump
cd ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/autojump
python3 ./install.py
# zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
#  zsh-syntax-highlighting
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
# zsh-navigation-tools
sh -c "$(curl -fsSL https://raw.githubusercontent.com/psprint/zsh-navigation-tools/master/doc/install.sh)"
# git-open
git clone https://github.com/paulirish/git-open.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/git-open
# zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-history-substring-search ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-history-substring-search
