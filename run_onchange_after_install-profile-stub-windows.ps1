# PowerShell loads the profile from the Documents folder, which can be in
# OneDrive rather than ~\Documents, where chezmoi puts it. Then this writes a
# profile there that loads chezmoi's, unless that one has other commands.
# chezmoi runs this after applying files, and again whenever this script changes.
$ErrorActionPreference = 'Stop'

$chezmoiProfile = Join-Path $HOME 'Documents\PowerShell\Microsoft.PowerShell_profile.ps1'
$profilePath = $PROFILE.CurrentUserCurrentHost
if ($profilePath -eq $chezmoiProfile) { return }

$stub = '. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"'
$current = if (Test-Path $profilePath -PathType Leaf) { "$(Get-Content -Raw $profilePath)".Trim() }
if ($current -eq $stub) { return }
if ($current) {
    Write-Warning "$profilePath has other commands, so it's left as is. To load the dotfiles' profile, add: $stub"
    return
}
Write-Host "`n# Load the dotfiles' profile from $profilePath"
New-Item -ItemType Directory -Force (Split-Path $profilePath) | Out-Null
Set-Content -Path $profilePath -Value $stub
