#!/bin/bash
set -e

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* || "$OSTYPE" == "cygwin" ]]
}

echo "🚀 Starting Bootstrap..."

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"

if is_windows; then
    echo "🪟 On Windows (Git Bash), using Scoop..."

    # Scoop should already be installed by bootstrap.ps1, but verify
    if ! command -v scoop &>/dev/null; then
        echo "⚠️  Scoop not found. Please run bootstrap.ps1 first, or install scoop manually."
        exit 1
    fi

    # Add required buckets (idempotent — scoop ignores duplicates)
    scoop bucket add extras 2>/dev/null || true
    scoop bucket add nerd-fonts 2>/dev/null || true

    echo "🍺 Installing packages with Scoop..."
    scoop import "$SCRIPT_DIR/Scoopfile.json"

elif [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 On macOS, Installing Homebrew..."
    if command -v brew &>/dev/null; then
        echo "✅ Homebrew already exists, skip installation."
    else
        export NONINTERACTIVE=1
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(brew shellenv)"
    echo "🍺 Installing packages with Homebrew..."
    brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose

else
    echo "🐧 On Linux, Installing Homebrew..."
    if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
        echo "✅ Homebrew already exists, skip installation."
    else
        export NONINTERACTIVE=1
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    fi
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    echo "🍺 Installing packages with Homebrew..."
    brew bundle --file="$SCRIPT_DIR/Brewfile" --verbose
fi

if is_windows; then
    # On Windows, skip mise/zsh — run nvim setup only
    # Symlinks are handled by bootstrap.ps1 (needs admin token)
    echo "🔌 Setting up Neovim plugins..."
    "$SCRIPT_DIR/scripts/setup_nvim_plugin.sh"

    echo ""
    echo "✅ Package installation complete!"
else
    echo "Installing Mise..."
    if [ -f "$HOME/.local/bin/mise" ]; then
        echo "✅ Mise already exists, skip installation."
    else
        curl https://mise.run | MISE_INSTALL_PATH=$HOME/.local/bin/mise sh
    fi

    echo "Running Mise setup..."
    eval "$(~/.local/bin/mise activate bash)"
    mise trust
    mise run setup
    mise run link_config
fi
