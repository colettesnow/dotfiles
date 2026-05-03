linux_base_apps=(flatpak:org.keepassxc.KeePassXC flatpak:it.mijorus.gearlever flatpak:io.gitlab.news_flash.NewsFlash)
linux_gaming_apps=(flatpak:com.moonlight_stream.Moonlight flatpak:com.heroicgameslauncher.hgl flatpak:net.davidotek.pupgui2)
linux_emulator_apps=(flatpak:org.libretro.RetroArch flatpak:org.ppsspp.PPSSPP flatpak:org.DolphinEmu.dolphin-emu flatpak:net.pcsx2.PCSX2 flatpak:io.mgba.mGBA flatpak:info.cemu.Cemu flatpak:org.flycast.Flycast flatpak:org.azahar_emu.Azahar flatpak:com.retrodev.blastem flatpak:com.snes9x.Snes9x)
linux_media_apps=(flatpak:com.github.iwalton3.jellyfin-media-player flatpak:org.videolan.VLC flatpak:org.fooyin.fooyin flatpak:com.spotify.Client flatpak:com.github.johnfactotum.Foliate)
linux_productivity_apps=(flatpak:io.github.Qalculate flatpak:org.onlyoffice.desktopeditors)
linux_audiovideo_apps=(flatpak:fr.handbrake.ghb flatpak:org.audacityteam.Audacity flatpak:org.kde.kdenlive flatpak:com.obsproject.Studio)
linux_graphics_apps=(flatpak:org.blender.Blender flatpak:com.boxy_svg.BoxySVG flatpak:org.gimp.GIMP flatpak:org.inkscape.Inkscape flatpak:org.kde.krita flatpak:com.github.PintaProject.Pinta flatpak:org.gnome.Shotwell flatpak:net.fasterland.converseen)
linux_utils_apps=(flatpak:org.remmina.Remmina flatpak:org.keepassxc.KeePassXC flatpak:com.bitwarden.desktop flatpak:org.localsend.localsend_app flatpak:com.github.tchx84.Flatseal flatpak:net.codelogistics.webapps)
linux_comm_apps=(flatpak:org.telegram.desktop flatpak:com.discordapp.Discord flatpak:org.squidowl.halloy flatpak:com.fastmail.Fastmail)
linux_dev_apps=(flatpak:org.filezillaproject.Filezilla flatpak:io.github.dvlv.boxbuddyrs)

mac_base_apps=(brew:google-chrome brew:google-drive brew:netnewswire brew:temurin brew:notion-calendar brew:joplin brew:kate brew:raycast brew:keepassxc)
mac_gaming_apps=(brew:moonlight)
mac_emulator_apps=(brew:dolphin)
mac_media_apps=(brew:spotify brew:vlc brew:pocket-casts brew:streamlink-twitch-gui)
mac_productivity_apps=(brew:anki brew:libreoffice brew:typora)
mac_audiovideo_apps=(brew:aegisub brew:audacity brew:handbrake-app brew:kdenlive brew:obs)
mac_graphics_apps=(brew:gimp brew:blender brew:krita brew:inkscape brew:freecad)
mac_utils_apps=(brew:ghostty brew:betterdisplay brew:connectmenow brew:wsddn )
mac_comm_apps=(brew:halloy brew:discord brew:zoom)
mac_dev_apps=(brew:visual-studio-code brew:wireshark-app brew:firefox brew:brave-browser brew:hex-fiend brew:postman brew:github brew:zed brew:zenmap brew:zap)

# profiles/workstation.sh

install_profile() {
  echo "Installing WORKSTATION profile..."

    # Core CLI tools
    install_pkg "mas" brew
    install_app "cli:git"
    install_app "cli:curl"
    install_app "cli:gh"
    install_app "cli:bitwarden-cli"

    # Editors / IDEs
    install_if macos install_app "gui:visual-studio-code"
    install_if linux install_app "gui:code"

    # Core Apps - MacOS
    install_if macos install_app "mas:1352778147" # Bitwarden
    install_if macos install_app "gui:google-chrome"
    install_if macos install_app "gui:google-drive"
    install_if macos install_app "gui:netnewswire"
    install_if macos install_app "gui:temurin"
    install_if macos install_app "gui:notion-calendar"
    install_if macos install_app "gui:joplin"
    install_if macos install_app "gui:raycast"
    install_if macos install_app "gui:keepassxc"
    
    # Core Apps - Linux
    install_if linux install_app "flatpak:org.keepassxc.KeePassXC"
    install_if linux install_app "flatpak:it.mijorus.gearlever"
    install_if linux install_app "flatpak:io.gitlab.news_flash.NewsFlash"

    # Core Apps - All
    install_app kate





}