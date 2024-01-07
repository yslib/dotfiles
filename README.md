![Feature](img/feature.png)
# Dotfiles
---

My development enviroment configruations on Windows, Linux and macOS.

# Setup Arch Linux

Skip this section if you don't you arch linux

### Create User

Add a sudo group: groupadd sudo

Enable sudoers: nano /etc/sudoers and uncomment lines %wheel ALL=(ALL) NOPASSWD: ALL and %sudo   ALL=(ALL) ALL

Add new admin user: useradd -m -G wheel,sudo -s /bin/zsh <username>, use -s /bin/bash if you want bash instead of zsh.

Set password for the new user: passwd <username>

>If you use WSL:
>Run Windows command shell, go to the directory with Arch Linux, run Arch.exe config --default-user <username>. Now you have basic ArchLinux with user.

### Install AUR Helper

Please refer [this article](https://www.tecmint.com/install-yay-aur-helper-in-arch-linux-and-manjaro/)


## Bootstrap

Some bootstraps need to be done before using these dotfiles.

- AUR
- Vim plug
- Zsh & Oh-My-Zsh and its plugins

Run the corresponding scripts in the repository.

### Caveat:
> The following shell sciprts is only for my personal use, it could *DELETE* your configruations without any backups. You must need to aware what you are doing before run these scripts.

## 1.Terminal and Shell

### Alacritty (Windows, macOS and Linux)
[Alacritty](https://github.com/alacritty/alacritty) is an excellent cross-platform terminal. It could work on all three platforms very well.

You can install alacritty using any available package manager you like.

On windows, [scoop]() is recommonded.

### Oh-My-Zsh

```sh
sudo pacman -S zsh
chsh -s /bin/zsh
sh ./initOhMyZsh.sh

```

### Tmux

```sh
sudo pacman -S tmux
ln -si $PWD/home/.config/.tmux.conf ~/.tmux.conf
```

[Solve](https://gist.github.com/andersevenrud/015e61af2fd264371032763d4ed965b6) the problem that colortheme is wrong when open vim/neovim in tmux using Alacritty.


## 2. Editor

### Neovim (Windows, macOS and Linux)

Currently, [vim-plug](https://github.com/junegunn/vim-plug) is used to manage my neovim plugins, though most of configure files are written in lua. So this plugin must be installed first.


```sh
sh ./initNeovim.sh
```

Some neovim plugins need their own dependencies, such as *npm*. Install by yourself if corresponding errors occurs.

On windows, you can install [VimPlug](https://github.com/junegunn/vim-plug) and make symbol link mannually.

```ps
iwr -useb https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim |`
    ni "$(@($env:XDG_DATA_HOME, $env:LOCALAPPDATA)[$null -eq $env:XDG_DATA_HOME])/nvim-data/site/autoload/plug.vim" -Force
```


## 3. CVS and Tools
### Delta

using [delta](https://github.com/dandavison/delta) as the diff tool


### Lazygit

```
sudo pacman -S lazygit
ln -si $PWD/.config/lazygit ~/.config/
```

## 4. Tiling Window Manager

### Awesome (Linux)

I use [awesome-git]() verion

```sh
yay -S awesome-git
ln -si ${PWD}/home/.config/awesome ~/.config/awesome
```

I use a modifiction of [Yoru](https://github.com/rxyhn/yoru).

It need the Material Icon font in ```assets/font/MaterialIcon```

### Yabai (macOS)

I use the combination ```Yabai```, ```skhd``` and ```SketchyBar```

For more detail please references their repositories.

dotfile:
```sh
{HOME}/.config/yabai
{HOME}/.config/skhd
{HOME}/.config/sketchybar
```

I copy most of configurations from [FelixKratz](https://github.com/FelixKratz), who is the author of ```SketcyBar```.

---
# Assets

There are some optional dependencies that could improve your using experiences. Such as font and icon.

### Fonts

[Hack Nerd Font](https://github.com/ryanoasis/nerd-fonts#option-4-homebrew-fonts) is required.

Install on macOS:

```sh
brew tap homebrew/cask-fonts
brew install --cask font-hack-nerd-font
```

### sf-symbols

This is a system icon framework for macOS.

```sh
brew install --cask sy-symbols
```

On Windows:

The original Hack Nerd Font works not very well on Windows Terminal. If you use Windows Terminal, you can use a patched version of nerd font.
