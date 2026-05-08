install_profile() {
    
    echo "Installing Gaming Apps.."
    echo $SEPERATOR
    echo ""

    # Gaming Apps

    echo "--- Installing Gaming Core Apps ---"

    # Moonlight Game Streaming Client
    install_if macos install_app "moonlight"
    install_app "gui:com.moonlight_stream.Moonlight"

    install_if linux install_app "gui:com.heroicgameslauncher.hgl" # Heroic Game Launcher, Linux client for Epic/GOG/Amazon
    install_if linux install_app "gui:net.davidotek.pupgui2" # ProtonUP QT

    # Emulators
    echo ""
    echo "--- Installing Emulators ---"
    if [[ $IS_LINUX ]]; then
        install_app "gui:org.libretro.RetroArch" # RetroArch multi-system emulator
        install_app "gui:org.ppsspp.PPSSPP" # PSP emulator
        install_app "gui:org.DolphinEmu.dolphin-emu" # GameCube / Wii emulator
        install_app "gui:net.pcsx2.PCSX2" # PS2 emulator
        install_app "gui:io.mgba.mGBA" # GBA emulator
        install_app "gui:info.cemu.Cemu" # Wii U emulator
        install_app "gui:org.flycast.Flycast" # Dreamcast emulator
        install_App "gui:net.kuribo64.melonDS" # Nintendo DS emulator
        install_app "gui:org.azahar_emu.Azahar" # Nintendo 3DS emulator
        install_app "gui:com.retrodev.blastem" # Sega Mega Drive emulator
        install_app "gui:ca._0ldsk00l.Nestopia" # Nintendo NES emulator
        install_app "gui:com.snes9x.Snes9x" # Super Nintendo emulator
        install_app "gui:app.xemu.xemu" # Original Xbox emulator
    fi

}
