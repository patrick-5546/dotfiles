# Run with admin priviledges
choco install delta fzf git ripgrep starship -y
Install-Module git-aliases -Scope CurrentUser -Allowclobber
Install-Module -Name PSFzf
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
