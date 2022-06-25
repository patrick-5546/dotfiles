# Run with admin priviledges
Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString('https://community.chocolatey.org/install.ps1'))
choco install delta fzf ripgrep starship -y
Install-Module git-aliases -Scope CurrentUser -Allowclobber
Install-Module -Name PSFzf
Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
