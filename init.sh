
#!/bin/bash
# create soft symbol link for dotfile
ln -si ${PWD}/home/.xprofile ~/.xprofile
ln -si ${PWD}/home/.zshrc ~/.zshrc
ln -si ${PWD}/home/.tmux.conf ~/.tmux.conf
rm -rf ~/.config/alacritty && ln -sfi ${PWD}/home/.config/alacritty ~/.config/alacritty
rm -rf ~/.config/ranger && ln -sfi ${PWD}/home/.config/ranger ~/.config/ranger
