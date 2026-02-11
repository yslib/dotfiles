#!/bin/bash
set -e
echo "🚀 Starting Bootstrap..."
if [[ "$OSTYPE" == "darwin"* ]]; then
    echo "🍎 On macOS, Installing Homebrew..."
else
    echo "🐧 On Linux, Installing Homebrew..."
fi

mkdir -p "$HOME/.local/bin"
mkdir -p "$HOME/.config"

if [ -f "/home/linuxbrew/.linuxbrew/bin/brew" ]; then
    echo "✅ Homebrew already exists, skip installation."
else 
    echo "Installing Homebrew..."
    export NONINTERACTIVE=1
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🍺 Installing packages with Homebrew..."
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew bundle --file=./Brewfile --verbose

echo "Installing Mise..."
curl https://mise.run | MISE_INSTALL_PATH=$HOME/.local/bin/mise sh

if [ -f "$HOME/.local/bin/mise" ]; then
    echo "✅ Mise already exists, skip installation."
fi

echo "Running Mise setup..."
eval "$(~/.local/bin/mise activate bash)"
mise trust
mise run setup
mise run link_config
