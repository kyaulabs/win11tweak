@ECHO OFF

:: ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
:: █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
:: █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
:: ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
:: █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
:: ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
:: ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀
::
:: Win11Tweaks (KYAU Labs Edition)
:: Copyright (C) 2023 KYAU Labs (https://kyaulabs.com)
::
:: This program is free software: you can redistribute it and/or modify
:: it under the terms of the GNU Affero General Public License as
:: published by the Free Software Foundation, either version 3 of the
:: License, or (at your option) any later version.
::
:: This program is distributed in the hope that it will be useful,
:: but WITHOUT ANY WARRANTY; without even the implied warranty of
:: MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
:: GNU Affero General Public License for more details.
::
:: You should have received a copy of the GNU Affero General Public License
:: along with this program.  If not, see <https://www.gnu.org/licenses/>.

:: Install Agave Terminal Font
PowerShell -Command "$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14); dir Resources/Fonts/*.ttf | %%{ $fonts.CopyHere($_.fullname) }"

:: Enable PowerShell External Script Usage
REG.EXE add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t "REG_SZ" /d "RemoteSigned" /f >nul

:: PowerShell and CMD Theme
PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0Modules\powershell.ps1"
"%~dp0Tools\ColorTool.exe" -b KYAULabs.itermcolors

:: Start Win11Tweaks
start "Win11Tweaks" "%~dp0Modules\defaults.cmd"
exit
