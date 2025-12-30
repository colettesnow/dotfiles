#!/usr/bin/env bash

if (!has_homebrew); then
    echo "Homebrew is not installed. Please install Homebrew first."
    return 1
fi

brew install neovim ripgrep fd tree-sitter astgrep

git clone https://github.com/LazyVim/starter ~/.config/nvim

rm -rf ~/.config/nvim/.git

