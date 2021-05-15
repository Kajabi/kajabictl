if [[ ! -o interactive ]]; then
    return
fi

compctl -K _kajabictl kajabictl

_kajabictl() {
  local word words completions
  read -cA words
  word="${words[2]}"

  if [ "${#words}" -eq 2 ]; then
    completions="$(kajabictl commands)"
  else
    completions="$(kajabictl completions "${word}")"
  fi

  reply=("${(ps:\n:)completions}")
}
