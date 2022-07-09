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

Start-Process -FilePath "${Env:SystemRoot}\system32\taskkill.exe" -ArgumentList "/F /IM msedge.exe" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\system32\taskkill.exe" -ArgumentList "/F /IM msedgewebview.exe" -NoNewWindow -Wait | Out-Null

$EdgeAppPath = "${Env:SystemRoot}\SystemApps\"
$EdgeApps = @(
    "Microsoft.MicrosoftEdge_8wekyb3d8bbwe",
    "Microsoft.MicrosoftEdgeDevToolsClient_8wekyb3d8bbwe"
    )

Get-Process *MicrosoftEdge* | Stop-Process -Force
Get-Process *MicrosoftEdgeCP* | Stop-Process -Force
Foreach ($sysapp in $EdgeApps) {
    [int]$i = "1"
    #$dis = "_disabled"
    $MoveTo = "${EdgeAppPath}${sysapp}_disabled"
    $MoveFrom = "${EdgeAppPath}${sysapp}"
    If (Test-Path -Path "${MoveFrom}") {
        Remove-Item "${MoveFrom}" -Recurse -Force -ErrorAction:SilentlyContinue

        # Rename _disabled
        <#
        If (Test-Path -Path "${MoveTo}") {
            Do {
                mv ${MoveFrom} ${MoveTo}${i} -EA SilentlyContinue
                $i++
                }
            Until (!(Test-Path -Path "${MoveFrom}"))
        }
        Else {
            mv ${MoveFrom} ${MoveTo}
        }
        #>
    }
}

Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\EdgeUpdate" -Name "DoNotUpdateToEdgeWithChromium" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" -Name "AllowPrelaunch" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" -Name "AllowTabPreloading" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "DisableEdgeDesktopShortcutCreation" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdge.exe" -Name "Debugger" -Type String -Value "%windir%\System32\taskkill.exe"

If (Test-Path -Path "${Env:ProgramFiles(x86)}\Microsoft\EdgeWebView\Application\*\Installer\SETUP.EXE") {
    Output-Section -Section "MSEdge" "Remove EdgeWebView"
    Start-Process -FilePath "${Env:ProgramFiles(x86)}\Microsoft\EdgeWebView\Application\*\Installer\SETUP.EXE" -ArgumentList "--uninstall --msedgewebview --system-level" -NoNewWindow -Wait | Out-Null
}

If (Test-Path -Path "${Env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\SETUP.EXE") {
    Output-Section -Section "MSEdge" "Remove Edge"
    Start-Process -FilePath "${Env:ProgramFiles(x86)}\Microsoft\Edge\Application\*\Installer\SETUP.EXE" -ArgumentList "--uninstall --forceuninstall --msedge --channel=stable --system-level" -NoNewWindow -Wait | Out-Null
}

If (Test-Path -Path "${Env:ProgramFiles(x86)}\Microsoft\EdgeCore") {
    Remove-Item "${Env:ProgramFiles(x86)}\Microsoft\EdgeCore" -Recurse -Force -ErrorAction:SilentlyContinue
}