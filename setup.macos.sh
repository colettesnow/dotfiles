/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew_casks_base_apps=(google-chrome google-drive netnewswire temurin notion-calendar joplin kate raycast keepassxc)
brew_casks_gaming_apps=(moonlight)
brew_casks_emulator_apps=(dolphin)
brew_casks_media_apps=(spotify vlc pocket-casts streamlink-twitch-gui)
brew_casks_productivity_apps=(anki libreoffice typora)
brew_casks_audiovideo_apps=(aegisub audacity handbrake-app kdenlive obs)
brew_casks_graphics_apps=(gimp blender krita inkscape freecad)
brew_casks_utils_apps=(ghostty betterdisplay connectmenow wsddn )
brew_casks_comm_apps=(halloy discord zoom)
brew_casks_dev_apps=(visual-studio-code wireshark-app firefox brave-browser hex-fiend postman github zed zenmap zap)

SEPERATOR="========================================"

echo "Installing Mac App Store Cli, Syncthing, Streamlink, Oh My Posh, Git, and Fastfetch..."
brew install mas syncthing streamlink oh-my-posh git fastfetch

# Install for everyone
echo "\nInstalling Base Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_base_apps[*]}

echo "Installing Bitwarden from Mac App Store..."
mas install 1352778147 # Bitwarden

echo "\nInstalling Gaming Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_gaming_apps[*]}

echo "Installing Steam Link from Mac App Store..."
mas install 1246969117 # Steam Link
    
echo "\nInstalling Emulator Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_emulator_apps[*]}

echo "\nInstalling Media Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_media_apps[*]}

echo "Installing Kindle from Mac App Store..."
mas install 302584613 # Kindle

echo "\nInstalling Productivity Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_productivity_apps[*]}

echo "Installing Todoist from Mac App Store..."
mas install 585829637 # Todoist

echo "\nInstalling Audio/Video Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_audiovideo_apps[*]}

echo "\nInstalling Graphics Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_graphics_apps[*]}

echo "\nInstalling Utility Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_utils_apps[*]}

echo "Installing Local Send from Mac App Store..."
mas install 1661733229 # Local Send

echo "Installing Windows App / Remote Desktop from Mac App Store..."
mas install 1295203466 # Remote Desktop

echo "\nInstalling Communication Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_comm_apps[*]}

echo "Installing Telegram from Mac App Store..."
mas install 747648890 # Telegram

echo "\nInstalling Development Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_dev_apps[*]}

echo "\nInstalling Xcode Command Line Tools..."
xcode-select --install
