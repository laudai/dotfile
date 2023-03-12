# Visual Studio Code

# default path by different os
VSCODE_PATH="$HOME/.dotfile/VSCode"
VSCODE_LINUX_PATH="$HOME/.config/Code/User"
VSCODE_MAC_PATH="$HOME/Library/Application Support/Code/User"
INSTALL_EXTENSIONS_MOTD="
Now start to install the VSCode extensions.
Will insall all VSCode extensions forcibly in the array in this script.
"

declare -a vscode_extensions=(
    "ms-python.python"
    "tht13.python"
    "ms-ceintl.vscode-language-pack-zh-hant"
    "visualstudioexptteam.vscodeintellicode"
    "formulahendry.code-runner"
    "mdickin.markdown-shortcuts"
    "yzhang.markdown-all-in-one"
    "vscodevim.vim"
    "DavidAnson.vscode-markdownlint"
    "shd101wyy.markdown-preview-enhanced"
    "formulahendry.auto-rename-tag"
    "aaron-bond.better-comments"
    "alefragnani.bookmarks"
    "github.vscode-pull-request-github"
    "eamodio.gitlens"
    "ritwickdey.liveserver"
    "patbenatar.advanced-new-file"
    "equinusocio.vsc-material-theme"
    "pkief.material-icon-theme"
    "ms-vscode-remote.remote-ssh"
    "esbenp.prettier-vscode"
    "pnp.polacode"
    "techer.open-in-browser"
    "vscode-icons-team.vscode-icons"
    "mikestead.dotenv"
    "editorconfig.editorconfig"
    "shan.code-settings-sync"
    "hoovercj.vscode-settings-cycler"
    "gruntfuggly.todo-tree"
    "spywhere.guides"
    "mhutchie.git-graph"
    "donjayamanne.githistory"
    "leodevbro.blockman"
)


function end_of_setting() {
    local os_setting_path="$1"
    echo "Set keybindings.json, settings.json, and python snippets on '$os_setting_path' successfully."
}


# check vscode path
if [[ -d "$VSCODE_PATH" ]]; then
    :
else
   echo "Cannot find the "$VSCODE_PATH", will exit this script."
   exit 1
fi


# check the vscode was installed and set to the environment variable
which code &> /dev/null
if [[ $? -eq 0 ]]; then
    echo "Can find code command in the environment variable."
elif [[ $? -eq 1 ]]; then
    echo "
    Cannot find the code command in the environment variable.
    You need to install the VSCode and add the command into the environment varible.
    " >&2 && exit 1
else
    echo "Undefined error number." >&2 && exit 1
fi
echo


# set the configuration files by different os
case "$OSTYPE" in
    "linux-gnu"*)
        # keybindings and settings
        BASE_PATH="$VSCODE_LINUX_PATH"
        ln -sf "$VSCODE_PATH/keybindings.json" "$BASE_PATH/keybindings.json"
        ln -sf "$VSCODE_PATH/settings.json" "$BASE_PATH/settings.json"

        # snippets
        [[ ! -d "$BASE_PATH/snippets" ]] && mkdir -p "$BASE_PATH/snippets"
        ln -sf "$VSCODE_PATH/python.json" "$BASE_PATH/snippets/phthon.json"

        end_of_setting "$BASE_PATH"
        ;;
    "darwin"*)
        BASE_PATH="$VSCODE_MAC_PATH"
        ln -sf "$VSCODE_PATH/keybindings.json" "$BASE_PATH/keybindings.json"
        ln -sf "$VSCODE_PATH/settings.json" "$BASE_PATH/settings.json"

        # snippets
        [[ ! -d "$BASE_PATH/snippets" ]] && mkdir -p "$BASE_PATH/snippets"
        ln -sf "$VSCODE_PATH/python.json" "$BASE_PATH/snippets/phthon.json"

        end_of_setting "$BASE_PATH"
        ;;
    *)
        echo "Can not match any OSTYPE variable name." >&2
        exit 1
        ;;
esac

echo "$INSTALL_EXTENSIONS_MOTD"
for extension in "${vscode_extensions[@]}"
do
    code --install-extension "$extension" --force
done
