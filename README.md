# dotfiles

My cross-platform, cross-shell configuration files and installation scripts managed with [chezmoi](https://www.chezmoi.io/):

- Zsh on Windows 11 WSL 2 Ubuntu 22.04
- Zsh on MacOS
- Zsh on Ubuntu 22.04
- Zsh on Fedora 36
- Powershell 7 on Windows 11

## Installation

### Zsh on Linux or MacOS

1. Ensure that [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git) and
   [age](https://github.com/FiloSottile/age#installation) are installed
      1. On Linux, [xz-utils](https://repology.org/project/xz/versions) also needs to be installed
2. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes

    ```
    mkdir -p ~/.local/bin
    pushd ~/.local
    sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply patrick-5546
    popd
    ```

3. Additional setup for GUI distros
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

1. Install PowerShell 7 from the Microsoft Store
2. Install git and gsudo using winget in PowerShell

    ```
    winget install --exact --id Git.Git --interactive
    winget install --exact --id gerardog.gsudo --interactive
    ```

3. [Install Chocolately](https://docs.chocolatey.org/en-us/choco/setup)
    - Running [winutil](https://github.com/ChrisTitusTech/winutil) installs Chocolately as part of the initialization process
4. Install age and chezmoi in PowerShell **with** administrator privileges

    ```
    choco install age.portable chezmoi -y
    ```

5. Clone this repository in PowerShell **without** administrator privileges

    ```
    chezmoi init https://github.com/patrick-5546/dotfiles.git
    ```

6. Run the installation script and apply the dotfiles in PowerShell **with** administrator privileges

    ```
    chezmoi apply
    ```
