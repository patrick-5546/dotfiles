# This file's folder. $profile isn't, when PowerShell loads this file from a
# profile elsewhere, such as in a Documents folder that's in OneDrive
$ProfilePath = $PSScriptRoot

# Functions
. $ProfilePath/functions.ps1
. $ProfilePath/ssh.autocomplete.ps1

## PSReadLine configuration
# PSReadLine comes with PowerShell 7, which loads it without Import-Module
Set-PSReadLineOption -EditMode Vi
# A beam cursor in insert mode and a block in command mode, like in zsh.
# starship init, below, keeps this handler and adds its own
Set-PSReadLineOption -ViModeIndicator Script -ViModeChangeHandler {
    if ($args[0] -eq 'Command') { Write-Host -NoNewline "`e[1 q" } else { Write-Host -NoNewline "`e[5 q" }
}
# Shows navigable menu of all options when hitting Tab
Set-PSReadlineKeyHandler -Key Tab -Function MenuComplete
# Search history for commands that start with the currently entered text
Set-PSReadLineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadLineKeyHandler -Key DownArrow -Function HistorySearchForward
Set-PSReadLineOption -HistorySearchCursorMovesToEnd
Set-PSReadlineKeyHandler -Chord 'Ctrl+j' -Function NextSuggestion
Set-PSReadlineKeyHandler -Chord 'Ctrl+k' -Function PreviousSuggestion
# Edit the command in Neovim, $env:VISUAL, like in zsh
Set-PSReadLineKeyHandler -Chord 'Ctrl+e' -Function ViEditVisually

# Aliases
. $ProfilePath/aliases.ps1

# Environment variables
$env:VISUAL = 'nvim'
$env:EDITOR = $env:VISUAL
$env:YAZI_FILE_ONE = "C:\Program Files\Git\usr\bin\file.exe"
$env:YAZI_CONFIG_HOME = Join-Path $HOME ".config\yazi"
$env:XDG_CONFIG_HOME = Join-Path $HOME ".config"
# delta and bat page with less, which comes with Git but isn't on PATH. Without
# arguments, so that they add their own options for less, such as -R and
# --quit-if-one-screen. The quotes are for the space: they split it like a command
$env:DELTA_PAGER = '"C:\Program Files\Git\usr\bin\less.exe"'
$env:BAT_PAGER = $env:DELTA_PAGER
# Like in zsh, fzf takes 40% of the window and lists files with fd. It runs the
# command with cmd, where single quotes don't quote, so .git has none
$env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
$env:FZF_DEFAULT_COMMAND = 'fd --hidden --follow --exclude .git'

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
