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

# --- Submenu 2 Function ---
function Submenu_DevSetup {
    do {
        Clear-Host
        Write-Host "========== Submenu 2 (Services) =========="
        Write-Host "1: List all services (top 20)"
        Write-Host "2: Stop the 'Spooler' service (requires admin)"
        Write-Host "B: Back to Main Menu"
        $choice = Read-Host "`nSelect an option"

        switch ($choice) {
            '1' { Get-Service | Select-Object -First 20; Write-Host "`nDone, press any key to continue..."; $Host.UI.RawUI.ReadKey() | Out-Null }
            '2' { 
                try {
                    Stop-Service -Name Spooler -Force -ErrorAction Stop
                    Write-Host "Service 'Spooler' stopped." -ForegroundColor Green
                } catch {
                    Write-Host "Could not stop service. Check permissions." -ForegroundColor Red
                }
                Write-Host "`nDone, press any key to continue..."; $Host.UI.RawUI.ReadKey() | Out-Null
            }
            'b' { return } # Return to the calling function (main menu)
            default { Write-Host "`nInvalid selection, press any key to continue..." -ForegroundColor Red; $Host.UI.RawUI.ReadKey() | Out-Null }
        }
    } until ($choice -eq 'b')
}

# --- Start the script ---
Show-MainMenu
