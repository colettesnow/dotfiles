export SEPERATOR="--------------------------------------------"

has_fzf() {
  command -v fzf >/dev/null 2>&1
}

show_menu() {
  local cmd

  if has_fzf; then
    echo "Select a command:"
  else
    echo "Available commands:"
    for c in "${!COMMANDS[@]}"; do
      echo "  $c - ${DESCRIPTIONS[$c]}"
    done
    read -rp "Enter command: " cmd
    [[ -n "$cmd" ]] && run_command "$cmd"
    return
  fi

  cmd=$(for c in "${!COMMANDS[@]}"; do
    echo "$c - ${DESCRIPTIONS[$c]}"
  done | fzf | cut -d' ' -f1)

  [[ -n "$cmd" ]] && run_command "$cmd"
}