#!/bin/bash
set -e

is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* || "$OSTYPE" == "cygwin" ]]
}

# vim-plug install path differs on Windows
if is_windows; then
    PLUG_DIR="$(cygpath "$LOCALAPPDATA")/nvim-data/site/autoload"
else
    PLUG_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/nvim/site/autoload"
fi

# 1. Install vim-plug
if [ -f "$PLUG_DIR/plug.vim" ]; then
    echo "✅ vim-plug already installed."
else
    echo "⬇️ Downloading vim-plug..."
    mkdir -p "$PLUG_DIR"
    curl -fLo "$PLUG_DIR/plug.vim" --create-dirs \
        https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
    echo "✅ vim-plug installed."
fi

# 2. Install tree-sitter-cli (needed by nvim-treesitter)
if command -v tree-sitter &>/dev/null; then
    echo "✅ tree-sitter-cli already available."
else
    echo "⬇️ Installing tree-sitter-cli via npm..."
    npm install -g tree-sitter-cli@0.24     #0.24 is the compatible version for glibc 2.35 which is for ubuntu 22.04 LTS
    # another way is to build from source by cargo
fi

# 3. Run PlugInstall headlessly
echo "🔌 Running :PlugInstall (headless)..."
export NVIM_BOOTSTRAP=1    # avoid require plugin when neovim start, see the definition in init.vim
nvim --headless -c "PlugInstall --sync" -c "messages" -c "qa"
echo "✅ Neovim plugins installed."
