<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win11Tweaks (KYAU Labs Edition)
 Copyright (C) 2026 KYAU Labs (https://kyaulabs.com)

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

# Install PowerShell 7
$WingetExe = "${Env:LocalAppData}\Microsoft\WindowsApps\winget.exe"
if (-NOT (Test-Path $WingetExe)) {
    $WingetExe = "winget.exe"
}
$runcmd = @"
@ECHO OFF

`"${WingetExe}`" install --id Microsoft.PowerShell --exact --source winget --scope machine --silent --accept-package-agreements --accept-source-agreements --disable-interactivity >nul
"@
New-Item -Path "${Env:UserProfile}" -Name "runcmd.bat" -ItemType File -Value $runcmd -Force | Out-Null
Start-Process -FilePath "${Env:UserProfile}\runcmd.bat" -NoNewWindow -Wait
Remove-Item -Path "${Env:UserProfile}\runcmd.bat" -Force | Out-Null

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
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='WdNisSvc'"
If (-NOT ($null -eq $Service)) {
    $Service.Delete() | Out-Null
}
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='WinDefend'"
If (-NOT ($null -eq $Service)) {
    $Service.Delete() | Out-Null
}
$Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='Sense'"
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

# KYAU Labs Branding
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "Model" -Type String -Value "KYAU Labs Edition"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\OEMInformation" -Name "SupportURL" -Type String -Value "https://github.com/kyaulabs/win11tweak"

# Remove Git from right-click
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_gui" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Classes\Directory\background\shell\git_shell" -Recursive

# OneDrive & Microsoft 365
Show-Section -Section "Cleanup" -Desc "Last Minute Removals"
If (-NOT $WinDefender) {
    Remove-WService -Name "WinDefend"
    Remove-WService -Name "Sense"
}

If (-NOT $Microsoft365) {
    Remove-Item "${Env:UserProfile}\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:LocalAppData}\Microsoft\OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:ProgramData}\Microsoft OneDrive" -Recurse -Force -ErrorAction:SilentlyContinue
    Remove-Item "${Env:SystemDrive}\OneDriveTemp" -Recurse -Force -ErrorAction:SilentlyContinue

    $onedrivetask = Get-ScheduledTask | Select-Object -ExpandProperty TaskName | Where-Object { $_ -like "OneDrive*" }
    Unregister-ScheduledTask -TaskName $onedrivetask -Confirm:$false
}

# Disable program data collection and reporting
Unregister-ScheduledTask -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false

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

# Dotfiles Repository Validation
$UsesDotfiles = $false
if (-not [string]::IsNullOrWhiteSpace($DotfilesRepo) -and $DotfilesRepo -match '^https://github\.com/[^/]+/[^/]+') {
    $RepoApiPath = [regex]::Match($DotfilesRepo, 'github\.com/(.+?)(?:\.git)?$').Groups[1].Value
    try {
        Invoke-RestMethod -Uri "https://api.github.com/repos/${RepoApiPath}" -ErrorAction Stop | Out-Null
        $UsesDotfiles = $true
    } catch {
        $UsesDotfiles = $false
    }
}

Show-Section -Section "Cleanup" -Desc "User Configs"
# Copy OpenShell.xml to Desktop
Copy-Item ${Location}\..\Tools\OpenShell.xml ${Env:UserProfile}\Desktop -Force | Out-Null
# Copy Windows Terminal settings
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

# %SystemDrive%\msys64\ucrt64\bin\gitleaks.exe
$URL = Find-GitRelease -Repo "zricethezav/gitleaks" -Search "windows_x64.zip"
Invoke-WebRequest $URL -OutFile ${Env:UserProfile}\Downloads\gitleaks.zip | Out-Null
Expand-Archive -LiteralPath "${Env:UserProfile}\Downloads\gitleaks.zip" -DestinationPath "${Env:SystemDrive}\msys64\ucrt64\bin" -Force | Out-Null
Remove-Item -Path "${Env:UserProfile}\Downloads\gitleaks.zip" | Out-Null
Remove-Item -Path "${Env:SystemDrive}\msys64\ucrt64\bin\README.md" | Out-Null
Remove-Item -Path "${Env:SystemDrive}\msys64\ucrt64\bin\LICENSE" | Out-Null

# %SystemDrive%\msys64\ucrt64\bin\jq.exe
$URL = Find-GitRelease -Repo "stedolan/jq" -Search "-win64.exe"
Invoke-WebRequest $URL -Outfile "${Env:SystemDrive}\msys64\ucrt64\bin\jq.exe" | Out-Null

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

# %ProgramFiles%\Bin\zZz.ps1
$zzz = @'
Add-Type @"
using System;
using System.Runtime.InteropServices;

public class Monitor {
    [DllImport("user32.dll")]
    public static extern IntPtr SendMessage(
        IntPtr hWnd,
        uint Msg,
        IntPtr wParam,
        IntPtr lParam
    );

    [DllImport("user32.dll")]
    public static extern bool LockWorkStation();
}
"@

[Monitor]::LockWorkStation()

Start-Sleep -Milliseconds 1500

[Monitor]::SendMessage(
    [IntPtr]0xffff,
    0x0112,
    [IntPtr]0xF170,
    [IntPtr]2
)
'@
New-Item -ItemType File -Path "${Env:ProgramFiles}\Bin\" -Name "zZz.ps1" -Value $zzz | Out-Null

if (-not $UsesDotfiles) {
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
    set -x PATH "`$HOME/bin" "/c/Program Files/Sublime Text" "/ucrt64/bin" "/clang64/bin" "/mingw64/bin" "/opt/bin" `$MSYS2_PATH `$ORIGINAL_PATH
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
}

# Configure Default MSYS2 Environment
Show-Section -Section "MSYS2" -Desc "Configuration"
$dotprofile = @"
export PATH="/ucrt64/bin:/usr/bin:/bin:/usr/local/bin:/clang64/bin:/mingw64/bin:/opt/bin:`$PATH"
"@
New-Item -ItemType File -Path "${Env:UserProfile}" -Name ".profile" -Value $dotprofile | Out-Null
if ($UsesDotfiles) {
    $defaultfish = @"
if status is-interactive
    set -x PATH "`$HOME/bin" "/c/Program Files/Sublime Text" "/ucrt64/bin" "/clang64/bin" "/mingw64/bin" "/usr/local/bin" "/usr/bin" "/bin" "/opt/bin" `$ORIGINAL_PATH
end
"@
    New-Item -ItemType File -Path "${Env:UserProfile}\.config\fish\" -Name "config.fish" -Value $defaultfish -Force | Out-Null
}

# MSYS2 Additional Packages
Show-Section -Section "MSYS2" -Desc "Packages"
Show-Package
Foreach ($pkg in $MsysPkgs) {
    Show-Package "${pkg}"
    Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -S ${pkg} --noconfirm`""
}
Show-Package "msys/openssh-fix"
Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"pacman -S ucrt64/mingw-w64-ucrt-x86_64-curl ucrt64/mingw-w64-ucrt-x86_64-gnutls ucrt64/mingw-w64-ucrt-x86_64-openssl msys/libopenssl msys/libgnutls msys/openssl msys/openssh --noconfirm`""
Show-Package -NewLine

# MSYS2 Dotfiles Customization
if ($UsesDotfiles) {
    $RepoName = ($DotfilesRepo -split '/')[-1] -replace '\.git$', ''
    Show-Section -Section "Dotfiles" -Desc "Cloning Repository"
    Show-Package "${RepoName}"
    Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"git clone ${DotfilesRepo} ~/${RepoName}`""
    Show-Package -NewLine
    Show-Section -Section "Dotfiles" -Desc "Running Setup Script"
    Show-Package "${DotfilesScript}"
    Show-RunAsUser -Command "${Env:SystemDrive}\msys64\msys2_shell.cmd -defterm -here -no-start -msys -c `"cd ~/${RepoName} && ${DotfilesScript}`""
    Show-Package -NewLine
}

# MSYS2 Path Fixes (Removable/Network Drives)
$AddedText = "MSYS=nonativeinnerlinks"
Get-ChildItem -Path "${Env:SystemDrive}\msys64\*.ini" -Exclude "uninstall*" | ForEach-Object {$AddedText+"`r`n" + (Get-Content $_.FullName -Raw) | Out-File $_.FullName}

# MSYS2 Cleanup
Remove-Item -Path "${Env:SystemDrive}\msys64\home\${Env:UserName}" -Force -Recurse -ErrorAction SilentlyContinue | Out-Null

# Clear Icon Cache
Start-Process -FilePath "IE4UINIT.EXE" -ArgumentList "-show" -NoNewWindow -Wait | Out-Null
Remove-Item "${Env:LocalAppData}\Microsoft\Windows\Explorer\*" -Include "iconcache*.db" -Force

# Clean StartMenu
Remove-Item -Path "${Env:UserProfile}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:Public}\Desktop\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:ProgramData}\Microsoft\Windows\Start Menu\*.LNK" -Force | Out-Null
Remove-Item -Path "${Env:ProgramData}\Microsoft\Windows\Start Menu\Corsair" -Recurse -Force -ErrorAction:SilentlyContinue | Out-Null

If (Test-Path "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server\Uninstall.exe") {
    Show-Section -Section "PostFix" -Desc "Remove RivaTuner"
    Start-Process -FilePath "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server\Uninstall.exe" -ArgumentList "/S /SUPPRESSMSGBOXES" -NoNewWindow -Wait | Out-Null
    Remove-Item "${Env:ProgramFiles(x86)}\RivaTuner Statistics Server" -Recurse -Force | Out-Null
}

Remove-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "EADM"
Remove-Reg -Path "HKLM:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "Everything"
Remove-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Run" -Name "PostFix"

# Cleanup Batch files
Remove-Item -Path "${Env:SystemDrive}\temp.bat" -Force | Out-Null

# Restarting Explorer.EXE
Show-Section -Section "PostFix" -Desc "Restarting Explorer.EXE"