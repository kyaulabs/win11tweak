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

Output-Section -Section "Apps" -Desc "Remove Bloated Defaults"

$Whitelist = 'Microsoft.DesktopAppInstaller|Microsoft.GetHelp|Microsoft.MicrosoftSolitaireCollection|Microsoft.Paint|Microsoft.WindowsNotepad|Microsoft.WindowsTerminal'
$NonRemovable = 'Microsoft.549981C3F5F10|Microsoft.MicrosoftEdge.Stable|Microsoft.StorePurchaseApp|Microsoft.UI*|Microsoft.VCLibs*|Microsoft.Windows.FilePicker*|Microsoft.WindowsStore'
# remove app packages
$remove = Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $Whitelist -and $_.Name -NotMatch $NonRemovable}
Foreach ($app in $remove) {
    #Write-Output " - RemoveAppx (allusers): ${app}"
    Remove-AppxPackage -Package $app -AllUsers -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null
}
$remove = Get-AppxPackage | Where-Object {$_.Name -NotMatch $Whitelist -and $_.Name -NotMatch $NonRemovable}
Foreach ($app in $remove) {
    #Write-Output " - RemoveAppx: ${app}"
    Remove-AppxPackage -Package $app -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null
}
# built-in apps
$remove = Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $Whitelist -and $_.PackageName -NotMatch $NonRemovable}
Foreach ($pkg in $remove) {
    #Write-Output " - RemoveAppxProvisioned: ${pkg}"
    Remove-AppxProvisionedPackage -PackageName $pkg.PackageName -Online -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null
}
# Only remove MediaPlayer on non-N versions
$os = systeminfo.exe /fo csv | ConvertFrom-Csv | Select -ExpandProperty "OS Name"
if ($os -match "N$") {
    $Blacklist = Get-WindowsPackage -Online | Where-Object {$_.PackageName -Match '^(OpenSSH-Client|Microsoft-Windows-Hello-Face|Microsoft-Windows-InternetExplorer|Microsoft-Windows-QuickAssist|Microsoft-Windows-TabletPCMath|Microsoft-Windows-StepsRecorder|Microsoft-Windows-WordPad).*'} | Select-Object PackageName,PackageState | Sort-Object PackageName
    foreach ($app in $Blacklist) {
        #Write-Output " - RemovePackage (N): ${app}"
        Remove-WindowsPackage -Online -NoRestart -PackageName $app.PackageName -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null
    }
} else {
    $Blacklist = Get-WindowsPackage -Online | Where-Object {$_.PackageName -Match '^(OpenSSH-Client|Microsoft-Windows-Hello-Face|Microsoft-Windows-InternetExplorer|Microsoft-Windows-MediaPlayer|Microsoft-Windows-QuickAssist|Microsoft-Windows-TabletPCMath|Microsoft-Windows-StepsRecorder|Microsoft-Windows-WordPad).*'} | Select-Object PackageName,PackageState | Sort-Object PackageName
    foreach ($app in $Blacklist) {
        #Write-Output " - RemovePackage: ${app}"
        Remove-WindowsPackage -Online -NoRestart -PackageName $app.PackageName -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null
    }
    Disable-WindowsOptionalFeature -Online -FeatureName 'MediaPlayback' -NoRestart -WarningAction:SilentlyContinue | Out-Null
}

# Remove Cortana
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCortana" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  -Name "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" -Type String -Value "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "BingSearchEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "CortanaConsent" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "DisableWebSearch" -Type Dword -Value "1"

# Remove Movies-TypeV/Xbox
Del-Service -Name "XblAuthManager"
Del-Service -Name "XblGameSave"
Del-Service -Name "XboxNetApiSvc"
Del-Service -Name "XboxGipSvc"
Unregister-ScheduledTask -TaskName "XblGameSaveTask" -Confirm:$false
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\GameDVR" -Name "AllowGameDVR" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\GameBar" -Name "AutoGameModeEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\GameBar" -Name "UseNexusForGameBarEnabled" -Type Dword -Value "0"

# Remove Maps
Del-Service -Name "MapsBroker"
Del-Service -Name "lfsvc"
Unregister-ScheduledTask -TaskName "MapsUpdateTask" -Confirm:$false
Unregister-ScheduledTask -TaskName "MapsToastTask" -Confirm:$false

# Remove Third Party Bloat
Output-Section -Section "Apps" -Desc "Remove 3rd Party Bloat"
Get-AppxPackage -Name *EclipseManager* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *ActiproSoftwareLLC* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *PandoraMediaInc* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *CandyCrush* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Wunderlist* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Flipboard* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Twitter* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Facebook* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Spotify* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Minecraft* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Royal Revolt* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *Dolby* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage -Name *TheNewYorkTimes.NYTCrossword* | Remove-AppxPackage -WarningAction:SilentlyContinue | Out-Null
Get-AppxPackage Microsoft.NetworkSpeedTest | Remove-AppxPackage -AllUsers -WarningAction:SilentlyContinue | Out-Null
Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-XPSServices-Features' -NoRestart -WarningAction:SilentlyContinue | Out-Null
Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-Services45' -NoRestart -WarningAction:SilentlyContinue | Out-Null
Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-TCP-PortSharing45' -NoRestart -WarningAction:SilentlyContinue | Out-Null
Disable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' -NoRestart -WarningAction:SilentlyContinue | Out-Null
Remove-Printer -Name "Fax" -ErrorAction:SilentlyContinue | Out-Null

# Remove PowerShellV2 (Deprecated)
Disable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2Root' -NoRestart -WarningAction:SilentlyContinue -ErrorAction:SilentlyContinue | Out-Null

# Remove 3D Paint
$tmpdel = REG.EXE query "HKCR\SystemFileAssociations" /s /k /f "3D " | FIND.EXE /i "3D "
Foreach ($tmp in $tmpdel) {
    REG.EXE delete $tmp /f | Out-Null
}

# Reset Icon Cache / Cleanup OneDrive
TASKKILL.EXE /F /IM explorer.exe | Out-Null

If (-NOT $Microsoft365) {
    # Remove OneDrive
    Output-Section -Section "Apps" -Desc "Remove OneDrive"
    TASKKILL.EXE /F /IM OneDrive.exe | Out-Null
    Start-Process -FilePath "${Env:SystemRoot}\SysWOW64\ONEDRIVESETUP.EXE" -ArgumentList "/uninstall" -NoNewWindow -Wait | Out-Null
    Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\OneDrive" -Name "DisableFileSyncNGSC" -Type Dword -Value "1"
    Remove-Item -Path "${Env:UserProfile}\OneDrive" -Recurse -Force | Out-Null
    Remove-Item -Path "${Env:LocalAppData}\Microsoft\OneDrive" -Recurse -Force | Out-Null
    Remove-Item -Path "${Env:ProgramData}\Microsoft OneDrive" -Recurse -Force | Out-Null
    Remove-Item -Path "${Env:SystemDrive}\OneDriveTemp" -Recurse -Force | Out-Null
}

Start-Process -FilePath "IE4UINIT.EXE" -ArgumentList "-show" -NoNewWindow -Wait | Out-Null
Remove-Item "${Env:LocalAppData}\Microsoft\Windows\Explorer\*" -Include "iconcache*.db" -Force
Start-Process -FilePath "explorer.exe"
