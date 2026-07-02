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

#. "${PSScriptRoot}\_funcs.ps1"

Show-Section -Section "StartMenu" -Desc "Creating Folders"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Type Dword -Value "1"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAl" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarMn" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarSi" -Type Dword -Value "1"
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\AdobeCC" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Apps" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\BBS" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Creative" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Development" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Games" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Hardware" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Media" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\MSOffice" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\Utilities" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\SSH-Local" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\SSH-Remote" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\RDP-Local" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\RDP-Remote" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Start\RTSP-Local" | Out-Null

Show-Section -Section "StartMenu" -Desc "Creating Shortcuts"
# Add-Shortcut "SubMenu\Application OR Startup" "target.exe" "icon-name" "arguments" "working-directory"
Add-Shortcut "Apps\Brave" "${Env:LocalAppData}\BraveSoftware\Brave-Browser\Application\brave.exe" ""
Add-Shortcut "Apps\Discord" "%LocalAppData%\Discord\Update.exe" "%LocalAppData%\Discord\app.ico" "--processStart Discord.exe"
Add-Shortcut "Apps\Everything" "${Env:ProgramFiles}\Everything\Everything.exe" "win11tweak-apps.dll,537"
Add-Shortcut "Apps\SumatraPDF" "${Env:ProgramFiles}\SumatraPDF\SumatraPDF.exe" "win11tweak-apps.dll,449"
Add-Shortcut "Apps\KeePassXC" "${Env:ProgramFiles}\KeePassXC\KeePassXC.exe" "win11tweak-apps.dll,621"
Add-Shortcut "Apps\Yubico Authenticator" "${Env:ProgramFiles}\Yubico\Yubico Authenticator\authenticator.exe" "win11tweak-apps.dll,1363"
Add-Shortcut "Apps\Yubico Manager" "${Env:ProgramFiles}\Yubico\YubiKey Manager\ykman-gui.exe" "win11tweak-apps.dll,1361"
Add-Shortcut "Apps\Yubico PIV Manager" "${Env:ProgramFiles(x86)}\Yubico\YubiKey PIV Manager\pivman.exe" "win11tweak-apps.dll,1362"
Add-Shortcut "Creative\Obsidian" "${Env:LocalAppData}\Programs\Obsidian\Obsidian.exe" ""
Add-Shortcut "Development\HeidiSQL" "${Env:LocalAppData}\Programs\HeidiSQL\heidisql.exe" "win11tweak-apps.dll,1113"
Add-Shortcut "Development\KDiff3" "${Env:LocalAppData}\Programs\KDiff3\bin\kdiff3.exe" "win11tweak-apps.dll,619"
Add-Shortcut "Development\Resource Hacker" "${Env:ProgramFiles(x86)}\Resource Hacker\ResourceHacker.exe" "win11tweak-apps.dll,1175"
Add-Shortcut "Development\Sublime Text" "${Env:ProgramFiles}\Sublime Text\sublime_text.exe" ""
Add-Shortcut "Development\Visual Studio Code" "${Env:LocalAppData}\Programs\Microsoft VS Code Insiders\Code - Insiders.exe" ""
Add-Shortcut "Hardware\Core Temp" "${Env:ProgramFiles}\Core Temp\Core Temp.exe" "win11tweak-hardware.dll,138"
Add-Shortcut "Hardware\CPU-Z" "${Env:ProgramFiles}\CPUID\CPU-Z\cpuz.exe" ""
Add-Shortcut "Hardware\ScrCpy" "${Env:ProgramFiles}\WinGet\Packages\Genymobile.scrcpy_Microsoft.Winget.Source_8wekyb3d8bbwe\scrcpy.exe" "win11tweak-hardware.dll,3"
Add-Shortcut "Media\ImageGlass" "${Env:ProgramFiles}\ImageGlass\ImageGlass.exe" ""
Add-Shortcut "Media\Jellyfin Media Player" "${Env:ProgramFiles}\Jellyfin\Jellyfin Media Player\jellyfinmediaplayer.exe" ""
Add-Shortcut "Media\MPV" "${Env:LocalAppData}\Microsoft\WinGet\Packages\mpv-player.mpv-CI.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe\mpv.exe" "win11tweak-apps.dll,788"
Add-Shortcut "RDP-Local\archlinux.machine" "${Env:ProgramFiles}\VirtViewer v11.0-256\bin\remote-viewer.exe" "win11tweak-apps.dll,1005" "spice://archlinux.machine:5900"
Add-Shortcut "RDP-Local\debian.machine" "${Env:ProgramFiles}\VirtViewer v11.0-256\bin\remote-viewer.exe" "win11tweak-apps.dll,1007" "spice://debian.machine:5900"
Add-Shortcut "RDP-Local\windows.machine" "${Env:ProgramFiles}\VirtViewer v11.0-256\bin\remote-viewer.exe" "win11tweak-apps.dll,1015" "spice://windows.machine:5900"
Add-Shortcut "SSH-Local\test.machine" "${Env:ProgramFiles}\Bin\ssh.bat" "win11tweak-apps.dll,1119" "test.machine 0"
Add-Shortcut "SSH-Remote\test.machine.com" "${Env:ProgramFiles}\Bin\ssh.bat" "win11tweak-apps.dll,1120" "test.machine.com 1"
Add-Shortcut "Utilities\7-Zip File Manager" "${Env:ProgramFiles}\7-zip\7zFM.exe" "win11tweak-apps.dll,371"
Add-Shortcut "Utilities\Autoruns" "${Env:LocalAppData}\Microsoft\WinGet\Packages\Microsoft.Sysinternals.Suite_Microsoft.Winget.Source_8wekyb3d8bbwe\Autoruns64.exe" ""
Add-Shortcut "Utilities\CCEnhancer" "${Env:ProgramFiles(x86)}\CCEnhancer\CCEnhancer.exe" ""
Add-Shortcut "Utilities\CCleaner" "${Env:ProgramFiles}\Piriform\CCleaner 7\CCleaner.exe" ""
Add-Shortcut "Utilities\MSEdgeRedirect" "${Env:ProgramFiles}\MSEdgeRedirect\MSEdgeRedirect.exe" "" "/settings"
Add-Shortcut "Utilities\Process Explorer" "${Env:LocalAppData}\Microsoft\WinGet\Packages\Microsoft.Sysinternals.Suite_Microsoft.Winget.Source_8wekyb3d8bbwe\procexp64.exe" ""
Add-Shortcut "Utilities\ShareX" "${Env:ProgramFiles}\ShareX\ShareX.exe" ""
Add-Shortcut "Utilities\SimpleWall" "${Env:ProgramFiles}\simplewall\simplewall.exe" ""
Add-Shortcut "Utilities\SpeedCrunch" "${Env:ProgramFiles(x86)}\SpeedCrunch\speedcrunch.exe" ""
Add-Shortcut "Utilities\UniGetUI" "${Env:LocalAppData}\Programs\UniGetUI\UniGetUI.exe" ""
Add-Shortcut "Utilities\WinDirStat" "${Env:ProgramFiles(x86)}\WinDirStat\windirstat.exe" "win11tweak-hardware.dll,69"

# Remove Startup / Add Postfix
Remove-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "CCleaner Smart Cleaning"
Remove-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "KeePassXC"
$edgerun = Get-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | Select-Object -ExpandProperty Property | Where-Object { $_ -like "MicrosoftEdgeAutoLaunch*" }
Remove-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $edgerun
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "PostFix" -Type String -Value "`"${PSScriptRoot}\postfix.cmd`""

# Shrink Search Button
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "SearchboxTaskbarMode" -Type Dword -Value "3"

Show-Section -Section "User" -Desc "Environment Variables"
# Modify PATH
$pathsToAdd = @(
    "${Env:SystemDrive}\msys64\ucrt64\bin",
    "${Env:SystemDrive}\msys64\bin",
    "${Env:SystemDrive}\msys64\usr\bin",
    "${Env:SystemDrive}\msys64\usr\local\bin",
    "${Env:SystemDrive}\msys64\opt\bin",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\Google.PlatformTools_Microsoft.Winget.Source_8wekyb3d8bbwe\platform-tools",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\koalaman.shellcheck_Microsoft.Winget.Source_8wekyb3d8bbwe",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\Microsoft.Sysinternals.Suite_Microsoft.Winget.Source_8wekyb3d8bbwe",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\mpv-player.mpv-CI.MSVC_Microsoft.Winget.Source_8wekyb3d8bbwe",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\yt-dlp.FFmpeg_Microsoft.Winget.Source_8wekyb3d8bbwe\ffmpeg-N-124279-g0f6ba39122-win64-gpl\bin",
    "${Env:LocalAppData}\Microsoft\WinGet\Packages\yt-dlp.yt-dlp_Microsoft.Winget.Source_8wekyb3d8bbwe"
)
Add-ToUserPath -Paths $pathsToAdd -RefreshSession
[Environment]::SetEnvironmentVariable("SSH_AUTH_SOCK", "${Env:UserProfile}\.gnupg\S.gpg-agent.ssh", "User")
