# Decrypts the key that chezmoi decrypts the encrypted files with, asking for its
# passphrase, if it isn't decrypted yet. chezmoi runs this before applying files.
$key = Join-Path $HOME '.chezmoikey.txt'
if (-Not (Test-Path $key -PathType Leaf)) {
    Write-Host "# create ~/.chezmoikey.txt"
    & $env:CHEZMOI_EXECUTABLE age decrypt --output $key --passphrase (Join-Path $env:CHEZMOI_SOURCE_DIR 'key.txt.age')
    if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
}
