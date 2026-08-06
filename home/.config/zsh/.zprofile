# Homebrew is not present in the clean PATH of a remote login session.
if [[ -x /opt/homebrew/bin/brew ]]; then
  eval "$(/opt/homebrew/bin/brew shellenv)"
elif [[ -x /home/linuxbrew/.linuxbrew/bin/brew ]]; then
  eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# brew shellenv and macOS path_helper may reorder PATH during login.
path=("$HOME/.scripts" "$HOME/.local/bin" "$HOME/.cargo/bin" $path)
