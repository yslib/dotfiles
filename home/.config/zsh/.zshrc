# Enable Powerlevel10k instant prompt. Keep this close to the top.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

[[ -n ${TERM-} ]] || export TERM=xterm-256color

# ZDOTDIR changes zsh's defaults; keep these files where they were before.
HISTFILE="$HOME/.zsh_history"
ZSH_COMPDUMP="$HOME/.zcompdump-$HOST-$ZSH_VERSION"

export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="powerlevel10k/powerlevel10k"

plugins=(git zoxide zsh-autosuggestions zsh-syntax-highlighting)

source "$ZSH/oh-my-zsh.sh"
[[ -r $HOME/.p10k.zsh ]] && source "$HOME/.p10k.zsh"

for dotfiles_script in \
  "$HOME/.scripts/fzf-git" \
  "$HOME/.scripts/dot-fzf.zsh"
do
  [[ -r $dotfiles_script ]] && source "$dotfiles_script"
done
unset dotfiles_script

alias nv="nvim ."
alias lg="lazygit"

# Let yazi change the current directory when it exits.
y() {
  local tmp="$(mktemp -t 'yazi-cwd.XXXXXX')" cwd
  yazi "$@" --cwd-file="$tmp"
  IFS= read -r -d '' cwd < "$tmp"
  [[ -n $cwd && $cwd != $PWD ]] && builtin cd -- "$cwd"
  rm -f -- "$tmp"
}


# Print a welcome message when logging in via SSH.

if [[ -n ${SSH_CONNECTION-} ]]; then
  print
  if (( $+commands[figlet] )); then
    figlet "Hello, $USER"
  else
    print -P "%F{cyan}Welcome back, %B%n%b@%m%f"
  fi
  print -P "%F{245}%D{%Y-%m-%d %H:%M} · ${SSH_CONNECTION:+SSH · }${TERM:-unknown}%f\n"

  (( $+commands[fastfetch] )) && env -u NO_COLOR fastfetch
fi
