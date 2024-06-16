type -p curl >/dev/null || (sudo apt update && sudo apt install curl -y)
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update
sudo apt install fzf eza git git-lfs golang gh build-essential neofetch php-cgi python3-pip python-is-python3 ruby ri ruby-dev ruby-bundler ranger renameutils wget zoxide zsh -y

curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.3/install.sh | bash

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

nvm install node

npm install -g lessc @bitwarden/cli

go install github.com/justjanne/powerline-go@latest

mkdir .zsh
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.nanorc > .nanorc
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zshrc > .zshrc
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zsh/zsh_aliases > .zsh/zsh_aliases
curl -o- https://raw.githubusercontent.com/colettesnow/dotfiles/master/.zsh/zsh_functions > .zsh/zsh_functions

chsh -s $(which zsh)
