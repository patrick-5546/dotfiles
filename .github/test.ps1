# Installs the dotfiles from this checkout like the README does, then checks that
# applying again changes nothing and that PowerShell starts cleanly with the
# tools from mise. It replaces your dotfiles, so it only runs in CI.
$ErrorActionPreference = 'Stop'

if ($env:CI -ne 'true') {
    throw 'This replaces your dotfiles, so it only runs in CI (CI=true)'
}
$checkout = Split-Path -Parent $PSScriptRoot
$bin = "$HOME\.local\bin"
$env:Path = "$bin;$env:Path"

$failed = $false
function Fail([string] $Message) {
    Write-Host "::error::$Message"
    $script:failed = $true
}

# Runs code in a new PowerShell, which loads the profile like a new terminal
# does, and returns everything it printed
function Invoke-NewPowerShell([string] $Code) {
    $encoded = [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Code))
    pwsh -NoLogo -EncodedCommand $encoded 2>&1 | Out-String
}

Write-Host '::group::Install the dotfiles'
New-Item -ItemType Directory -Force "$HOME\.local\share" | Out-Null
Copy-Item -Recurse -Force $checkout "$HOME\.local\share\chezmoi"
Invoke-Expression "&{$(Invoke-RestMethod https://get.chezmoi.io/ps1)} -b '$bin'"
chezmoi init --apply --promptBool 'Decrypt the encrypted files with the key passphrase=false'
if ($LASTEXITCODE -ne 0) { throw "chezmoi init --apply failed with exit code $LASTEXITCODE" }
Write-Host '::endgroup::'

Write-Host '::group::Check chezmoi'
$output = chezmoi apply 2>&1 | Out-String
if ($LASTEXITCODE -ne 0 -or $output.Trim()) {
    Fail "Applying again should do nothing, but printed: $output"
}
$output = chezmoi status 2>&1 | Out-String
if ($output.Trim()) { Fail "chezmoi status should be empty, but printed: $output" }
chezmoi verify
if ($LASTEXITCODE -ne 0) { Fail 'chezmoi verify found differences' }
mise ls
Write-Host '::endgroup::'

Write-Host '::group::Check PowerShell'
$output = Invoke-NewPowerShell 'exit'
if ($LASTEXITCODE -ne 0 -or $output.Trim()) { Fail "PowerShell printed on startup: $output" }
# Prints the problems it finds
$checks = @'
$installs = Join-Path $env:LOCALAPPDATA 'mise\installs'
$tools = 'atuin', 'bat', 'delta', 'dust', 'fd', 'fzf', 'gh', 'go', 'lazygit', 'lsd',
    'node', 'npm', 'nvim', 'rg', 'starship', 'uv', 'uvx', 'ya', 'yazi', 'zoxide'
foreach ($tool in $tools) {
    $source = (Get-Command $tool -ErrorAction Ignore | Select-Object -First 1).Source
    if ($source -notlike "$installs\*") {
        "$tool should come from mise, but is $(if ($source) { $source } else { 'missing' })"
        continue
    }
    $version = if ($tool -eq 'go') { & $tool version 2>&1 } else { & $tool --version 2>&1 }
    if ($LASTEXITCODE -ne 0) { "$tool doesn't run: $version" }
}
# Vi insert mode's keys. Command mode's are listed as <Ctrl+r> and <UpArrow>
$ctrlR = (Get-PSReadLineKeyHandler -Chord 'Ctrl+r' | Where-Object Key -eq 'Ctrl+r').Function
if ($ctrlR -ne 'Runs Atuin search') { "Ctrl+r runs '$ctrlR', not Atuin" }
$upArrow = (Get-PSReadLineKeyHandler -Chord 'UpArrow' | Where-Object Key -eq 'UpArrow').Function
if ($upArrow -ne 'HistorySearchBackward') { "UpArrow runs '$upArrow', not HistorySearchBackward" }
if (-not (Get-Command __zoxide_z -ErrorAction Ignore)) { "zoxide isn't initialized" }
'@
$output = Invoke-NewPowerShell $checks
if ($LASTEXITCODE -ne 0 -or $output.Trim()) { Fail "The PowerShell checks failed: $output" }
Write-Host '::endgroup::'

if ($failed) {
    exit 1
}
Write-Host 'All checks passed'
