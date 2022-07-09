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

function Output-Logo {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Title
    )

    PROCESS {
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
}

function Output-Section {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Section,
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Desc
    )

    PROCESS {
        Write-Output "[1;36m${dot}[1;37m ${Section}:[0m ${Desc}"
    }
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

    PROCESS {
        If (-NOT (Test-Path $Path)) {
            New-Item -Path $Path -Force | Out-Null
        }
        If ([bool]$Name -And [bool]$Type -And [bool]$Value) {
            Set-ItemProperty -Path $Path -Name $Name -Type $Type -Value $Value -Force | Out-Null
        }
    }
}

function Del-Reg {
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
        [switch] $Recursive
    )

    PROCESS {
        If ([bool]$Name) {
            If (-NOT ((Get-ItemPropertyValue -Path $Path -Name $Name) -eq $null)) {
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
}

function Del-Service {
    [CmdletBinding()]
    param (
        [Parameter(Mandatory=$true)]
        [ValidateNotNullOrEmpty()]
        [string] $Name
    )

    PROCESS {
        $Service = Get-WmiObject -Class Win32_Service -Filter "Name='$Name'" | Out-Null
        If (-NOT ($Service -eq $null)) {
            $Service.Delete() | Out-Null
        }
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
        [string] $IconName = "",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $Arguments = "",
        [Parameter(Mandatory=$false)]
        [ValidateNotNull()]
        [string] $WorkingDirectory = ""
    )

    PROCESS {
        $link = ""
        If ($Name -eq "Startup") {
            $link = "${Env:ProgramData}\Microsoft\Windows\Start Menu\Programs\Startup\" + $Name + ".lnk"
        } else {
            $link = "${Env:ProgramData}\Windows Start\" + $Name + ".lnk"
        }
        $Shortcut = $Shell.CreateShortcut($link)
        $Shortcut.TargetPath = $Target
        $Shortcut.Arguments = $Arguments

        if ([bool]$IconName) {
            $Shortcut.IconLocation = "${Env:ProgramData}\Windows Icons\Apps\" + $IconName + ".ico,0"
        } else {
            $Shortcut.IconLocation = $Target + ",0"
        }

        $Shortcut.WorkingDirectory = $WorkingDirectory
        $Shortcut.Save()
    }
}

function Set-UserFolderIcon {
    [CmdletBinding()]
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

    PROCESS {
        $file = "${Env:USERPROFILE}\${Name}\desktop.ini"
        ATTRIB -H -S $file
        CAT $file | %{$_ -Replace "IconResource=%SystemRoot%\\system32\\imageres.dll,-${ImageRes}","IconResource=%ProgramData%\Windows Icons\${Icon}.ico"} | Out-File ${file}2
        Move-Item -Path "${file}2" -Destination "$file" -Force
        ATTRIB +H +S $file
    }
}