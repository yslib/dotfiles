My development environment configurations on Windows, Linux and macOS.

## Linux / macOS

### Prerequisites

- git, curl, bash, unzip, tar, make
- A C compiler (e.g., gcc, clang)

### Usage

```sh
curl -fsSL https://raw.githubusercontent.com/yslib/dotfiles/master/bootstrap.sh | bash
```

### Minimal Vim only

For low-end servers, install only the plugin-free Vim config:

```sh
mkdir -p ~/.config/vim && curl -fsSL https://raw.githubusercontent.com/yslib/dotfiles/master/home/.config/vim/vimrc -o ~/.config/vim/vimrc && ln -sf ~/.config/vim/vimrc ~/.vimrc
```

Or clone manually:

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
3. Clone this repo to `./dotfiles` (current directory)
4. Hand off to `bootstrap.sh` running in Git Bash for package installation
5. Create **native NTFS symlinks** for config files (PowerShell, with admin token)

### Windows config path mapping

| Config | Linux/macOS | Windows |
|--------|-------------|---------|
| nvim | `~/.config/nvim` | `%LOCALAPPDATA%\nvim` |
| vim | `~/.config/vim/vimrc` + `~/.vimrc` | `%USERPROFILE%\_vimrc` |
| yazi | `~/.config/yazi` | `%APPDATA%\yazi\config` |
| lazygit | `~/.config/lazygit` | `%LOCALAPPDATA%\lazygit` |
| alacritty | `~/.config/alacritty` | `%APPDATA%\alacritty` |
| gitconfig | `~/.gitconfig` | `%USERPROFILE%\.gitconfig` |
| PowerShell profile | — | `<Documents>\PowerShell\profile.ps1` |
| Windows Terminal | — | Auto-detected (Stable/Preview/Canary, Store or Scoop) |
