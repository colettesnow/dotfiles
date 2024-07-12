sudo apt update
sudo apt upgrade

sudo apt install arc-theme curl default-jre fzf wget git git-lfs build-essential ruby ri ruby-dev ruby-bundler flatpak ttf-mscorefonts-installer ranger eza renameutils golang php-cgi steam-installer vlc lollypop cifs-utils python3-smbc zoxide  -y
wget -O code.deb "https://code.visualstudio.com/sha/download?build=stable&os=linux-deb-x64"
wget -O edge.deb https://go.microsoft.com/fwlink?linkid=2149051
sudo apt install ./code.deb
sudo apt install ./edge.deb
rm code.deb
rm edge.deb

mkdir ~/.ssh
mkdir ~/Dropbox

export UBUNTU_VERSION=$(lsb_release -r -s)

# Add Repos
wget -qO - https://dl.google.com/linux/linux_signing_key.pub | sudo tee /etc/apt/trusted.gpg.d/google.asc >/dev/null
echo "deb [arch=amd64] https://dl.google.com/linux/chrome/deb/ stable main" | sudo tee /etc/apt/sources.list.d/google-chrome.list
wget -qO - https://typora.io/linux/public-key.asc | sudo tee /etc/apt/trusted.gpg.d/typora.asc
sudo add-apt-repository 'deb https://typora.io/linux ./'
sudo curl -o /usr/share/keyrings/syncthing-archive-keyring.gpg https://syncthing.net/release-key.gpg
echo "deb [signed-by=/usr/share/keyrings/syncthing-archive-keyring.gpg] https://apt.syncthing.net/ syncthing stable"|sudo tee /etc/apt/sources.list.d/syncthing.list
sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

sudo apt update

if [ $XDG_CURRENT_DESKTOP != KDE ]
then
    echo "deb http://download.opensuse.org/repositories/home:/manuelschneid3r/xUbuntu_$UBUNTU_VERSION/ /" | sudo tee /etc/apt/sources.list.d/home:manuelschneid3r.list
    curl -fsSL https://download.opensuse.org/repositories/home:manuelschneid3r/xUbuntu_$UBUNTU_VERSION/Release.key | gpg --dearmor | sudo tee /etc/apt/trusted.gpg.d/home_manuelschneid3r.gpg > /dev/null
    sudo apt update
    sudo apt install albert
fi

sudo apt install google-chrome-stable syncthing typora brave-browser -y

sudo systemctl enable syncthing@$USER.service
sudo systemctl start syncthing@$USER.service

# Setup flatpaks
flatpak remote-add --if-not-exists flathub --system https://flathub.org/repo/flathub.flatpakrepo
flatpak remote-add --if-not-exists flathub --user https://flathub.org/repo/flathub.flatpakrepo

# Install for everyone
flatpak install flathub --system com.github.iwalton3.jellyfin-media-player com.moonlight_stream.Moonlight com.parsecgaming.parsec fr.handbrake.ghb org.audacityteam.Audacity org.blender.Blender org.filezillaproject.Filezilla org.gimp.GIMP org.inkscape.Inkscape org.kde.kdenlive org.kde.krita org.keepassxc.KeePassXC org.libretro.RetroArch --noninteractive

# Install only for Colette
flatpak install flathub --user com.obsproject.Studio net.fasterland.converseen net.pcsx2.PCSX2 org.DolphinEmu.dolphin-emu org.ppsspp.PPSSPP org.remmina.Remmina org.telegram.desktop --noninteractive

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
go install github.com/justjanne/powerline-go@latest

read -p "Please enter your Full Name for Git: " GIT_FULL_NAME
read -p "Please enter your Email Address for Git: " GIT_EMAIL

git config --global user.name "$GIT_FULL_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.eol lf
git config --global core.autocrlf input
