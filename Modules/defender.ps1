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

If (-NOT $WinDefender) {
    Output-Section -Section "Anti-Virus" -Desc "Removing Defender"

    Del-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\Windows Defender" -Recursive
    Del-Service -Name "WdNisSvc"
    Del-Service -Name "WinDefend"
    Del-Service -Name "Sense"
    Set-MpPreference -DisableArchiveScanning $true | Out-Null
    Set-MpPreference -DisableBehaviorMonitoring $true | Out-Null
    Set-MpPreference -DisableDatagramProcessing $true | Out-Null
    Set-MpPreference -DisableDnsOverTcpParsing $true | Out-Null
    Set-MpPreference -DisableDnsParsing $true | Out-Null
    Set-MpPreference -DisableEmailScanning $true | Out-Null
    Set-MpPreference -DisableHttpParsing $true | Out-Null
    Set-MpPreference -DisableIntrusionPreventionSystem $true | Out-Null
    Set-MpPreference -DisableIOAVProtection $true | Out-Null
    Set-MpPreference -DisableRdpParsing $true | Out-Null
    Set-MpPreference -DisableRealtimeMonitoring $true | Out-Null
    Set-MpPreference -DisableScanningNetworkFiles $true | Out-Null
    Set-MpPreference -DisableScriptScanning $true | Out-Null
    Set-MpPreference -DisableSshParsing $true | Out-Null
    Set-MpPreference -DisableTlsParsing $true | Out-Null
    Set-MpPreference -MAPSReporting Disabled | Out-Null
    Set-MpPreference -SubmitSamplesConsent 2 | Out-Null
    Add-MpPreference -ExclusionPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableBehaviorMonitoring" -Force | Out-Null
    Add-MpPreference -ExclusionPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableOnAccessProtection" -Force | Out-Null
    Add-MpPreference -ExclusionPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection\DisableRealtimeMonitoring" -Force | Out-Null
    Add-MpPreference -ExclusionPath "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\DisableAntiSpyware" -Force | Out-Null

    Unregister-ScheduledTask -TaskName "ExploitGuard MDM policy Refresh" -Confirm:$false
    Unregister-ScheduledTask -TaskName "Windows Defender Cache Maintenance" -Confirm:$false
    Unregister-ScheduledTask -TaskName "Windows Defender Cleanup" -Confirm:$false
    Unregister-ScheduledTask -TaskName "Windows Defender Scheduled Scan" -Confirm:$false
    Unregister-ScheduledTask -TaskName "Windows Defender Verification" -Confirm:$false

    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Type Dword -Value "0"
    Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" -Name "SmartScreenEnabled" -Type String -Value "Off"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableSmartScreen" -Type Dword -Value "0"
    Add-Reg -Path "HKCU:\Software\Microsoft\Edge\SmartScreenEnabled" -Name "(Default)" -Type Dword -Value "0"
    Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost" -Name "EnableWebContentEvaluation" -Type Dword -Value "0"
    Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\AppHost" -Name "PreventOverride" -Type Dword -Value "0"
    Add-Reg -Path "HKCU:\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" -Name "EnabledV9" -Type Dword -Value "0"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRealtimeMonitoring" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableBehaviorMonitoring" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableOnAccessProtection" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableIOAVProtection" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableRoutinelyTakingAction" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Real-Time Protection" -Name "DisableScanOnRealtimeEnable" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiVirus" -Type Dword -Value "1"
    #Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" -Name "MpEnginePlus" -Type Dword -Value "0"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\MpEngine" -Name "MpEnablePus" -Type Dword -Value "0"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Reporting" -Name "DisableEnhancedNotifications" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "DisableBlockAtFirstSeen" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting" -Type Dword -Value "0"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Type Dword -Value "2"
    #Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "DontReportInfectionInformation" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\System\CurrentControlSet\Services\WdFilter" -Name "Start" -Type Dword -Value "4"
    Add-Reg -Path "HKLM:\System\CurrentControlSet\Services\WdNisDrv" -Name "Start" -Type Dword -Value "4"
    Add-Reg -Path "HKLM:\System\CurrentControlSet\Services\WdNisSvc" -Name "Start" -Type Dword -Value "4"
    Add-Reg -Path "HKLM:\System\CurrentControlSet\Services\WinDefend" -Name "Start" -Type Dword -Value "4"
    #Add-Reg -Path "HKLM:\Software\Microsoft\Windows Defender\Features" -Name "TamperProtection" -Type Dword -Value "0"
    Del-Reg -Path "HKLM:\SYSTEM\CurrentControlSet\Services\Sense" -Recursive
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Type Dword -Value "1"
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\MRT" -Name "DontOfferThroughWUAU" -Type Dword -Value "1"

    If (-NOT $SecurityHealth) {
        Output-Section -Section "Anti-Virus" -Desc "Removing Windows Security"
        Del-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" -Name "SecurityHealth"
        Del-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" -Name "SecurityHealth"
        Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SecHealthUI.exe" -Name "Debugger" -Type String -Value "%windir%\System32\taskkill.exe"
        Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" -Name "Enabled" -Type Dword -Value "0"
        Del-Reg -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SecurityHealthService" -Recursive
    }

    Output-Section -Section "Anti-Virus" -Desc "Removing Context Menu Handlers"
    REG.EXE delete "HKCR\*\shellex\ContextMenuHandlers\EPP" /f | Out-Null
    REG.EXE delete "HKCR\CLSID\{09A47860-11B0-4DA5-AFA5-26D86198A780}" /f | Out-Null
    REG.EXE delete "HKCR\Directory\shellex\ContextMenuHandlers\EPP" /f | Out-Null
    REG.EXE delete "HKCR\Drive\shellex\ContextMenuHandlers\EPP" /f | Out-Null

    Start-Process -FilePath "${PSScriptRoot}\..\Tools\install_wim_tweak.exe" -ArgumentList "/o /c Windows-Defender /r" -NoNewWindow -Wait -RedirectStandardOutput "${Env:UserProfile}\defender.txt"
    Remove-Item -Path "${Env:UserProfile}\defender.txt" -Force | Out-Null
}
