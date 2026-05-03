
run_profile() {
  local profile="$1"

  local file="$SCRIPT_DIR/config/profiles/$profile.sh"

  if [[ ! -f "$file" ]]; then
    echo "Profile not found: $profile"
    return 1
  fi

  # shellcheck disable=SC1090
  source "$file"

  install_profile
}