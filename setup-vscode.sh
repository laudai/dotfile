# Visual Studio Code
ln -s ~/.dotfile/VSCode/keybindings.json ~/.config/Code/User/keybindings.json
ln -s ~/.dotfile/VSCode/settings.json ~/.config/Code/User/settings.json
if [ ! -d ~/.config/Code/User/snippets ]; then
	mkdir -p ~/.config/Code/User/snippets;
fi
ln -s ~/.dotfile/VSCode/python.json ~/.config/Code/User/snippets/python.json

code --install-extension ms-python.python  --force
code --install-extension tht13.python  --force
code --install-extension ms-ceintl.vscode-language-pack-zh-hant  --force
code --install-extension visualstudioexptteam.vscodeintellicode  --force
code --install-extension formulahendry.code-runner  --force
code --install-extension mdickin.markdown-shortcuts  --force
code --install-extension yzhang.markdown-all-in-one  --force
code --install-extension coenraads.bracket-pair-colorizer-2  --force
code --install-extension vscodevim.vim  --force
code --install-extension DavidAnson.vscode-markdownlint  --force
code --install-extension shd101wyy.markdown-preview-enhanced  --force
code --install-extension formulahendry.auto-rename-tag  --force
code --install-extension aaron-bond.better-comments  --force
code --install-extension alefragnani.bookmarks  --force
code --install-extension github.vscode-pull-request-github  --force
code --install-extension eamodio.gitlens  --force
code --install-extension ritwickdey.liveserver  --force
code --install-extension patbenatar.advanced-new-file  --force
code --install-extension equinusocio.vsc-material-theme  --force
code --install-extension pkief.material-icon-theme  --force
code --install-extension ms-vscode-remote.remote-ssh  --force
code --install-extension esbenp.prettier-vscode  --force
code --install-extension pnp.polacode  --force
code --install-extension techer.open-in-browser  --force
code --install-extension vscode-icons-team.vscode-icons  --force
code --install-extension mikestead.dotenv  --force
code --install-extension wayou.vscode-todo-highlight  --force
code --install-extension editorconfig.editorconfig  --force
code --install-extension shan.code-settings-sync  --force
code --install-extension hoovercj.vscode-settings-cycler --force
code --install-extension gruntfuggly.todo-tree --force
code --install-extension spywhere.guides --force
code --install-extension mhutchie.git-graph --force
code --install-extension donjayamanne.githistory --force
