# Visual Studio Code

# default path by different os
linux_path="$HOME/.config/Code/User"
mac_path="$HOME/Library/Application Support/Code/User"


# check the vscode was installed and set to the environment variable
which code &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "Can find code command in the environment variable."
elif [[ $? -eq 1 ]]; then
    echo "Cannot find the code command in the environment variable." >&2 && exit 1
else
    echo "Undefined error number." >&2 && exit 1
fi
echo

# set the configuration files by different os
if [[ "$OSTYPE" == "linux-gnu"* ]]; then
    # keybindings and settings
    base_path="$linux_path"
    ln -sf ~/.dotfile/VSCode/keybindings.json "$base_path/keybindings.json"
    ln -sf ~/.dotfile/VSCode/settings.json "$base_path/settings.json"

    # snippets
    [[ ! -d "$base_path/snippets" ]] && mkdir -p "$base_path/snippets"
    ln -sf ~/.dotfile/VSCode/python.json "$base_path/snippets/phthon.json"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    base_path="$mac_path"
    ln -sf ~/.dotfile/VSCode/keybindings.json "$base_path/keybindings.json"
    ln -sf ~/.dotfile/VSCode/settings.json "$base_path/settings.json"

    # snippets
    [[ ! -d "$base_path/snippets" ]] && mkdir -p "$base_path/snippets"
    ln -sf ~/.dotfile/VSCode/python.json "$base_path/snippets/phthon.json"

else
    echo "Can not match any OSTYPE variable name." >&2 && exit 1
fi

code --install-extension ms-python.python  --force
code --install-extension tht13.python  --force
code --install-extension ms-ceintl.vscode-language-pack-zh-hant  --force
code --install-extension visualstudioexptteam.vscodeintellicode  --force
code --install-extension formulahendry.code-runner  --force
code --install-extension mdickin.markdown-shortcuts  --force
code --install-extension yzhang.markdown-all-in-one  --force
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
code --install-extension editorconfig.editorconfig  --force
code --install-extension shan.code-settings-sync  --force
code --install-extension hoovercj.vscode-settings-cycler --force
code --install-extension gruntfuggly.todo-tree --force
code --install-extension spywhere.guides --force
code --install-extension mhutchie.git-graph --force
code --install-extension donjayamanne.githistory --force
code --install-extension leodevbro.blockman --force
