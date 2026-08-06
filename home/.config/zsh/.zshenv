export ZDOTDIR="$HOME/.config/zsh"

# Environment shared by login, interactive, and non-interactive zsh.
typeset -gU path PATH
path=(
  "$HOME/.scripts"
  "$HOME/.local/bin"
  "$HOME/.cargo/bin"
  $path
)
export PATH
export EDITOR=nvim
