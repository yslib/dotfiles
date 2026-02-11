#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_HOME="$SCRIPT_DIR/../home"

echo "🔗 Linking configuration files from $CONFIG_HOME to $HOME"

ln -sf "$CONFIG_HOME/.config/nvim" "$HOME/.config/nvim"
ln -sf "$CONFIG_HOME/.config/yazin" "$HOME/.config/yazi"
ln -sf "$CONFIG_HOME/.config/lazygit" "$HOME/.config/lazygit"
ln -sf "$CONFIG_HOME/.config/.gitconfig" "$HOME/.gitconfig"
ln -sf "$CONFIG_HOME/.zshrc" "$HOME/.zshrc"
ln -sf "$CONFIG_HOME/.tmux.conf" "$HOME/.tmux.conf"
ln -sf "$CONFIG_HOME/.tmux.conf.local" "$HOME/.tmux.conf.local"

echo "✅ Configuration files linked successfully!"
