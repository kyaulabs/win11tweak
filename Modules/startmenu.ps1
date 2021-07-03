<#
 ▄▄▄▄ ▄▄▄▄ ▄▄▄▄▄▄▄▄▄ ▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄▄
 █ ▄▄ ▄ ▄▄ ▄ ▄▄▄▄ ▄▄ ▄    ▄▄   ▄▄▄▄ ▄▄▄▄  ▄▄▄ ▀
 █ ██ █ ██ █ ██ █ ██ █    ██   ██ █ ██ █ ██▀  █
 ■ ██▄▀ ██▄█ ██▄█ ██ █ ▀▀ ██   ██▄█ ██▄▀ ▀██▄ ■
 █ ██ █ ▄▄ █ ██ █ ██ █    ██▄▄ ██ █ ██ █  ▄██ █
 ▄ ▀▀ ▀ ▀▀▀▀ ▀▀ ▀ ▀▀▀▀    ▀▀▀▀ ▀▀ ▀ ▀▀▀▀ ▀▀▀  █
 ▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀▀ ▀▀▀▀▀▀▀▀▀▀▀▀▀

 Win10Tweaks (KYAU Labs Edition)
 Copyright (C) 2020 KYAU Labs (https://kyaulabs.com)

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

$Shell = New-Object -ComObject WScript.Shell

function CreateShortcut {
    param( [string]$Name, [string]$Target, [string]$IconName, [string]$Arguments = "", [string]$WorkingDirectory = "" )

    $Shortcut = $Shell.CreateShortcut("$($env:ProgramData)\Windows Start\" + $Name + ".lnk")
    $Shortcut.TargetPath = $Target
    $Shortcut.Arguments = $Arguments

    if ($IconName) {
        $Shortcut.IconLocation = "$($env:ProgramData)\Windows Icons\Apps\" + $IconName + ".ico,0"
    } else {
        $Shortcut.IconLocation = $Target + ",0"
    }

    $Shortcut.WorkingDirectory = $WorkingDirectory
    $Shortcut.Save()
}

CreateShortcut "Apps\Firefox" "$($env:ProgramFiles)\Mozilla Firefox\firefox.exe" ""
CreateShortcut "Apps\Foxit Reader" "$($env:SystemDrive)\Program Files (x86)\Foxit Software\Foxit Reader\FoxitReader.exe" "foxit-reader"
CreateShortcut "Apps\KeePassXC" "$($env:ProgramFiles)\KeePassXC\KeePassXC.exe" "keepassxc"
CreateShortcut "Apps\SSH Agent" "$($env:ProgramFiles)\PuTTY\pageant.exe" "ssh-askpass-gnome" "F:\Private\SSH\id_ed25519.ppk"
CreateShortcut "Development\GitKraken" "$($env:UserProfile)\AppData\Local\gitkraken\Update.exe --processStart gitkraken.exe" ""
CreateShortcut "Development\KDiff3" "$($env:ProgramFiles)\KDiff3\kdiff3.exe" "kdiff3"
CreateShortcut "Development\Typora" "$($env:ProgramFiles)\Typora\Typora.exe" ""
CreateShortcut "Media\ImageGlass" "$($env:ProgramFiles)\ImageGlass\ImageGlass.exe" ""
CreateShortcut "Media\MPV" "$($env:ProgramData)\chocolatey\lib\mpv.install\tools\mpv.exe" "mpv"
CreateShortcut "Utilities\7-Zip File Manager" "$($env:ProgramFiles)\7-zip\7zFM.exe" "file-roller"
CreateShortcut "Utilities\Autoruns" "$($env:ProgramData)\chocolatey\lib\AutoRuns\tools\Autoruns.exe" "bomber"
CreateShortcut "Utilities\CCleaner" "$($env:ProgramFiles)\CCleaner\CCleaner64.exe" ""
CreateShortcut "Utilities\CCEnhancer" "$($env:SystemDrive)\Program Files (x86)\CCEnhancer\CCEnhancer.exe" ""
CreateShortcut "Utilities\Chocolatey GUI" "$($env:SystemDrive)\Program Files (x86)\Chocolatey GUI\ChocolateyGui.exe" ""
CreateShortcut "Utilities\Core Temp" "$($env:ProgramData)\chocolatey\lib\coretemp\tools\Core Temp.exe" "thermal-monitor"
CreateShortcut "Utilities\DisplayFusion" "$($env:SystemDrive)\Program Files (x86)\DisplayFusion\DisplayFusionCommand.exe -windowsettings" ""
CreateShortcut "Utilities\ShareX" "$($env:ProgramFiles)\ShareX\ShareX.exe" ""
CreateShortcut "Utilities\SimpleWall" "$($env:ProgramFiles)\simplewall\simplewall.exe" ""
CreateShortcut "Utilities\WinDirStat" "$($env:SystemDrive)\Program Files (x86)\WinDirStat\windirstat.exe" "partitionmanager"
