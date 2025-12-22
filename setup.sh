#!/usr/bin/env bash

if ! declare -F detect_os >/dev/null 2>&1; then
    source "lib/os.sh"
fi

# Get Ubuntu Version
UBUNTU_VERSION=$(lsb_release -r -s)
export UBUNTU_VERSION

# Seperator
export SEPERATOR="-------------------------------------"

sudo apt update
sudo apt upgrade -y

sudo dpkg --add-architecture i386 # add 32bit libraries for Steam
sudo apt update && sudo apt upgrade -y
sudo apt install alacritty curl default-jre wget build-essential ruby ri ruby-dev ruby-bundler flatpak ttf-mscorefonts-installer ranger renameutils golang php-cgi steam-installer cifs-utils python3-smbc -y

mkdir ~/.ssh
mkdir ~/Dropbox

# Add Repos
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo wget -O /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable"|sudo tee /etc/apt/sources.list.d/syncthing.list
sudo wget -qO /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
wget -qO - https://packages.microsoft.com/keys/microsoft.asc | sudo tee /etc/apt/trusted.gpg.d/microsoft.asc >/dev/null
echo "deb [arch=amd64] https://packages.microsoft.com/repos/edge stable main" | sudo tee /etc/apt/sources.list.d/microsoft-edge.list
echo "deb [arch=amd64,arm64,armhf] https://packages.microsoft.com/repos/code stable main" | sudo tee /etc/apt/sources.list.d/vscode.list

ext_repo_apps=(google-chrome-stable syncthing typora brave-browser microsoft-edge-stable code)

if [[ ! "$XDG_SESSION_TYPE" == "kde" ]] && [[ ! "$XDG_SESSION_TYPE" == "wayland" ]]; then
    echo "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$UBUNTU_VERSION/ /" | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
wget -qO - https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_"$UBUNTU_VERSION"/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
    ext_repo_apps+=(albert)
fi

sudo apt update
sudo apt upgrade ${ext_repo_apps[*]} -y

sudo systemctl enable syncthing@"$USER".service
sudo systemctl start syncthing@"$USER".service

# Remove snapd
sudo apt remove snapd -y

# Setup flatpaks
flatpak remote-add --if-not-exists flathub --system https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub --user https://flathub.org/repo/flathub.flatpakrepo

flatpak_base_apps=(org.keepassxc.KeePassXC it.mijorus.gearlever)
flatpak_gaming_apps=(com.moonlight_stream.Moonlight com.heroicgameslauncher.hgl net.davidotek.pupgui2)
flatpak_emulator_apps=(org.libretro.RetroArch org.ppsspp.PPSSPP org.DolphinEmu.dolphin-emu net.pcsx2.PCSX2 io.mgba.mGBA info.cemu.Cemu org.flycast.Flycast org.azahar_emu.Azahar com.retrodev.blastem com.snes9x.Snes9x)
flatpak_media_apps=(com.github.iwalton3.jellyfin-media-player org.videolan.VLC org.fooyin.fooyin com.spotify.Client)
flatpak_productivity_apps=(io.github.Qalculate org.onlyoffice.desktopeditors)
flatpak_audiovideo_apps=(fr.handbrake.ghb org.audacityteam.Audacity org.kde.kdenlive com.obsproject.Studio)
flatpak_graphics_apps=(org.blender.Blender org.gimp.GIMP org.inkscape.Inkscape org.kde.krita com.github.PintaProject.Pinta org.gnome.Shotwell net.fasterland.converseen)
flatpak_utils_apps=(org.remmina.Remmina org.keepassxc.KeePassXC com.bitwarden.desktop org.localsend.localsend_app com.github.tchx84.Flatseal net.codelogistics.webapps)
flatpak_comm_apps=(org.telegram.desktop com.discordapp.Discord org.squidowl.halloy com.fastmail.Fastmail)
flatpak_dev_apps=(org.filezillaproject.Filezilla io.github.dvlv.boxbuddyrs org.zaproxy.ZAP) 

# Install for everyone
echo "Installing Base Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_base_apps[*]} --noninteractive

echo "Installing Gaming Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --user ${flatpak_gaming_apps[*]} --noninteractive

echo "Installing Emulator Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --user ${flatpak_emulator_apps[*]} --noninteractive

echo "Installing Media Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_media_apps[*]} --noninteractive

echo "Installing Productivity Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_productivity_apps[*]} --noninteractive

echo "Installing Audio/Video Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_audiovideo_apps[*]} --noninteractive

echo "Installing Graphics Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_graphics_apps[*]} --noninteractive

echo "Installing Utility Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_utils_apps[*]} --noninteractive

echo "Installing Communication Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --system ${flatpak_comm_apps[*]} --noninteractive

echo "Installing Development Flatpaks..."
echo "$SEPERATOR"
flatpak install flathub --user ${flatpak_dev_apps[*]} --noninteractive
