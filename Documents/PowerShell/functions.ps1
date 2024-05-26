function setViCommandMode{
    [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
}

# aliased: https://github.com/renemarc/dotfiles/blob/master/dot_config/powershell/functions.ps1
function Set-LocationUp {
    <#
    .SYNOPSIS
        Goes up a directory.
    .INPUTS
        System.String
    .OUTPUTS
        None
    .LINK
        Set-Location
    #>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='Low'
    )]
    param()

    begin {
        $path = Convert-Path -Path ".."
        Write-Verbose "Destination set to $path"
    }

    process {
        if ($PSCmdlet.ShouldProcess($path, 'Go to directory')) {
            Write-Verbose "Navigating to $path"
            Set-Location $path
        }
    }
}

function Set-LocationUp2 {
    <#
    .SYNOPSIS
        Goes up two directories.
    .INPUTS
        System.String
    .OUTPUTS
        None
    .LINK
        Set-Location
    #>
    [CmdletBinding(
        SupportsShouldProcess=$true,
        ConfirmImpact='Low'
    )]
    param()

    begin {
        $path = Convert-Path -Path "../.."
        Write-Verbose "Destination set to $path"
    }

    process {
        if ($PSCmdlet.ShouldProcess($path, 'Go to directory')) {
            Write-Verbose "Navigating to $path"
            Set-Location $path
        }
    }
}

function Get-ChildItemSimple {
    <#
    .SYNOPSIS
        Lists visible files in wide format.
    .PARAMETER Path
        The directory to list from.
    .INPUTS
        System.String[]
    .OUTPUTS
        System.IO.FileInfo
        System.IO.DirectoryInfo
    .LINK
        Get-ChildItem
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true
        )]
        [string[]]$Path = ".",

        [Parameter(ValueFromRemainingArguments=$true)]
        $Params
    )

    begin {
        # https://stackoverflow.com/a/33302472
        $hashtable = @{}
        if ($Params) {
            $Params | ForEach-Object {
                if ($_ -match "^-") {
                    $hashtable.$($_ -replace "^-") = $null
                }
                else {
                    $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
                }
            }
        }
    }

    process {
        Get-ChildItem -Path @Path @hashtable | Format-Wide
    }
}

function Get-ChildItemVisible {
    <#
    .SYNOPSIS
        Lists visible files in long format.
    .PARAMETER Path
        The directory to list from.
    .INPUTS
        System.String[]
    .OUTPUTS
        System.IO.FileInfo
        System.IO.DirectoryInfo
    .LINK
        Get-ChildItem
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true
        )]
        [string[]]$Path = ".",

        [Parameter(ValueFromRemainingArguments=$true)]
        $Params
    )

    begin {
        # https://stackoverflow.com/a/33302472
        $hashtable = @{}
        if ($Params) {
            $Params | ForEach-Object {
                if ($_ -match "^-") {
                    $hashtable.$($_ -replace "^-") = $null
                }
                else {
                    $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
                }
            }
        }
    }

    process {
        Get-ChildItem -Path @Path @hashtable
    }
}

function Get-ChildItemAll {
    <#
    .SYNOPSIS
        Lists all files in long format, excluding `.` and `..`.
    .PARAMETER Path
        The directory to list from.
    .INPUTS
        System.String[]
    .OUTPUTS
        System.IO.FileInfo
        System.IO.DirectoryInfo
    .LINK
        Get-ChildItem
    #>
    [CmdletBinding()]
    param(
        [Parameter(
            Mandatory=$false,
            ValueFromPipeline=$true
        )]
        [string[]]$Path = ".",

        [Parameter(ValueFromRemainingArguments=$true)]
        $Params
    )

    begin {
        # https://stackoverflow.com/a/33302472
        $hashtable = @{}
        if ($Params) {
            $Params | ForEach-Object {
                if ($_ -match "^-") {
                    $hashtable.$($_ -replace "^-") = $null
                }
                else {
                    $hashtable.$(([string[]]$hashtable.Keys)[-1]) = $_
                }
            }
        }
    }

    process {
        Get-ChildItem -Path @Path -Force @hashtable
    }
}

# yazi
function yy {
    $tmp = [System.IO.Path]::GetTempFileName()
    yazi $args --cwd-file="$tmp"
    $cwd = Get-Content -Path $tmp
    if (-not [String]::IsNullOrEmpty($cwd) -and $cwd -ne $PWD.Path) {
        Set-Location -LiteralPath $cwd
    }
    Remove-Item -Path $tmp
}
