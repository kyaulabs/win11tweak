@ECHO OFF

:: ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
:: █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
:: █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
:: ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
:: █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
:: ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
:: ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀
::
:: Win10Tweaks (KYAU Labs Edition)
:: Copyright (C) 2020 KYAU Labs (https://kyaulabs.com)
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

PowerShell -Command "$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14); dir Resources/Fonts/*.ttf | %%{ $fonts.CopyHere($_.fullname) }"
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "CodePage" /t "REG_DWORD" /d 65001 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "CodePage" /t "REG_DWORD" /d 65001 /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Command Processor" /v "AutoRun" /t "REG_SZ" /d "@chcp 65001>nul" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "FaceName" /t "REG_SZ" /d "Agave" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "FontWeight" /t "REG_DWORD" /d 400 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_system32_cmd.exe" /v "FontFamily" /t "REG_DWORD" /d 54 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "FaceName" /t "REG_SZ" /d "Agave" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "FontWeight" /t "REG_DWORD" /d 400 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_System32_WindowsPowerShell_v1.0_powershell.exe" /v "FontFamily" /t "REG_DWORD" /d 54 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "FaceName" /t "REG_SZ" /d "Agave" /f >nul
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "FontWeight" /t "REG_DWORD" /d 400 /f >nul
reg add "HKCU\Console\%%SystemRoot%%_SysWOW64_WindowsPowerShell_v1.0_powershell.exe" /v "FontFamily" /t "REG_DWORD" /d 54 /f >nul
reg add "HKCU\Console" /v "FontSize" /t "REG_DWORD" /d 1179648 /f >nul
reg add "HKCU\Software\Microsoft\Notepad" /v "lfFaceName" /t "REG_SZ" /d "Agave" /f >nul
"%~dp0Tools\ColorTool.exe" -b KYAULabs.itermcolors
chcp 65001
MODE CON COLS=80 LINES=25

"%~dp0Modules\defaults.cmd"
