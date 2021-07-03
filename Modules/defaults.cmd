@ECHO OFF

:: ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
:: █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
:: █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
:: ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
:: █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
:: ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
:: ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀
::
:: Win10Tweaks (KYAU Labs Edition)
:: Copyright (C) 2020 KYAU Labs (https://kyaulabs.com)
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

CLS

ECHO [0;1;30m▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄[0m▄▄▄[1m▄▄
ECHO [30m█ [36m▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    [37m▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ [47m▀[40m
ECHO [30m█ [36m██ █ ██ █ ██ █ ██ █    [37m██   ██ █ ██ █ ██▀  [30m█
ECHO ■ [36m██▄▀ ██▄█ ██▄█ ██ █ [31;41m▀▀[1C[37;40m██   ██▄█ ██▄▀ ▀██▄ [30m■
ECHO █ [46m [36;40m█ █ [0;36m▄[1m▄ █ [46m [40m█ █ [46m [40m█ █    [47m [37m█[40m▄▄ [47m [40m█ █ [47m [40m█ █  [0m▄[1m██ [30m█
ECHO [37;47m▄[1C[0;36m▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    [37m▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  [1;30m█
ECHO [37m▀▀[0m▀▀▀[1;30m▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀[0m
ECHO [37m [0m
ECHO [1;33mWindows 10 Workstation Tweaks[0m
ECHO [37m [0m

:: Enable PowerShell Scripts
ECHO [1;36m■[1;37m General:[0m Enable PowerShell Scripts
reg add "HKLM\SOFTWARE\Microsoft\PowerShell\1\ShellIds\Microsoft.PowerShell" /v "ExecutionPolicy" /t "REG_SZ" /d "RemoteSigned" /f >nul
ECHO [1;36m■[1;37m General:[0m Disable Windows Defender
::reg add "HKLM\Software\Microsoft\Windows Defender\Features" /v "TamperProtection" /t "REG_DWORD" /d "0" /f >/nul
%~dp0..\Tools\dControl.exe /D
:: Network
ECHO [1;36m■[1;37m Network:[0m Force Current Network to Private
PowerShell -Command "Set-NetConnectionProfile -NetworkCategory Private | Out-Null"
ECHO [1;36m■[1;37m Network:[0m Enable Network Browsing
netsh advfirewall firewall set rule group="Network Discovery" new enable=Yes >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\System" /v "LocalAccountTokenFilterPolicy" /t "REG_DWORD" /d "1" /f >nul
:: Remove Default Apps
ECHO [1;36m■[1;37m Cleanup:[0m Default Apps
PowerShell -Command "$Whitelist = 'Microsoft.DesktopAppInstaller|Microsoft.GetHelp|Microsoft.MicrosoftSolitaireCollection|Microsoft.Paint|Microsoft.WindowsNotepad|Microsoft.WindowsTerminal'; $NonRemovable = 'Microsoft.549981C3F5F10|Microsoft.MicrosoftEdge.Stable|Microsoft.StorePurchaseApp|Microsoft.UI*|Microsoft.VCLibs*|Microsoft.WindowsStore'; Get-AppxPackage -AllUsers | Where-Object {$_.Name -NotMatch $Whitelist -and $_.Name -NotMatch $NonRemovable} | Remove-AppxPackage -AllUsers -ErrorAction SilentlyContinue | Out-Null; Get-AppxPackage | Where-Object {$_.Name -NotMatch $Whitelist -and $_.Name -NotMatch $NonRemovable} | Remove-AppxPackage -ErrorAction SilentlyContinue | Out-Null; Get-AppxProvisionedPackage -Online | Where-Object {$_.PackageName -NotMatch $Whitelist -and $_.PackageName -NotMatch $NonRemovable} | Remove-AppxProvisionedPackage -Online -ErrorAction SilentlyContinue | Out-Null" >nul
PowerShell -Command "$Blacklist = Get-WindowsPackage -Online | Where-Object {$_.PackageName -Match '^(OpenSSH-Client|Microsoft-Windows-Hello-Face|Microsoft-Windows-InternetExplorer|Microsoft-Windows-MediaPlayer|Microsoft-Windows-QuickAssist|Microsoft-Windows-TabletPCMath|Microsoft-Windows-StepsRecorder|Microsoft-Windows-WordPad).*'} | Select-Object PackageName,PackageState | Sort-Object PackageName; foreach ($app in $Blacklist) { Remove-WindowsPackage -Online -NoRestart -PackageName $app.PackageName -ErrorAction SilentlyContinue | Out-Null }" >nul
:: Remove 3D Paint
for /f "tokens=1* delims=" %%I in (' reg query "HKEY_CLASSES_ROOT\SystemFileAssociations" /s /k /f "3D Edit" ^| find /i "3D Edit" ') do ( reg delete "%%I" /f >nul )
for /f "tokens=1* delims=" %%I in (' reg query "HKEY_CLASSES_ROOT\SystemFileAssociations" /s /k /f "3D Print" ^| find /i "3D Print" ') do ( reg delete "%%I" /f >nul )
:: Remove Cortana
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCortana" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SYSTEM\CurrentControlSet\Services\SharedAccess\Parameters\FirewallPolicy\FirewallRules"  /v "{2765E0F4-2918-4A46-B9C9-43CDD8FCBA2B}" /t "REG_SZ" /d  "BlockCortana|Action=Block|Active=TRUE|Dir=Out|App=C:\windows\systemapps\microsoft.windows.cortana_cw5n1h2txyewy\searchui.exe|Name=Search  and Cortana  application|AppPkgId=S-1-15-2-1861897761-1695161497-2927542615-642690995-327840285-2659745135-2630312742|" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "BingSearchEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "CortanaConsent" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "DisableWebSearch" /t "REG_DWORD" /d "1" /f >nul
:: Remove Movies/TV/Xbox
sc delete XblAuthManager >nul
sc delete XblGameSave >nul
sc delete XboxNetApiSvc >nul
sc delete XboxGipSvc >nul
schtasks /Change /TN "Microsoft\XblGameSave\XblGameSaveTask" /disable >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\GameDVR" /v "AllowGameDVR" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v "AutoGameModeEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\GameBar" /v "UseNexusForGameBarEnabled" /t "REG_DWORD" /d "0" /f >nul
:: Remove Maps
sc delete MapsBroker >nul
sc delete lfsvc >nul
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsUpdateTask" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Maps\MapsToastTask" /disable >nul
:: Remove Third Party Bloat
PowerShell -Command "Get-AppxPackage -Name *EclipseManager* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *ActiproSoftwareLLC* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *AdobeSystemsIncorporated.AdobePhotoshopExpress* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Duolingo-LearnLanguagesforFree* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *PandoraMediaInc* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *CandyCrush* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Wunderlist* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Flipboard* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Twitter* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Facebook* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Spotify* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Minecraft* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Royal Revolt* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *Dolby* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage -Name *TheNewYorkTimes.NYTCrossword* | Remove-AppxPackage -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Get-AppxPackage Microsoft.NetworkSpeedTest | Remove-AppxPackage -AllUsers -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'MediaPlayback' -NoRestart -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'Printing-XPSServices-Features' -NoRestart -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-Services45' -NoRestart -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'WCF-TCP-PortSharing45' -NoRestart -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'WorkFolders-Client' -NoRestart -WarningAction SilentlyContinue | Out-Null"
PowerShell -Command "Remove-Printer -Name "Fax" -ErrorAction SilentlyContinue | Out-Null"
:: Remove Windows Defender
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "SmartScreenEnabled" /t "REG_SZ" /d "Off" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\AppHost" /v "EnableWebContentEvaluation" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Classes\Local Settings\Software\Microsoft\Windows\CurrentVersion\AppContainer\Storage\microsoft.microsoftedge_8wekyb3d8bbwe\MicrosoftEdge\PhishingFilter" /v "EnabledV9" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" /v "DisableAntiSpyware" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SpyNetReporting" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "SubmitSamplesConsent" /t "REG_DWORD" /d "2" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" /v "DontReportInfectionInformation" /t "REG_DWORD" /d "1" /f >nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\Sense" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontReportInfectionInformation" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MRT" /v "DontOfferThroughWUAU" /t "REG_DWORD" /d "1" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Run" /v "SecurityHealth" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\StartupApproved\Run" /v "SecurityHealth" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\SecHealthUI.exe" /v "Debugger" /t "REG_SZ" /d "%windir%\System32\taskkill.exe" /f >nul
%~dp0..\Tools\install_wim_tweak /o /c Windows-Defender /r >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Notifications\Settings\Windows.SystemToast.SecurityAndMaintenance" /v "Enabled" /t "REG_DWORD" /d "0" /f >nul
reg delete "HKLM\SYSTEM\CurrentControlSet\Services\SecurityHealthService" /f >nul
:: Remove OneDrive
taskkill /f /im OneDrive.exe >nul
%SystemRoot%\SysWOW64\OneDriveSetup.exe /uninstall
reg delete "HKEY_CLASSES_ROOT\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul
reg delete "HKEY_CLASSES_ROOT\Wow6432Node\CLSID\{018D5C66-4533-4307-9B53-224DE2ED1FE6}" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\OneDrive" /v "DisableFileSyncNGSC" /t "REG_DWORD" /d "1" /f >nul
:: Remove PowerShellV2 (Deprecated)
PowerShell -Command "Disable-WindowsOptionalFeature -Online -FeatureName 'MicrosoftWindowsPowerShellV2Root' -NoRestart -WarningAction SilentlyContinue | Out-Null" >nul
PowerShell -Command "Uninstall-WindowsFeature -Name 'PowerShell-V2' -WarningAction SilentlyContinue | Out-Null" >nul
:: Disable Microsoft Edge
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\Main" /v "AllowPrelaunch" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\MicrosoftEdge\TabPreloader" /v "AllowTabPreloading" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer" /v "DisableEdgeDesktopShortcutCreation" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Image File Execution Options\MicrosoftEdge.exe" /v "Debugger" /t "REG_SZ" /d "%windir%\System32\taskkill.exe" /f >nul
PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0msedge.ps1"
:: Disable System Restore
ECHO [1;36m■[1;37m Disable:[0m System Restore
PowerShell -Command "Disable-ComputerRestore -Drive %SystemDrive%" >nul
vssadmin delete shadows /all /Quiet >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableConfig" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\SystemRestore" /v "DisableSR " /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableConfig" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows NT\CurrentVersion\SystemRestore" /v "DisableSR " /t "REG_DWORD" /d "1" /f >nul
schtasks /Change /TN "\Microsoft\Windows\SystemRestore\SR" /disable >nul
:: Disable Telemetry
ECHO [1;36m■[1;37m Disable:[0m Telemetry
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Policies\DataCollection" /v "MaxTelemetryAllowed" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\DataCollection" /v "AllowTelemetry" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\PreviewBuilds" /v "AllowBuildPreview" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\SQMClient\Windows" /v "CEIPEnable" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "AITEnable" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\AppCompat" /v "DisableInventory" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\AppV\CEIP" /v "CEIPEnable" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\TabletPC" /v "PreventHandwritingDataSharing" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\TextInput" /v "AllowLinguisticDataCollection" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Control Panel\International\User Profile" /v "HttpAcceptLanguageOptOut" /t "REG_DWORD" /d "1" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackProgs" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitInkCollection" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\InputPersonalization" /v "RestrictImplicitTextCollection" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\InputPersonalization\TrainedDataStore" /v "HarvestContacts" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Personalization\Settings" /v "AcceptedPrivacyPolicy" /t "REG_DWORD" /d "0" /f >nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowWiFiHotSpotReporting" /v "Value" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\PolicyManager\default\WiFi\AllowAutoConnectToWiFiSenseHotspots" /v "Value" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "AutoConnectAllowedOEM" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\WcmSvc\wifinetworkmanager\config" /v "WiFISenseAllowed" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "EnableActivityFeed" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "PublishUserActivities" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\System" /v "UploadUserActivities" /t "REG_DWORD" /d "0" /f >nul
:: Remove Windows Services
::Connected User Experiences and Telemetry
sc delete DiagTrack >nul
::WAP (Wireless Application Protocol) Push Message Routing Service
sc delete dmwappushservice >nul
::Windows Error Reporting Service
sc delete WerSvc >nul
::Calendar/Contacts/Mail Sync
sc delete OneSyncSvc >nul
::Text Messaging Support
sc delete MessagingService >nul
::Problem Reports and Solutions Control Panel Support
sc delete wercplsupport >nul
::Program Compatibility Assistant Service
sc delete PcaSvc >nul
::Microsoft Account Sign-in Assistant
sc config wlidsvc start=demand >nul
::Windows Insider Service
sc delete wisvc >nul
::Retail Demo Experience (RDX)
sc delete RetailDemo >nul
::Diagnostic Execution Service
sc delete diagsvc >nul
::Shared PC Account Manager
sc delete shpamsvc >nul
::Recommended Troubleshooting Service
sc delete TroubleshootingSvc >nul
::Windows Search Indexing
sc stop WSearch >nul
sc config WSearch start=disabled >nul
:: Remove Scheduled Tasks
schtasks /Change /TN "Microsoft\Windows\Application Experience\Microsoft Compatibility Appraiser" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\ProgramDataUpdater" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Application Experience\StartupAppTask" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Autochk\Proxy" /disable >nul
schtasks /Change /TN "Microsoft\Windows\CloudExperienceHost\CreateObjectTask" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\Consolidator" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Customer Experience Improvement Program\UsbCeip" /disable >nul
schtasks /Change /TN "Microsoft\Windows\DiskDiagnostic\Microsoft-Windows-DiskDiagnosticDataCollector" /disable >nul
schtasks /Change /TN "Microsoft\Windows\DiskFootprint\Diagnostics" /disable >nul
schtasks /Change /TN "Microsoft\Windows\FileHistory\File History (maintenance mode)" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Maintenance\WinSAT" /disable >nul
schtasks /Change /TN "Microsoft\Windows\PI\Sqm-Tasks" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Windows Error Reporting\QueueReporting" /disable >nul
schtasks /Change /TN "Microsoft\Windows\License Manager\TempSignedLicenseExchange" /disable >nul
schtasks /Change /TN "Microsoft\Windows\Clip\License Validation" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\ApplicationData\DsSvcCleanup" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Power Efficiency Diagnostics\AnalyzeSystem" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\LoginCheck" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\PushToInstall\Registration" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyMonitor" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Shell\FamilySafetyRefreshTask" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Subscription\EnableLicenseAcquisition" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Subscription\LicenseAcquisition" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\RecommendedTroubleshootingScanner" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\Diagnosis\Scheduled" /disable >nul
schtasks /Change /TN "\Microsoft\Windows\NetTrace\GatherNetworkInfo" /disable >nul
del /F /Q "C:\Windows\System32\Tasks\Microsoft\Windows\SettingSync\*" 
:: Disable Windows Spotlight
ECHO [1;36m■[1;37m Disable:[0m Windows Spotlight
PowerShell -Command "$o = New-Object System.Security.Principal.NTAccount('%USERNAME%'); $s = $o.Translate([System.Security.Principal.SecurityIdentifier]); $r = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Authentication\LogonUI\Creative\' + $s.Value; New-ItemProperty -Path $r -Name RotatingLockScreenEnabled -Value 0 -PropertyType DWORD -Force | Out-Null; New-PSDrive HKU Registry HKEY_USERS | Out-Null; $r = 'HKU:\'+$s.Value+'\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager'; New-ItemProperty -Path $r -Name RotatingLockScreenEnabled -Value 0 -Type DWORD -Force | Out-Null"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "ContentDeliveryAllowed" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "OemPreInstalledAppsEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "PreInstalledAppsEverEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SilentInstalledAppsEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SystemPaneSuggestionsEnabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-310093Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-314559Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338387Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338388Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338389Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-338393Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353694Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353696Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\ContentDeliveryManager" /v "SubscribedContent-353698Enabled" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t "REG_DWORD" /d "1" /f >nul
:: Set Windows Update to Manual
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "NoAutoUpdate" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "AUOptions" /t "REG_DWORD" /d "2" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallDay" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\WindowsUpdate\AU" /v "ScheduledInstallTime" /t "REG_DWORD" /d "3" /f >nul
:: Disable License Check on Boot
reg add "HKLM\Software\Policies\Microsoft\Windows NT\CurrentVersion\Software Protection Platform" /v "NoGenTicket" /t "REG_DWORD" /d "1" /f >nul
:: Disable Microsoft Account Sync
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSync" /t "REG_DWORD" /d "2" /f >nul
reg add "HKLM\Software\Policies\Microsoft\Windows\SettingSync" /v "DisableSettingSyncUserOverride" /t "REG_DWORD" /d "1" /f >nul
:: Remove Windows Tips
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableSoftLanding" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsSpotlightFeatures" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\Software\Policies\Microsoft\Windows\CloudContent" /v "DisableWindowsConsumerFeatures" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\Software\Policies\Microsoft\Windows\DataCollection" /v "DoNotShowFeedbackNotifications" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\Software\Policies\Microsoft\WindowsInkWorkspace" /v "AllowSuggestedAppsInWindowsInkWorkspace" /t "REG_DWORD" /d "0" /f >nul

:: Package Manager
ECHO [1;36m■[1;37m Install:[0m Chocolatey
PowerShell -Command "Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))" >nul
ECHO [1;36m■[1;37m Install:[0m Packages
for %%a in (7zip autoruns ccleaner ccenhancer chocolateygui cpu-z.install eartrumpet foxitreader gpu-z hashcheck imageglass kdiff3 keepassxc mediainfo mpv putty.install sharex simplewall speedcrunch sysinternals typora windirstat winscp.install youtube-dl) do (
    %ProgramData%\chocolatey\bin\choco.exe install %%a -y -r >nul
)
PowerShell -Command "[Environment]::SetEnvironmentVariable('Path', '%USERPROFILE%\AppData\Local\Microsoft\WindowsApps;%ProgramData%\chocolatey', 'User')"

reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\AppKey\18" /v "ShellExecute" /t "REG_SZ" /d "%ProgramFiles(x86)%\SpeedCrunch\speedcrunch.exe" /f >nul
:: Clean Desktop / Start Menu
DEL /F /Q %USERPROFILE%\Desktop\*.lnk >nul
DEL /F /Q %PUBLIC%\Desktop\*.lnk >nul

:: Power
ECHO [1;36m■[1;37m Config:[0m Power Profile
%SystemRoot%\System32\powercfg.exe /setactive 8c5e7fda-e8bf-4a96-9a85-a6e23a8c635c >nul
%SystemRoot%\System32\powercfg.exe /h off >nul
%SystemRoot%\System32\powercfg.exe /X -hibernate-timeout-ac 0 >nul
%SystemRoot%\System32\powercfg.exe /X -hibernate-timeout-dc 0 >nul
%SystemRoot%\System32\powercfg.exe /X -disk-timeout-ac 0 >nul
%SystemRoot%\System32\powercfg.exe /X -disk-timeout-dc 0 >nul
%SystemRoot%\System32\powercfg.exe /X -standby-timeout-ac 0 >nul
%SystemRoot%\System32\powercfg.exe /X -standby-timeout-dc 0 >nul
%SystemRoot%\System32\powercfg.exe /X monitor-timeout-ac 10 >nul
%SystemRoot%\System32\powercfg.exe /X monitor-timeout-dc 5 >nul
:: Disable Memory Compression
PowerShell -Command "Disable-MMAgent -mc | Out-Null"
:: Remove Modern Swap
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Session Manager\Memory Management" /v "SwapfileControl" /t "REG_DWORD" /d "0" /f >nul
:: Disable Sleep
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FlyoutMenuSettings" /v "ShowSleepOption" /t "REG_DWORD" /d "0" /f >nul
%SystemRoot%\System32\powercfg.exe /SETACVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0 >nul
%SystemRoot%\System32\powercfg.exe /SETDCVALUEINDEX SCHEME_CURRENT SUB_BUTTONS SBUTTONACTION 0 >nul
:: Disable Accessabilities
reg add "HKCU\Control Panel\Accessibility\StickyKeys" /v "Flags" /t "REG_SZ" /d "506" /f >nul
reg add "HKCU\Control Panel\Accessibility\ToggleKeys" /v "Flags" /t "REG_SZ" /d "58" /f >nul
reg add "HKCU\Control Panel\Accessibility\Keyboard Response" /v "Flags" /t "REG_SZ" /d "122" /f >nul
:: Disable Remote Assistance
reg add "HKLM\SYSTEM\CurrentControlSet\Control\Remote Assistance" /v "fAllowToGetHelp" /t "REG_DWORD" /d "0" /f >nul

:: Rename Computer
PowerShell -Command "Rename-Computer -NewName CHLOE -NoRestart | Out-Null ; Add-Computer -WorkGroupName 'AH42' -NoRestart | Out-Null" >nul

:: Windows Theme
ECHO [1;36m■[1;37m Config:[0m Windows Theme
COPY %~dp0..\Resources\Wallpaper\wallpaper-21_9.png %USERPROFILE%\Pictures /Y >nul
COPY %~dp0..\Resources\user.png %ProgramData% /Y >nul
PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0theme.ps1"
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Explorer" /v "HideRecentlyAddedApps" /t "REG_DWORD" /d "1" /f >nul
reg add "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" /v "NoStartMenuMFUprogramsList" /t "REG_DWORD" /d "1" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "Start_TrackDocs" /t "REG_DWORD" /d "0" /f >nul
reg add "HKLM\SOFTWARE\Policies\Microsoft\Windows\Windows Search" /v "AllowCloudSearch" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Search" /v "DeviceHistoryEnabled" /t "REG_DWORD" /d "0" /f >nul
%SystemRoot%\System32\rundll32.exe setupapi,InstallHinfSection DefaultInstall 132 %~dp0..\Resources\Cursors\Install.inf
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "ShowTaskViewButton" /t "REG_DWORD" /d "0" /f >nul
PowerShell -Command "Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer' -Name 'link' -Type Binary -Value ([byte[]](0,0,0,0))"
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "HideFileExt" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SeparateProcess" /t "REG_DWORD" /d "1" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "SharingWizardOn" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowRecent" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer" /v "ShowFrequent" /t "REG_DWORD" /d "0" /f >nul
reg add "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "LaunchTo" /t "REG_DWORD" /d "1" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" /f >nul
reg delete "HKLM\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" /f >nul
:: Icons
mkdir "%ProgramData%\Windows Icons\Start"
mkdir "%ProgramData%\Windows Icons\Apps"
COPY %~dp0..\Resources\Icons\*.ico "%ProgramData%\Windows Icons\" /Y >nul
COPY %~dp0..\Resources\Icons\start\*.ico "%ProgramData%\Windows Icons\Start\" /Y >nul
COPY %~dp0..\Resources\Icons\apps\*.ico "%ProgramData%\Windows Icons\Apps\" /Y >nul
PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0icons.ps1"
:: Reset Icon Cache
set iconcache=%localappdata%\IconCache.db
set iconcache_x=%localappdata%\Microsoft\Windows\Explorer\iconcache*
ie4uinit.exe -show >nul
taskkill /IM explorer.exe /F >nul
If exist del /A /F /Q "%iconcache%" >nul
If exist del /A /F /Q "%iconcache_x%" >nul
RD "%UserProfile%\OneDrive" /Q /S >nul
RD "%LocalAppData%\Microsoft\OneDrive" /Q /S >nul
RD "%ProgramData%\Microsoft OneDrive" /Q /S >nul
RD "%SystemDrive%\OneDriveTemp" /Q /S >nul
start explorer.exe
:: Start Orb
COPY "%~dp0..\Resources\Startorb\Windows 10X.bmp" %ProgramData% /Y >nul
:: Start Menu
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "MMTaskbarEnabled" /t "REG_DWORD" /d "1" /f >nul
REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" /v "TaskbarSi" /t "REG_DWORD" /d "0" /f >nul
MKDIR "%ProgramData%\Windows Start\AdobeCC"
MKDIR "%ProgramData%\Windows Start\Apps"
MKDIR "%ProgramData%\Windows Start\BBS"
MKDIR "%ProgramData%\Windows Start\Creative"
MKDIR "%ProgramData%\Windows Start\Development"
MKDIR "%ProgramData%\Windows Start\Games"
MKDIR "%ProgramData%\Windows Start\Hardware"
MKDIR "%ProgramData%\Windows Start\Media"
MKDIR "%ProgramData%\Windows Start\MSOffice"
MKDIR "%ProgramData%\Windows Start\Utilities"
MKDIR "%ProgramData%\Windows Start\SSH-Local"
MKDIR "%ProgramData%\Windows Start\SSH-Remote"
MKDIR "%ProgramData%\Windows Start\RDP-Spice"

PowerShell -NoLogo -NoProfile -ExecutionPolicy Bypass -File "%~dp0startmenu.ps1"

REG ADD "HKCU\Software\Microsoft\Windows\CurrentVersion\Run" /v "PostFix" /t "REG_SZ" /d "%~dp0postfix.cmd" /f >nul

ECHO [37m [0m
ECHO [37mPress any key to reboot...[0m
PAUSE >nul
SHUTDOWN -t 0 -r -f
