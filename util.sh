#!/usr/bin/env bash

set -euo pipefail

SCRIPT_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if ! declare -F detect_os >/dev/null 2>&1; then
    source "$SCRIPT_DIR/lib/os.sh"
fi

export IS_UTIL=true

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
        source "$SCRIPT_DIR/setup-dev.sh"
        echo "Development tools installed."
        pause
        ;;
      2)
        source "$SCRIPT_DIR/install/nvim.sh"
        echo "Neovim and LazyVim setup complete."
        pause
        ;;
      3)
        source "$SCRIPT_DIR/update/dotfiles.sh"
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
        if ( is_ubuntu || is_debian ); then
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
        elif ( is_macos ); then
          echo "Please download DaVinci Resolve from the official website and install manually."
        elif ( is_ublue ); then
          ujust install-resolve
          echo "Davinci Resolve installation complete."
        else
          echo "Davinci Resolve installation not supported on this OS."
        fi
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


submenu_bulk_install() {
    clear
    echo "=== CSM Bulk Application Installer (MacOS) ==="

    application_directory="/Applications"
    bulk_installer_directory="$HOME/Downloads/Applications"
    after_install="installed";

    echo "This feature allows you to bulk install applications from DMG, APP, or ZIP files."
    echo ""
    echo "Installer Location: $bulk_installer_directory"
    echo "Application Location: $application_directory"
    echo "After Install: $after_install"
    echo ""
    echo "1) Install Applications"
    echo "2) Change Source Directory"
    echo "3) Change Application Directory"
    echo "4) Change After Install Setting"
    echo "0) Back"

    while true; do
      echo
      echo "Current Source Directory: $bulk_installer_directory"
      echo "Current Application Directory: $application_directory"
      echo "After Install Setting: $after_install"
      echo
      read -rp "Select an option: " choice2
      case "$choice2" in
        1)
          if [ ! -d "$bulk_installer_directory" ]; then
            echo "Source directory does not exist: $bulk_installer_directory"
            pause
            continue
          fi

          for src in "$bulk_installer_directory"/*; do
            [ -e "$src" ] || continue

            case "$src" in
              *.dmg|*.DMG)
                echo "Processing DMG: $src"
                MNT=$(mktemp -d)
                if hdiutil attach -nobrowse -noautoopen -mountpoint "$MNT" "$src" >/dev/null 2>&1; then
                  APP=$(find "$MNT" -maxdepth 2 -type d -name "*.app" -print -quit)
                  if [ -n "$APP" ]; then
                    echo "Installing $(basename "$APP") to $application_directory"
                    sudo rm -rf "$application_directory/$(basename "$APP")"
                    sudo cp -R "$APP" "$application_directory"/
                    [ "$after_install" = "installed" ] && echo "Installed: $(basename "$APP")"
                  else
                    echo "No .app found inside $src"
                  fi
                  hdiutil detach "$MNT" >/dev/null 2>&1 || true
                  rmdir "$MNT" >/dev/null 2>&1 || true
                else
                  rmdir "$MNT" >/dev/null 2>&1 || true
                  echo "Failed to mount $src"
                fi
                ;;
              *.zip|*.ZIP)
                echo "Processing ZIP: $src"
                TMP=$(mktemp -d)
                if unzip -q "$src" -d "$TMP"; then
                  APP=$(find "$TMP" -maxdepth 3 -type d -name "*.app" -print -quit)
                  if [ -n "$APP" ]; then
                    echo "Installing $(basename "$APP") to $application_directory"
                    sudo rm -rf "$application_directory/$(basename "$APP")"
                    sudo cp -R "$APP" "$application_directory"/
                    [ "$after_install" = "installed" ] && echo "Installed: $(basename "$APP")"
                  else
                    echo "No .app found in $src"
                  fi
                else
                  echo "Failed to unzip $src"
                fi
                rm -rf "$TMP"
                ;;
              *.app|*.APP)
                echo "Processing APP bundle: $(basename "$src")"
                sudo rm -rf "$application_directory/$(basename "$src")"
                sudo cp -R "$src" "$application_directory"/
                [ "$after_install" = "installed" ] && echo "Installed: $(basename "$src")"
                ;;
              *)
                echo "Skipping unsupported file type: $(basename "$src")"
                ;;
            esac
          done
          pause
          ;;
        2)
          read -rp "Enter new source directory path: " new_src
          if [ -z "$new_src" ]; then
            echo "No change made."
          else
            if [ ! -d "$new_src" ]; then
              read -rp "Directory does not exist. Create it? (y/N): " yn
              case "$yn" in [Yy]*) mkdir -p "$new_src" && echo "Created $new_src" ;; *) echo "Not created." ;; esac
            fi
            if [ -d "$new_src" ]; then
              bulk_installer_directory="$new_src"
              echo "Source directory set to: $bulk_installer_directory"
            fi
          fi
          pause
          ;;
        3)
          read -rp "Enter new application directory path (e.g. /Applications): " new_appdir
          if [ -z "$new_appdir" ]; then
            echo "No change made."
          else
            if [ ! -d "$new_appdir" ]; then
              read -rp "Directory does not exist. Create it? (requires sudo) (y/N): " yn
              case "$yn" in
                [Yy]*)
                  sudo mkdir -p "$new_appdir" && sudo chown "$USER" "$new_appdir"
                  echo "Created $new_appdir"
                  ;;
                *) echo "Not created." ;;
              esac
            fi
            if [ -d "$new_appdir" ]; then
              application_directory="$new_appdir"
              echo "Application directory set to: $application_directory"
            fi
          fi
          pause
          ;;
        4)
          echo "Current after-install action: $after_install"
          echo "Options: installed (leave app), moved (move source to subdir 'installed'), deleted (remove source after install)"
          read -rp "Set After Install action [installed/moved/deleted]: " new_after
          case "$new_after" in
            installed|moved|deleted)
              after_install="$new_after"
              echo "After Install set to: $after_install"
              ;;
            *)
              echo "Invalid choice, no change."
              ;;
          esac
          pause
          ;;
        0)
          break
          ;;
        *)
          echo "Invalid option"
          pause
          ;;
      esac
    done

    pause

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
    else
      echo "5) Bulk Install Applications (DMG/APP/ZIP)"
    fi

    echo "6) Update System"
    echo "0) Exit"
    echo

    read -rp "Select an option: " choice
    case "$choice" in
      1)
        if is_ubuntu || is_debian; then
          source "$SCRIPT_DIR/setup.sh"
        elif is_macos; then
          source "$SCRIPT_DIR/setup.macos.sh"
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
        if ( ! is_macos ); then
          submenu_setup_network_mounts
        else
          submenu_bulk_install
        fi
        ;;
      6)
        if is_debian || is_ubuntu; then
            echo "Updating system packages..."
            sudo apt update && sudo apt upgrade -y
        fi
        if is_ublue; then
            ujust upgrade
        fi
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
