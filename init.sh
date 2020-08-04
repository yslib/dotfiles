
#!/bin/bash
# create soft symbol link for dotfile

ln -si ${PWD}/home/.xprofile ~/.xprofile

ln -si ${PWD}/home/.zshrc ~/.zshrc

ln -si ${PWD}/home/.tmux.conf ~/.tmux.conf

rm -rf ~/.SpaceVim.d && ln -sfi ${PWD}/home/.SpaceVim.d ~/.SpaceVim.d
