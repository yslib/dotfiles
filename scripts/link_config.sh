#!/bin/bash
SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )
CONFIG_HOME="$SCRIPT_DIR/../home"

is_windows() {
    [[ "$OSTYPE" == "msys" || "$OSTYPE" == "mingw"* || "$OSTYPE" == "cygwin" ]]
}

# On Windows, cmd-style symlinks are needed for native apps (nvim, lazygit, etc.)
# Git Bash's `ln -s` creates copies or MSYS-internal symlinks that native
# Windows programs cannot follow. We use cmd.exe /c mklink instead.
win_symlink() {
    local source="$1"
    local target="$2"

    # Convert to Windows paths
    local win_source win_target
    win_source=$(cygpath -w "$source")
    win_target=$(cygpath -w "$target")

    # Remove existing target
    if [ -e "$target" ] || [ -L "$target" ]; then
        rm -rf "$target"
    fi

    # Determine if source is a directory or file
    if [ -d "$source" ]; then
        cmd.exe //c "mklink /D \"$win_target\" \"$win_source\"" > /dev/null 2>&1
    else
        cmd.exe //c "mklink \"$win_target\" \"$win_source\"" > /dev/null 2>&1
    fi
    echo "  $target -> $source"
}

make_link() {
    local source="$1"
    local target="$2"

    if [ ! -e "$source" ]; then
        echo "  [WARN] Source not found, skipping: $source"
        return
    fi

    # Ensure parent directory exists
    mkdir -p "$(dirname "$target")"

    if is_windows; then
        win_symlink "$source" "$target"
    else
        ln -sf "$source" "$target"
        echo "  $target -> $source"
    fi
}

echo "🔗 Linking configuration files from $CONFIG_HOME"

if is_windows; then
    # Windows native app config paths
    APPDATA_LOCAL="$(cygpath "$LOCALAPPDATA")"
    APPDATA_ROAMING="$(cygpath "$APPDATA")"
    USERPROFILE="$(cygpath "$USERPROFILE")"

    # nvim: %LOCALAPPDATA%\nvim
    make_link "$CONFIG_HOME/.config/nvim"      "$APPDATA_LOCAL/nvim"

    # yazi: %APPDATA%\yazi\config
    make_link "$CONFIG_HOME/.config/yazi"      "$APPDATA_ROAMING/yazi/config"

    # lazygit: %LOCALAPPDATA%\lazygit
    make_link "$CONFIG_HOME/.config/lazygit"   "$APPDATA_LOCAL/lazygit"

    # alacritty: %APPDATA%\alacritty
    make_link "$CONFIG_HOME/.config/alacritty" "$APPDATA_ROAMING/alacritty"

    # gitconfig: ~\.gitconfig
    make_link "$CONFIG_HOME/.gitconfig"        "$USERPROFILE/.gitconfig"
else
    # Linux / macOS (XDG paths)
    make_link "$CONFIG_HOME/.config/nvim"      "$HOME/.config/nvim"
    make_link "$CONFIG_HOME/.config/yazi"      "$HOME/.config/yazi"
    make_link "$CONFIG_HOME/.config/lazygit"   "$HOME/.config/lazygit"
    make_link "$CONFIG_HOME/.gitconfig"        "$HOME/.gitconfig"
    make_link "$CONFIG_HOME/.zshrc"            "$HOME/.zshrc"
    make_link "$CONFIG_HOME/.tmux.conf"        "$HOME/.tmux.conf"
    make_link "$CONFIG_HOME/.tmux.conf.local"  "$HOME/.tmux.conf.local"
fi

echo "✅ Configuration files linked successfully!"
