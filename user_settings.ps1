<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win11Tweaks (KYAU Labs Edition)
 Copyright (C) 2022 KYAU Labs (https://kyaulabs.com)

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
    $script:WinDefender = $false

    # Keep Windows Security? ($true/$false)
    $script:SecurityHealth = $true

    # Keep Microsoft 365 / OneDrive ($true/$false)
    $script:Microsoft365 = $false

    # Keep Microsoft Edge? ($true / $false)
    $script:MicrosoftEdge = $true

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
    #         Icon = "%ProgramData%\Windows Icons\drive-network.ico"
    #     },
    #     ...
    # )
    $script:MappedDrives = @(
        [PSCustomObject]@{
            DriveLetter = "N"
            RemotePath = "\\10.0.10.20\archive"
            Name = "ARCHiVE"
            Icon = "%ProgramData%\Windows Icons\drive-network.ico"
        }
    )


    <#
     # Packages
     #>

    # Default Chocolatey Packages to Install
    $script:ChocoPkgs = @(
        # default applications
        "7zip","autoruns","ccleaner","ccenhancer","choco-protocol-support","chocolateygui","exiftool","hashcheck","heidisql",
        "imageglass","kdiff3","marktext","mediainfo","mpv","nfopad","reshack","scrcpy","sharex","simplewall","speedcrunch",
        "sublimetext4","sumatrapdf","sysinternals","virt-viewer","windirstat","yt-dlp",
        # gaming
        "playnite","amazongames","battle.net","epicgameslauncher","goggalaxy","origin","steam","ubisoft-connect",
        # hardware applications/drivers
        "adb","cpu-z.install","eartrumpet","msiafterburner","voicemeeter-potato",
        # security applications
        #"gpg4win"
        "keepassxc","yubico-authenticator","yubikey-manager","yubikey-piv-manager"
    )

    # Default MSYS2/Mingw64 Packages to Install
    $script:MsysPkgs = @(
        "mingw-w64-x86_64-{git,git-doc-html,git-doc-man,starship,toolchain,zstd}",
        "colordiff","fish","openssh","p7zip","rsync","tmux","unrar","vim"
    )


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

