# dotfiles

My cross-platform, cross-shell configuration files and installation scripts managed with [chezmoi](https://www.chezmoi.io/):

- Zsh on Windows 11 WSL 2 Ubuntu 22.04
- Zsh on MacOS
- Zsh on Ubuntu 22.04
- Zsh on Fedora 36
- Powershell 7 on Windows 11

## Highlights

Documentation for my setup can be found on my notes website: [Setup](https://patrick-5546.github.io/notes/setup/).

The files I think are most notable are listed below:

- Neovim configuration, based off [LazyVim](https://www.lazyvim.org): [`dot_config/nvim`](./dot_config/nvim)
- Tmux configuration: [`dot_tmux.conf`](./dot_tmux.conf)
    - Integrated with neovim: uses same theme, seamless navigation between tmux and neovim splits
    - Complex tmux sessions are managed easily using [tmuxinator](https://github.com/tmuxinator/tmuxinator):
      [`dot_config/tmuxinator`](./dot_config/tmuxinator)
- Installation scripts: improve and standardize the CLI across operating systems
    - [`.chezmoiexternal.toml`](./.chezmoiexternal.toml)
        - To see what software is installed, search for `url`
    - Unix-specific: [`run_install-unix.sh.tmpl`](./run_install-unix.sh.tmpl)
        - To see what software is installed, search for `dependencies`
        - Does not require Sudo privileges
    - Windows-specific: [`run_install-windows.ps1`](./reference_dotfiles/run_install-windows.ps1)
        - To see what software is installed, search for `wingetInstallIfNotInstalled`, `choco install`, and `Install-Module`
        - I don't use this script anymore, in favor of [WingetUI](https://github.com/marticliment/WingetUI): [`wingetui/`](./reference_dotfiles/wingetui/)
- Encryption scripts: files with sensitive information are
  [encrypted](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/)
    - Unix-specific: [`run_before_decrypt-private-key-unix.sh.tmpl`](./run_before_decrypt-private-key-unix.sh.tmpl)
    - Windows-specific: [`run_before_decrypt-private-key-windows.ps1.tmpl`](./run_before_decrypt-private-key-windows.ps1.tmpl)
- Configuration files for software that is not managed with chezmoi: [`reference_dotfiles`](./reference_dotfiles)

## Installation

### Zsh on Linux or MacOS

1. Install prerequisites
      1. [git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)
      2. [age](https://github.com/FiloSottile/age#installation)
      3. On Linux, [xz-utils](https://repology.org/project/xz/versions)
      4. On a fresh Ubuntu install, this is how I install the above prerequisites and other packages I uses

          ```
          sudo add-apt-repository ppa:neovim-ppa/unstable -y && sudo apt install git age xz-utils curl neovim tmux zsh -y
          ```

2. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes

    ```
    pushd ~
    sh -c "$(curl -fsLS get.chezmoi.io)" -- init --apply patrick-5546 --branch work
    popd
    ```

3. If desired, manually install software with unique installation instructions
    - [Alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
    - [Neovim](https://github.com/neovim/neovim/wiki/Installing-Neovim)
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
    winget install --exact --id FiloSottile.age --interactive
    winget install --exact --id twpayne.chezmoi --interactive
    winget install --exact --id Git.Git --interactive
    ```

3. Clone this repository in PowerShell, pulling and applying the latest changes

    ```
    chezmoi init --apply patrick-5546
    ```

4. Optional: run [`run_install-windows.ps1`](./reference_dotfiles/run_install-windows.ps1) to match my unix developer experience
    - Prerequisite: `winget install --exact --id gerardog.gsudo --interactive`
    - Note: I do not run this automatically anymore because I do most of my development through WSL or VS Code.
      Instead, I now manage the software I want through [WingetUI](https://github.com/marticliment/WingetUI) whenever possible
