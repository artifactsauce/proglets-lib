if [[ ! -o interactive ]]; then
    return
fi

compctl -K _mpkg mpkg

_mpkg() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(mpkg commands)"
  else
    completions="$(mpkg completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
