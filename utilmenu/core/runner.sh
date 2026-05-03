run_command() {
  local cmd="$1"

  if [[ -z "${COMMANDS[$cmd]}" ]]; then
    echo "Unknown command: $cmd"
    return 1
  fi

  "${COMMANDS[$cmd]}"
}