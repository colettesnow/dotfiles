## This script is in not complete. Use at own risk.

Write-Warning "ATTENTION! Please run all pending Windows Updates and Microsoft Store updates before attempting to run this script."
$BEGIN = Read-Host "Press Enter to Continue or Q to abort"
if ($BEGIN -eq "q")
{
    Exit
}

## Install Scoop
if (Test-Path -Path "$HOME/scoop") {
    Write-Host "Scoop is already installed. Continuing…"
} else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

$scoop_apps = "sudo", "nano", "grep"
$choco_apps = "filezilla", "mupdf"
$winget_categories = "base", "audiovideo", "comm", "dev", "graphics", "games", "productivity", "security", "utils", "browsers"
$winget_app_pins = "Valve.Steam", "ElectronicArts.EADesktop", "GOG.Galaxy", "Ubisoft.Connect", "Amazon.Games", "EpicGames.EpicGamesLauncher"

# Install Apps

foreach ($app in $scoop_apps)
{
    Write-Host "Installing $app using Scoop."
    scoop install $app
}

Write-Warning "You will receive several user account control prompts, please allow them promptly."
$APP_INSTALL_PROMPT = Read-Host "Press Enter to Continue or Q to abort"
if ($APP_INSTALL_PROMPT -eq "q")
{
    Exit
}

if (Test-Path -Path "C:\ProgramData\chocolatey") {
    Write-Host "Chocolately is already installed. Continuing…"
} else {
    ## Install Chocolately
    sudo Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
}

# Install Choco Apps
foreach ($app in $choco_apps)
{
    Write-Host "Installing $app using Chocolately."
    sudo choco install $app -y
}

foreach ($app_category in $winget_categories)
{
    Write-Host ""
    Write-Host "Installing $app_category Apps using Winget"
    Write-Host "============================================"
    winget import -i winget/$app_category.json --accept-package-agreements --accept-source-agreements --ignore-unavailable
}

# Pin Game Launchers since they update themselves

foreach ($app in $winget_app_pins)
{
    Write-Host "Adding pin for $app."
    winget pin add $app
}

# Delete Desktop Shortcuts
Write-Output "Cleaned up/deleted Application Desktop Shortcuts"
sudo Remove-Item C:\Users\Public\Desktop\*.lnk
Remove-Item $HOME\Desktop\*.lnk

# Git
$user_gitname = Read-Host "Please enter your Full Name for Git"
$user_gitemail = Read-Host "Please enter your Email Address for Git"

git config --global user.name "$user_gitname"
git config --global user.email "$user_gitemail"