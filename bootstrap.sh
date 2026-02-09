#!/bin/bash
set -e

export MISE_INSTALL_PATH="$HOME/.local/bin/mise"

if [ ! -f "$MISE_INSTALL_PATH" ]; then
    curl https://mise.jdx.dev/mise-latest-linux-x64-musl > "$MISE_INSTALL_PATH"
    chmod +x "$MISE_INSTALL_PATH"
fi

export PATH="$HOME/.local/bin:$PATH"

export MISE_ENV=linux

eval "$(mise activate bash)"

echo "🔧 Bootstrap complete. MISE is installed and activated."

mise run setup
