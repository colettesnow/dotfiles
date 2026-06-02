install_dev() {
    install_pkg "git"
    install_pkg "curl"
    install_pkg "wget"
    install_pkg "neovim" "io.neovim.nvim" brew
    install_pkg "php"
    install_pkg "nvm" brew
    install_pkg "lazygit" brew
    install_pkg "gh" brew
    install_pkg "treesitter-cli" brew
    install_pkg "shellcheck" brew
    install_pkg "lua" brew
    install_pkg "luarocks" brew
}

install_cmd_core() {
    install_pkg "eza" brew
    install_pkg "fzf" brew
    install_pkg "bat" brew
    install_pkg "ripgrep" brew
    install_pkg "fd" brew
    install_pkg "btop"
    install_pkg "fastfetch" brew
    install_pkg "oh-my-posh" brew
    install_pkg "nano" brew
    install_pkg "bitwarden-cli" brew
    install_pkg "zellij" brew
}

setup_profile() {
    HOSTNAME="${HOSTNAME/".local"/""}"

    if [[ -f "$SCRIPT_DIR/config/profiles/$HOSTNAME.sh" ]]; then
        run_profile $HOSTNAME
    else
        echo "No profile found for $HOSTNAME, installing default profile..."
        run_profile workstation
    fi
}

register_command "install.dev" "Install development tools" install_dev
register_command "install.cmd_core" "Install core command line tools" install_cmd_core
register_command "install.apps" "Install applications" install_apps
register_command "system.setup" "Setup profile" setup_profile