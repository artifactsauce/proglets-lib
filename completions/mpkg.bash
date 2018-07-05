_mpkg() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(mpkg commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(mpkg completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _mpkg mpkg
