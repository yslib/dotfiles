#!/bin/bash
export http_proxy=http://127.0.0.1:7897
export https_proxy=http://127.0.0.1:7897
sh -c 'curl -fLo "${XDG_DATA_HOME:-$HOME/.local/share}"/nvim/site/autoload/plug.vim --create-dirs \
       https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim'

export NVIM_BOOTSTRAP=1    # avoid require plugin when neovim start, see the definition in init.vim
# -c "PlugInstall --sync"
# -c "messages"
# -c "qa"

npm install -g tree-sitter-cli
nvim --headless -c "PlugInstall --sync" -c "messages" -c "qa"
