system_update() {

  # use topgrade to update if available
  if command -v topgrade >/dev/null 2>&1; then
    topgrade
  else

    echo "== Updating system =="

    # System layer
    if has_apt; then
      echo "-- apt --"
      sudo apt update && sudo apt upgrade -y
    elif has_dnf && ! $IS_IMMUTABLE; then
      echo "-- dnf --"
      sudo dnf upgrade -y
    elif $IS_IMMUTABLE; then
      echo "-- rpm-ostree --"
      rpm-ostree upgrade
    fi

    # User package layer (brew)
    if has_brew; then
      echo "-- brew --"
      brew update && brew upgrade
    fi

    # App layer (flatpak)
    if has_flatpak; then
      echo "-- flatpak --"
      flatpak update -y
    fi

  fi
}

register_command "system.update" "Update system packages" system_update
register_command "system.sysinfo" "Show system info for debugging" print_system_info
if command -v fastfetch >/dev/null 2>&1; then
  register_command "system.fastfetch" "Display system information" fastfetch
fi 
