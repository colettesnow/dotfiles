resolve_pkg_manager() {
  local prefer="${1:-native}"

  if [[ "$prefer" == "system" ]]; then
    [[ "$CAN_APT" == "true" ]] && echo "apt" && return
    [[ "$CAN_DNF" == "true" ]] && echo "dnf" && return
  fi

  if [[ "$prefer" == "brew" && "$CAN_BREW" == "true" ]]; then
    echo "brew"
    return
  fi

  if [[ "$prefer" == "flatpak" && "$CAN_FLATPAK" == "true" ]]; then
    echo "flatpak"
    return
  fi

  # fallback chain
  [[ "$CAN_APT" == "true" ]] && echo "apt" && return
  [[ "$CAN_DNF" == "true" ]] && echo "dnf" && return
  [[ "$CAN_BREW" == "true" ]] && echo "brew" && return
  [[ "$CAN_FLATPAK" == "true" ]] && echo "flatpak" && return

  echo "none"
}

install_if() {
  local condition="$1"
  shift

  case "$condition" in
    macos)
      $IS_MACOS && "$@"
      ;;
    linux)
      $IS_LINUX && "$@"
      ;;
    immutable)
      $IS_IMMUTABLE && "$@"
      ;;
  esac
}

install_pkg() {
  local pkg="$1"
  local flatpak_pkg="${2:-}"

  # Step 1: resolve preference (override > global)
  local prefer="${PKG_PREFER[$pkg]:-$UTILMENU_PREFER}"

  # support second argument for preference if no flatpak specified
  if [[ "$flatpak_pkg" == "brew" || "$flatpak_pkg" == "system" ]]; then
    prefer="$flatpak_pkg"
  fi

  local manager
  manager="$(resolve_pkg_manager "$prefer")"

  case "$manager" in
    apt)
      sudo apt update
      sudo apt install -y "$pkg"
      ;;
    dnf)
      sudo dnf install -y "$pkg"
      ;;
    brew)
      brew install "$pkg"
      ;;
    flatpak)
      if [[ -n "$flatpak_pkg" ]]; then
        flatpak install -y "$flatpak_pkg"
      else
        echo "No flatpak mapping for $pkg"
        return 1
      fi
      ;;
    *)
      echo "No supported package manager for $pkg"
      return 1
      ;;
  esac
}

install_apt() {
  sudo apt install -y "$1"
}

install_brew() {
  brew install "$1"
}

install_mas() {
  mas install "$1"
}

install_flatpak() {
  flatpak install -y flathub "$1"
}

install_app() {
  local spec="$1"

  IFS=":" read -r type name <<< "$spec"

  local backend
  backend=$(resolve_backend "$type")

  if [ -n "$2" ]; then
      backend="$2"
  fi

  case "$backend" in
    apt) sudo apt install -y "$name" ;;
    dnf) sudo dnf install -y "$name" ;;
    brew) brew install "$name" ;;
    flatpak) flatpak install -y flathub "$name" ;;
    mas) mas install "$name" ;;
    toolbox) echo "Install via toolbox: $name" ;;
  esac
}