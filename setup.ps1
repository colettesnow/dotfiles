## This script is in not complete. Use at own risk.

# Config

$scoop_apps = "sudo", "nano", "grep"
$choco_apps = "filezilla", "mupdf", "cdburnerxp"
$winget_categories = "base", "audiovideo", "comm", "dev", "graphics", "games", "productivity", "security", "utils", "browsers"
$winget_app_pins = "Google.Chrome", "Valve.Steam", "ElectronicArts.EADesktop", "GOG.Galaxy", "Ubisoft.Connect", "Amazon.Games", "EpicGames.EpicGamesLauncher"

# Install the things

Write-Warning "ATTENTION! Please run all pending Windows Updates and Microsoft Store updates before attempting to run this script."
$BEGIN = Read-Host "Press Enter to Continue or Q to abort"
if ($BEGIN -eq "q")
{
    Exit
}

# Check if script is running as administrator
$isAdmin = ([Security.Principal.WindowsPrincipal]([Security.Principal.WindowsIdentity]::GetCurrent())).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")

if ($isAdmin) {
    if (Test-Path -Path "C:\ProgramData\chocolatey") {
        Write-Host "Chocolately is already installed."
    } else {
        Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; Invoke-Expression ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
    }

    # Install Choco Apps
    foreach ($app in $choco_apps)
    {
        Write-Host "Installing $app using Chocolately."
        choco install $app -y
    }
    Write-Host "Please run the script again without administrator privileges to continue."
    Exit
}

if (!(Test-Path -Path "C:\ProgramData\chocolatey")) {
    Write-Warning "Please first run the script again with administrator privileges."
    Exit
}

## Install Scoop
if (Test-Path -Path "$HOME/scoop") {
    Write-Host "Scoop is already installed. Continuing…"
} else {
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser # Optional: Needed to run a remote script the first time
    Invoke-RestMethod get.scoop.sh | Invoke-Expression
}

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

Write-Host "Cleaned up/deleted Application Desktop Shortcuts"
sudo Move-Item "C:\Users\Public\Desktop\Google Chrome.lnk" "C:\Users\Public\Desktop\Google Chrome.lnk.tmp"
sudo Remove-Item C:\Users\Public\Desktop\*.lnk
sudo Move-Item "C:\Users\Public\Desktop\Google Chrome.lnk.tmp" "C:\Users\Public\Desktop\Google Chrome.lnk"
Remove-Item $HOME\Desktop\*.lnk

# Git
Read-Host "Git will now be configured."
$BEGIN = Read-Host "Press Enter to Continue or Q to abort"
if ($BEGIN -eq "q")
{
    Exit
}

$user_gitname = Read-Host "Please enter your Full Name for Git"
$user_gitemail = Read-Host "Please enter your Email Address for Git"
$user_pgp_key = Read-Host "Please enter your PGP key ID for Git"
if ($null -ne $user_pgp_key) {
    $user_pgp_sign = Read-Host "Should Git sign all commits using this key? (y/n)"
}
$user_pgp_sign_all_boolean = "false"
if ($user_pgp_sign -eq "y" -or $user_pgp_sign -eq "Y") {
    $user_pgp_sign_all_boolean = "true"
}

& "C:\Program Files\Git\bin\git.exe" config --global user.name "$user_gitname"
& "C:\Program Files\Git\bin\git.exe" config --global user.email "$user_gitemail"
if ($null -ne $user_pgp_key) {

    & "C:\Program Files\Git\bin\git.exe" config --global user.signingkey $user_pgp_key
    & "C:\Program Files\Git\bin\git.exe" config --global commit.gpgsign $user_pgp_sign_all_boolean
}
& "C:\Program Files\Git\bin\git.exe" config --global core.eol lf
& "C:\Program Files\Git\bin\git.exe" config --global core.autocrlf input
& "C:\Program Files\Git\bin\git.exe" config --global core.fileMode false

# Download Dotfiles
Invoke-WebRequest https://raw.githubusercontent.com/colettesnow/dotfiles/master/.nanorc -OutFile $HOME\.nanorc

# Hide Dotfiles
$userFolder = $env:USERPROFILE

# Get all items starting with a period in the user folder and hide them
Get-ChildItem -Path $userFolder -Filter ".*" -Force | ForEach-Object {
    $_.Attributes = $_.Attributes -bor [System.IO.FileAttributes]::Hidden
}