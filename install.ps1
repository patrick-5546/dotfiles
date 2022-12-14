#Requires -RunAsAdministrator

# Update installed packages
choco upgrade all -y
Update-Module

# Install packages if they aren't already installed
choco install bat delta dust fd fzf git lf neovim ripgrep starship -y
Install-Module git-aliases -Scope CurrentUser -Allowclobber
Install-Module -Name PSFzf
Install-Module posh-git -Scope CurrentUser -Force -AllowClobber
Install-Module -Name Terminal-Icons -Repository PSGallery

Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
