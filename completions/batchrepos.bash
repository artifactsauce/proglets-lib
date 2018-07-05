_batchrepos() {
  COMPREPLY=()
  local word="${COMP_WORDS[COMP_CWORD]}"

  if [ "$COMP_CWORD" -eq 1 ]; then
    COMPREPLY=( $(compgen -W "$(batchrepos commands)" -- "$word") )
  else
    local command="${COMP_WORDS[1]}"
    local completions="$(batchrepos completions "$command")"
    COMPREPLY=( $(compgen -W "$completions" -- "$word") )
  fi
}

complete -F _batchrepos batchrepos
