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

. "${PSScriptRoot}\_funcs.ps1"

# Map All Network Drives
Output-Section -Section "Network" -Desc "Mapped Drives"
Foreach ($drive in $MappedDrives) {
    $Letter = $drive.DriveLetter
    $RemotePath = $drive.RemotePath
    $Name = $drive.Name
    $Icon = $drive.Icon
    if ($RemotePath) {
        Add-Reg -Path "HKCU:\Network\${Letter}"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "ConnectionType" -Type Dword -Value "0"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "DeferFlags" -Type Dword -Value "4"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "ProviderName" -Type String -Value "Microsoft Windows Network"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "ProviderType" -Type Dword -Value "131072"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "RemotePath" -Type String -Value "${RemotePath}"
        Add-Reg -Path "HKCU:\Network\${Letter}" -Name "UserName" -Type Dword -Value "0"
    }

    $sh = New-Object -com Shell.Application
    $sh.NameSpace($Letter+':').Self.Name = ${Name}
    if ($Icon) {
        Add-Reg -Path "HKCU:\Software\Classes\Applications"
        Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe"
        Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives"
        Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${Letter}"
        Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${Letter}\DefaultIcon"
        Add-Reg -Path "HKCU:\Software\Classes\Applications\Explorer.exe\Drives\${Letter}\DefaultIcon" -Name "(Default)" -Type String -Value ${Icon}
    }
}
