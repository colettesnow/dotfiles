# =========================
# OS + Platform Detection
# =========================

OS_TYPE=""
OS_ID=""
OS_LIKE=""

SYSTEM_MODEL=""

# Capability flags (global)
CAN_APT=false
CAN_DNF=false
CAN_BREW=false
CAN_FLATPAK=false
CAN_MAS=false
IS_IMMUTABLE=false
IS_MACOS=false
IS_LINUX=false


# -------------------------
# Load /etc/os-release safely
# -------------------------
if [[ -f /etc/os-release ]]; then
  # shellcheck disable=SC1091
  source /etc/os-release
  OS_ID="${ID:-unknown}"
  OS_LIKE="${ID_LIKE:-}"
fi


# -------------------------
# Base OS detection
# -------------------------
detect_base_os() {
  case "$(uname -s)" in
    Darwin)
      OS_TYPE="macos"
      IS_MACOS=true
      IS_LINUX=false
      ;;
    Linux)
      OS_TYPE="linux"
      IS_LINUX=true
      IS_MACOS=false
      ;;
    *)
      OS_TYPE="unknown"
      ;;
  esac
}

# -------------------------
# Homebrew detection (cross-platform)
# -------------------------
has_homebrew() {
  command -v brew >/dev/null 2>&1
}

# -------------------------
# System model detection
# (this is the key abstraction)
# -------------------------
detect_system_model() {

  # Check for Homebrew first since it's cross-platform and common on macOS
  if command -v brew >/dev/null 2>&1; then
    CAN_BREW=true
  fi

  # macOS
  if [[ "$OS_TYPE" == "macos" ]]; then
    SYSTEM_MODEL="macos"
    CAN_FLATPAK=false
    return
  fi

  # Linux: immutable (Bazzite, Silverblue, etc.)
  if command -v rpm-ostree >/dev/null 2>&1; then
    SYSTEM_MODEL="immutable"
    IS_IMMUTABLE=true
  fi

  # Debian/Ubuntu family
  if [[ "$OS_ID" == "ubuntu" || "$OS_ID" == "debian" || "$OS_LIKE" == *"debian"* ]]; then
    SYSTEM_MODEL="apt-based"
    CAN_APT=true
  fi

  # Fedora family (mutable)
  if [[ "$OS_ID" == "fedora" && "$IS_IMMUTABLE" == false ]]; then
    SYSTEM_MODEL="dnf-based"
    CAN_DNF=true
  fi

  # Bazzite (special case but still immutable Fedora base)
  if [[ "$OS_ID" == "bazzite" ]] || [[ "$IS_IMMUTABLE" == true ]]; then
    SYSTEM_MODEL="immutable-fedora"
    CAN_FLATPAK=true
    CAN_DNF=true   # allowed but discouraged for system layer
  fi

  # fallback Linux
  if [[ -z "$SYSTEM_MODEL" && "$IS_LINUX" == true ]]; then
    SYSTEM_MODEL="generic-linux"
  fi

  if command -v flatpak >/dev/null 2>&1; then
    CAN_FLATPAK=true
  fi

  if command -v mas >/dev/null 2>&1; then
    CAN_MAS=true
  fi
}

resolve_backend() {
  local type="$1"
  local app_kind="$2"

  case "$OS_TYPE:$type" in

    macos:cli)
      echo "brew"
      ;;

    macos:gui)
      echo "brew"
      ;;

    linux:cli)
      if $CAN_APT; then echo "apt"
      elif $CAN_DNF; then echo "dnf"
      else echo "brew"; fi
      ;;

    linux:gui)
      if $CAN_FLATPAK; then echo "flatpak"
      else echo "apt"; fi
      ;;

    linux:media)
      echo "flatpak"
      ;;

    linux:dev)
      if $IS_IMMUTABLE; then echo "toolbox"
      else echo "apt"; fi
      ;;

  esac
}


# -------------------------
# Capability helpers
# -------------------------
has_apt() { $CAN_APT; }
has_dnf() { $CAN_DNF; }
has_brew() { $CAN_BREW; }
has_flatpak() { $CAN_FLATPAK; }
has_mas() { $CAN_MAS; }

# -------------------------
# Debug helper (VERY useful for v2)
# -------------------------
print_system_info() {
  echo "OS_TYPE:        $OS_TYPE"
  echo "OS_ID:          $OS_ID"
  echo "SYSTEM_MODEL:   $SYSTEM_MODEL"
  echo "-------------------------"
  echo "CAN_APT:        $CAN_APT"
  echo "CAN_DNF:        $CAN_DNF"
  echo "CAN_BREW:       $CAN_BREW"
  echo "CAN_FLATPAK:    $CAN_FLATPAK"
  echo "CAN_MAS:        $CAN_MAS"
  echo "IS_IMMUTABLE:   $IS_IMMUTABLE"
}
