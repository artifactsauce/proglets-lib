if [[ ! -o interactive ]]; then
    return
fi

compctl -K _generate generate

_generate() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(generate commands)"
  else
    completions="$(generate completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
