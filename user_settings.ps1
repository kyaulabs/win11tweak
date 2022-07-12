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

<#
 # Windows Defaults
 #>

# Computer Name
$ComputerName = "WIN11TWEAK"

# Network WorkGroup
$WorkGroupName = "KYAULABS"

# Keep Windows Defender? ($true / $false)
$WinDefender = $false

# Keep Windows Security? ($true/$false)
$SecurityHealth = $true

# Keep Microsoft 365 / OneDrive ($true/$false)
$Microsoft365 = $false

# Desktop / Lock Screen Wallpaper
$WallpaperPath = "${Env:WINDIR}\Web\4K\Wallpaper\Windows\img19_1920x1200.jpg"
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
$MappedDrives = @(
    [PSCustomObject]@{
        DriveLetter = "N"
        RemotePath = "\\10.0.10.20\archive"
        Name = "ARCHiVE"
        Icon = "%ProgramData%\Windows Icons\drive-network.ico"
    }
)


<#
 # Chocolatey
 #>

# Default Packages to Install
$ChocoPkgs = @(
    # default applications
    "7zip","autoruns","ccleaner","ccenhancer","choco-protocol-support","chocolateygui","exiftool","hashcheck","heidisql",
    "imageglass","kdiff3","mediainfo","mpv","nfopad","reshack","scrcpy","sharex","simplewall","speedcrunch",
    "sublimetext4","sumatrapdf","sysinternals","virt-viewer","windirstat","yt-dlp",
    # gaming
    "playnite","amazongames","battle.net","epicgameslauncher","goggalaxy","origin","steam","ubisoft-connect",
    # hardware applications/drivers
    "adb","cpu-z.install","ddu","eartrumpet","msiafterburner","voicemeeter-potato",
    # security applications
    "gpg4win","git","keepassxc","yubico-authenticator","yubikey-manager","yubikey-piv-manager"
)


<#
 # Git
 #>

# Git - UserName (default: Windows login username)
$UserName = ${Env:UserName}.ToLower()

# Git - Email Address
$Email = "kyau@kyau.net"

# Git - GPG Key
#
# Run the following command and look for the "sec#" line and get the key 
# listed after the encryption type
# (ex. "sec#  ed25519/GPG_SHORT_KEY DATE-MM-DD [C]")
#
# gpg --list-secret-keys --keyid-format LONG
$GPG_Key = "1F125B5425110CCE"
