#!/bin/bash
set -e

DOTFILES_REPO="https://github.com/yslib/dotfiles.git"
DOTFILES_DIR="$(pwd)/dotfiles"

is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* || "$OSTYPE" == "cygwin" ]]
}

echo "🚀 Starting Bootstrap..."

# ── 0. Clone repo if not already inside one ─────────────────────
# If run via `curl | bash`, we're not in the repo yet — clone it.
# If run via `./bootstrap.sh` from the repo, skip cloning.
if [ -f "$(dirname "${BASH_SOURCE[0]}")/Brewfile" ]; then
    SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
    echo "📂 Running from existing repo at $SCRIPT_DIR"
else
    if [ -d "$DOTFILES_DIR/.git" ]; then
        echo "📂 Dotfiles repo already exists at $DOTFILES_DIR, pulling latest..."
        git -C "$DOTFILES_DIR" pull --rebase
    else
        echo "📥 Cloning dotfiles repo to $DOTFILES_DIR..."
        git clone "$DOTFILES_REPO" "$DOTFILES_DIR"
    fi
    SCRIPT_DIR="$DOTFILES_DIR"
fi

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"

# ── 1. Install packages ─────────────────────────────────────────
if is_windows; then
    echo "🪟 On Windows (Git Bash), using Scoop..."

    if ! command -v scoop &>/dev/null; then
        echo "⚠️  Scoop not found. Please run bootstrap.ps1 first, or install scoop manually."
        exit 1
    fi

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

# ── 2. Setup tools and link configs ─────────────────────────────
if is_windows; then
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
