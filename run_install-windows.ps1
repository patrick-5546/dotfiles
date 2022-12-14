#Requires -RunAsAdministrator

Write-Host "# Update packages and modules"
choco upgrade all -y
Update-Module

Write-Host "# Install packages"
choco install bat delta dust fd fzf git lf ripgrep starship vim -y

Write-Host "# Install modules"
Install-Module git-aliases -Scope CurrentUser -Allowclobber
Install-Module -Name PSFzf
Install-Module posh-git -Scope CurrentUser -AllowClobber
Install-Module -Name Terminal-Icons -Repository PSGallery

Write-Host "# Set execution policy"
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
