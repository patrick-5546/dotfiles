#$executionTime = Measure-Command `
#{

# Imports
# - Slowest imports are posh-git, PsFzf, Terminal-Icons
Import-Module git-aliases -DisableNameChecking
#Import-Module posh-git
# must import PSReadLine before PSFzf
Import-Module PSReadLine
Import-Module PsFzf
#Import-Module Terminal-Icons

$ProfilePath=Split-Path -parent $profile

# Functions
. $ProfilePath/functions.ps1
. $ProfilePath/ssh.autocomplete.ps1

# PSReadLine configuration
Set-PSReadLineOption -EditMode Vi
Set-PSReadLineKeyHandler -vimode insert -Chord "j" -ScriptBlock { mapTwoLetterNormal 'j' 'k' }
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete

# PsFzf configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
# https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
$env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'

# Zoxide: https://github.com/ajeetdsouza/Zoxide
Invoke-Expression (& {
    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
    (zoxide init --hook $hook powershell | Out-String)
})

# Aliases
. $ProfilePath/aliases.ps1

# Prompt
Invoke-Expression (&starship init powershell)

#}
#Write-Host "$PSCommandPath execution time: $executionTime"
