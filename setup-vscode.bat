@echo off
echo This script can set hardlink to your VSCode settings.json, keybindings.json etc on your Windows OS.
echo.

echo Check User/Documents/dotfile path if exist?
IF exist %USERPROFILE%\Documents\dotfile (echo Yes!) ELSE (echo oh no QAQ)
echo.
IF exist %USERPROFILE%\Documents\dotfiles (
::MKLINK [[/D] | [/H] | [/J]] Link Target
    mklink /H %AppData%\Code\User\settings.json %USERPROFILE%\Documents\dotfile\VSCode\settings.json
    mklink /H %AppData%\Code\User\keybindings.json %USERPROFILE%\Documents\dotfile\VSCode\keybindings.json
    mklink /H %AppData%\Code\User\snippets\python.json %USERPROFILE%\Documents\dotfile\VSCode\python.json
    code --install-extension ms-python.python
    code --install-extension tht13.python
    code --install-extension ms-ceintl.vscode-language-pack-zh-hant
    code --install-extension visualstudioexptteam.vscodeintellicode
    code --install-extension formulahendry.code-runner
    code --install-extension mdickin.markdown-shortcuts
    code --install-extension yzhang.markdown-all-in-one
    code --install-extension coenraads.bracket-pair-colorizer-2
    code --install-extension vscodevim.vim
    code --install-extension DavidAnson.vscode-markdownlint
    code --install-extension shd101wyy.markdown-preview-enhanced
    code --install-extension formulahendry.auto-rename-tag
    code --install-extension aaron-bond.better-comments
    code --install-extension alefragnani.bookmarks
    code --install-extension github.vscode-pull-request-github
    code --install-extension eamodio.gitlens
    code --install-extension ritwickdey.liveserver
    code --install-extension patbenatar.advanced-new-file
    code --install-extension equinusocio.vsc-material-theme
    code --install-extension pkief.material-icon-theme
    code --install-extension ms-vscode-remote.remote-ssh
    code --install-extension esbenp.prettier-vscode

    echo.
    echo Set hardlink ^& install extension completed!
    rem use timeout /t 10 or pause to wait user press any key.
    pause
) ELSE (
    echo Please donwload the dotfile!
    echo $ git clone https://github.com/laudai/dotfile.git %USERPROFILE%\Documents\dotfile
    pause
    )