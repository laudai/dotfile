@echo off
echo This script can set hardlink to your VSCode settings.json, keybindings.json etc on your Windows OS.
echo.

echo Check User\AppData\Roaming\Code\User path if exist?
IF exist %AppData%\Code\User (echo Yes!) ELSE (echo oh no QAQ)
echo.

echo Check User\Documents\dotfile path if exist?
IF exist %USERPROFILE%\Documents\dotfile (echo Yes!) ELSE (echo oh no QAQ)
echo.
IF exist %USERPROFILE%\Documents\dotfile (
::MKLINK [[/D] | [/H] | [/J]] Link Target
    rem Use Symbolic link to link file
    :: Windows下硬連結、軟連結和快捷方式
    :: http://www.4i4u.com/blog/windows-link-shortcut/
    mklink %AppData%\Code\User\settings.json %USERPROFILE%\Documents\dotfile\VSCode\settings.json
    mklink %AppData%\Code\User\keybindings.json %USERPROFILE%\Documents\dotfile\VSCode\keybindings.json
    mklink %AppData%\Code\User\snippets\python.json %USERPROFILE%\Documents\dotfile\VSCode\python.json
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

    echo.
    echo Set hardlink ^& install extension completed!
    rem use timeout /t 10 or pause to wait user press any key.
    pause
) ELSE (
    echo Please donwload the dotfile!
    echo $ git clone https://github.com/laudai/dotfile.git %USERPROFILE%\Documents\dotfile
    pause
    )
