<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win10Tweaks (KYAU Labs Edition)
 Copyright (C) 2020 KYAU Labs (https://kyaulabs.com)

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

# 3D Objects
$file = "${env:USERPROFILE}\3D Objects\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-198","IconResource=%ProgramData%\Windows Icons\folder-3dobjects.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Contacts
$file = "${env:USERPROFILE}\Contacts\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-181","IconResource=%ProgramData%\Windows Icons\folder-contacts.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Desktop
$file = "${env:USERPROFILE}\Desktop\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-183","IconResource=%ProgramData%\Windows Icons\desktop.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Documents
$file = "${env:USERPROFILE}\Documents\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-112","IconResource=%ProgramData%\Windows Icons\folder-documents.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Downloads
$file = "${env:USERPROFILE}\Downloads\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-184","IconResource=%ProgramData%\Windows Icons\folder-downloads.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Favorites
$file = "${env:USERPROFILE}\Favorites\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-115","IconResource=%ProgramData%\Windows Icons\folder-favorites.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Links
$file = "${env:USERPROFILE}\Links\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-185","IconResource=%ProgramData%\Windows Icons\folder-links.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Music
$file = "${env:USERPROFILE}\Music\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-108","IconResource=%ProgramData%\Windows Icons\folder-music.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Pictures
$file = "${env:USERPROFILE}\Pictures\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-113","IconResource=%ProgramData%\Windows Icons\folder-pictures.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Saved Games
$file = "${env:USERPROFILE}\Saved Games\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-186","IconResource=%ProgramData%\Windows Icons\folder-games.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Searches
$file = "${env:USERPROFILE}\Searches\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-18","IconResource=%ProgramData%\Windows Icons\folder-searches.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Videos
$file = "${env:USERPROFILE}\Videos\desktop.ini"
ATTRIB -H -S $file
CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-189","IconResource=%ProgramData%\Windows Icons\folder-videos.ico"} | Out-File ${file}2
Move-Item -Path "${file}2" -Destination "$file" -Force
ATTRIB +H +S $file
# Desktop
If (!(Test-Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons")) {
    New-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Force | Out-Null
}
If (!(Test-Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons")) {
    New-Item -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Force | Out-Null
}
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\Windows Icons\desktop.ico" -Force | Out-Null
Set-ItemProperty -Path "HKLM:\SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Explorer\Shell Icons" -Name "34" -Type String "%ProgramData%\Windows Icons\desktop.ico" -Force | Out-Null
# This PC
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{20D04FE0-3AEA-1069-A2D8-08002B30309D}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\computer.ico" -Force | Out-Null
# Recycle Bin
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "empty" -Type ExpandString -Value "%ProgramData%\Windows Icons\recycle.ico" -Force | Out-Null
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\DefaultIcon" -Name "full" -Type ExpandString -Value "%ProgramData%\Windows Icons\recycle-full.ico" -Force | Out-Null
# Network
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{F02C1A0D-BE21-4350-88B0-7367FC96EF3C}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\network.ico" -Force | Out-Null
# Navigation Pane - Show All folders
Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "NavPaneShowAllFolders" -Type Dword -Value "1" -Force | Out-Null
# Navigation Pane - Remove Quick Access
Set-ItemProperty -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "HubMode" -Type Dword -Value "1" -Force | Out-Null
# Navigation Pane - Remove Libraries from Desktop
Remove-Item -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace\{031E4825-7B94-4dc3-B131-E946B44C8DD5}" -ErrorAction SilentlyContinue -Force | Out-Null
# Control Panel
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{26EE0668-A00A-44D7-9371-BEB064C98683}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\settings.ico" -Force | Out-Null
# User Files
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon")) {
    New-Item -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\CLSID\{59031A47-3F72-44A7-89C5-5595FE6B30EE}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\folder-home.ico" -Force | Out-Null
# System Drive
$SysDrive = "${env:SystemDrive}".Substring(0,1)
If (!(Test-Path "HKCU:\Software\Classes\Applications")) {
    New-Item -Path "HKCU:\Software\Classes\Applications" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Classes\Applications\Explorer.exe")) {
    New-Item -Path "HKCU:\Software\Classes\Applications\Explorer.exe" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives")) {
    New-Item -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}")) {
    New-Item -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}" -Force | Out-Null
}
If (!(Test-Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon")) {
    New-Item -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon" -Force | Out-Null
}
Set-ItemProperty -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${SysDrive}\DefaultIcon" -Name "(Default)" -Type String -Value "%ProgramData%\Windows Icons\drive-win10.ico" -Force | Out-Null
