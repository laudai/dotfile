# LauDai dotfile config

**_Author : LauDai_**

Personal dotfiles for macOS and Linux, managed via symlinks.

## Setup

New machine setup order:

```bash
# 1. Install packages, utilities, and create symlinks
./scripts/pkg-mgr.sh --install

# 2. Create symlinks for all config files
./scripts/setup-symlinks.sh

# 3. Install oh-my-zsh custom plugins
./scripts/install-ZSH-Plugins.sh

# 4. Restore host-level secrets from Bitwarden → ~/.env
./scripts/sync-env.sh

# 5. (Optional) Install VSCode settings and extensions
./scripts/setup-vscode.sh

# 6. Open a new terminal session to load ~/.env
```

**`~/.env` setup** (first time only, before running `sync-env.sh`):
- Create a Bitwarden Secure Note named `host-env`
- Contents should match `host.env.example`
- Run `bw login` then `./scripts/sync-env.sh`

---

## Structure

```
.dotfile/
├── config/              # All config files (symlinked to ~/)
│   ├── zsh/             # zshrc, aliases, functions (split by OS)
│   ├── ghostty          # Ghostty terminal config
│   ├── tmux.conf
│   ├── vimrc
│   ├── gitconfig
│   ├── gitignore_global
│   ├── starship.toml    # Starship prompt config
│   ├── ssh.config       # SSH settings (included via ~/.ssh/config)
│   ├── pet.config.toml  # pet snippet manager
│   ├── i3.config        # i3 window manager (Linux)
│   ├── polybar.config.ini
│   ├── conky.conf
│   └── karabiner_bash_emacs.json  # Karabiner (macOS)
├── VSCode/              # settings.json, keybindings, snippets
├── scripts/             # Setup and utility scripts
│   ├── pkg-mgr.sh      # Cross-platform package installer (brew/apt)
│   ├── pkg-mgr.lists.sh # Package lists (edit this, not pkg-mgr.sh)
│   ├── setup-symlinks.sh # Create all dotfile symlinks
│   ├── install-ZSH-Plugins.sh # Clone oh-my-zsh custom plugins
│   ├── sync-env.sh     # Pull secrets from Bitwarden → ~/.env
│   ├── setup-vscode.sh # Install VSCode settings + extensions
│   ├── ssh/             # SSH helpers (date-match, SSM proxy)
│   ├── tmux/            # Tmux status bar scripts
│   └── i3/              # i3 WM automation scripts (Linux)
├── bin/                 # Custom executables (added to PATH)
│   ├── masscode2pet     # Sync massCode snippets to pet
│   ├── pkg-lookup       # Check package availability across managers
│   ├── whatismyip       # Show IP and VPN status
│   └── workspace        # Create pre-configured tmux workspace
├── completions/         # Shell completions (bash/zsh)
├── Layout/              # Window manager layouts (Amethyst macOS)
├── docs/                # Reference documentation
│   ├── vimrc-reference.md
│   └── tmux-reference.md
├── archive/             # Legacy/unused configs
└── screenshot/          # Screenshots
```

---

## Tools & Themes

| Tool | Theme/Style | Config |
|------|-------------|--------|
| Ghostty | Material Design Colors | `config/ghostty` |
| tmux (tmux2k) | Catppuccin, icons-only | `config/tmux.conf` |
| Vim | material.vim (default variant) | `config/vimrc` |
| VSCode | Bearded Theme Oceanic | `VSCode/settings.json` |
| Zsh | oh-my-zsh (prompt overridden by Starship) | `config/zsh/zshrc` |
| Prompt | Starship | `config/starship.toml` |

---

## Documentation

- [Vim keybindings & settings reference](docs/vimrc-reference.md)
- [Tmux keybindings & settings reference](docs/tmux-reference.md)

---

## Scripts

| Script | Description |
|--------|-------------|
| `pkg-mgr.sh` | Cross-platform package installer. Detects OS, supports `--install`, `--check-apt`, `--check-brew`. Default is dry-run. |
| `pkg-mgr.lists.sh` | Package lists sourced by pkg-mgr.sh. Edit this file to add/remove packages. |
| `setup-symlinks.sh` | Creates symlinks: ~/.zshrc, ~/.vimrc, ~/.tmux.conf, ~/.gitconfig, ~/.ssh/config (Include), ghostty, starship, etc. OS-specific: karabiner (macOS), i3/polybar/conky (Linux). |
| `install-ZSH-Plugins.sh` | Clones oh-my-zsh custom plugins (zsh-autosuggestions, zsh-syntax-highlighting, git-open, zsh-nvm, etc.) |
| `sync-env.sh` | Pulls host-level secrets from Bitwarden Secure Note → ~/.env |
| `setup-vscode.sh` | Copies VSCode settings/keybindings and batch-installs extensions |

---

## Key Config Notes

### Tmux

- Prefix: `Ctrl-a`
- Status bar: tmux2k plugin (catppuccin theme, icons-only mode)
- Plugins: tpm, tmux-yank, tmux-urlview, tmux-resurrect, tmux-open, tmux2k
- Requires: bash 5.x+ (for tmux2k associative arrays)

### Vim

- Colorscheme: material.vim (`default` variant, blue-gray background)
- Airline: material theme with powerline fonts
- Completion: coc.nvim (LSP-based)
- Leader key: `<Space>`
- Requires: vim with `+clipboard` (macOS built-in works, Linux needs `vim-gtk3`)

### Zsh

- Framework: oh-my-zsh
- Key plugins: zsh-autosuggestions, zsh-syntax-highlighting, vi-mode, fzf, zoxide
- Functions split into: `functions.zsh`, `functions-macos.zsh`, `functions-linux.zsh`
- Aliases: `aliases.zsh`

### Terminal

- macOS: Ghostty (Material Design Colors)
- Font: Nerd Font (required for powerline symbols in tmux/vim/starship)

---

## Requirements

### General

- `zsh`, `git`, `curl`, `vim` (with `+clipboard`), `tmux` (3.2+)
- bash 5.x+ (for tmux2k plugin)
- A [Nerd Font](https://www.nerdfonts.com/) installed and set in terminal

### Linux-specific

- `vim-gtk3` for clipboard support
- `xsel` or `xclip` for tmux-yank
- `urlview` for tmux-urlview

### macOS-specific

- Homebrew
- `brew install bash` (macOS ships bash 3.2, tmux2k needs 5.x+)

---

## Caps Lock → Ctrl

Remap Caps Lock to Ctrl for easier prefix/modifier access:

- **macOS**: System Preferences → Keyboard → Modifier Keys → Caps Lock → Control
- **Linux (GNOME)**: gnome-tweaks → Keyboard → Additional Layout Options → Ctrl position
- **Linux (console)**: Add `ctrl:nocaps` to `XKBOPTIONS` in `/etc/default/keyboard`
