if [[ ! -o interactive ]]; then
    return
fi

compctl -K _batchrepos batchrepos

_batchrepos() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(batchrepos commands)"
  else
    completions="$(batchrepos completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
