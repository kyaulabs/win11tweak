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

function Add-Configuration {
    # PSScriptAnalyzer - ignore unused variables
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseDeclaredVarsMoreThanAssignments", "", Justification = "Settings assignments are imported by other scripts.")]
    param()

    <#
     # Windows Defaults
     #>

    # Computer Name
    $script:ComputerName = "WIN11TWEAK"

    # Network WorkGroup
    $script:WorkGroupName = "KYAULABS"

    # Keep Windows Defender? ($true / $false)
    # NOTE: Removal breaks Windows Update.
    $script:WinDefender = $true

    # Keep Windows Security? ($true/$false)
    # NOTE: Removal not recommended, breaks Windows Defender & Windows Update.
    $script:SecurityHealth = $true

    # Keep Microsoft 365 / OneDrive ($true/$false)
    $script:Microsoft365 = $true

    # Keep Microsoft Edge? ($true / $false)
    # NOTE: Removal not recommended, breaks search, widgets, etc.
    #       MSEdgeRedirect Recommended.
    $script:MicrosoftEdge = $true

    # Install Microsoft PowerToys from winget when available? ($true / $false)
    # NOTE: Some environments do not expose this package/source consistently.
    $script:InstallPowerToys = $true

    # Remove Copilot app using modern/legacy policy toggles? ($true / $false)
    # NOTE: New policy applies on newer builds; legacy policy kept for fallback.
    $script:RemoveMicrosoftCopilotApp = $true

    # Enable Energy Saver tuning? ($true / $false)
    $script:EnableEnergySaver = $true

    # Energy Saver battery threshold percent (0-100, lower values are less aggressive)
    # 100 means Energy Saver is active on battery at all levels.
    $script:EnergySaverBatteryThreshold = 100

    # Desktop / Lock Screen Wallpaper
    $script:WallpaperPath = "${Env:WINDIR}\Web\4K\Wallpaper\Windows\img19_1920x1200.jpg"
    #$imagePath =  "${env:USERPROFILE}\Pictures\wallpaper-21_9.png"

    # Mapped Network Drives
    #
    # $MappedDrives = @(
    #     [PSCustomObject]@{
    #         DriveLetter = "Z"
    #         RemotePath = "\\server\location"
    #         Name = "SHARENAME"
    #         Icon = "%ProgramData%\win11tweak-hardware.dll,60"
    #     },
    #     ...
    # )
    $script:MappedDrives = @(
        [PSCustomObject]@{
            DriveLetter = "N"
            RemotePath = "\\10.0.10.20\archive"
            Name = "ARCHiVE"
            Icon = "%ProgramData%\win11tweak-hardware.dll,60"
        },
        [PSCustomObject]@{
            DriveLetter = "N"
            RemotePath = "\\10.0.10.20\isoimages"
            Name = "ISO IMAGES"
            Icon = "%ProgramData%\win11tweak-hardware.dll,59"
        }
    )

    <#
     # Packages
     #>

    
    # Default winget Packages to Install
    $script:WingetPkgs = @(
        # Default Applications
        "MSYS2.MSYS2",                          # MSYS2 (for development tools, package management, and terminal)
        "7zip.7zip",                            # 7-Zip (file archiver)
        "Brave.Brave",                          # Brave (web browser)
        "Piriform.CCleaner",                    # CCleaner (system optimization)
        "SingularLabs.CCEnhancer",              # CCEnhancer (CCleaner plugin)
        "Discord.Discord",                      # Discord (communication)
        "OliverBetz.ExifTool",                  # ExifTool (metadata editor)
        "voidtools.Everything",                 # Everything (file search)
        "idrassi.HashCheckShellExtension",      # HashCheck (file integrity)
        "DuongDieuPhap.ImageGlass",             # ImageGlass (image viewer)
        "Jellyfin.JellyfinMediaPlayer",         # Jellyfin Media Player (media player)
        "MediaArea.MediaInfo.GUI",              # MediaInfo (media metadata)
        "mpv-player.mpv-CI.MSVC",               # MPV (media player)
        "rcmaehl.MSEdgeRedirect",               # MSEdgeRedirect (browser redirect)
        "Obsidian.Obsidian",                    # Obsidian (note-taking app)
        "Open-Shell.Open-Shell-Menu",           # Open-Shell (Start Menu replacement)
        "Genymobile.scrcpy",                    # scrcpy (Android screen mirroring)
        "ShareX.ShareX",                        # ShareX (screenshot and screen recording)
        "Henry++.simplewall",                   # simplewall (firewall)
        "SpeedCrunch.SpeedCrunch",              # SpeedCrunch (calculator)
        "SumatraPDF.SumatraPDF",                # SumatraPDF (PDF reader)
        "Microsoft.Sysinternals.Suite",         # Sysinternals Suite (system utilities)
        "Devolutions.UniGetUI",                 # UniGetUI (winget GUI)
        "RedHat.VirtViewer",                    # virt-viewer (virtual machine viewer)
        "WinDirStat.WinDirStat",                # WinDirStat (disk usage analyzer)
        "yt-dlp.FFmpeg",                        # FFmpeg (media framework, required for yt-dlp)
        "yt-dlp.yt-dlp",                        # yt-dlp (YouTube downloader)
        # development
        "HeidiSQL.HeidiSQL",                    # HeidiSQL (database manager)
        "KDE.KDiff3",                           # KDiff3 (file and directory diff)
        "Microsoft.PowerShell",                 # PowerShell (terminal and scripting)
        "AngusJohnson.ResourceHacker",          # Resource Hacker (resource editor)
        "koalaman.shellcheck",                  # ShellCheck (shell script linter)
        "SublimeHQ.SublimeText.4",              # Sublime Text (text editor)
        "Microsoft.VisualStudioCode.Insiders",  # Visual Studio Code - Insiders (code editor)
        # gaming
        "Playnite.Playnite",                    # Playnite (game library manager)
        "Amazon.Games",                         # Amazon Games (game launcher)
        "Blizzard.BattleNet",                   # Battle.net (game launcher)
        "ElectronicArts.EADesktop",             # EA Desktop (game launcher)
        "EpicGames.EpicGamesLauncher",          # Epic Games Launcher (game launcher)
        "GOG.Galaxy",                           # GOG Galaxy (game launcher)
        "RockstarGames.Launcher",               # Rockstar Games Launcher (game launcher)
        "Valve.Steam",                          # Steam (game launcher)
        "Ubisoft.Connect",                      # Ubisoft Connect (game launcher)
        # hardware applications/drivers
        "Google.PlatformTools",                 # Android Platform Tools (ADB)
        "ALCPU.CoreTemp",                       # Core Temp (CPU temperature monitoring)
        "Corsair.iCUE.5",                       # Corsair iCUE (RGB lighting control)
        "CPUID.CPU-Z",                          # CPU-Z (system information)
        "CrystalDewWorld.CrystalDiskInfo",      # CrystalDiskInfo (disk health monitoring)
        "File-New-Project.EarTrumpet",          # EarTrumpet (audio manager)
        # security applications
        "KeePassXCTeam.KeePassXC",              # KeePassXC (password manager)
        "Yubico.Authenticator",                 # YubiKey Authenticator (2FA app)
        "Yubico.PIVTool",                       # YubiKey PIV Manager (PIV configuration)
        "Yubico.YubikeyManager"                 # YubiKey Manager (YubiKey configuration)
    )


    <#
     # MSYS2
     #>

    
    # Default MSYS2/Mingw64 Packages to Install
    $script:MsysPkgs = @(
        # Native Git
        "ucrt64/mingw-w64-ucrt-x86_64-{git,git-doc-html,git-doc-man,git-credential-wincred}",
        # Native Windows Utilities
        "ucrt64/mingw-w64-ucrt-x86_64-{imagemagick,lua,pngcrush,sassc,starship,toolchain}",
        # MSYS2 Utilities
        "msys/{colordiff,fish,iperf3,openssh,p7zip,rsync,tmux,unrar,vim}"
    )

    # Default dotfiles GitHub Repository
    $script:DotfilesRepo = "https://github.com/kyau/dotfiles"

    # Default dotfiles script to run after cloning
    $script:DotfilesScript = "./dotme -p vm"


    <#
     # Git
     #>

    # Git - UserName (default: Windows login username)
    $script:UserName = ${Env:UserName}.ToLower()

    # Git - Email Address
    $script:Email = "kyau@kyau.net"

    # Git - GPG Key
    #
    # Run the following command and look for the "sec#" line and get the key
    # listed after the encryption type
    # (ex. "sec#  ed25519/GPG_SHORT_KEY DATE-MM-DD [C]")
    #
    # gpg --list-secret-keys --keyid-format LONG
    $script:GPG_Key = "1F125B5425110CCE"

}

Add-Configuration
