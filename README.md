# dotfiles

My cross-platform, cross-shell configuration files and installation scripts managed with [chezmoi](https://www.chezmoi.io/):

- Zsh on Linux: Ubuntu and WSL 2
- Zsh on macOS
- PowerShell 7 on Windows 11

## Highlights

Documentation for my setup can be found on my notes website: [Setup](https://patrick-5546.github.io/notes/setup/).

The files I think are most notable are listed below:

- Neovim configuration, based off [LazyVim](https://www.lazyvim.org): [`dot_config/nvim`](./dot_config/nvim)
- Tmux configuration: [`dot_tmux.conf`](./dot_tmux.conf)
    - Integrated with neovim: uses same theme, seamless navigation between tmux and neovim splits
- Installation scripts: improve and standardize the CLI across operating systems
    - CLI tools are installed and updated with [mise](https://mise.jdx.dev):
      [`dot_config/mise/config.toml.tmpl`](./dot_config/mise/config.toml.tmpl)
    - Unix-specific, rerun by chezmoi only when they change:
        - [`run_onchange_before_install-packages-unix.sh.tmpl`](./run_onchange_before_install-packages-unix.sh.tmpl):
          installs the missing system packages and makes zsh the login shell. Only uses sudo when something is missing
        - [`run_onchange_after_install-tools-unix.sh.tmpl`](./run_onchange_after_install-tools-unix.sh.tmpl):
          installs mise and the tools in its config, and generates their zsh completions.
          Also reruns when the mise config changes
    - Plugins cloned from git: [`.chezmoiexternal.toml`](./.chezmoiexternal.toml)
    - Windows-specific: [`run_install-windows.ps1`](./reference_dotfiles/run_install-windows.ps1)
        - To see what software is installed, search for `wingetInstallIfNotInstalled`, `choco install`, and `Install-Module`
        - I don't use this script anymore, in favor of [UniGetUI](https://github.com/Devolutions/UniGetUI)
          (formerly WingetUI): [`wingetui/`](./reference_dotfiles/wingetui/)
- Encryption scripts: files with sensitive information are
  [encrypted](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/) with age.
  On the first apply, these scripts decrypt the age key with its passphrase using chezmoi's built-in age
    - Unix-specific: [`run_before_decrypt-private-key-unix.sh.tmpl`](./run_before_decrypt-private-key-unix.sh.tmpl)
    - Windows-specific: [`run_before_decrypt-private-key-windows.ps1.tmpl`](./run_before_decrypt-private-key-windows.ps1.tmpl)
- CI: [`.github/workflows/ci.yml`](./.github/workflows/ci.yml)
    - [`.github/lint.sh`](./.github/lint.sh): renders the templates for each OS, with and without the encrypted files,
      then checks them with shellcheck, `zsh -n`, the PowerShell parser, and TOML, YAML and git config parsers.
      Also runs locally
    - [`.github/test.sh`](./.github/test.sh): installs the dotfiles on fresh Ubuntu (latest and 22.04) and macOS
      machines, then checks that applying again changes nothing and that the shells start cleanly with the tools from mise
- Configuration files for software that is not managed with chezmoi: [`reference_dotfiles`](./reference_dotfiles)

## Installation

`chezmoi init` asks whether to decrypt the encrypted files with the key passphrase, and saves the answer in
`~/.config/chezmoi/chezmoi.yaml`. Answer no if you don't have the passphrase. Run `chezmoi init --prompt` to answer
again.

### Zsh on Linux or macOS

1. Install prerequisites
    - [curl](https://curl.se/download.html), to install chezmoi
    - On macOS, git from the Xcode Command Line Tools: `xcode-select --install`
    - On Linux, chezmoi installs git, zsh, and the other packages it needs with apt

2. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes

    ```
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply patrick-5546
    ```

    - Open a new terminal, or log out and back in, to start using zsh

3. If desired, manually install software with unique installation instructions
    - [Alacritty](https://github.com/alacritty/alacritty/blob/master/INSTALL.md)
4. Keep everything up to date

    ```
    chezmoi update     # pull and apply the latest changes
    mise upgrade       # upgrade the tools
    mise self-update   # upgrade mise
    chezmoi upgrade    # upgrade chezmoi
    ```

### PowerShell 7 on Windows

1. Install PowerShell 7 from the Microsoft Store
2. Install chezmoi and git using winget in PowerShell

    ```
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
      Instead, I now manage the software I want through [UniGetUI](https://github.com/Devolutions/UniGetUI) whenever possible
