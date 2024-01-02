Set-Alias .. Set-LocationUp
Set-Alias ... Set-LocationUp2
Set-Alias c chezmoi
Set-Alias cat 'C:\Program Files\Git\usr\bin\cat.exe'
Set-Alias cls clear
#Set-Alias e 'exit'
Set-Alias l Get-ChildItemAll
Set-Alias ll Get-ChildItemVisible
Set-Alias ls Get-ChildItemSimple
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
#Set-Alias md mkdir
#Set-Alias rd rmdir  # works but md doesn't

function gswm {
    git switch main
}

## From https://github.com/gokcehan/lf/blob/master/etc/lfcd.ps1
#function lfcd {
#    $tmp = [System.IO.Path]::GetTempFileName()
#    lf -last-dir-path="$tmp" $args
#    if (Test-Path -PathType Leaf "$tmp") {
#        $dir = Get-Content "$tmp"
#        Remove-Item -Force "$tmp"
#        if (Test-Path -PathType Container "$dir") {
#            if ("$dir" -ne "$pwd") {
#                cd "$dir"
#            }
#        }
#    }
#}

function ssh-copy-id($remote) {
    cat ~/.ssh/id_rsa.pub | ssh $remote "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
}

function which($name)
{
        Get-Command $name | Select-Object -ExpandProperty Definition
}
