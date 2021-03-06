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

Output-Logo "Windows 11 Tweaks"

# Network
Output-Section -Section "Defaults" -Desc "Network Configuration"
# Set Network Connection to Private
Set-NetConnectionProfile -NetworkCategory Private | Out-Null
# Enable Network Discovery (Browsing)
NETSH.EXE advfirewall firewall set rule group="Network Discovery" new enable=Yes | Out-Null
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" -Name "LocalAccountTokenFilterPolicy" -Type Dword -Value "1"
# Rename Computer & Set Workgroup
Rename-Computer -NewName $ComputerName | Out-Null
Add-Computer -WorkGroupName $WorkGroupName | Out-Null

# Remove System Restore
Output-Section -Section "Defaults" -Desc "Remove System Restore"
Disable-ComputerRestore -Drive ${Env:SystemDrive}
VSSADMIN.EXE delete shadows /all /Quiet | Out-Null
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" -Name "DisableConfig" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" -Name "DisableSR " -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "DisableConfig" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" -Name "DisableSR " -Type Dword -Value "1"
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\SystemRestore\" -TaskName "SR" -Confirm:$false

# Remove Telemetry
Output-Section -Section "Defaults" -Desc "Remove Telemetry"
Add-Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "MaxTelemetryAllowed" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "AllowTelemetry" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" -Name "MaxTelemetryAllowed" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection" -Name "AllowTelemetry" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" -Name "AllowBuildPreview" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Name "NoGenTicket" -Type Dword -Value "1" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\SQMClient\Windows" -Name "CEIPEnable" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "AITEnable" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\AppCompat" -Name "DisableInventory" -Type Dword -Value "1" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\AppV\CEIP" -Name "CEIPEnable" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\TabletPC" -Name "PreventHandwritingDataSharing" -Type Dword -Value "1" 
Add-Reg "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" -Name "AllowLinguisticDataCollection" -Type Dword -Value "0" 
Add-Reg "HKCU:\Control Panel\International\User Profile" -Name "HttpAcceptLanguageOptOut" -Type Dword -Value "1" 
Add-Reg "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackProgs" -Type Dword -Value "0" 
Add-Reg "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitInkCollection" -Type Dword -Value "0" 
Add-Reg "HKCU:\Software\Microsoft\InputPersonalization" -Name "RestrictImplicitTextCollection" -Type Dword -Value "0" 
Add-Reg "HKCU:\Software\Microsoft\InputPersonalization\TrainedDataStore" -Name "HarvestContacts" -Type Dword -Value "0" 
Add-Reg "HKCU:\Software\Microsoft\Personalization\Settings" -Name "AcceptedPrivacyPolicy" -Type Dword -Value "0" 
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Application Experience\" -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Autochk\" -TaskName "Proxy" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "Consolidator" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "UsbCeip" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\DiskDiagnostic\" -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector" -Confirm:$false
Add-Reg "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" -Name "Value" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" -Name "Value" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "AutoConnectAllowedOEM" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" -Name "WiFISenseAllowed" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "EnableActivityFeed" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "PublishUserActivities" -Type Dword -Value "0" 
Add-Reg "HKLM:\SOFTWARE\Policies\Microsoft\Windows\System" -Name "UploadUserActivities" -Type Dword -Value "0" 

# Remove Windows Services
Output-Section -Section "Defaults" -Desc "Remove Services/Tasks"
#Connected User Experiences and Telemetry
Del-Service -Name DiagTrack
#WAP (Wireless Application Protocol) Push Message Routing Service
Del-Service -Name dmwappushservice
#Windows Error Reporting Service
Del-Service -Name WerSvc
#Calendar/Contacts/Mail Sync
Del-Service -Name OneSyncSvc
#Text Messaging Support
Del-Service -Name MessagingService
#Problem Reports and Solutions Control Panel Support
Del-Service -Name wercplsupport
#Program Compatibility Assistant Service
Del-Service -Name PcaSvc
#Microsoft Account Sign-in Assistant
SC.EXE config wlidsvc start=demand | Out-Null
#Windows Insider Service
Del-Service -Name wisvc
#Retail Demo Experience (RDX)
Del-Service -Name RetailDemo
#Diagnostic Execution Service
Del-Service -Name diagsvc
#Shared PC Account Manager
Del-Service -Name shpamsvc
#Recommended Troubleshooting Service
Del-Service -Name TroubleshootingSvc
#Windows Search Indexing
SC.EXE stop WSearch | Out-Null
SC.EXE config WSearch start=disabled | Out-Null
# Remove Scheduled Tasks
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Application Experience\" -TaskName "Microsoft Compatibility Appraiser" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Application Experience\" -TaskName "ProgramDataUpdater" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Application Experience\" -TaskName "StartupAppTask" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Autochk\" -TaskName "Proxy" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\CloudExperienceHost\" -TaskName "CreateObjectTask" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "Consolidator" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Customer Experience Improvement Program\" -TaskName "UsbCeip" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\DiskDiagnostic\" -TaskName "Microsoft-Windows-DiskDiagnosticDataCollector" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\DiskFootprint\" -TaskName "Diagnostics" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\FileHistory\" -TaskName "File History (maintenance mode)" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Maintenance\" -TaskName "WinSAT" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\PI\" -TaskName "Sqm-Tasks" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Power Efficiency Diagnostics\" -TaskName "AnalyzeSystem" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Shell\" -TaskName "FamilySafetyMonitor" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Windows Error Reporting\" -TaskName "QueueReporting" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\License Manager\" -TaskName "TempSignedLicenseExchange" -Confirm:$false
Unregister-ScheduledTask -TaskPath "Microsoft\Windows\Clip\" -TaskName "License Validation" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\ApplicationData\" -TaskName "DsSvcCleanup" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Power Efficiency Diagnostics\" -TaskName "AnalyzeSystem" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\PushToInstall\" -TaskName "LoginCheck" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\PushToInstall\" -TaskName "Registration" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Shell\" -TaskName "FamilySafetyMonitor" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Shell\" -TaskName "FamilySafetyRefreshTask" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Subscription\" -TaskName "EnableLicenseAcquisition" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Subscription\" -TaskName "LicenseAcquisition" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Diagnosis\" -TaskName "RecommendedTroubleshootingScanner" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\Diagnosis\" -TaskName "Scheduled" -Confirm:$false
Unregister-ScheduledTask -TaskPath "\Microsoft\Windows\NetTrace\" -TaskName "GatherNetworkInfo" -Confirm:$false
Remove-Item -Path "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\" -Recurse -Force | Out-Null

# Disable Windows Spotlight
Output-Section -Section "Defaults" -Desc "Disable Windows Spotlight"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "ContentDeliveryAllowed" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "OemPreInstalledAppsEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "PreInstalledAppsEverEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SilentInstalledAppsEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SystemPaneSuggestionsEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-310093Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-314559Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338387Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338388Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338389Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-338393Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353694Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353696Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" -Name "SubscribedContent-353698Enabled" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Type Dword -Value "1"

# Set Windows Update to Manual
Output-Section -Section "Defaults" -Desc "Windows Update => Manual"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "NoAutoUpdate" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "AUOptions" -Type Dword -Value "2"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallDay" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" -Name "ScheduledInstallTime" -Type Dword -Value "3"

# Disable 'System requirements not met' Warning
Add-Reg -Path "HKCU:\Control Panel\UnsupportedHardwareNotificationCache" -Name "SV2" -Type Dword -Value "0"
# Disable License Check on Boot
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" -Name "NoGenTicket" -Type Dword -Value "1"
# Disable Microsoft Account Sync
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\SettingSync" -Name "DisableSettingSync" -Type Dword -Value "2"
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\SettingSync" -Name "DisableSettingSyncUserOverride" -Type Dword -Value "1"
# Remove Windows Tips
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableSoftLanding" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsSpotlightFeatures" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\CloudContent" -Name "DisableWindowsConsumerFeatures" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\Windows\DataCollection" -Name "DoNotShowFeedbackNotifications" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\Software\Policies\Microsoft\WindowsInkWorkspace" -Name "AllowSuggestedAppsInWindowsInkWorkspace" -Type Dword -Value "0"

# Power
Output-Section -Section "Defaults" -Desc "Power Profile"
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/h off" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -hibernate-timeout-ac 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -hibernate-timeout-dc 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -disk-timeout-ac 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -disk-timeout-dc 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -standby-timeout-ac 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X -standby-timeout-dc 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X monitor-timeout-ac 10" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/X monitor-timeout-dc 5" -NoNewWindow -Wait | Out-Null
# Disable Sleep
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" -Name "ShowSleepOption" -Type Dword -Value "0"
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0" -NoNewWindow -Wait | Out-Null
Start-Process -FilePath "${Env:SystemRoot}\System32\POWERCFG.EXE" -ArgumentList "/SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0" -NoNewWindow -Wait | Out-Null
# Disable Memory Compression
Disable-MMAgent -mc | Out-Null
# Remove Modern Swap
Add-Reg -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" -Name "SwapfileControl" -Type Dword -Value "0"
# Disable Accessabilities
Add-Reg -Path "HKCU:\Control Panel\Accessibility\StickyKeys" -Name "Flags" -Type String -Value "506"
Add-Reg -Path "HKCU:\Control Panel\Accessibility\ToggleKeys" -Name "Flags" -Type String -Value "58"
Add-Reg -Path "HKCU:\Control Panel\Accessibility\Keyboard Response" -Name "Flags" -Type String -Value "122"
# Disable Remote Assistance
Add-Reg -Path "HKLM:\SYSTEM\CurrentControlSet\Control\Remote Assistance" -Name "fAllowToGetHelp" -Type Dword -Value "0"

# Create User Folders
New-Item -Type Directory -Path "${Env:ProgramFiles}\Bin" | Out-Null
New-Item -Type Directory -Path "${Env:UserProfile}\.ssh" | Out-Null
New-Item -Type Directory -Path "${Env:AppData}\gnupg" | Out-Null

# Remove Default Apps
Start-Process -FilePath "${Env:SystemRoot}\system32\WindowsPowerShell\v1.0\powershell.exe" -ArgumentList "-NoLogo -NoProfile -ExecutionPolicy Bypass -File `"${PSScriptRoot}\apps.ps1`"" -NoNewWindow -Wait

# Remove Windows Defender
. "${PSScriptRoot}\defender.ps1"

# Disable Microsoft Edge
. "${PSScriptRoot}\msedge.ps1"

# Package Manager
. "${PSScriptRoot}\packages.ps1"

# Windows Theme
. "${PSScriptRoot}\theme.ps1"

# Icons
. "${PSScriptRoot}\icons.ps1"

# Start Menu
. "${PSScriptRoot}\startmenu.ps1"

# Mapped Network Drives
. "${PSScriptRoot}\mapdrives.ps1"

# Reboot
Write-Output "[37m [0m"
Read-Host -Prompt "[37mPress [1;37mENTER[0m [37mto reboot [0m"
#PAUSE >nul
Start-Process -FilePath "${Env:SystemRoot}\system32\SHUTDOWN.EXE" -ArgumentList "-t 0 -r -f" -NoNewWindow | Out-Null
