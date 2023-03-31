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

# PowerShell Script Defaults
$PSDefaultParameterValues['*:Encoding'] = "utf8"
$ErrorActionPreference = "SilentlyContinue"
$WarningPreference = "SilentlyContinue"

# Load User Settings
. "${PSScriptRoot}\..\user_settings.ps1"

# Shell Object
$Shell = New-Object -ComObject WScript.Shell

# U+2580: Upper Half Block
$uhb = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2580",16))
# U+2584: Lower Half Block
$lhb = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2584",16))
# U+2588: Full Block
$fb = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2588",16))
# U+25A0: Black Square
$dot = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("25A0",16))
# U+2713: Check Mark
$check = [System.Char]::ConvertFromUtf32([System.Convert]::toInt32("2713",16))

# Create HKEY_CLASSES_ROOT PSDrive
New-PSDrive -Name "HKCR" -PSProvider "Registry" -Root "HKEY_CLASSES_ROOT" | Out-Null

function Show-Logo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Title
    )

    Write-Output "[0;1;30m${lhb}${lhb}${lhb}${lhb} ${lhb}${lhb}${lhb}${lhb} ${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb} ${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}${lhb}[0m${lhb}${lhb}${lhb}[1m${lhb}${lhb}"
    Write-Output "[30m${fb} [36m${lhb}${lhb} ${lhb} ${lhb}${lhb} ${lhb} ${lhb}${lhb}${lhb}${lhb} ${lhb}${lhb} ${lhb}    [37m${lhb}${lhb}   ${lhb}${lhb}${lhb}${lhb} ${lhb}${lhb}${lhb}${lhb}  ${lhb}${lhb}${lhb} [47m${uhb}[40m"
    Write-Output "[30m${fb} [36m${fb}${fb} ${fb} ${fb}${fb} ${fb} ${fb}${fb} ${fb} ${fb}${fb} ${fb}    [37m${fb}${fb}   ${fb}${fb} ${fb} ${fb}${fb} ${fb} ${fb}${fb}${uhb}  [30m${fb}"
    Write-Output "${dot} [36m${fb}${fb}${lhb}${uhb} ${fb}${fb}${lhb}${fb} ${fb}${fb}${lhb}${fb} ${fb}${fb} ${fb} [31;41m${uhb}${uhb}[1C[37;40m${fb}${fb}   ${fb}${fb}${lhb}${fb} ${fb}${fb}${lhb}${uhb} ${uhb}${fb}${fb}${lhb} [30m${dot}"
    Write-Output "${fb} [46m [36;40m${fb} ${fb} [0;36m${lhb}[1m${lhb} ${fb} [46m [40m${fb} ${fb} [46m [40m${fb} ${fb}    [47m [37m${fb}[40m${lhb}${lhb} [47m [40m${fb} ${fb} [47m [40m${fb} ${fb}  [0m${lhb}[1m${fb}${fb} [30m${fb}"
    Write-Output "[37;47m${lhb}[1C[0;36m${uhb}${uhb} ${uhb} ${uhb}${uhb}${uhb}${uhb} ${uhb}${uhb} ${uhb} ${uhb}${uhb}${uhb}${uhb}    [37m${uhb}${uhb}${uhb}${uhb} ${uhb}${uhb} ${uhb} ${uhb}${uhb}${uhb}${uhb} ${uhb}${uhb}${uhb}  [1;30m${fb}"
    Write-Output "[37m${uhb}${uhb}[0m${uhb}${uhb}${uhb}[1;30m${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb} ${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb} ${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}${uhb}[0m"
    Write-Output "[37m [0m"
    Write-Output "[1;33m${Title}[0m"
    Write-Output "[37m [0m"
}

function Show-Section {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Section,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Desc
    )

    Write-Output "[1;36m${dot}[1;37m ${Section}:[0m ${Desc}"
}

function Add-Reg {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Type,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Value
    )

    If (-NOT (Test-Path $Path)) {
        New-Item -Path $Path -Force | Out-Null
    }
    If ([bool]$Name -And [bool]$Type -And [bool]$Value) {
        Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value -Force | Out-Null
    }
}

function Remove-Reg {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Path,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [switch] $Recursive
    )

    If ([bool]$Name) {
        If (-NOT ($null -eq (Get-ItemPropertyValue -Path $Path -Name $Name))) {
            Remove-ItemProperty -Path $Path -Name $Name -Force | Out-Null
        }
    } Else {
        If (Test-Path $Path) {
            If ($Recursive) {
                Remove-Item -Path $Path -Recurse -Force | Out-Null
            } Else {
                Remove-Item -Path $Path -Force | Out-Null
            }
        }
    }
}

function Remove-WService {
    # PSScriptAnalyzer - ignore system state change
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSUseShouldProcessForStateChangingFunctions", "", Justification = "False Positive")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    $Service = Get-CimInstance -ClassName Win32_Service -Filter "Name='$Name'" | Out-Null
    If (-NOT ($null -eq $Service)) {
        $Service.Delete() | Out-Null
    }
}

function Add-Shortcut {
    [CmdletBinding()]
    param(
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Target,
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $Icon = "",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $Arguments = "",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $WorkingDirectory = ""
    )

    $link = ""
    If ($Name -eq "Startup") {
        $link = "${Env:ProgramData}\Microsoft\Windows\Start Menu\Programs\Startup\" + $Name + ".lnk"
    } else {
        $link = "${Env:ProgramData}\Windows Start\" + $Name + ".lnk"
    }
    $Shortcut = $Shell.CreateShortcut($link)
    $Shortcut.TargetPath = $Target
    $Shortcut.Arguments = $Arguments

    if ([bool]$Icon) {
        $Shortcut.IconLocation = "${Env:ProgramData}\" + $Icon
    } else {
        $Shortcut.IconLocation = $Target + ",0"
    }

    $Shortcut.WorkingDirectory = $WorkingDirectory
    $Shortcut.Save()
}

function Set-UserFolderIcon {
    [CmdletBinding(SupportsShouldProcess = $true)]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int] $ImageRes,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Icon
    )

    $file = "${Env:USERPROFILE}\${Name}\desktop.ini"
    ATTRIB -H -S $file
    $find = "IconResource=%SystemRoot%\\system32\\imageres.dll,-${ImageRes}"
    $replace = "IconResource=%ProgramData%\win11tweak-places.dll,${Icon}"
    Get-Content $file | ForEach-Object{$_ -Replace $find,$replace} | Out-File ${file}2
    Move-Item -Path "${file}2" -Destination "$file" -Force
    ATTRIB +H +S $file
}

function Add-UserFolderIcon {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [int] $ImageRes
    )

    If (-NOT (Test-Path $Name)) {
        New-Item -Path $Name -Force | Out-Null
    }
    $File = "${Name}\desktop.ini"
    $Text = @"
[.ShellClassInfo]
IconResource=%ProgramData%\win11tweak-places.dll,${ImageRes}
ConfirmFileOp=0
DefaultDropEffect=1
"@
    New-Item -ItemType File -Path $File -Value $Text | Out-Null
    Set-ItemProperty $File -Name Attributes -Value "ReadOnly,System,Hidden"
    (Get-Item "${Name}").Attributes = "ReadOnly, Directory"
}

function Show-RunAsUser {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Command
    )

    $cmdfile = @"
@ECHO OFF
${Command}
start /b "" cmd /c del "%~f0"&exit /b
"@
    New-Item -ItemType File -Path "${Env:SystemDrive}\" -Name "temp.bat" -Value $cmdfile -Force | Out-Null
    Start-Process -FilePath "explorer.exe" -Argument "${Env:SystemDrive}\temp.bat" -Verb runas -WindowStyle Hidden
    Write-Host -NoNewLine ""
    Start-Sleep -Seconds 2
    while ((Get-Process cmd).Length -eq 2) {
        Write-Host -NoNewLine ""
        Start-Sleep -Seconds 1
    }
}

function Show-Package {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$false)]
        [string] $Text = " ",
        [Parameter(Mandatory=$false)]
        [ValidateNotNullOrEmpty()]
        [switch] $NewLine
    )

    if ($NewLine) {
            Write-Host "`n" -NoNewline
    } else {
        if ($Text -eq " ") {
            Write-Host "${Text}" -NoNewline
        } else {
            Write-Host " : ${Text} [1;32m${check}[0m" -NoNewline
        }
    }
}

function Find-GitRelease {
    # PSScriptAnalyzer - ignore unused variables
    [Diagnostics.CodeAnalysis.SuppressMessageAttribute("PSReviewUnusedParameter", "Search", Justification = "False positive because variable is used inside of Where-Object.")]
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [string] $Repo,
        [Parameter(Mandatory=$false)]
        [string] $Search
    )

    $URI = "https://api.github.com/repos/${Repo}/releases"
    $Match = Invoke-RestMethod -uri $URI
    $Match[0] | Select-Object -ExpandProperty assets | Where-Object { $_.name -Match $Search } | Select-Object -expand browser_download_url
}

