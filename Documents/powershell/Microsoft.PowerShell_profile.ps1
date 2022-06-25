#$executionTime = Measure-Command `
#{

# Imports
# - Slowest imports are posh-git, PsFzf, Terminal-Icons
Import-Module git-aliases -DisableNameChecking
Import-Module posh-git
# must import PSReadLine before PSFzf
Import-Module PSReadLine
Import-Module PsFzf
Import-Module Terminal-Icons

# PSReadLine configuration
Set-PSReadLineOption -EditMode Vi
# https://stackoverflow.com/a/62426108
Set-PSReadLineKeyHandler -vimode insert -Chord "j" -ScriptBlock { mapTwoLetterNormal 'j' 'k' }
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

# PsFzf configuration
Set-PsFzfOption -PSReadlineChordProvider 'Ctrl+f' -PSReadlineChordReverseHistory 'Ctrl+r'
$env:FZF_DEFAULT_OPTS = '--height 40% --layout=reverse --info=inline'
# https://github.com/junegunn/fzf/wiki/Windows#relative-filepaths
$env:FZF_DEFAULT_COMMAND = 'rg --files . 2> nul'

# Aliases
#Set-Alias .. "cd .."
#Set-Alias ... 'cd ../..'
Set-Alias c chezmoi
Set-Alias cls clear
#Set-Alias e 'exit'
Set-Alias grep rg
Set-Alias l ls
Set-Alias less 'C:\Program Files\Git\usr\bin\less.exe'
#Set-Alias md mkdir
#Set-Alias rd rmdir  # works but md doesn't
Set-Alias vim nvim

# Prompt
Invoke-Expression (&starship init powershell)

#}
#Write-Host "$PSCommandPath execution time: $executionTime"
