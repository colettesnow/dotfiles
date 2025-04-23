#!/bin/bash

type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update
sudo apt install eza git git-lfs golang gh build-essential neofetch php-cgi python3-pip python-is-python3 ruby ri ruby-dev ruby-bundler ranger renameutils wget zsh -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

npm install -g lessc @bitwarden/cli

# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"

brew install oh-my-posh zoxide fzf fastfetch nvim zellij lazygit
git clone https://github.com/LazyVim/starter ~/.config/nvim
rm -rf ~/.config/nvim/.git

read -p "Please enter your Full Name for Git: " GIT_FULL_NAME
read -p "Please enter your Email Address for Git: " GIT_EMAIL

git config --global user.name "$GIT_FULL_NAME"
git config --global user.email "$GIT_EMAIL"
git config --global core.eol lf
git config --global core.autocrlf input

mkdir ~/.zsh
mkdir -p ~/.config/oh-my-posh
mkdir -p ~/.config/alacritty
mkdir -p ~/.config/zellij/themes
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.config/oh-my-posh/omp.toml > ~/.config/oh-my-posh/omp.toml
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.config/zellij/config.kdl > ~/.config/zellij/config.kdl
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.config/zellij/themes/tokyo-night.kdl > ~/.config/zellij/tokyo-night.kdl
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.config/alacritty/alacritty_linux.toml > ~/.config/alacritty/alacritty.toml
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.nanorc > ~/.nanorc
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zshrc > ~/.zshrc
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zsh/zsh_aliases > ~/.zsh/zsh_aliases
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zsh/zsh_functions > ~/.zsh/zsh_functions

if [[ ! "$XDG_CURRENT_DESKTOP" == "KDE" ]]; then
    chsh -s $(which zsh)
fi