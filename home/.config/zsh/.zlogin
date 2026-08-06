if [[ -o interactive && -t 1 ]]; then
  print
  if (( $+commands[figlet] )); then
    figlet "Hello, ${HOST%%.*}"
  else
    print -P "%F{cyan}Welcome back, %B%n%b@%m%f"
  fi
  print -P "%F{245}%D{%Y-%m-%d %H:%M} · ${SSH_CONNECTION:+SSH · }${TERM:-unknown}%f\n"

  (( $+commands[fastfetch] )) && fastfetch
fi
