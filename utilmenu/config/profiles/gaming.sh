install_profile() {
    
    echo "Installing Gaming Apps.."
    echo $SEPERATOR
    echo ""

    # Gaming Apps
    install_if macos install_app "moonlight"
    install_if linux install_app "flatpak:com.moonlight_stream.Moonlight"
    install_if linux install_app "flatpak:com.heroicgameslauncher.hgl"
    install_if linux install_app "flatpak:net.davidotek.pupgui2"

}