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

Show-Section -Section "Theme" -Desc "Set Desktop/LockScreen Wallpaper"

# Copy Wallpaper
Copy-Item "${PSScriptRoot}\..\Resources\Wallpaper\wallpaper-21_9.png" -Destination "${Env:UserProfile}\Pictures" -Force | Out-Null
Copy-Item "${PSScriptRoot}\..\Resources\user.png" -Destination "${Env:ProgramData}" -Force | Out-Null

# Start Orb
Copy-Item "${PSScriptRoot}\..\Resources\Startorb\Windows 11X.bmp" -Destination "${Env:ProgramData}" -Force | Out-Null

# LockScreen Image
$NewWallpaperPath = "${Env:TEMP}\" + (New-Guid).Guid + [System.IO.Path]::GetExtension($WallpaperPath)
Copy-Item $WallpaperPath $NewWallpaperPath
[Windows.System.UserProfile.LockScreen,Windows.System.UserProfile,ContentType=WindowsRuntime] | Out-Null
Add-Type -AssemblyName System.Runtime.WindowsRuntime
$asTaskGeneric = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and $_.GetParameters()[0].ParameterType.Name -eq 'IAsyncOperation`1' })[0]
function Await($WinRtTask, $ResultType) {
    $asTask = $asTaskGeneric.MakeGenericMethod($ResultType)
    $netTask = $asTask.Invoke($null, @($WinRtTask))
    $netTask.Wait(-1) | Out-Null
    $netTask.Result
}
function AwaitAction($WinRtAction) {
    $asTask = ([System.WindowsRuntimeSystemExtensions].GetMethods() | Where-Object { $_.Name -eq 'AsTask' -and $_.GetParameters().Count -eq 1 -and !$_.IsGenericMethod })[0]
    $netTask = $asTask.Invoke($null, @($WinRtAction))
    $netTask.Wait(-1) | Out-Null
}
[Windows.Storage.StorageFile,Windows.Storage,ContentType=WindowsRuntime] | Out-Null
$LockImage = Await ([Windows.Storage.StorageFile]::GetFileFromPathAsync($NewWallpaperPath)) ([Windows.Storage.StorageFile])
AwaitAction ([Windows.System.UserProfile.LockScreen]::SetImageFileAsync($LockImage))
Remove-Item $NewWallpaperPath

# Wallpaper Image
$DesktopImage = $WallpaperPath;
Add-Type -TypeDefinition @"
    using System;
    using System.Runtime.InteropServices;

    public class Params
    {
        [DllImport("User32.dll",CharSet=CharSet.Unicode)]
        public static extern int SystemParametersInfo (Int32 uAction,
                                                       Int32 uParam,
                                                       String lpvParam,
                                                       Int32 fuWinIni);
    }
"@
$SPI_SETDESKWALLPAPER = 0x0014
$UpdateIniFile = 0x01
$SendChangeEvent = 0x02
$fWinIni = $UpdateIniFile -bor $SendChangeEvent
[Params]::SystemParametersInfo($SPI_SETDESKWALLPAPER, 0, $DesktopImage, $fWinIni) | Out-Null

Show-Section -Section "Theme" -Desc "Cleanup Windows Theme"
# UnPin Tiles from Start Menu
$key = Get-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\CloudStore\Store\Cache\DefaultAccount\*start.tilegrid`$windows.data.curatedtilecollection.tilecollection\Current"
$data = $key.Data[0..25] + ([byte[]](202,50,0,226,44,1,1,0,0))
Set-ItemProperty -Path $key.PSPath -Name "Data" -Type Binary -Value $data
Stop-Process -Name "ShellExperienceHost" -Force -ErrorAction:SilentlyContinue
# Restore OG Right-Click Menu
REG.EXE ADD "HKCU\Software\Classes\CLSID\{86ca1aa0-34aa-4e8b-a509-50c905bae2a2}\InprocServer32" /f /ve
# UnPin Taskbar Icons
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "Favorites" -Type Binary -Value ([byte[]](255))
Remove-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Taskband" -Name "FavoritesResolve"
# Disable Thumbs.db on Network Folders
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "DisableThumbsDBOnNetworkFolders" -Type DWord -Value 1
# Hide Context Menu Bloat
Remove-Item -LiteralPath "HKCR:\*\shellex\ContextMenuHandlers\Sharing" -Recurse
Remove-Reg -Path "HKCR:\Folder\ShellEx\ContextMenuHandlers\Library Location" -Recursive
Remove-Reg -Path "HKCR:\Directory\Background\shellex\ContextMenuHandlers\Sharing" -Recursive
Remove-Reg -Path "HKCR:\Directory\shellex\ContextMenuHandlers\Sharing" -Recursive
Remove-Reg -Path "HKCR:\Drive\shellex\ContextMenuHandlers\Sharing" -Recursive
# Explorer Cleanup
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3dfdf296-dbec-4fb4-81d1-6a3438bcf4de}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{f86fa3ab-70d2-4fc7-9c99-fcbf05467f3a}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{0DB7E03F-FC29-4DC6-9020-FF41B59E513A}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{d3162b92-9365-467a-956b-92703aca08af}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{088e3905-0323-4b02-9826-5d99428e115f}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{374DE290-123F-4565-9164-39C4925E467B}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{24ad3ad4-a569-4530-98e1-ab02f9417aa8}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\MyComputer\NameSpace\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{B4BFCC3A-DB2C-424C-B029-7FE99A87C641}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{374DE290-123F-4565-9164-39C4925E467B}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{A8CDFF1C-4878-43be-B5FD-F8091C1C60D0}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{1CF1260C-4DD0-4ebb-811F-33C572699FDE}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{3ADD1653-EB32-4cb0-BBD7-DFA0ABB5ACCA}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{A0953C92-50DC-43bf-BE83-3742FED03C9C}" -Recursive
Remove-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Desktop\NameSpace_36354489\{f874310e-b6b7-47dc-bc84-b9e6b38f5903}" -Recursive
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{a0c69a99-21c8-4671-8703-7934162fcf1d}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{35286a68-3c57-41a1-bbb1-0eae73d76c95}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Wow6432Node\Microsoft\Windows\CurrentVersion\Explorer\FolderDescriptions\{31C0DD25-9439-4F12-BF41-7FF4EDA38722}\PropertyBag" -Name "ThisPCPolicy" -Type String -Value "Hide"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Explorer" -Name "HideRecentlyAddedApps" -Type Dword -Value "1"
Add-Reg -Path "HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Policies\Explorer" -Name "NoStartMenuMFUprogramsList" -Type Dword -Value "1"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "Start_TrackDocs" -Type Dword -Value "0"
Add-Reg -Path "HKLM:\SOFTWARE\Policies\Microsoft\Windows\Windows Search" -Name "AllowCloudSearch" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Search" -Name "DeviceHistoryEnabled" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskViewButton" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "link" -Type Binary -Value ([byte[]](0,0,0,0))
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "HideFileExt" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SeparateProcess" -Type Dword -Value "1"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "SharingWizardOn" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowRecent" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer" -Name "ShowFrequent" -Type Dword -Value "0"
Add-Reg -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "LaunchTo" -Type Dword -Value "1"

Show-Section -Section "Theme" -Desc "Install Mouse Theme"
Start-Process -FilePath "${Env:SystemRoot}\System32\RUNDLL32.EXE" -ArgumentList "setupapi,InstallHinfSection DefaultInstall 132 ${PSScriptRoot}\..\Resources\Cursors\Install.inf" -NoNewWindow | Out-Null
