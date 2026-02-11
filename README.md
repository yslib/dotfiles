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
git clone https://github.com/yslib/dotfiles.git; cd dotfiles; powershell -ExecutionPolicy Bypass -File .\bootstrap.ps1
```

`bootstrap.ps1` installs Scoop + Git for Windows, then hands off to `bootstrap.sh` running in Git Bash.
The same bash scripts handle everything — only the config paths differ on Windows.

### What happens

1. **Scoop + Git** are installed by `bootstrap.ps1`
2. **Packages** from `Scoopfile.json` are installed via `scoop import` (neovim, lazygit, ripgrep, fzf, yazi, delta, etc.)
3. **Symlinks** are created by `link_config.sh` using `mklink` (Windows-native symlinks that native apps can follow)
4. **Neovim plugins** are bootstrapped by `setup_nvim_plugin.sh` (vim-plug + PlugInstall)

### Windows config path mapping

| Config | Linux/macOS | Windows |
|--------|-------------|---------|
| nvim | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| yazi | `~/.config/yazi` | `%APPDATA%\yazi\config` |
| lazygit | `~/.config/lazygit` | `%LOCALAPPDATA%\lazygit` |
| alacritty | `~/.config/alacritty` | `%APPDATA%\alacritty` |
| gitconfig | `~/.gitconfig` | `%USERPROFILE%\.gitconfig` |
