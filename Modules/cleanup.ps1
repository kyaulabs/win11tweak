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
. "${PSScriptRoot}\msedge.ps1"
. "${PSScriptRoot}\defender.ps1"
. "${PSScriptRoot}\mapdrives.ps1"

# Mapped Network Drives
$action = New-ScheduledTaskAction -Execute "powershell.exe" -Argument "NoLogo -NoProfile -ExecutionPolicy Bypass -File `"${PSScriptRoot}\mapdrives.ps1"`"
$trigger = New-ScheduledTaskTrigger -AtLogOn
$principal = New-ScheduledTaskPrincipal -UserId (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -ExpandProperty UserName)
$task = New-ScheduledTask -Action $action -Trigger $trigger -Principal $principal
Register-ScheduledTask KL_MapDrives -InputObject $task | Out-Null
Start-ScheduledTask -TaskName KL_MapDrives | Out-Null
Start-Sleep -Seconds 10 | Out-Null
Unregister-ScheduledTask -TaskName KL_MapDrives -Confirm:$false | Out-Null

$Location = Get-Location
Del-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_gui" -Recursive
Del-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_shell" -Recursive
Output-Section -Section "Cleanup" -Desc "Download Brave"
Invoke-WebRequest https://laptop-updates.brave.com/latest/winx64 -OutFile ${Env:UserProfile}\Desktop\BraveSetup.exe | Out-Null
Output-Section -Section "Cleanup" -Desc "Download OpenShell"
Invoke-WebRequest https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.170/OpenShellSetup_4_4_170.exe -OutFile ${Env:UserProfile}\Desktop\OpenShellSetup.exe | Out-Null

Output-Section -Section "Cleanup" -Desc "Last Minute Removals"
If (-NOT $WinDefender) {
    Del-Service -Name "WinDefend"
    Del-Service -Name "Sense"
}
Del-Service -Name "XblAuthManager"
Del-Service -Name "XblGameSave"
Del-Service -Name "XboxNetApiSvc"
Del-Service -Name "XboxGipSvc"

If (-NOT $Microsoft365) {
    Remove-Item "${Env:UserProfile}\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:LocalAppData}\Microsoft\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:ProgramData}\Microsoft OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:SystemDrive}\OneDriveTemp" -Recurse -Force -ErrorAction:SilentlyContinue

    $onedrivetask = Get-ScheduledTask | Select-Object -ExpandProperty TaskName | where { $_ -like "OneDrive*" }
    Unregister-ScheduledTask -TaskName $onedrivetask -Confirm:$false
}

Unregister-ScheduledTask -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false

Output-Section -Section "Cleanup" -Desc "User Configs"
Copy-Item ${Location}\..\Tools\OpenShell.xml ${Env:UserProfile}\Desktop -Force | Out-Null
Copy-Item ${Location}\..\Tools\wt.json ${Env:LocalAppData}\Packages\Microsoft.WindowsTerminal_8wekyb3d8bbwe\LocalState\settings.json -Force | Out-Null

# %AppData%\mpv
New-Item -Type Directory -Path "${Env:AppData}\mpv" | Out-Null
Invoke-WebRequest https://github.com/kyaulabs/mpv-config/archive/refs/heads/master.zip -OutFile ${Env:UserProfile}\Downloads\mpv-config.zip | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("${Env:UserProfile}\Downloads\mpv-config.zip", "${Env:AppData}\mpv")
Remove-Item -Path "${Env:UserProfile}\Downloads\mpv-config.zip" -Force | Out-Null
Move-Item -Path "${Env:AppData}\mpv\mpv-config-master\*" -Destination "${Env:AppData}\mpv" -Force | Out-Null
Remove-Item -Path "${Env:AppData}\mpv\mpv-config-master" -Force | Out-Null
$fonts = (New-Object -ComObject Shell.Application).Namespace(0x14)
dir ${Env:AppData}\mpv\fonts\*.ttf | %%{ $fonts.CopyHere($_.fullname) }

# %ProgramFiles%\Git\usr\lib\winhello.dll
Invoke-WebRequest https://github.com/tavrez/openssh-sk-winhello/releases/download/v2.0.0/winhello.dll -OutFile ${Env:ProgramFiles}\Git\usr\lib\winhello.dll -Force | Out-Null

# %ProgramFiles%\Bin\gpg-bridge.exe
Invoke-WebRequest https://github.com/BusyJay/gpg-bridge/releases/download/v0.1.0/gpg-bridge-v0.1.0.zip -OutFile ${Env:UserProfile}\Downloads\gpg-bridge.zip | Out-Null
Add-Type -AssemblyName System.IO.Compression.FileSystem
[System.IO.Compression.ZipFile]::ExtractToDirectory("${Env:UserProfile}\Downloads\gpg-bridge.zip", "${Env:ProgramFiles}\Bin")
Remove-Item -Path "${Env:UserProfile}\Downloads\gpg-bridge.zip" -Force | Out-Null

# %ProgramFiles%\Bin\gpg-forward.bat
$gpgforward = @"
@ECHO OFF

`"%Programfiles%\Bin\gpg-bridge.exe`" --extra 127.0.0.1:4321 --ssh \\.\pipe\openssh-ssh-agent --detach
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

%LocalAppData%\Microsoft\WindowsApps\wt.exe new-tab --title %HOST% --tabColor %COLOR% --useApplicationTitle %ProgramFiles%\Git\bin\bash.exe -i -l -c `"SSH_AUTH_SOCK=\\.\pipe\openssh-ssh-agent ssh %HOST%`"
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
[gpg]
    program = C:/Program Files (x86)/GnuPG/bin/gpg.exe
[commit]
    gpgsign = true
"@
New-Item -ItemType File -Path "${Env:UserProfile}\" -Name ".gitconfig" -Value $ssh | Out-Null
Set-ItemProperty "${Env:UserProfile}\.gitconfig" -Name Attributes -Value "ReadOnly,System,Hidden"

# %UserProfile%\.ssh\config
$sshconfig = @"
# `$KYAULabs: config,v 1.0.0 2021/12/20 15:29:46 kyau Exp `$

# Default Config
Host *
    User ${UserName}
    SecurityKeyProvider winhello.dll
    IdentitiesOnly yes
    IdentityFile ~/.ssh/id_ed25519_sk-17928361
    KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
    ChallengeResponseAuthentication no
    ConnectTimeout 60
    HashKnownHosts yes
    HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,ssh-rsa-cert-v01@openssh.com,ssh-ed25519,ssh-rsa
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
    ServerAliveInterval 30

# Forward the local gpg-agent to remote unix socket (requires gpg-bridge on startup)
Host remote.host.com
    StreamLocalBindUnlink yes
    RemoteForward `$HOME/.gnupg/S.gpg-agent 127.0.0.1:4321

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
keyid-format 0xlong
list-options show-uid-validity
verify-options show-uid-validity
with-fingerprint
require-cross-certification
no-symkey-cache
use-agent
throw-keyids
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.gnupg\" -Name "gpg.conf" -Value $gpgconf | Out-Null

# %UserProfile%\.gnupg/gpg.conf
$gpgagentconf = @"
###+++--- GPGConf ---+++###
use-standard-socket
default-cache-ttl 600
max-cache-ttl 7200
enable-ssh-support
min-passphrase-len 3
enable-putty-support
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.gnupg\" -Name "gpg-agent.conf" -Value $gpgagentconf | Out-Null

# Fix GPG under Git Bash
$gitbash = "dirmngr.exe","dirmngr-client.exe","gpg.exe","gpg-agent.exe","gpgconf.exe","gpg-connect-agent.exe","gpg-error.exe","gpgparsemail.exe","gpgscm.exe","gpgsm.exe","gpgsplit.exe","gpgtar.exe","gpgv.exe","gpg-wks-server.exe"
Foreach ($file in $gitbash) {
    Remove-Item "${Env:ProgramFiles}\Git\usr\bin\${file}" -Force | Out-Null
}
# GnuPG added to PATH
Add-Reg -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Type ExpandString -Value "${Env:PATH};${Env:ProgramData}\chocolatey\lib\nircmd\tools;${Env:ProgramData}\chocolatey\lib\sysinternals\tools;${Env:ProgramFiles(x86)}\GnuPG\bin"

# Clear Icon Cache
Start-Process -FilePath "IE4UINIT.EXE" -ArgumentList "-show" -NoNewWindow -Wait | Out-Null
Remove-Item "${Env:LocalAppData}\Microsoft\Windows\Explorer\*" -Include "iconcache*.db" -Force

# Clean ContextMenu
Del-Reg -Path "HKCR:\Directory\shell\git_gui" -Recursive
Del-Reg -Path "HKCR:\Directory\shell\git_shell" -Recursive
Del-Reg -Path "HKCR:\LibraryFolder\background\shell\git_gui" -Recursive
Del-Reg -Path "HKCR:\LibraryFolder\background\shell\git_shell" -Recursive

# Clean StartMenu
Remove-Item -Path "${Env:UserProfile}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:Public}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:ProgramData}\Microsoft\Windows\Start Menu\*.LNK" -Force | Out-Null
