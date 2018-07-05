if [[ ! -o interactive ]]; then
    return
fi

compctl -K _pm pm

_pm() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(pm commands)"
  else
    completions="$(pm completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
