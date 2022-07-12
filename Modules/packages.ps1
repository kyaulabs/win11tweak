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

# Add Chocolatey to PATH
[Environment]::SetEnvironmentVariable('Path', '%USERPROFILE%\AppData\Local\Microsoft\WindowsApps;%ProgramData%\chocolatey', 'User')

# Install Chocolatey Packages
Output-Section -Section "Packages" -Desc "Install Chocolatey"
Start-Process -FilePath "PowerShell.EXE" -ArgumentList "-Command `"Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))`"" -NoNewWindow -Wait -RedirectStandardOutput "${Env:UserProfile}\choco_install.txt"

Output-Section -Section "Packages" -Desc "Install"
Write-Host " " -NoNewline
Start-Process -FilePath "${Env:ProgramData}\chocolatey\bin\CHOCO.EXE" -ArgumentList "install powershell-core --install-arguments=`"ENABLE_PSREMOTING=1`" -y -r" -NoNewWindow -Wait -RedirectStandardOutput "${Env:UserProfile}\choco_install.txt"
Foreach ($pkg in $ChocoPkgs) {
    $ipkg = $pkg
    $runtest = ""
    if ($pkg -eq "sharex" -Or $pkg -eq "simplewall") {
        $runtest = "${Env:SystemRoot}\system32\taskkill.exe /F /IM ${pkg}.exe >nul"
    }
    if ($pkg -eq "amazongames") {
        $pkg = "${pkg} --checksum 49DD00B312A87B9E40695D68D0680360C97189251EE2EF91C8BDABEC40FFFDD7"
        $runtest = "${Env:SystemRoot}\system32\taskkill.exe /F /IM `"Amazon Games UI.exe`" >nul"
    }
    $runcmd = @"
@ECHO OFF

`"%ProgramData%\chocolatey\bin\choco.exe`" install $pkg -y -r >nul
$runtest
"@
    New-Item -Path "${Env:UserProfile}" -Name "runcmd.bat" -ItemType File -Value $runcmd | Out-Null
    Start-Process -FilePath "${Env:UserProfile}\runcmd.bat" -NoNewWindow -Wait
    Remove-Item -Path "${Env:UserProfile}\runcmd.bat" -Force | Out-Null
    #Start-Process -FilePath "${Env:ProgramData}\chocolatey\bin\CHOCO.EXE" -ArgumentList "install $pkg -y -r --ignore-package-codes" -NoNewWindow -Wait -RedirectStandardOutput "${Env:UserProfile}\choco_install.txt"
    Write-Host " : ${ipkg} [1;32m${check}[0m" -NoNewline
    if ($ipkg -eq "amazongames") {

    }
}
Write-Host "`n" -NoNewline

# Change Calculator Keyboard Key to Speedcrunch
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" -Name "ShellExecute" -Type String -Value "%ProgramFiles(x86)%\SpeedCrunch\speedcrunch.exe"

# Cleanup
Remove-Item -Path "${Env:UserProfile}\choco_install.txt" -Force | Out-Null
