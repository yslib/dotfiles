#!/bin/bash
set -e
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
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi

echo "🍺 Installing packages with Homebrew..."
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
brew bundle --file=./Brewfile --verbose

echo "Installing Mise..."
curl https://mise.run | sh

echo "Running Mise setup..."
eval "$(~/.local/bin/mise activate bash)"
mise run setup
