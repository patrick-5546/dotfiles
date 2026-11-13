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

function Invoke-Exit {
    exit
}

# The repository's main branch: main or trunk, locally or on origin or
# upstream, otherwise master. Like git_main_branch in zsh
function git_main_branch {
    git rev-parse --git-dir *> $null
    if ($LASTEXITCODE -ne 0) { return }
    foreach ($location in 'heads', 'remotes/origin', 'remotes/upstream') {
        foreach ($branch in 'main', 'trunk') {
            git show-ref --quiet --verify "refs/$location/$branch"
            if ($LASTEXITCODE -eq 0) { return $branch }
        }
    }
    'master'
}

# The current branch, or the commit when HEAD is detached
function git_current_branch {
    $ref = git symbolic-ref --quiet --short HEAD 2> $null
    if ($LASTEXITCODE -ne 0) { $ref = git rev-parse --short HEAD 2> $null }
    $ref
}
