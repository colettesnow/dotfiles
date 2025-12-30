#!/usr/bin/env bash

set -euo pipefail

if ! declare -F detect_os >/dev/null 2>&1; then
    source "lib/os.sh"
fi

pause() {
  read -rp "Press Enter to continue..."
}

has_homebrew() {
  command -v brew >/dev/null 2>&1
}

has_flatpak() {
  command -v flatpak >/dev/null 2>&1
}

submenu_dev() {
  while true; do
    clear
    echo "=== Setup Development Environment ==="
    echo "1) Install Core Environment"
    echo "2) Install Neovim and Plugins (LazyVim)"
    echo "3) Update Dotfiles"
    echo "0) Back"
    echo

    read -rp "Select an option: " choice
    case "$choice" in
      1)
        source setup-dev.sh
        echo "Development tools installed."
        pause
        ;;
      2)
        source install/nvim.sh
        echo "Neovim and LazyVim setup complete."
        pause
        ;;
      3)
        source update/dotfiles.sh
        echo "Dotfiles updated."
        pause
        ;;
      0)
        return
        ;;
      *)
        echo "Invalid option"
        pause
        ;;
    esac
  done
}

submenu_optional_apps() {
  while true; do
    clear
    echo "=== Setup Optional Apps ==="
    echo "1) Zed"
    echo "2) Zotero"
    echo "3) Zoom"
    echo "4) Warp Terminal"
    echo "5) Affinity Suite"
    echo "6) Davinci Resolve"
    echo "7) Calibre"
    echo "8) Flatpak Gaming Runtime Extras"
    echo "0) Back"

    read -rp "Select an option: " choice
    case "$choice" in
      1)
        curl -f https://zed.dev/install.sh | sh
        echo "Zed installation complete."
        pause
        ;;
      2)
        flatpak install flathub org.zotero.Zotero -y
        echo "Zotero installation complete."
        pause
        ;;
      3)
        flatpak install flathub us.zoom.Zoom -y
        echo "Zoom installation complete."
        pause
        ;;
      4)
        curl -f https://warp.dev/install.sh | sh
        echo "Warp Terminal installation complete."
        pause
        ;;
      5)
        echo "Affinity Photo installation not yet implemented."
        pause
        ;;
      6)
        sudo apt update
        sudo apt install -y \
          libxcb-cursor0 \
          libxcb-icccm4 \
          libxcb-image0 \
          libxcb-keysyms1 \
          libxcb-randr0 \
          libxcb-render-util0 \
          libxcb-shape0 \
          libxcb-sync1 \
          libxcb-xfixes0 \
          libxcb-xinerama0 \
          libxkbcommon-x11-0 \
          libxrender1 \
          libxi6 \
          libxrandr2 \
          libxtst6

        sudo apt install libapr1 libaprutil1 libglib2.0-0 -y
        echo "Davinci Resolve pre-installation adjustments complete."
        echo "Please download DaVinci Resolve and install manually before proceeding."
        pause
        sudo mkdir /opt/resolve/libs/unneeded
        sudo mv /opt/resolve/libs/libgio* /opt/resolve/libs/unneeded/
        sudo mv /opt/resolve/libs/libglib* /opt/resolve/libs/unneeded/
        sudo mv /opt/resolve/libs/libgmodule* /opt/resolve/libs/unneeded/
        echo "Davinci Resolve post-installation adjustments complete."
        pause
        ;;
      7)
        sudo -v && wget -nv -O- https://download.calibre-ebook.com/linux-installer.sh | sudo sh /dev/stdin
        echo "Calibre installation complete."
        pause
        ;;
      8)
        flatpak install flathub --user org.freedesktop.Platform.VulkanLayer.gamescope
        flatpak install flathub --user org.freedesktop.Platform.VulkanLayer.MangoHud
        echo "Flatpak Gaming Runtime Extras installation complete."
        pause
        ;;
      0)
        return
        ;;
      *)
        echo "Invalid option"
        pause
        ;;
    esac
  done
}

submenu_setup_network_mounts() {
  while true; do
    clear
    echo "=== Setup Network Mounts ==="
    echo "1) Mount NAS Share"
    echo "2) Set Samba Credentials"
    echo "0) Back"
    echo

    read -rp "Select an option: " choice
    case "$choice" in
      1)
        SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" && pwd)"

        SYSTEMD_SRC="$SCRIPT_DIR/systemd"
        SYSTEMD_DST="/etc/systemd/system"

        # Install units
        sudo install -m 644 "$SYSTEMD_SRC"/*.{mount,automount} "$SYSTEMD_DST"/

        # Reload systemd to see new units
        sudo systemctl daemon-reload

        # Enable + start all automount units
        for unit in "$SYSTEMD_SRC"/*.automount; do
            unit_name=$(basename "$unit")
            sudo systemctl enable --now "$unit_name"
        done
        echo "Network mounts setup complete."
        pause
        ;;
      2)
        read -rp "Enter Samba Username: " SMB_USER
        read -rsp "Enter Samba Password: " SMB_PASS
        sudo install -m 600 /dev/null /root/.smb
        printf "username=%s\npassword=%s\n" "$SMB_USER" "$SMB_PASS" | sudo tee /root/.smb > /dev/null
        echo -e "\nSamba credentials saved."
        pause
        ;;
      0)
        return
        ;;
      *)
        echo "Invalid option"
        pause
        ;;
    esac
  done  
}

main_menu() {
  while true; do
    clear
    echo "=== CSM Main Menu ==="
    echo "1) Setup System"
    echo "2) Setup Development Environment"
    echo "3) Configure Desktop Environment"
    echo "4) Setup Optional Apps"
    if ( ! is_macos ); then
      echo "5) Setup Network Mounts"
    fi
    echo "6) Update System"
    echo "0) Exit"
    echo

    read -rp "Select an option: " choice
    case "$choice" in
      1)
        if is_ubuntu || is_debian; then
          source setup.sh
        fi
        echo "System setup complete."
        pause
        ;;
      2)
        submenu_dev
        ;;
      3)
        submenu_config_desktopenv
        ;;
      4)
        submenu_optional_apps
        ;;
      5)
        submenu_setup_network_mounts
        ;;
      6)
        echo "Updating system packages..."
        sudo apt update && sudo apt upgrade -y
        if has_flatpak; then
          echo "Updating flatpaks..."
          flatpak update -y
        fi
        if has_homebrew; then
          echo "Updating homebrew packages..."
          brew update && brew upgrade
        fi
        echo "System update complete."
        pause
        ;;
      0)
        echo "Exiting..."
        exit 0
        ;;
      *)
        echo "Invalid option"
        pause
        ;;
    esac
  done
}

main_menu
