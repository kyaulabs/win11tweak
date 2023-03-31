<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win11Tweaks (KYAU Labs Edition)
 Copyright (C) 2023 KYAU Labs (https://kyaulabs.com)

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
    Register-ScheduledTask _WinDefendRemoval -InputObject $task | Out-Null
    Start-ScheduledTask -TaskName _WinDefendRemoval | Out-Null
}

# Fix Sublime Text context menu
if ("sublimetext4" -in $ChocoPkgs) {
    Rename-Item -Path "HKCR:\``*\shell\Open with Sublime Text" -NewPath "HKCR:\``*\shell\Edit with Sublime Text" -Force | Out-Null
    Add-Reg -Path "HKCR:\``*\shell\Open with Sublime Text" -Name "Icon" -Type String -Value "`"${Env:ProgramFiles}\Sublime Text\sublime_text.exe`",0"
    Add-Reg -Path "HKCR:\``*\shell\Open with Sublime Text" -Name "MuiVerb" -Type String -Value "Edit with &Sublime Text"
    Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text" -Name "(Default)" -Type String -Value "Open with &Sublime Text"
    Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text" -Name "Icon" -Type String -Value "`"${Env:ProgramFiles}\Sublime Text\sublime_text.exe`",0"
    Add-Reg -Path "HKCR:\Directory\shell\Open with Sublime Text\command" -Name "(Default)" -Type String -Value "`"${Env:ProgramFiles}\Sublime Text\sublime_text.exe`" `"%1`""
}

# Fix Recycle Bin context menu
if ("ccleaner" -in $ChocoPkgs) {
    Remove-Item -Path "HKCR:\CLSID\{645FF040-5081-101B-9F08-00AA002F954E}\shell\Run CCleaner" -Recursive
}

# Remove Git from right-click
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_gui" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_shell" -Recursive

# Download Brave
Show-Section -Section "Cleanup" -Desc "Download Brave"
Invoke-WebRequest https://laptop-updates.brave.com/latest/winx64 -OutFile ${Env:UserProfile}\Desktop\BraveSetup.exe | Out-Null

# Download OpenShell
Show-Section -Section "Cleanup" -Desc "Download OpenShell"
#Invoke-WebRequest https://github.com/Open-Shell/Open-Shell-Menu/releases/download/v4.4.180/OpenShellSetup_4_4_180.exe -OutFile ${Env:UserProfile}\Desktop\OpenShellSetup.exe | Out-Null
$URL = Find-GitRelease -Repo "Open-Shell/Open-Shell-Menu" -Search ".exe$"
Invoke-WebRequest $URL -OutFile ${Env:UserProfile}\Desktop\Open-Shell-Setup.exe | Out-Null

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
Add-UserFolderIcon -Name "${Env:UserProfile}\.cache" -ImageRes 28 #-Icon "folder-black-poly"

# %UserProfile%\.config
New-Item -Type Directory -Path "${Env:UserProfile}\.config" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.config" -ImageRes 8 #-Icon "folder-black-config"

# %UserProfile%\.gnupg
New-Item -ItemType SymbolicLink -Path ($Env:UserProfile + "\.gnupg") -Target ($Env:AppData + "\gnupg") | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.gnupg" -ImageRes 18 #-Icon "folder-black-gpg"

# %UserProfile%\.local
New-Item -Type Directory -Path "${Env:UserProfile}\.local" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.local" -ImageRes 7 #-Icon "folder-black-coffee"

# %UserProfile%\.ssh
New-Item -Type Directory -Path "${Env:UserProfile}\.ssh" | Out-Null
Add-UserFolderIcon -Name "${Env:UserProfile}\.ssh" -ImageRes 29 #-Icon "folder-black-private"

# %SystemDrive%\msys64\usr\bin\gitleaks.exe
$URL = Find-GitRelease -Repo "zricethezav/gitleaks" -Search "windows_x64.zip"
Invoke-WebRequest $URL -OutFile ${Env:UserProfile}\Downloads\gitleaks.zip | Out-Null
Expand-Archive -LiteralPath "${Env:UserProfile}\Downloads\gitleaks.zip" -DestinationPath "${Env:SystemDrive}\msys64\usr\bin" -Force | Out-Null
Remove-Item -Path "${Env:UserProfile}\Downloads\gitleaks.zip" | Out-Null
Remove-Item -Path "${Env:SystemDrive}\msys64\usr\bin\README.md" | Out-Null
Remove-Item -Path "${Env:SystemDrive}\msys64\usr\bin\LICENSE" | Out-Null

# %SystemDrive%\msys64\usr\bin\jq.exe
$URL = Find-GitRelease -Repo "stedolan/jq" -Search "-win64.exe"
Invoke-WebRequest $URL -Outfile "${Env:SystemDrive}\msys64\usr\bin\jq.exe" | Out-Null

# %SystemDrive%\msys64\usr\lib\winhello.dll
#$URL = Find-GitRelease -Repo "tavrez/openssh-sk-winhello" -Search "winhello.dll"
#Invoke-WebRequest $URL -OutFile "${Env:SystemDrive}\msys64\usr\lib\winhello.dll" | Out-Null

# %ProgramFiles%\Bin\ssh.bat
$ssh = @"
@ECHO OFF

SET HOST=%1
:: local ssh color
SET COLOR=#1e90ff
SET PROFILE=SSH-Local
:: remote ssh color (if 2nd argument = 1)
IF /I `"%2`" EQU `"1`" SET COLOR=#bb3385
IF /I `"%2`" EQU `"1`" SET PROFILE=SSH-Remote

%LocalAppData%\Microsoft\WindowsApps\wt.exe new-tab --profile %PROFILE% --title %HOST% --tabColor %COLOR% --useApplicationTitle `"%SystemDrive%\msys64\msys2_shell.cmd`" -defterm -here -no-start -msys -shell fish -i -c `"ssh %HOST%`"
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
$gpgsocket = '/' + ${Env:UserProfile} -replace '\:', '' -replace '\\', '/'
$gpgsocket = $gpgsocket + '/.gnupg/S.gpg-agent.extra'
$sshconfig = @"
# `$KYAULabs: config,v 1.0.2 2022/11/24 19:32:55 kyau Exp `$

# Default Config
Host *
    User ${UserName}
    KexAlgorithms curve25519-sha256@libssh.org,diffie-hellman-group-exchange-sha256
    ChallengeResponseAuthentication no
    ConnectTimeout 60
    HashKnownHosts yes
    HostKeyAlgorithms ssh-ed25519-cert-v01@openssh.com,rsa-sha2-512-cert-v01@openssh.com,rsa-sha2-256-cert-v01@openssh.com,ssh-ed25519,rsa-sha2-512,rsa-sha2-256
    Ciphers chacha20-poly1305@openssh.com,aes256-gcm@openssh.com,aes128-gcm@openssh.com,aes256-ctr,aes192-ctr,aes128-ctr
    MACs hmac-sha2-512-etm@openssh.com,hmac-sha2-256-etm@openssh.com,umac-128-etm@openssh.com,hmac-sha2-512,hmac-sha2-256,umac-128@openssh.com
    ServerAliveInterval 30

# Forward the local gpg-agent to remote unix socket
Host remote.host.com
    ForwardAgent yes
    StreamLocalBindUnlink yes
    RemoteForward /home/${UserName}/.gnupg/S.gpg-agent ${gpgsocket}

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

# %UserProfile%\.config\starship.toml
$starshiptoml = @"
# `$KYAULabs: starship.toml,v 1.0.0 2021/07/10 00:37:02 kyau Exp $
#

[character]
success_symbol = "[✓](bold green)"
error_symbol = "[✕](bold red)"

[git_branch]
format = "on [`$symbol`$branch](`$style) "

[hostname]
format = "[`$hostname](`$style)∶"
ssh_only = false
style = "242"

[line_break]
disabled = true

[username]
format = "[`$user](`$style)[ ┅ ](247)"
style_user = "27"
style_root = "52"

# vim: ft=toml sts=4 sw=4 ts=4 noet:
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.config\" -Name "starship.toml" -Value $starshiptoml | Out-Null

New-Item -Type Directory -Path "${Env:UserProfile}\.config\fish" | Out-Null
$configfish = @"
# `$KYAULabs: config.fish,v 1.0.2 2022/11/23 18:27:36 kyau Exp $

# Null the default fish greeting
set fish_greeting

# Set the platform variable
set -x FISH_PLATFORM (uname -s)

# Set the window title
function fish_title
    set -l _fish_hostname (hostname)
    echo "`$_fish_hostname:" `$_ ' '
    dirs
end

# Aliases
function aliases -d "Command Aliases"
    alias c="clear"
    alias cd..="cd .."
    alias ..="cd .."
    alias ...="cd ../.."
    alias ....="cd ../../.."
    alias bc="bc -l"
    alias diff="colordiff -u"
    alias du="du -ch"
    alias edit="`$EDITOR"
    alias g="grep"
    alias grep="grep --color=auto --exclude-dir=\.git --exclude-dir=\.svn --exclude-dir=\.hg"
    alias h="history"
    alias nssh="ssh -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"
    alias scp="scp -q"
    alias nscp="scp -oUserKnownHostsFile=/dev/null -oStrictHostKeyChecking=no"
    alias tmux="tmux -2 -u"
    alias vi="`$EDITOR"
    alias wget="wget -c"
    alias ls="ls --color=auto --file-type --group-directories-first"
    alias lsa="ls -A"
    alias lla="ls -Al --human-readable"
    alias lld="ls -At1"
    alias ll="ls -l --human-readable"
    alias cp="cp -i"
    alias k="kill"
    alias k1="kill -1"
    alias k2="kill -2"
    alias k9="kill -9"
    alias ln="ln -i"
    alias mkdir="mkdir -pv"
    alias mv="mv -i"
    alias rm="rm -I --preserve-root"
end
function aliases_git -d "Git Command Aliases"
    alias commit="git commit -S -a"
    alias gitad="git add -A -n ."
    alias gitadd="git add -A ."
    alias gitlog="git log --graph --all --format=format:'%C(bold red)%h%C(reset) %C(white)-%C(reset) %C(reset)%s %C(bold green)(%ar)%C(reset) %C(bold cyan)[%an]%C(reset)%C(bold yellow)%d%C(reset)%n''''    %C(white)%b%C(reset)' --no-abbrev-commit"
    alias gitls="git ls-files -o --exclude-standard"
    alias pull="git pull origin"
    alias push="git push origin"
end

# Interactive shell
if status --is-interactive
    # environmental variables
    set -x GPG_TTY (tty)
    set -x SSH_AUTH_SOCK (gpgconf --list-dirs agent-ssh-socket)
    set -x EDITOR "subl -w"
    set -x PATH "`$HOME/bin" "/c/Program Files/Sublime Text" "/mingw64/bin" "/opt/bin" `$MSYS2_PATH `$ORIGINAL_PATH
    set -x PAGER "less"
    set -x LESS "-RSM~gIsw"
    # gpg-agent + scdaemon check
    ps -eaf | grep scdaemon >/dev/null 2>&1
    if test `$status -eq 1
        set -l _gpg_pid (ps | grep -i gpg-agent | awk '{ print `$1 }')
        if test -n "`$_gpg_pid"
            kill -9 `$_gpg_pid
            gpg --card-status >/dev/null 2>&1
        end
    end
    # command aliases
    aliases
    aliases_git
    starship init fish | source
end
"@
New-Item -ItemType File -Path "${Env:UserProfile}\.config\fish\" -Name "config.fish" -Value $configfish | Out-Null

# Nircmd / Sysinternals added to PATH
Add-Reg -Path "HKLM:\System\CurrentControlSet\Control\Session Manager\Environment" -Name PATH -Type ExpandString -Value "${Env:PATH};${Env:ProgramData}\chocolatey\lib\nircmd\tools;${Env:ProgramData}\chocolatey\lib\sysinternals\tools"

# Install Git for Windows inside of MSYS2
Show-Section -Section "MSYS2" -Desc "Configuration"
Show-Package
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
Show-Package "msys2-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
Show-Package "pacman-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"sed -i '/^\[mingw32\]/{ s|^|[git-for-windows]\nServer = https://wingit.blob.core.windows.net/x86-64\n\n[git-for-windows-mingw32]\nServer = https://wingit.blob.core.windows.net/i686\n\n|; }' /etc/pacman.conf`""
Show-Package "gitforwindows-repo"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"rm -r /etc/pacman.d/gnupg/`""
Show-Package "pacman-db"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman-key --init`""
Show-Package "key-init"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman-key --populate msys2`""
Show-Package "key-populate"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"curl -L https://raw.githubusercontent.com/git-for-windows/build-extra/HEAD/git-for-windows-keyring/git-for-windows.gpg | pacman-key --add - && pacman-key --lsign-key E8325679DFFF09668AD8D7B67115A57376871B1C && pacman-key --lsign-key 3B6D86A1BA7701CD0F23AED888138B9E1A9F3986`""
Show-Package "gitforwindows-gpg"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Syyuu --noconfirm`""
Show-Package "msys2-update"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -Suu --noconfirm`""
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

# MSYS2 Path Fixes (Removable/Network Drives)
$AddedText = "MSYS=nonativeinnerlinks"
Get-ChildItem -Path "${Env:SystemDrive}\msys64\*.ini" -Exclude "uninstall*" | ForEach-Object {$AddedText+"`r`n" + (Get-Content $_.FullName -Raw) | Out-File $_.FullName}

# MSYS2 Cleanup
Move-Item -Path "${Env:SystemDrive}\msys64\home\${Env:UserName}\.bash*" -Destination "${Env:UserProfile}" | Out-Null
Move-Item -Path "${Env:SystemDrive}\msys64\home\${Env:UserName}\.inputrc" -Destination "${Env:UserProfile}" | Out-Null
Move-Item -Path "${Env:SystemDrive}\msys64\home\${Env:UserName}\.profile" -Destination "${Env:UserProfile}" | Out-Null
Remove-Item -Path "${Env:SystemDrive}\msys64\home\${Env:UserName}" -Force -Recurse | Out-Null

# Clear Icon Cache
Start-Process -FilePath "IE4UINIT.EXE" -ArgumentList "-show" -NoNewWindow -Wait | Out-Null
Remove-Item "${Env:LocalAppData}\Microsoft\Windows\Explorer\*" -Include "iconcache*.db" -Force

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

# Cleanup Batch files
Remove-Item -Path "${Env:SystemDrive}\temp.bat" -Force | Out-Null

# Restarting Explorer.EXE
Show-Section -Section "PostFix" -Desc "Restarting Explorer.EXE"