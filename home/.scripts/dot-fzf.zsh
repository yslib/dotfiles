# Interactively select a dot target, profile, and set of jobs.
#
# Usage:
#   dot-fzf             # preview the selected jobs
#   dot-fzf dry-run     # preview the selected jobs
#   dot-fzf apply       # execute the selected jobs
dot-fzf() {
  emulate -L zsh
  setopt pipe_fail

  local mode=${1:-dry-run}
  if (( $# > 1 )) || [[ $mode != dry-run && $mode != apply ]]; then
    print -u2 -- "usage: dot-fzf [dry-run|apply]"
    return 2
  fi

  local dependency
  for dependency in dot fzf; do
    if ! command -v "$dependency" >/dev/null 2>&1; then
      print -u2 -- "dot-fzf: required command not found: $dependency"
      return 127
    fi
  done

  local target_row profile_row job_rows target profile row
  target_row=$(
    dot list targets |
      fzf \
        --prompt='target> ' \
        --height=60% \
        --layout=reverse \
        --border \
        --header='Select a compatible target'
  ) || return
  [[ -n $target_row ]] || return 1
  target=${target_row%%$'\t'*}

  profile_row=$(
    dot list profiles --target "$target" |
      fzf \
        --prompt='profile> ' \
        --height=60% \
        --layout=reverse \
        --border \
        --header='Select a profile'
  ) || return
  [[ -n $profile_row ]] || return 1
  profile=${profile_row%%$'\t'*}

  job_rows=$(
    dot list jobs --target "$target" --profile "$profile" |
      fzf \
        --multi \
        --prompt='jobs> ' \
        --height=80% \
        --layout=reverse \
        --border \
        --header='Select jobs (Tab: toggle, Ctrl-A: all, Ctrl-D: none)' \
        --bind='ctrl-a:select-all,ctrl-d:deselect-all'
  ) || return
  [[ -n $job_rows ]] || {
    print -u2 -- "dot-fzf: no jobs selected"
    return 1
  }

  local -a job_args
  for row in "${(@f)job_rows}"; do
    job_args+=(--job "${row%%$'\t'*}")
  done

  dot "$mode" \
    --target "$target" \
    --profile "$profile" \
    "${job_args[@]}"
}
