Write-Host "Request administrator access"
gsudo {
    Write-Host "Update choco packages and modules"
    choco upgrade all -y
    Update-Module

    Write-Host "`nInstall choco packages"
    choco install bat delta dust fd fzf lf ripgrep starship -y

    Write-Host "`nInstall modules"
    Install-Module git-aliases -Scope CurrentUser -Allowclobber
    Install-Module -Name PSFzf
    Install-Module posh-git -Scope CurrentUser -AllowClobber
    Install-Module -Name Terminal-Icons -Repository PSGallery

    Write-Host "`nSet execution policy"
    Set-ExecutionPolicy RemoteSigned -Scope CurrentUser
}

Write-Host "Update winget packages"
winget upgrade --all
Write-Host("")

function wingetInstallIfNotInstalled($id) {
    Write-Host("Install $id if not installed")
    winget list --exact --id $id || winget install --exact --id $id --interactive
    Write-Host("")
}
wingetInstallIfNotInstalled("ajeetdsouza.zoxide")
wingetInstallIfNotInstalled("Bitwarden.Bitwarden")
wingetInstallIfNotInstalled("code52.Carnac")
wingetInstallIfNotInstalled("Discord.Discord")
wingetInstallIfNotInstalled("Docker.DockerDesktop")
wingetInstallIfNotInstalled("Git.Git")
wingetInstallIfNotInstalled("gerardog.gsudo")
wingetInstallIfNotInstalled("Logitech.GHUB")
wingetInstallIfNotInstalled("Logitech.LogiBolt")
wingetInstallIfNotInstalled("Logitech.LogiTune")
wingetInstallIfNotInstalled("Logitech.OptionsPlus")
wingetInstallIfNotInstalled("Logitech.UnifyingSoftware")
wingetInstallIfNotInstalled("Neovim.Neovim")
wingetInstallIfNotInstalled("Nextcloud.NextcloudDesktop")
wingetInstallIfNotInstalled("OpenVPNTechnologies.OpenVPNConnect")
wingetInstallIfNotInstalled("Poly.PlantronicsHub")
wingetInstallIfNotInstalled("SlackTechnologies.Slack")
wingetInstallIfNotInstalled("TeamViewer.TeamViewer")
wingetInstallIfNotInstalled("VPNetwork.TorGuard")
wingetInstallIfNotInstalled("JAMSoftware.TreeSize.Free")
wingetInstallIfNotInstalled("vim.vim")
wingetInstallIfNotInstalled("Microsoft.VisualStudioCode")
wingetInstallIfNotInstalled("Zoom.Zoom")
