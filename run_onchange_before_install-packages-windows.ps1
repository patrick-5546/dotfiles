# Installs the programs that Neovim needs and mise doesn't install, if they're
# missing: gcc, which nvim-treesitter compiles its parsers with, and Python,
# which Mason installs pyrefly with. chezmoi runs this before applying files,
# and again whenever this script changes.
$ErrorActionPreference = 'Stop'

function Install-Package([string]$id) {
    Write-Host "`n# Install $id with winget"
    winget install --exact --id $id --source winget --no-upgrade --accept-package-agreements --accept-source-agreements
    # -1978335135 means it's already installed, but isn't on this terminal's Path
    if ($LASTEXITCODE -ne 0 -and $LASTEXITCODE -ne -1978335135) {
        throw "winget couldn't install $id, and exited with $LASTEXITCODE"
    }
}

if (-not (Get-Command gcc -ErrorAction Ignore)) {
    Install-Package 'BrechtSanders.WinLibs.POSIX.UCRT'
}
# Windows comes with a python command that only opens the Microsoft Store
$python = Get-Command python -ErrorAction Ignore
if (-not $python -or "$(& $python --version 2>&1)" -notmatch '^Python 3') {
    Install-Package 'Python.Python.3.14'
}
