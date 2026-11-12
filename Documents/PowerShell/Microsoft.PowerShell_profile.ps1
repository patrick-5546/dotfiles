# This file's folder. $profile isn't, when PowerShell loads this file from a
# profile elsewhere, such as in a Documents folder that's in OneDrive
$ProfilePath = $PSScriptRoot

# Functions
. $ProfilePath/functions.ps1
. $ProfilePath/ssh.autocomplete.ps1

## PSReadLine configuration
# PSReadLine comes with PowerShell 7, which loads it without Import-Module
Set-PSReadLineOption -EditMode Vi
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Search history for commands that start with the currently entered text
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Chord 'Ctrl+j' -Function NextSuggestion
Set-PSReadlineKeyHandler -Chord 'Ctrl+k' -Function PreviousSuggestion

# Aliases
. $ProfilePath/aliases.ps1

# Environment variables
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:YAZI_CONFIG_HOME = Join-Path $HOME ".config\yazi"
$env:XDG_CONFIG_HOME = Join-Path $HOME ".config"

# Tools installed by mise: https://mise.jdx.dev
# Before atuin, starship and zoxide, which it puts on PATH. Starship replaces
# mise's prompt hook, but mise still updates PATH on cd and after mise commands
(& "$HOME\.local\bin\mise.exe" activate pwsh) | Out-String | Invoke-Expression

# Atuin: https://github.com/atuinsh/atuin
# Replaces Ctrl+r. The Up arrow keeps the prefix search above
atuin init powershell --disable-up-arrow --disable-ai | Out-String | Invoke-Expression

# Prompt
Invoke-Expression (&starship init powershell)

# Zoxide
Invoke-Expression (& { (zoxide init powershell | Out-String) })
