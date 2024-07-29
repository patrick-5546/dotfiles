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

function Invoke-Chezmoi {
    param(
        [Parameter(Mandatory=$true)]
        [string]$SubCommand,

        [Parameter(Mandatory=$false)]
        [string[]]$Arguments
    )

    & chezmoi $SubCommand @Arguments
}

