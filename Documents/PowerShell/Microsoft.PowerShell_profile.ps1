#$executionTime = Measure-Command `
#{

# Imports
# - Slowest imports are posh-git, PsFzf, Terminal-Icons
# Import-Module git-aliases -DisableNameChecking
#Import-Module posh-git
# must import PSReadLine before PSFzf
Import-Module PSReadLine
# Import-Module PsFzf
#Import-Module Terminal-Icons

$ProfilePath=Split-Path -parent $profile

# Functions
. $ProfilePath/functions.ps1
. $ProfilePath/ssh.autocomplete.ps1

## PSReadLine configuration
Set-PSReadLineOption -EditMode Vi
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Search history for commands that start with the currently entered text
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Chord 'Ctrl+r' -Function SwitchPredictionView
Set-PSReadlineKeyHandler -Chord 'Ctrl+j' -Function NextSuggestion
Set-PSReadlineKeyHandler -Chord 'Ctrl+k' -Function PreviousSuggestion

## PsFzf configuration
#Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
#$env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
## https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
#$env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'

## Zoxide: https://github.com/ajeetdsouza/Zoxide
#Invoke-Expression (& {
#    $hook = if ($PSVersionTable.PSVersion.Major -lt 6) { 'prompt' } else { 'pwd' }
#    (zoxide init --hook $hook powershell | Out-String)
#})

# Aliases
. $ProfilePath/aliases.ps1

# Environment variables
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:YAZI_CONFIG_HOME = Join-Path $HOME ".config\yazi"
$env:XDG_CONFIG_HOME = Join-Path $HOME ".config"

# Prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })

#}
#Write-Host "$PSCommandPath execution time: $executionTime"
