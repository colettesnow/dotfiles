sudo apt update
sudo apt upgrade

sudo apt install arc-theme curl default-jre wget git git-lfs build-essential ruby ri ruby-dev ruby-bundler flatpak ttf-mscorefonts-installer ranger exa renameutils golang php-cgi steam-installer vlc lollypop cifs-utils python3-smbc  -y
wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
wget https://dl.google.com/linux/direct/google-chrome-stable_current_amd64.deb
wget -O edge.deb https://go.microsoft.com/fwlink?linkid=2149051
sudo apt install ./google-chrome-stable_current_amd64.deb
sudo apt install ./code.deb
sudo apt install ./edge.deb
rm google-chrome-stable_current_amd64.deb
rm code.deb
rm edge.deb

mkdir ~/.ssh
mkdir ~/Dropbox

export UBUNTU_VERSION=$(lsb_release -r -s)

# Add Repos
wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable"|sudo tee /etc/apt/sources.list.d/syncthing.list
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

if [ $XDG_CURRENT_DESKTOP != KDE ]
then
    curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$UBUNTU_VERSION/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
    sudo add-apt-repository "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$UBUNTU_VERSION/ /"
    sudo apt install albert
fi

sudo apt install syncthing typora brave-browser -y

sudo systemctl enable syncthing@$USER.service
sudo systemctl start syncthing@$USER.service

# Setup flatpaks
flatpak remote-add --if-not-exists flathub --system https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub --user https://flathub.org/repo/flathub.flatpakrepo

# Install for everyone
flatpak install flathub --system com.github.iwalton3.jellyfin-media-player fr.handbrake.ghb org.audacityteam.Audacity org.blender.Blender org.filezillaproject.Filezilla org.gimp.GIMP org.inkscape.Inkscape org.kde.kdenlive org.kde.krita org.keepassxc.KeePassXC org.libretro.RetroArch --noninteractive

# Install only for Colette
flatpak install flathub --user com.obsproject.Studio net.fasterland.converseen net.pcsx2.PCSX2 org.DolphinEmu.dolphin-emu org.ppsspp.PPSSPP org.remmina.Remmina org.telegram.desktop --noninteractive

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
go install github.com/justjanne/powerline-go@latest