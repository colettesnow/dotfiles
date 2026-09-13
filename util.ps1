# --- Main Menu Function ---
function Show-MainMenu {
    do {
        Clear-Host
        Write-Host "=== CSM Main Menu ==="
        Write-Host "1. Setup System"
        Write-Host "   Installs Applications, PowerShell dotfiles and Performs Basic Configuration."
        Write-Host "2. Setup Development Environment"
        Write-Host "   Options to setup development tools and services."
        Write-Host "3. Setup Optional Apps"
        Write-Host "0. Quit"
        $choice = Read-Host "`nSelect an option"

        switch ($choice) {
            '1' { Initialize-System }
            '2' { Submenu_DevSetup }
            '3' { Submenu_OptionalApps }
            '0' { return }
            default { Write-Host "`nInvalid selection, press any key to continue..." -ForegroundColor Red; $Host.UI.RawUI.ReadKey() | Out-Null }
        }
    } until ($choice -eq '0')
}

# --- Submenu 1 Function ---    
function Initialize-System {
    Clear-Host
    if (-not (Test-Path -Path "C:\ProgramData\chocolatey")) {
        Write-Host "Please run all Windows Updates, and Microsoft Store Updates, then run `setup.ps1` separately as an admistrator first." -ForegroundColor Red
        Write-Host "`nPress any key to return to the main menu..."
        Pause
        return
    }

    Write-Host "Setting up system..."
    ./setup.ps1
    Write-Host "`nSetup complete, press any key to return to the main menu..." -ForegroundColor Green
    Pause
}

function Submenu_OptionalApps {
    do {
        Clear-Host
        Write-Host "=== CSM => Setup Optional Apps ==="
        Write-Host "1. Install Bulk Default Apps"
        Write-Host "2. Install Individual Apps"
        Write-Host "0. Back to Main Menu"
        $choice = Read-Host "`nSelect an option"

        switch ($choice) {
            '1' { Submenu_BulkDefaultApps }
            '2' { Write-Host "`nIndividual app installation is not implemented yet. Press any key to continue..." -ForegroundColor Yellow; $Host.UI.RawUI.ReadKey() | Out-Null }
            '0' { return }
            default { Write-Host "`nInvalid selection, press any key to continue..." -ForegroundColor Red; $Host.UI.RawUI.ReadKey() | Out-Null }
        }
    } until ($choice -eq '0')
}
function Submenu_BulkDefaultApps {
    do {
        Clear-Host
        Write-Host "=== CSM => Setup Optional Apps => Setup Bulk Install Default Applications ==="
		Write-Host "1. Install Audio-Video Apps"
		Write-Host "2. Install Web Browsers"
		Write-Host "3. Install Communication Apps"
		Write-Host "4. Install Development Apps"
		Write-Host "5. Install Games Apps"
        Write-Host "6. Install Game Emulators"
		Write-Host "7. Install Graphics Apps"
		Write-Host "8. Install Media Apps"
		Write-Host "9. Install Productivity Apps"
		Write-Host "10. Install Security Apps"
        Write-Host "11. Install Cybersecurity & Diagnostics Tools"
		Write-Host "12. Install Utility Apps"

        Write-Host "0. Back to Install Optional Apps Menu"
        $choice = Read-Host "`nSelect an option"

        switch ($choice) {
            '1' { Action_SetupOptionalApps -category "audiovideo" }
            '2' { Action_SetupOptionalApps -category "browsers" }
            '3' { Action_SetupOptionalApps -category "comm" }
            '4' { Action_SetupOptionalApps -category "dev" }
            '5' { Action_SetupOptionalApps -category "games" }
            '6' { Action_SetupOptionalApps -category "game-emulators" -scoop_apps @("games/azahar", "games/cemu", "games/dolphin", "games/duckstation", "games/eden", "games/flycast", "games/melonds", "games/mgba", "games/pcsx2", "games/ppsspp", "games/xemu", "games/xenia") }
            '7' { Action_SetupOptionalApps -category "graphics" }
            '8' { Action_SetupOptionalApps -category "media" }
            '9' { Action_SetupOptionalApps -category "productivity" }
            '10' { Action_SetupOptionalApps -category "security" }
            '11' { Action_SetupOptionalApps -category "cybersecurity-diagnostics" -scoop_apps @("advanced-ip-scanner", "hxd", "nmap", "wireshark", "zaproxy") }
            '12' { Action_SetupOptionalApps -category "utils" -scoop_apps @("fastfetch")}
            '0' { return }
            default { Write-Host "`nInvalid selection, press any key to continue..." -ForegroundColor Red; $Host.UI.RawUI.ReadKey() | Out-Null }
        }
    } until ($choice -eq '0')
}


# --- Submenu 2 Function ---
function Submenu_DevSetup {
    do {
        Clear-Host
        Write-Host "=== CSM => Setup Optional Apps ===="
        Write-Host "1: Install Core Environment"
        Write-Host "2: Install Neovim and Plugins (LazyVim)"
        Write-Host "0: Back to Main Menu"
        $choice = Read-Host "`nSelect an option"

        switch ($choice) {
            '1' { Action_SetupOptionalApps -category "dev" }
            '2' { Action_SetupOptionalApps -category "neovim" -scoop_apps @("neovim", "fzf", "fd", "python", "luajit", "luarocks", "php", "go", "lazygit", "grep", "ripgrep", "rustup", "ruby", "ast-grep", "tree-sitter") -Action {
                Write-Host "`nSetting up Neovim plugins..."
                # required
                Move-Item $env:LOCALAPPDATA\nvim $env:LOCALAPPDATA\nvim.bak

                # optional but recommended
                Move-Item $env:LOCALAPPDATA\nvim-data $env:LOCALAPPDATA\nvim-data.bak

                git clone https://github.com/LazyVim/starter $env:LOCALAPPDATA\nvim

                Remove-Item $env:LOCALAPPDATA\nvim\.git -Recurse -Force

                Write-Host "`nNeovim setup complete, press any key to continue..." -ForegroundColor Green
                Pause
            }}
            '0' { return } # Return to the calling function (main menu)
            default { Write-Host "`nInvalid selection, press any key to continue..." -ForegroundColor Red; $Host.UI.RawUI.ReadKey() | Out-Null }
        }
    } until ($choice -eq '0')
}

function Action_SetupOptionalApps {
    param (
        [string]$category,
        [array]$scoop_apps,
        [scriptblock]$Action
    )

    Clear-Host
    Write-Host "Setting up optional apps for category: $category..."

    if (Test-Path -Path "winget/$category.json") {
        Write-Host "Installing apps from winget for category: $category..."

        winget import -i "winget/$category.json" `
        --accept-package-agreements `
        --accept-source-agreements `
        --ignore-unavailable
    }

    if ($scoop_apps) {
        scoop install $scoop_apps
    }

    if ($Action) {
        & $Action
    }

    Write-Host "`nSetup complete for category: $category, press any key to return to the main menu..." -ForegroundColor Green
    Pause
}

# --- Start the script ---
Show-MainMenu
