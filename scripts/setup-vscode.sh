# Visual Studio Code

# default path by different os
VSCODE_PATH="$HOME/.dotfile/VSCode"
VSCODE_LINUX_PATH="$HOME/.config/Code/User"
VSCODE_MAC_PATH="$HOME/Library/Application Support/Code/User"
INSTALL_EXTENSIONS_MOTD="
Now start to install the VSCode extensions.
Will insall all VSCode extensions forcibly in the array in this script.
"

# MacOS high CPU cluprit
# https://github.com/shanalikhan/code-settings-sync
# https://code.visualstudio.com/docs/editor/settings-sync
declare -a vscode_extensions=(
    # --- Python ---
    "ms-python.python"
    "charliermarsh.ruff"
    "ms-toolsai.jupyter"

    # --- Markdown ---
    "yzhang.markdown-all-in-one"
    "DavidAnson.vscode-markdownlint"
    "shd101wyy.markdown-preview-enhanced"

    # --- Git ---
    "eamodio.gitlens"
    "mhutchie.git-graph"
    "donjayamanne.githistory"
    "github.vscode-pull-request-github"

    # --- Remote ---
    "ms-vscode-remote.remote-ssh"
    "jeanp413.open-remote-ssh"

    # --- Debug ---
    "vadimcn.vscode-lldb"
    "hediet.debug-visualizer"

    # --- Editor enhancement ---
    "vscodevim.vim"
    "aaron-bond.better-comments"
    "alefragnani.bookmarks"
    "leodevbro.blockman"
    "hoovercj.vscode-settings-cycler"
    "patbenatar.advanced-new-file"
    "formulahendry.auto-rename-tag"
    "gruntfuggly.todo-tree"

    # --- Formatter / Linter ---
    "esbenp.prettier-vscode"
    "editorconfig.editorconfig"
    "brokenbonesdd.opencclint"

    # --- Stats / Counter ---
    "j4ng5y.charactercount"
    "worisur.wordcount-cjk"
    "uctakeoff.vscode-counter"

    # --- Theme / Appearance ---
    "BeardedBear.beardedtheme"
    "pkief.material-icon-theme"
    "vscode-icons-team.vscode-icons"

    # --- Web / Preview ---
    "ritwickdey.liveserver"
    "techer.open-in-browser"
    "formulahendry.code-runner"
    "ArthurLobo.easy-codesnap"

    # --- Language / i18n ---
    "ms-ceintl.vscode-language-pack-zh-hant"
    "druideinformatique.antidote"

    # --- Config / Env ---
    "mikestead.dotenv"
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

        # extension settings
        # vim
        # To enable key-repeating, execute the following in your Terminal, log out and back in, and then restart VS Code:
        defaults write com.microsoft.VSCode ApplePressAndHoldEnabled -bool false              # For VS Code
        defaults write com.microsoft.VSCodeInsiders ApplePressAndHoldEnabled -bool false      # For VS Code Insider
        defaults write com.visualstudio.code.oss ApplePressAndHoldEnabled -bool false         # For VS Codium
        defaults write com.microsoft.VSCodeExploration ApplePressAndHoldEnabled -bool false   # For VS Codium Exploration users
        defaults delete -g ApplePressAndHoldEnabled
        echo

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
