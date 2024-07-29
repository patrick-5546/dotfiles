Set-Alias .. Set-LocationUp
Set-Alias ... Set-LocationUp2
Set-Alias c chezmoi
Set-Alias cat 'C:\Program Files\Git\usr\bin\cat.exe'
Set-Alias cls clear
Set-Alias e Invoke-Exit
Set-Alias g git
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
# The aliases below already exist
#Set-Alias md mkdir
#Set-Alias rd rmdir

function cad {
    Invoke-Chezmoi -SubCommand add @args
}

function cap {
    Invoke-Chezmoi -SubCommand apply @args
}

function ccd {
    Invoke-Chezmoi -SubCommand cd @args
}

function cdi {
    Invoke-Chezmoi -SubCommand diff @args
}

function cst {
    Invoke-Chezmoi -SubCommand status @args
}

function cup {
    Invoke-Chezmoi -SubCommand update @args
}

function gswm {
    git switch main
}

# Prevent conflict with built-in aliases
Remove-Alias ls -Force -ErrorAction SilentlyContinue

function ls {
    lsd @args
}

function l {
    ll -alh @args
}

function ll {
    ls -lh @args
}

function llt {
    ll -lhrt @args
}

function lt {
    ls -alhrt @args
}

function kstart {
    komorebic start --whkd
}

function kstop {
    komorebic stop --whkd
}

function ssh-copy-id($remote) {
    cat ~/.ssh/id_rsa.pub | ssh $remote "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

function which($name)
{
        Get-Command $name | Select-Object -ExpandProperty Definition
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
