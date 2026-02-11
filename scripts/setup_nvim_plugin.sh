#!/bin/bash
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

export NVIM_BOOTSTRAP=1    # avoid require plugin when neovim start, see the definition in init.vim
# -c "PlugInstall --sync"
# -c "messages"
# -c "qa"

npm install -g tree-sitter-cli@0.24     #0.24 is the compatible version for glibc 2.35 which is for ubuntu 22.04 LTS
# another way is to build from source by cargo
nvim --headless -c "PlugInstall --sync" -c "messages" -c "qa"
