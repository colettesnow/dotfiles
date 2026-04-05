/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

brew_casks_base_apps=(netnewswire temurin notion-calendar joplin kate raycast keepassxc)
brew_casks_gaming_apps=(moonlight)
brew_casks_emulator_apps=(doplin)
brew_casks_media_apps=(spotify vlc pocket-casts streamlink-twitch-gui)
brew_casks_productivity_apps=(anki libreoffice typora)
brew_casks_audiovideo_apps=(aegisub audacity handbrake-app kdenlive obs)
brew_casks_graphics_apps=(gimp blender krita inkscape freecad)
brew_casks_utils_apps=(ghostty betterdisplay connectmenow localsend wsddn )
brew_casks_comm_apps=(halloy discord)
brew_casks_dev_apps=(visual-studio-code wireshark-app firefox brave-browser hex-fiend postman github zed zenmap zap)

SEPERATOR="========================================"

echo "Installing Syncthing, Streamlink, Oh My Posh, Git, and Fastfetch..."
brew install syncthing streamlink oh-my-posh git fastfetch

# Install for everyone
echo "\nInstalling Base Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_base_apps[*]}

echo "\nInstalling Gaming Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_gaming_apps[*]}
    
echo "\nInstalling Emulator Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_emulator_apps[*]}

echo "\nInstalling Media Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_media_apps[*]}

echo "\nInstalling Productivity Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_productivity_apps[*]}

echo "\nInstalling Audio/Video Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_audiovideo_apps[*]}

echo "\nInstalling Graphics Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_graphics_apps[*]}

echo "\nInstalling Utility Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_utils_apps[*]}

echo "\nInstalling Communication Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_comm_apps[*]}

echo "\nInstalling Development Casks..."
echo "$SEPERATOR"
brew install --casks ${brew_casks_dev_apps[*]}