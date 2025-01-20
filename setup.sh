sudo apt update
sudo apt upgrade

sudo dpkg --add-architecture i386 # add 32bit libraries for Steam
sudo apt update && sudo apt upgrade -y
sudo apt install alacritty curl default-jre wget build-essential ruby ri ruby-dev ruby-bundler flatpak ttf-mscorefonts-installer ranger renameutils golang php-cgi steam-installer vlc lollypop cifs-utils python3-smbc -y

mkdir ~/.ssh
mkdir ~/Dropbox

export UBUNTU_VERSION=$(lsb_release -r -s)

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
    wget -qO - https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$UBUNTU_VERSION/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
    ext_repo_apps+=(albert)
fi

sudo apt update
sudo apt upgrade ${ext_repo_apps[*]} -y

sudo systemctl enable syncthing@$USER.service
sudo systemctl start syncthing@$USER.service

# Setup flatpaks
flatpak remote-add --if-not-exists flathub --system https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub --user https://flathub.org/repo/flathub.flatpakrepo

# Install for everyone
flatpak install flathub --system com.github.iwalton3.jellyfin-media-player com.moonlight_stream.Moonlight com.parsecgaming.parsec fr.handbrake.ghb org.audacityteam.Audacity org.blender.Blender org.filezillaproject.Filezilla org.gimp.GIMP org.inkscape.Inkscape org.kde.kdenlive org.kde.krita org.keepassxc.KeePassXC org.libretro.RetroArch --noninteractive

# Install only for Colette
flatpak install flathub --user com.obsproject.Studio net.fasterland.converseen net.pcsx2.PCSX2 org.DolphinEmu.dolphin-emu org.ppsspp.PPSSPP org.remmina.Remmina org.telegram.desktop --noninteractive
