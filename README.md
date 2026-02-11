My development environment configurations on Windows, Linux and macOS.

## Linux / macOS

### Prerequisites

- git, curl, bash, unzip, tar, make
- A C compiler (e.g., gcc, clang)

### Usage

```sh
git clone https://github.com/yslib/dotfiles.git && cd dotfiles && ./bootstrap.sh
```

## Windows

### Usage

No prerequisites needed. Run in PowerShell:

```powershell
irm https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.ps1 | iex
```

This single command will:

1. Install **Scoop** (package manager)
2. Install **Git for Windows** via Scoop (provides bash)
3. Clone this repo to `~/dotfiles`
4. Hand off to `bootstrap.sh` running in Git Bash — the same bash scripts handle the rest

From there `bootstrap.sh` detects Windows (MSYS/MINGW) and:

1. Installs packages from `Scoopfile.json` via `scoop import`
2. Creates **native NTFS symlinks** (`mklink`) for config files
3. Bootstraps Neovim plugins (vim-plug + PlugInstall)

### Windows config path mapping

| Config | Linux/macOS | Windows |
|--------|-------------|---------|
| nvim | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| yazi | `~/.config/yazi` | `%APPDATA%\yazi\config` |
| lazygit | `~/.config/lazygit` | `%LOCALAPPDATA%\lazygit` |
| alacritty | `~/.config/alacritty` | `%APPDATA%\alacritty` |
| gitconfig | `~/.gitconfig` | `%USERPROFILE%\.gitconfig` |
