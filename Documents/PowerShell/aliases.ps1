Set-Alias .. Set-LocationUp
Set-Alias ... Set-LocationUp2
Set-Alias c chezmoi
Set-Alias cat 'C:\Program Files\Git\usr\bin\cat.exe'
Set-Alias cls clear
Set-Alias e Invoke-Exit
Set-Alias g git
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
Set-Alias lg lazygit
# The aliases below already exist
#Set-Alias md mkdir
#Set-Alias rd rmdir

function cad {
    chezmoi add @args
}

function cap {
    chezmoi apply @args
}

function ccd {
    chezmoi cd @args
}

function cdi {
    chezmoi diff @args
}

function cst {
    chezmoi status @args
}

function cup {
    chezmoi update @args
}

# git, like in zsh. From https://github.com/ohmyzsh/ohmyzsh/tree/master/plugins/git
# Local branches whose remote branch is gone
function gbg {
    git branch -vv | Where-Object { $_ -match ': gone\]' }
}

function gbgD {
    # Each line starts with two characters: "* " for the current branch. @()
    # keeps one branch a list, which @branches would otherwise pass by letter
    $branches = @(gbg | ForEach-Object { ($_.Substring(2) -split ' ')[0] })
    if ($branches) { git branch --delete --force @branches }
}

function gc! {
    git commit --verbose --amend @args
}

function gmom {
    git merge "origin/$(git_main_branch)" --no-edit @args
}

function gpsup {
    git push --set-upstream origin "$(git_current_branch)" @args
}

function grbom {
    git rebase "origin/$(git_main_branch)" @args
}

function gswm {
    git switch "$(git_main_branch)" @args
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

# OpenSSH's ssh-copy-id, which comes with Git but isn't on PATH. Git's bash puts
# Git's ssh and the other commands it uses on PATH
function ssh-copy-id {
    & 'C:\Program Files\Git\bin\bash.exe' /usr/bin/ssh-copy-id @args
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
