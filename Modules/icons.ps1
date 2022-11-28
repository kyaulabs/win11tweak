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

Show-Section -Section "Icons" -Desc "Copying Icon Theme"
<#
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Apps" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Emblems" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Hardware" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Mimetypes" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Places" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Start" | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Apps\*.ico -Destination "${Env:ProgramData}\Windows Icons\Apps\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Emblems\*.ico -Destination "${Env:ProgramData}\Windows Icons\Emblems\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Hardware\*.ico -Destination "${Env:ProgramData}\Windows Icons\Hardware\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Mimetypes\*.ico -Destination "${Env:ProgramData}\Windows Icons\Mimetypes\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Places\*.ico -Destination "${Env:ProgramData}\Windows Icons\Places\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\Start\*.ico -Destination "${Env:ProgramData}\Windows Icons\Start\" -Force | Out-Null
#>
Copy-Item ${PSScriptRoot}\..\Resources\Icons\*.dll -Destination "${Env:ProgramData}" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\*.ico -Destination "${Env:ProgramData}" -Force | Out-Null

Show-Section -Section "Icons" -Desc "System Icons"
# youtube-dl
New-Item -ItemType SymbolicLink -Path "${Env:ProgramData}\chocolatey\lib\mpv.install\tools\yt-dlp.exe" -Target "${Env:ProgramData}\chocolatey\lib\yt-dlp\tools\x64\yt-dlp.exe" | Out-Null

# User Folders
Set-UserFolderIcon -Name "Contacts" -ImageRes 181 -Icon 73 #"folder-blue-public"
Set-UserFolderIcon -Name "Desktop" -ImageRes 183 -Icon 52 #"folder-blue-desktop"
Set-UserFolderIcon -Name "Documents" -ImageRes 112 -Icon 54 #"folder-blue-documents"
Set-UserFolderIcon -Name "Downloads" -ImageRes 184 -Icon 55 #"folder-blue-download"
Set-UserFolderIcon -Name "Favorites" -ImageRes 115 -Icon 56 #"folder-blue-favorites"
Set-UserFolderIcon -Name "Links" -ImageRes 185 -Icon 86 #"folder-blue-web"
Set-UserFolderIcon -Name "Music" -ImageRes 108 -Icon 66 #"folder-blue-music"
Set-UserFolderIcon -Name "Pictures" -ImageRes 113 -Icon 63 #"folder-blue-images"
Set-UserFolderIcon -Name "Saved Games" -ImageRes 186 -Icon 57 #"folder-blue-games"
Set-UserFolderIcon -Name "Searches" -ImageRes 18 -Icon 75 #"folder-blue-saved-search"
Set-UserFolderIcon -Name "Videos" -ImageRes 189 -Icon 83 #"folder-blue-video"
New-Item -ItemType SymbolicLink -Path ($Env:UserProfile + "\Documents\My Games") -Target ($Env:UserProfile + "\Saved Games") | Out-Null
# Desktop
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
Add-Reg -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\win11tweak-places.dll,52"
Add-Reg -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\win11tweak-places.dll,52"
# This PC
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\win11tweak-hardware.dll,45"
# Recycle Bin
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "empty" -Type ExpandString -Value "%ProgramData%\win11tweak-places.dll,87"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "full" -Type ExpandString -Value "%ProgramData%\win11tweak-places.dll,88"
# Network
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\win11tweak-apps.dll,835"
# Navigation Pane - Show All folders
Add-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneShowAllFolders" -Type Dword -Value "1"
# Navigation Pane - Remove Quick Access
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Type Dword -Value "1"
# Navigation Pane - Remove Libraries from Desktop
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}"
# Control Panel
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\win11tweak-apps.dll,155"
# User Files
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\win11tweak-places.dll,62"
# System Drive
$SysDrive = "${Env:SystemDrive}".Substring(0,1)
Add-Reg -Path "HKCU:\Software\Classes\Applications"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\win11tweak-hardware.dll,73"
