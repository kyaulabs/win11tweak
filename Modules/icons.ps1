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

Output-Section -Section "Icons" -Desc "Copying Icon Theme"
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Start" | Out-Null
New-Item -Type Directory -Path "${Env:ProgramData}\Windows Icons\Apps" | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\*.ico -Destination "${Env:ProgramData}\Windows Icons\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\start\*.ico -Destination "${Env:ProgramData}\Windows Icons\Start\" -Force | Out-Null
Copy-Item ${PSScriptRoot}\..\Resources\Icons\apps\*.ico -Destination "${Env:ProgramData}\Windows Icons\Apps\" -Force | Out-Null

Output-Section -Section "Icons" -Desc "System Icons"
# youtube-dl
New-Item -ItemType SymbolicLink -Path "${Env:ProgramData}\chocolatey\lib\mpv.install\tools\youtube-dl.exe" -Target "${Env:ProgramData}\chocolatey\lib\youtube-dl\tools\youtube-dl.exe" | Out-Null
# .gnupg
New-Item -ItemType SymbolicLink -Path ($Env:UserProfile + "\.gnupg") -Target ($Env:AppData + "\gnupg") | Out-Null
$file = "${Env:UserProfile}\.gnupg\desktop.ini"
$text = @"
[.ShellClassInfo]
IconIndex=0
IconResource=%ProgramData%\Windows Icons\folder-gpg.ico,0
ConfirmFileOp=0
DefaultDropEffect=1
"@
New-Item -ItemType File -Path $file -Value $text | Out-Null
Set-ItemProperty $file -Name Attributes -Value "ReadOnly,System,Hidden"
(Get-Item "${Env:UserProfile}\.gnupg").Attributes = "ReadOnly, Directory"
# .ssh
$file = "${Env:UserProfile}\.ssh\desktop.ini"
$text = @"
[.ShellClassInfo]
IconIndex=0
IconResource=%ProgramData%\Windows Icons\folder-private.ico,0
ConfirmFileOp=0
DefaultDropEffect=1
"@
New-Item -ItemType File -Path $file -Value $text | Out-Null
Set-ItemProperty $file -Name Attributes -Value "ReadOnly,System,Hidden"
(Get-Item "${Env:UserProfile}\.ssh").Attributes = "ReadOnly, Directory"
# User Folders
Set-UserFolderIcon -Name "Contacts" -ImageRes 181 -Icon "folder-contacts"
Set-UserFolderIcon -Name "Desktop" -ImageRes 183 -Icon "desktop"
Set-UserFolderIcon -Name "Documents" -ImageRes 112 -Icon "folder-documents"
Set-UserFolderIcon -Name "Downloads" -ImageRes 184 -Icon "folder-downloads"
Set-UserFolderIcon -Name "Favorites" -ImageRes 115 -Icon "folder-favorites"
Set-UserFolderIcon -Name "Links" -ImageRes 185 -Icon "folder-links"
Set-UserFolderIcon -Name "Music" -ImageRes 108 -Icon "folder-music"
Set-UserFolderIcon -Name "Pictures" -ImageRes 113 -Icon "folder-pictures"
Set-UserFolderIcon -Name "Saved Games" -ImageRes 186 -Icon "folder-games"
Set-UserFolderIcon -Name "Searches" -ImageRes 18 -Icon "folder-searches"
Set-UserFolderIcon -Name "Videos" -ImageRes 189 -Icon "folder-videos"
New-Item -ItemType SymbolicLink -Path ($Env:UserProfile + "\Documents\My Games") -Target ($Env:UserProfile + "\Saved Games") | Out-Null
# Desktop
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
Add-Reg -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\Windows Icons\desktop.ico"
Add-Reg -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\Windows Icons\desktop.ico"
# This PC
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\computer.ico"
# Recycle Bin
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "empty" -Type ExpandString -Value "%ProgramData%\Windows Icons\recycle.ico"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "full" -Type ExpandString -Value "%ProgramData%\Windows Icons\recycle-full.ico"
# Network
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\network.ico"
# Navigation Pane - Show All folders
Add-Reg -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneShowAllFolders" -Type Dword -Value "1"
# Navigation Pane - Remove Quick Access
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Type Dword -Value "1"
# Navigation Pane - Remove Libraries from Desktop
Del-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}"
# Control Panel
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\settings.ico"
# User Files
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\folder-home.ico"
# System Drive
$SysDrive = "${Env:SystemDrive}".Substring(0,1)
Add-Reg -Path "HKCU:\Software\Classes\Applications"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon"
Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\drive-win10.ico"
