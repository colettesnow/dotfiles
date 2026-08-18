#!/usr/bin/env bash

# Ensure target folders exist locally with their proper hidden names
mkdir -p "$HOME/.config/oh-my-posh"
mkdir -p "$HOME/.config/zellij"
mkdir -p "$HOME/.config/alacritty"
mkdir -p "$HOME/.config/btop"
mkdir -p "$HOME/.config/ghostty"
mkdir -p "$HOME/.local/share/warp-terminal/themes"
mkdir -p "$HOME/.zsh"
mkdir -p "$HOME/.bashrc.d"

# Dotfiles to update
dot_files=(
    "$HOME/.config/oh-my-posh/omp.toml"
    "$HOME/.config/zellij/config.kdl"
    "$HOME/.config/zellij/tokyo-night.kdl"
    "$HOME/.config/alacritty/alacritty.toml"
    "$HOME/.config/ghostty/config"
    "$HOME/.local/share/warp-terminal/themes/tokyo_night_theme.yaml"
    "$HOME/.nanorc"
    "$HOME/.zshrc"
    "$HOME/.zsh/zsh_aliases"
    "$HOME/.zsh/zsh_functions"
    "$HOME/.config/btop/btop.conf"
)

for dot_file_dst in "${dot_files[@]}"; do
    # 1. Strip the absolute path prefix to get the relative path
    relative_path="${dot_file_dst#$HOME/}"
    
    # 2. Strip ALL dots from the relative path for Git
    # Example: ".config/oh-my-posh/omp.toml" -> "config/oh-my-posh/omp.toml"
    dot_file_git="${relative_path//./}"

    echo ""
    echo "Downloading: $dot_file_git -> $dot_file_dst"
    echo "--------------------------"
    
    # Download directly into the local absolute destination
    curl -o- "https://raw.githubusercontent.com/colettesnow/dotfiles/master/$dot_file_git" > $dot_file_dst
done