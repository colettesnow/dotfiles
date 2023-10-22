## This script is in not complete. Use at own risk.

## Install Scoop
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
irm get.scoop.sh | iex

scoop install sudo nano

## Install Chocolately
sudo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))

sudo choco install 7zip kdenlive filezilla php -y

# Install Apps using Winget

winget import -i winget/base.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/audiovideo.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/comm.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/dev.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/graphics.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/productivity.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/security.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/utils.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
winget import -i winget/browsers.json --accept-package-agreements --accept-source-agreements --ignore-unavailable