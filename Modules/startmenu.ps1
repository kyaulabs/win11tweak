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

#. "${PSScriptRoot}\_funcs.ps1"

Output-Section -Section "StartMenu" -Desc "Creating Folders"
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

Output-Section -Section "StartMenu" -Desc "Creating Shortcuts"
# Add-Shortcut "SubMenu\Application OR Startup" "target.exe" "icon-name" "arguments" "working-directory"
Add-Shortcut "Apps\Brave" "${Env:ProgramFiles}\BraveSoftware\Brave-Browser\Application\brave.exe" ""
Add-Shortcut "Apps\SumatraPDF" "${Env:ProgramFiles}\SumatraPDF\SumatraPDF.exe" "gnome-books"
Add-Shortcut "Apps\KeePassXC" "${Env:ProgramFiles}\KeePassXC\KeePassXC.exe" "keepassxc"
Add-Shortcut "Apps\Kleopatra" "${Env:ProgramFiles(x86)}\gpg4win\bin\kleopatra.exe" ""
Add-Shortcut "Apps\Yubico Authenticator" "${Env:ProgramFiles}\Yubico\Yubico Authenticator\yubioath-desktop.exe" "yubioath"
Add-Shortcut "Apps\Yubico Manager" "${Env:ProgramFiles}\Yubico\YubiKey Manager\ykman-gui.exe" "yubikey-personalization-gui"
Add-Shortcut "Apps\Yubico PIV Manager" "${Env:ProgramFiles}\Yubico\YubiKey PIV Manager\pivman.exe" "yubikey-piv-manager"
Add-Shortcut "Development\HeidiSQL" "${Env:ProgramFiles}\HeidiSQL\heidisql.exe" "sqlninja"
Add-Shortcut "Development\KDiff3" "${Env:ProgramFiles}\KDiff3\kdiff3.exe" "kdiff3"
Add-Shortcut "Development\MarkText" "${Env:LocalAppData}\Programs\MarkText\MarkText.exe" ""
Add-Shortcut "Development\Resource Hacker" "${Env:ProgramFiles(x86)}\Resource Hacker\ResourceHacker.exe" "teighaviewer"
Add-Shortcut "Development\Sublime Text" "${Env:ProgramFiles}\Sublime Text\sublime_text.exe" ""
Add-Shortcut "Hardware\CPU-Z" "${Env:ProgramFiles}\CPUID\CPU-Z\cpuz.exe" ""
Add-Shortcut "Hardware\EarTrumpet" "${Env:ProgramData}\chocolatey\lib\eartrumpet\tools\EarTrumpet\EarTrumpet.exe" ""
Add-Shortcut "Hardware\MSI Afterburner" "${Env:ProgramFiles(x86)}\MSI Afterburner\MSIAfterburner.exe" ""
Add-Shortcut "Hardware\ScrCpy" "${Env:ProgramData}\chocolatey\lib\scrcpy\tools\scrcpy.exe" "android-file-transfer"
Add-Shortcut "Hardware\Voicemeeter Potato" "${Env:ProgramFiles(x86)}\VB\Voicemeeter\voicemeeter8x64.exe" ""
Add-Shortcut "Media\ImageGlass" "${Env:ProgramFiles}\ImageGlass\ImageGlass.exe" ""
Add-Shortcut "Media\MPV" "${Env:ProgramData}\chocolatey\lib\mpv.install\tools\mpv.exe" "mpv"
Add-Shortcut "RDP-Local\archlinux.machine" "${Env:ProgramFiles}\VirtViewer v10.0-256\bin\remote-viewer.exe" "distributor-logo-archlinux" "spice://archlinux.machine:5900"
Add-Shortcut "RDP-Local\debian.machine" "${Env:ProgramFiles}\VirtViewer v10.0-256\bin\remote-viewer.exe" "distributor-logo-debian" "spice:/-Valueebian.machine:5900"
Add-Shortcut "RDP-Local\windows.machine" "${Env:ProgramFiles}\VirtViewer v10.0-256\bin\remote-viewer.exe" "codeblocks" "spice://windows.machine:5900"
Add-Shortcut "SSH-Local\test.machine" "${Env:ProgramFiles}\Bin\ssh.bat" "urxvt" "test.machine 0"
Add-Shortcut "SSH-Remote\test.machine.com" "${Env:ProgramFiles}\Bin\ssh.bat" "urxvt" "test.machine.com 1"
Add-Shortcut "Startup" "`"%ProgramFiles%\Bin\gpg-forward.bat`"" "GPG Bridge"
Add-Shortcut "Utilities\7-Zip File Manager" "${Env:ProgramFiles}\7-zip\7zFM.exe" "file-roller"
Add-Shortcut "Utilities\Autoruns" "${Env:ProgramData}\chocolatey\lib\AutoRuns\tools\Autoruns.exe" "bomber"
Add-Shortcut "Utilities\CCEnhancer" "${Env:ProgramFiles(x86)}\CCEnhancer\CCEnhancer.exe" ""
Add-Shortcut "Utilities\CCleaner" "${Env:ProgramFiles}\CCleaner\CCleaner64.exe" ""
Add-Shortcut "Utilities\Chocolatey GUI" "${Env:ProgramFiles(x86)}\Chocolatey GUI\ChocolateyGui.exe" ""
Add-Shortcut "Utilities\Core Temp" "${Env:ProgramData}\chocolatey\lib\coretemp\tools\Core Temp.exe" "thermal-monitor"
Add-Shortcut "Utilities\NFOPad" "${Env:ProgramFiles(x86)}\NFOPad\NFOPad.exe" ""
Add-Shortcut "Utilities\ShareX" "${Env:ProgramFiles}\ShareX\ShareX.exe" ""
Add-Shortcut "Utilities\SimpleWall" "${Env:ProgramFiles}\simplewall\simplewall.exe" ""
Add-Shortcut "Utilities\WinDirStat" "${Env:ProgramFiles(x86)}\WinDirStat\windirstat.exe" "partitionmanager"

# Remove Startup / Add Postfix
Del-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "KeePassXC"
$edgerun = Get-Item -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" | Select-Object -ExpandProperty Property | where { $_ -like "MicrosoftEdgeAutoLaunch*" }
Del-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name $edgerun
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "PostFix" -Type String -Value "`"${PSScriptRoot}\postfix.cmd`""