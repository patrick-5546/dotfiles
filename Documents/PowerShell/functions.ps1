# map jk to escape insert mode: https://stackoverflow.com/a/62426108
function mapTwoLetterNormal($a, $b){
  mapTwoLetterFunc $a $b -func $function:setViCommandMode
}

function setViCommandMode{
    [Microsoft.PowerShell.PSConsoleReadLine]::ViCommandMode()
}

function mapTwoLetterFunc($a,$b,$func) {
  if ([Microsoft.PowerShell.PSConsoleReadLine]::InViInsertMode()) {
    $key = $host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown")
    if ($key.Character -eq $b) {
        &$func
    } else {
      [Microsoft.Powershell.PSConsoleReadLine]::Insert("$a")
      # Representation of modifiers (like shift) when ReadKey uses IncludeKeyDown
      if ($key.Character -eq 0x00) {
        return
      } else {
        # Insert func above converts escape characters to their literals, e.g.
        # converts return to ^M. This doesn't.
        $wshell = New-Object -ComObject wscript.shell
        $wshell.SendKeys("{$($key.Character)}")
      }
    }
  }
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

# From https://github.com/gokcehan/lf/blob/master/etc/lfcd.ps1
function lfcd {
    $tmp = [System.IO.Path]::GetTempFileName()
    lf -last-dir-path="$tmp" $args
    if (Test-Path -PathType Leaf "$tmp") {
        $dir = Get-Content "$tmp"
        Remove-Item -Force "$tmp"
        if (Test-Path -PathType Container "$dir") {
            if ("$dir" -ne "$pwd") {
                cd "$dir"
            }
        }
    }
}

function gswm {
    git switch main
}

function ssh-copy-id($remote) {
    cat ~/.ssh/id_rsa.pub | ssh $remote "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}
