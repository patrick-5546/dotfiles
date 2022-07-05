# dotfiles

My cross-platform, cross-shell configuration files and installation scripts managed with [chezmoi](https://www.chezmoi.io/):
- Zsh on Windows 11 WSL 2 Ubuntu 22.04
- Zsh on Ubuntu 22.04
- Zsh on Fedora 36
- Powershell 7 on Windows 11

## Installation
### Zsh on Linux
1. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes
    ```
    mkdir -p ~/.local/bin
    pushd ~/.local
    sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply patrick-5546
    popd
    ```
2. Additional setup for GUI distros
    1. [Install alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
4. Additional setup for Fedora
    1. [Enable RPM Fusion repositories](https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/)
    2. [Install multimedia plugins](https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/)
    3. Configure dnf (run `man dnf.conf` to see options and defaults): append the following lines to `/etc/dnf/dnf.conf`
        ```
        max_parallel_downloads=10
        defaultyes=True
        keepcache=True
        ```

### PowerShell 7 on Windows
1. Install PowerShell 7 and open it with administrator priviledges
2. [Install Chocolately](https://docs.chocolatey.org/en-us/choco/setup)
3. Install chezmoi, pull the latest changes, run the installation script, then apply the latest changes
    ```
    choco install chezmoi -y
    chezmoi init https://github.com/patrick-5546/dotfiles.git
    chezmoi cd
    .\install.ps1
    exit
    chezmoi apply
    ```
