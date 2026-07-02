<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win11Tweaks (KYAU Labs Edition)
 Copyright (C) 2026 KYAU Labs (https://kyaulabs.com)

 This program is free software: you can redistribute it and/or modify
 it under the terms of the GNU Affero General Public License as
 published by the Free Software Foundation, either version 3 of the
 License, or (at your option) any later version.

 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU Affero General Public License for more details.

 You should have received a copy of the GNU Affero General Public License
 along with this program.  If not, see <https://www.gnu.org/licenses/>.
#>

# Install winget Packages
Show-Section -Section "Packages" -Desc "Install Winget Packages"
Show-Package

if (-not (Get-Command winget -ErrorAction SilentlyContinue)) {
    Write-Error "winget not found. Install App Installer from Microsoft Store"
}

$WingetLog = "${Env:UserProfile}\win11tweak-winget.log"
Add-Content -Path $WingetLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Packages pass start"

if ($InstallPowerToys -and ("Microsoft.PowerToys" -notin $WingetPkgs)) {
    $WingetPkgs = @("Microsoft.PowerToys") + $WingetPkgs
    Add-Content -Path $WingetLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] Added Microsoft.PowerToys from InstallPowerToys setting"
}

$PostInstallKill = @{
    "Microsoft.PowerToys"      = @("PowerToys")
    "Piriform.CCleaner"        = @("CCleaner")
    "Discord.Discord"          = @("Discord")
    "ElectronicArts.EADesktop" = @("EADesktop")
    "Blizzard.BattleNet"       = @("Battle.net", "Battle.net Helper")
    "Amazon.Games"             = @("Amazon Games")
    "Playnite.Playnite"        = @("Playnite.DesktopApp")
}

Foreach ($pkg in $WingetPkgs) {
    $ipkg = $pkg
    $pkgLocation = ""
    if ($pkg -eq "Blizzard.BattleNet") {
        $pkgLocation = "--location `"${Env:ProgramFiles(x86)}\BattleNet`""
    }
    winget install --id $pkg --exact $pkgLocation --accept-package-agreements --accept-source-agreements --disable-interactivity 2>&1 | Out-Null
    $exitCode = $LASTEXITCODE
    $pkgInstalled = ($exitCode -eq 0)

    if ($PostInstallKill.ContainsKey($pkg)) {
        # Some installers launch the app after winget exits; retry for a short window.
        $killNames = $PostInstallKill[$pkg]
        $killedAny = $false
        for ($attempt = 1; $attempt -le 30; $attempt++) {
            $active = @()
            foreach ($killName in $killNames) {
                $active += Get-Process -Name $killName -ErrorAction SilentlyContinue
            }

            if (-not $active -or $active.Count -eq 0) {
                if ($attempt -gt 1) {
                    break
                }

                Start-Sleep -Seconds 1
                continue
            }

            $active | Stop-Process -Force -ErrorAction SilentlyContinue
            $killedAny = $true
            Start-Sleep -Seconds 1
        }

        Add-Content -Path $WingetLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $pkg postinstall-kill=$($killedAny)"
    }

    $checkOutput = (& winget list --id $pkg --exact --source winget --accept-source-agreements --disable-interactivity 2>&1 | Out-String)
    $hasExactId = ($checkOutput -match "(?m)^.+\s+$([Regex]::Escape($pkg))\s+.+$")
    if ($hasExactId) {
        $pkgInstalled = $true
    }
    elseif ($exitCode -ne 0) {
        $pkgInstalled = $false

    }
    Add-Content -Path $WingetLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $pkg verify=$($hasExactId)"

    Add-Content -Path $WingetLog -Value "[$(Get-Date -Format 'yyyy-MM-dd HH:mm:ss')] $pkg exit=$($exitCode)"
    Show-Package -Text $ipkg -Installed $pkgInstalled
}

Show-Package -NewLine

# Context Menu for VSCode
if ("Microsoft.VisualStudioCode.Insiders" -in $WingetPkgs) {
    $CodeInsidersExe = "${Env:LocalAppData}\Programs\Microsoft VS Code Insiders\Code - Insiders.exe"
    if (Test-Path $CodeInsidersExe) {
        Add-RegLiteral -Key "HKCR\*\shell\Edit with VSCode" -Type "REG_SZ" -Value "Edit with VSCode"
        Add-RegLiteral -Key "HKCR\*\shell\Edit with VSCode" -Name "Icon" -Type "REG_SZ" -Value "`"${CodeInsidersExe}`",0"
        Add-RegLiteral -Key "HKCR\*\shell\Edit with VSCode\command" -Type "REG_SZ" -Value "`"${CodeInsidersExe}`" `"%1`""

        Add-Reg -Path "HKCR:\Directory\shell\Open with VSCode" -Name "(Default)" -Type String -Value "Open with VSCode"
        Add-Reg -Path "HKCR:\Directory\shell\Open with VSCode" -Name "Icon" -Type String -Value "`"${CodeInsidersExe}`",0"
        Add-Reg -Path "HKCR:\Directory\shell\Open with VSCode\command" -Name "(Default)" -Type String -Value "`"${CodeInsidersExe}`" `"%V`""

        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with VSCode" -Name "(Default)" -Type String -Value "Open with VSCode"
        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with VSCode" -Name "Icon" -Type String -Value "`"${CodeInsidersExe}`",0"
        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with VSCode\command" -Name "(Default)" -Type String -Value "`"${CodeInsidersExe}`" `"%V`""
    }
}

# Context Menu for Sublime Text
if ("SublimeHQ.SublimeText.4" -in $WingetPkgs) {
    $SublimeExe = "${Env:ProgramFiles}\Sublime Text\sublime_text.exe"
    if (Test-Path $SublimeExe) {
        Add-RegLiteral -Key "HKCR\*\shell\Edit with Sublime Text" -Type "REG_SZ" -Value "Edit with Sublime &Text"
        Add-RegLiteral -Key "HKCR\*\shell\Edit with Sublime Text" -Name "Icon" -Type "REG_SZ" -Value "`"${SublimeExe}`",0"
        Add-RegLiteral -Key "HKCR\*\shell\Edit with Sublime Text\command" -Type "REG_SZ" -Value "`"${SublimeExe}`" `"%1`""

        Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text" -Name "(Default)" -Type String -Value "Open with Sublime Text"
        Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text" -Name "Icon" -Type String -Value "`"${SublimeExe}`",0"
        Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text\command" -Name "(Default)" -Type String -Value "`"${SublimeExe}`" `"%V`""

        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with Sublime Text" -Name "(Default)" -Type String -Value "Open with Sublime Text"
        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with Sublime Text" -Name "Icon" -Type String -Value "`"${SublimeExe}`",0"
        Add-Reg -Path "HKCR:\Directory\Background\shell\Open with Sublime Text\command" -Name "(Default)" -Type String -Value "`"${SublimeExe}`" `"%V`""
    }
}

# Change Calculator Keyboard Key to Speedcrunch
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" -Name "ShellExecute" -Type String -Value "${Env:ProgramFiles(x86)}\SpeedCrunch\speedcrunch.exe"

# Remove Links from Root of Start Menu
$StartMenuRoot = Join-Path $Env:AppData "Microsoft\Windows\Start Menu"
if (Test-Path $StartMenuRoot) {
    $shortcutFiles = Get-ChildItem -Path $StartMenuRoot -Filter "*.lnk" -File -Recurse
    $removedCount = 0

    foreach ($shortcut in $shortcutFiles) {
        Remove-Item -Path $shortcut.FullName -Force -ErrorAction SilentlyContinue
        if (-not (Test-Path $shortcut.FullName)) {
            $removedCount++
        }
    }
}
