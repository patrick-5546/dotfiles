# Installs the dotfiles from this checkout like the README does, then checks that
# applying again changes nothing, that PowerShell starts cleanly with the tools
# from mise, and that Neovim is ready to use. It replaces your dotfiles, so it
# only runs in CI.
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

# Encodes code for pwsh -EncodedCommand, so it doesn't need quoting
function ConvertTo-EncodedCommand([string] $Code) {
    [Convert]::ToBase64String([Text.Encoding]::Unicode.GetBytes($Code))
}

# Runs code in a new PowerShell, which loads the profile like a new terminal
# does, and returns everything it printed
function Invoke-NewPowerShell([string] $Code) {
    pwsh -NoLogo -EncodedCommand (ConvertTo-EncodedCommand $Code) 2>&1 | Out-String
}

Write-Host '::group::Install the dotfiles'
New-Item -ItemType Directory -Force "$HOME\.local\share" | Out-Null
Copy-Item -Recurse -Force $checkout "$HOME\.local\share\chezmoi"
Invoke-Expression "&{$(Invoke-RestMethod https://get.chezmoi.io/ps1)} -b '$bin'"
chezmoi init --apply --promptBool 'Decrypt the encrypted files with the key passphrase=false' `
    --promptBool 'Install the desktop apps=false'
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
    'node', 'npm', 'nvim', 'rg', 'starship', 'tree-sitter', 'uv', 'uvx', 'ya', 'yazi', 'zoxide'
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

Write-Host '::group::Check Neovim'
# Opening a file the first time installs the plugins, tools, language servers
# and parsers. The new PowerShell loads the profile, which sets XDG_CONFIG_HOME
# for Neovim. lazy.nvim's install log on stdout is mostly git's progress, so
# it's only shown on failure. The temp folder's path is shortened to RUNNER~1
# on GitHub's runners, so the file goes in the home folder
$nvimDir = New-Item -ItemType Directory -Force (Join-Path $HOME 'nvim-check')
Set-Content (Join-Path $nvimDir 'check.py') 'print("Hello")'
$code = @"
Set-Location '$nvimDir'
nvim --headless check.py -S '$PSScriptRoot\check-nvim.lua' > lazy.log
exit `$LASTEXITCODE
"@
pwsh -NoLogo -EncodedCommand (ConvertTo-EncodedCommand $code)
if ($LASTEXITCODE -ne 0) {
    Get-Content (Join-Path $nvimDir 'lazy.log')
    Fail "Neovim isn't ready to use"
}
Write-Host '::endgroup::'

if ($failed) {
    exit 1
}
Write-Host 'All checks passed'
