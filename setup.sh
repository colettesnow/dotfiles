sudo apt update
sudo apt upgrade

sudo apt install arc-theme curl wget git git-lfs build-essential ruby ri ruby-dev ruby-bundler flatpak ttf-mscorefonts-installer ranger exa renameutils golang php-cgi steam-installer vlc lollypop cifs-utils python3-smbc  -y
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

echo $username=$( users )
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

sudo systemctl enable syncthing@$username.service
sudo systemctl start syncthing@$username.service

# Setup flatpaks
flatpak remote-add --if-not-exists flathub https://flathub.org/repo/flathub.flatpakrepo

flatpak install flathub org.keepassxc.KeePassXC org.telegram.desktop org.filezillaproject.Filezilla org.libretro.RetroArch org.DolphinEmu.dolphin-emu org.ppsspp.PPSSPP fr.handbrake.ghb net.pcsx2.PCSX2 org.kde.kdenlive org.kde.krita org.audacityteam.Audacity tv.plex.PlexDesktop org.gimp.GIMP org.inkscape.Inkscape org.remmina.Remmina net.fasterland.converseen --noninteractive

wget -O - https://raw.githubusercontent.com/laurent22/joplin/dev/Joplin_install_and_update.sh | bash
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.1/install.sh | bash
go install github.com/justjanne/powerline-go@latest

sudo snap install todoist authy obs-studio bitwarden spotify skype
