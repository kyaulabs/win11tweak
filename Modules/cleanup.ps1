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

$Location = Get-Location

Show-Logo "Windows 11 Tweaks"

Show-Section -Section "PostFix" -Desc "Terminating Explorer.EXE!"
Start-Process -FilePath "${Env:WinDir}\System32\taskkill.exe" -ArgumentList "/F /IM explorer.exe" -Wait

Show-Section -Section "PostFix" -Desc "This Window Will Close When Finished"

If (-NOT $MicrosoftEdge) {
    # Disable Microsoft Edge
    . "${PSScriptRoot}\msedge.ps1"
}

# Remove Windows Defender
. "${PSScriptRoot}\defender.ps1"

# Mapped Network Drives
. "${PSScriptRoot}\mapdrives.ps1"

# ScheduledTask: Mapped Network Drives
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "NoLogo -NoProfile -ExecutionPolicy Bypass -File `"${PSScriptRoot}\mapdrives.ps1"`"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty UserName)
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask KL_MapDrives -InputObject $task | Out-Null
Start-ScheduledTask -TaskName KL_MapDrives | Out-Null
Start-Sleep -Seconds 10 | Out-Null
Unregister-ScheduledTask -TaskName KL_MapDrives -Confirm:$false | Out-Null

# ScheduledTask: Remove Windows Defender Tasks
If (-NOT $WinDefender) {
    $windefend = @"
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='WdNisSvc'" | Out-Null
If (-NOT ($null -eq $Service)) {
    $Service.Delete() | Out-Null
}
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='WinDefend'" | Out-Null
If (-NOT ($null -eq $Service)) {
    $Service.Delete() | Out-Null
}
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='Sense'" | Out-Null
If (-NOT ($null -eq $Service)) {
    $Service.Delete() | Out-Null
}
Unregister-ScheduledTask -TaskName "Windows Defender Cache Maintenance" -Confirm:$false
Unregister-ScheduledTask -TaskName "Windows Defender Cleanup" -Confirm:$false
Unregister-ScheduledTask -TaskName "Windows Defender Scheduled Scan" -Confirm:$false
Unregister-ScheduledTask -TaskName "Windows Defender Verification" -Confirm:$false
"@
    New-Item -ItemType File -Path "${Env:SystemRoot}\" -Name "windefend.ps1" -Value $windefend | Out-Null
    $action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "NoLogo -NoProfile -ExecutionPolicy Bypass -File `"${Env:SystemRoot}\windefend.ps1"`"
    $trigger = New-ScheduledTaskTrigger -AtLogOn
    $principal = New-ScheduledTaskPrincipal -GroupId "BUILTIN\Administrators" -RunLevel Highest
    $task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
    Register-ScheduledTask KL_WinDefendRemoval -InputObject $task | Out-Null
    Start-ScheduledTask -TaskName KL_WinDefendRemoval | Out-Null
}

# Remove Git from right-click
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_gui" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_shell" -Recursive

# Download Brave
Show-Section -Section "Cleanup" -Desc "Download Brave"
Invoke-WebRequest https://laptop-updates.brave.com/latest/winx64 -OutFile ${Env:UserProfile}\Desktop\BraveSetup.exe | Out-Null

# Download OpenShell
Show-Section -Section "Cleanup" -Desc "Download OpenShell"
Invoke-WebRequest https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe -OutFile ${Env:UserProfile}\Desktop\OpenShellSetup.exe | Out-Null

Show-Section -Section "Cleanup" -Desc "Last Minute Removals"
If (-NOT $WinDefender) {
    Remove-WService -Name "WinDefend"
    Remove-WService -Name "Sense"
}
Remove-WService -Name "XblAuthManager"
Remove-WService -Name "XblGameSave"
Remove-WService -Name "XboxNetApiSvc"
Remove-WService -Name "XboxGipSvc"

If (-NOT $Microsoft365) {
    Remove-Item "${Env:UserProfile}\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:LocalAppData}\Microsoft\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:ProgramData}\Microsoft OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:SystemDrive}\OneDriveTemp" -Recurse -Force -ErrorAction:SilentlyContinue

    $onedrivetask = Get-ScheduledTask | Select-Object -ExpandProperty TaskName | Where-Object { $_ -like "OneDrive*" }
    Unregister-ScheduledTask -TaskName $onedrivetask -Confirm:$false
}

Unregister-ScheduledTask -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false

Show-Section -Section "Cleanup" -Desc "User Configs"
Copy-Item ${Location}\..\Tools\OpenShell.xml ${Env:UserProfile}\Desktop -Force | Out-Null
Copy-Item ${Location}\..\Tools\wt.json ${Env:LocalAppData}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force | Out-Null

# %AppData%\mpv
New-Item -Type Directory -Path "${Env:AppData}\mpv" | Out-Null
Invoke-WebRequest https://github.com/kyaulabs/mpv-config/archive/refs/heads/master.zip -OutFile ${Env:UserProfile}\Downloads\mpv-config.zip | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
Expand-Archive -LiteralPath "${Env:UserProfile}\Downloads\mpv-config.zip" -DestinationPath "${Env:AppData}\mpv" | Out-Null
Move-Item -Path "${Env:AppData}\mpv\mpv-config-master\*" -Destination "${Env:AppData}\mpv" -Force | Out-Null
Remove-Item -Path "${Env:AppData}\mpv\mpv-config-master" -Force | Out-Null
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
Get-ChildItem ${Env:AppData}\mpv\fonts\*.ttf | %%{ $fonts.CopyHere($_.fullname) }

# %UserProfile%\.cache
New-Item -Type Directory -Path "${Env:UserProfile}\.cache" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.cache" -Icon "folder-black-poly.ico" -ImageRes 0

# %UserProfile%\.config
New-Item -Type Directory -Path "${Env:UserProfile}\.config" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.config" -Icon "folder-black-config.ico" -ImageRes 0

# %UserProfile%\.gnupg
New-Item -ItemType SymbolicLink -Path ($Env:UserProfile + "\.gnupg") -Target ($Env:AppData + "\gnupg") | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.gnupg" -Icon "folder-gpg.ico" -ImageRes 0

# %UserProfile%\.local
New-Item -Type Directory -Path "${Env:UserProfile}\.local" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.local" -Icon "folder-black-coffee.ico" -ImageRes 0

# %UserProfile%\.ssh
New-Item -Type Directory -Path "${Env:UserProfile}\.ssh" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.ssh" -Icon "folder-private.ico" -ImageRest 0

# %ProgramFiles%\Git\usr\lib\winhello.dll
$URL = Find-GitRelease -Repo "tavrez/openssh-sk-winhello" "winhello.dll"
Invoke-WebRequest $URL -OutFile ${Env:SystemDrive}\msys64\usr\lib\winhello.dll | Out-Null

# %ProgramFiles%\Bin\gpg-bridge.exe
$URL = Find-GitRelease -Repo "BusyJay/gpg-bridge" ".zip$"
Invoke-WebRequest $URL -OutFile ${Env:UserProfile}\Downloads\gpg-bridge.zip | Out-Null
Expand-Archive -LiteralPath "${Env:UserProfile}\Downloads\gpg-bridge.zip" -DestinationPath "${Env:SystemDrive}\msys64\usr\bin" -Force | Out-Null
Remove-Item -Path "${Env:UserProfile}\Downloads\gpg-bridge.zip" | Out-Null

# %ProgramFiles%\Bin\gpg-forward.bat
$gpgforward = @"
@ECHO OFF

`"%SystemDrive%\msys64\usr\bin\gpg-bridge.exe`" --extra 127.0.0.1:4321 --ssh \\.\pipe\openssh-ssh-agent --detach
"@
New-Item -ItemType File -Path "${Env:ProgramFiles}\Bin\" -Name "gpg-forward.bat" -Value $gpgforward | Out-Null

# %ProgramFiles%\Bin\ssh.bat
$ssh = @"
@ECHO OFF

SET HOST=%1
:: local ssh color
SET COLOR=#1e90ff
:: remote ssh color (if 2nd argument = 1)
IF /I `"%2`" EQU `"1`" SET COLOR=#bb3385

%LocalAppData%\Microsoft\WindowsApps\wt.exe new-tab --title %HOST% --tabColor %COLOR% --useApplicationTitle %SystemDrive%\msys64\bin\sh.exe -i -l -c `"SSH_AUTH_SOCK=\\.\pipe\openssh-ssh-agent ssh %HOST%`"
"@
New-Item -ItemType File -Path "${Env:ProgramFiles}\Bin\" -Name "ssh.bat" -Value $ssh | Out-Null

# %UserProfile%\.gitconfig
$gitconfig = @"
[User]
    email = ${Email}
    name = ${UserName}
    signingkey = ${GPG_Key}
[core]
    longpaths = true
[commit]
    gpgsign = true
"@
New-Item -ItemType File -Path "${Env:UserProfile}\" -Name ".gitconfig" -Value $gitconfig | Out-Null
Set-ItemProperty "${Env:UserProfile}\.gitconfig" -Name Attributes -Value "ReadOnly,System,Hidden"

# %UserProfile%\.ssh\config
$sshconfig = @"
# `$KYAULabs: config,v 1.0.1 2022/08/13 20:37:49 kyau Exp `$

# Default Config
Host *
    User ${UserName}
    #SecurityKeyProvider winhello.dll
    KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
    ChallengeResponseAuthentication no
    ConnectTimeout 60
    HashKnownHosts yes
    HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
    ServerAliveInterval 30

# Forward the local gpg-agent to remote unix socket (requires gpg-bridge on startup)
Host remote.host.com
    StreamLocalBindUnlink yes
    #RemoteForward /home/${UserName}/.gnupg/S.gpg-agent 127.0.0.1:4321

# vim: ft=sshconfig ts=4 sw=4 noet :
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.ssh\" -Name "config" -Value $sshconfig | Out-Null

# %UserProfile%\.gnupg/gpg.conf
$gpgconf = @"
personal-cipher-preferences AES256 AES192 AES
personal-digest-preferences SHA512 SHA384 SHA256
personal-compress-preferences ZLIB BZIP2 ZIP Uncompressed
default-preference-list SHA512 SHA384 SHA256 AES256 AES192 AES ZLIB BZIP2 ZIP Uncompressed
cert-digest-algo SHA512
s2k-digest-algo SHA512
s2k-cipher-algo AES256
charset utf-8
fixed-list-mode
no-comments
no-emit-version
no-greeting
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
#with-key-origin
require-cross-certification
no-symkey-cache
use-agent
throw-keyids
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.gnupg\" -Name "gpg.conf" -Value $gpgconf | Out-Null

# %UserProfile%\.gnupg/gpg-agent.conf
$gpgagentconf = @"
###+++--- GPGConf ---+++###
enable-ssh-support
enable-putty-support
default-cache-ttl 60
max-cache-ttl 120
use-standard-socket
#pinentry-program /usr/bin/pinentry-w32
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.gnupg\" -Name "gpg-agent.conf" -Value $gpgagentconf | Out-Null

# Fix GPG under Git Bash
#$gitbash = "dirmngr.exe","dirmngr-client.exe","gpg.exe","gpg-agent.exe","gpgconf.exe","gpg-connect-agent.exe","gpg-error.exe","gpgparsemail.exe","gpgscm.exe","gpgsm.exe","gpgsplit.exe","gpgtar.exe","gpgv.exe","gpg-wks-server.exe"
#Foreach ($file in $gitbash) {
#    Remove-Item "${Env:ProgramFiles}\Git\usr\bin\${file}" -Force | Out-Null
#}
# GnuPG added to PATH
#Add-Reg -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Type ExpandString -Value "${Env:PATH};${Env:ProgramData}\chocolatey\lib\nircmd\tools;${Env:ProgramData}\chocolatey\lib\sysinternals\tools;${Env:ProgramFiles(x86)}\GnuPG\bin"
Add-Reg -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Type ExpandString -Value "${Env:PATH};${Env:ProgramData}\chocolatey\lib\nircmd\tools;${Env:ProgramData}\chocolatey\lib\sysinternals\tools"

# Install Git for Windows inside of MSYS2
Show-Section -Section "MSYS2" -Desc "Configuration"
Show-Package
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
#Show-Host " : msys2-update [1;32m${check}[0m" -NoNewline
Show-Package "msys2-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
#Show-Host " : pacman-update [1;32m${check}[0m" -NoNewline
Show-Package "pacman-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"sed -i '/^\[mingw32\]/{ s|^|[git-for-windows]\nServer = https://wingit.blob.core.windows.net/x86-64\n\n[git-for-windows-mingw32]\nServer = https://wingit.blob.core.windows.net/i686\n\n|; }' /etc/pacman.conf`""
#Show-Host " : gitforwindows-repo [1;32m${check}[0m" -NoNewline
Show-Package "gitforwindows-repo"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"rm -r /etc/pacman.d/gnupg/`""
#Show-Host " : pacman-db [1;32m${check}[0m" -NoNewline
Show-Package "pacman-db"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman-key --init`""
#Show-Host " : key-init [1;32m${check}[0m" -NoNewline
Show-Package "key-init"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman-key --populate msys2`""
#Show-Host " : key-populate [1;32m${check}[0m" -NoNewline
Show-Package "key-populate"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/HEAD/git-for-windows-keyring/git-for-windows.gpg | pacman-key --add - && pacman-key --lsign-key E8325679DFFF09668AD8D7B67115A57376871B1C && pacman-key --lsign-key 3B6D86A1BA7701CD0F23AED888138B9E1A9F3986`""
#Show-Host " : gitforwindows-gpg [1;32m${check}[0m" -NoNewline
Show-Package "gitforwindows-gpg"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
#Show-Host " : msys2-update [1;32m${check}[0m" -NoNewline
Show-Package "msys2-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Suu --noconfirm`""
#Show-Host " : pacman-update [1;32m${check}[0m" -NoNewline
Show-Package "pacman-update"

# %SystemDrive%\msys64\etc\nsswitch.conf
$nsswitch = @"
passwd: files db
group: files db

db_enum: cache builtin

db_home: windows cygwin desc
db_shell: cygwin desc
db_gecos: cygwin desc
"@
New-Item -ItemType File -Path "${Env:SystemDrive}\msys64\etc\" -Name "nsswitch.conf" -Value $nsswitch -Force | Out-Null
Show-Package "nsswitch.conf"
Show-Package -NewLine

# MSYS2 Additional Packages
Show-Section -Section "MSYS2" -Desc "Packages"
Show-Package
Foreach ($pkg in $MsysPkgs) {
    Show-Package "${pkg}"
    Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -S ${pkg} --noconfirm`""
}
Show-Package -NewLine

# Clear Icon Cache
Start-Process -FilePath "IE4UINIT.EXE" -ArgumentList "-show" -NoNewWindow -Wait | Out-Null
Remove-Item "${Env:LocalAppData}\Microsoft\Windows\Explorer\*" -Include "iconcache*.db" -Force

# Clean ContextMenu
#Remove-Reg -Path "HKCR:\Directory\shell\git_gui" -Recursive
#Remove-Reg -Path "HKCR:\Directory\shell\git_shell" -Recursive
#Remove-Reg -Path "HKCR:\LibraryFolder\background\shell\git_gui" -Recursive
#Remove-Reg -Path "HKCR:\LibraryFolder\background\shell\git_shell" -Recursive

# Clean StartMenu
Remove-Item -Path "${Env:UserProfile}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:Public}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:ProgramData}\Microsoft\Windows\Start Menu\*.LNK" -Force | Out-Null

If (Test-Path "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server\Uninstall.exe") {
    Show-Section -Section "PostFix" -Desc "Remove RivaTuner"
    Start-Process -FilePath "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server\Uninstall.exe" -ArgumentList "/S /SUPPRESSMSGBOXES" -NoNewWindow -Wait | Out-Null
    Remove-Item "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server" -Recurse -Force | Out-Null
}

Remove-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "PostFix"

# Restarting Explorer.EXE
Show-Section -Section "PostFix" -Desc "Restarting Explorer.EXE"