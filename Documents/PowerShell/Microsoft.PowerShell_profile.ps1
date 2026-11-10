# Imports
Import-Module PSReadLine

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

# Aliases
. $ProfilePath/aliases.ps1

# Environment variables
$env:KOMOREBI_CONFIG_HOME = Join-Path $HOME ".config\komorebi"
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:YAZI_CONFIG_HOME = Join-Path $HOME ".config\yazi"
$env:XDG_CONFIG_HOME = Join-Path $HOME ".config"

# Tools installed by mise: https://mise.jdx.dev
# Before starship and zoxide, which it puts on PATH. Starship replaces mise's
# prompt hook, but mise still updates PATH on cd and after mise commands
(& "$HOME\.local\bin\mise.exe" activate pwsh) | Out-String | Invoke-Expression

# Prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
