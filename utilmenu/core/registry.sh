declare -A COMMANDS
declare -A DESCRIPTIONS

register_command() {
  local name="$1"
  local desc="$2"
  local func="$3"

  COMMANDS["$name"]="$func"
  DESCRIPTIONS["$name"]="$desc"
}