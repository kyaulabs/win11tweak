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

Add-Reg -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -Name "CodePage" -Type Dword -Value 65001
Add-Reg -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -Name "CodePage" -Type Dword -Value 65001
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Command Processor" -Name "AutoRun" -Type String -Value "@chcp 65001>nul"
Add-Reg -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -Name "FaceName" -Type String -Value "Agave"
Add-Reg -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -Name "FontWeight" -Type Dword -Value 400
Add-Reg -Path "HKCU:\Console\%SystemRoot%_System32_WindowsPowerShell_v1.0_powershell.exe" -Name "FontFamily" -Type Dword -Value 54
Add-Reg -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -Name "FaceName" -Type String -Value "Agave"
Add-Reg -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -Name "FontWeight" -Type Dword -Value 400
Add-Reg -Path "HKCU:\Console\%SystemRoot%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" -Name "FontFamily" -Type Dword -Value 54
Add-Reg -Path "HKCU:\Console" -Name "FaceName" -Type String -Value "Agave"
Add-Reg -Path "HKCU:\Console" -Name "FontFamily" -Type Dword -Value 54
Add-Reg -Path "HKCU:\Console" -Name "FontSize" -Type Dword -Value 1179648
Add-Reg -Path "HKCU:\Console" -Name "FontWeight" -Type Dword -Value 400
Add-Reg -Path "HKCU:\Software\Microsoft\Notepad" -Name "lfFaceName" -Type String -Value "Agave"
