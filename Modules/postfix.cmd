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
:: Copyright (C) 2022 KYAU Labs (https://kyaulabs.com)
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

:: Check privileges 
net file 1>NUL 2>NUL
if not '%errorlevel%' == '0' (
    powershell Start-Process -FilePath "%0" -ArgumentList "%cd%" -verb runas >NUL 2>&1
    exit /b
)

:: Change directory with passed argument. Processes started with
:: "runas" start with forced C:\Windows\System32 workdir
cd /d %~dp0

:: Script
ECHO [1;36m■[1;37m PostFix:[0m Terminating Explorer.exe...
taskkill /F /IM explorer.exe >nul

ECHO [1;36m■[1;37m PostFix:[0m This Window Will Close When Finished
PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0cleanup.ps1"

::MOVE /Y %UserProfile%\Contacts\desktop.ini2 %UserProfile%\Contacts\desktop.ini
ECHO [1;36m■[1;37m PostFix:[0m Install Typora
%UserProfile%\Desktop\typora-update-x64-1117.exe /VERYSILENT /SUPPRESSMSGBOXES /NORESTART /SP-
IF EXIST "%ProgramFiles(x86)%\RivaTuner Statistics Server\Uninstall.exe" (
	ECHO [1;36m■[1;37m PostFix:[0m Remove RivaTuner
	"%ProgramFiles(x86)%\RivaTuner Statistics Server\Uninstall.exe" /S /SUPPRESSMSGBOXES
	RD "%ProgramFiles(x86)%\RivaTuner Statistics Server" /Q /S /NO >nul
)
DEL /F /Q %UserProfile%\Desktop\typora-update-x64-1117.exe
taskkill /F /IM typora.exe >nul
REG DELETE "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "PostFix" /F >nul
ECHO [1;36m■[1;37m PostFix:[0m Restarting Explorer.exe
start explorer.exe

ECHO [37m [0m
ECHO [37mPress any key to exit...[0m
PAUSE >nul
exit