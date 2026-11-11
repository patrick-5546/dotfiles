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
      [`dot_config/mise/config.toml`](./dot_config/mise/config.toml), with their versions pinned in
      [`mise.lock`](./dot_config/mise/mise.lock)
    - Unix-specific, rerun by chezmoi only when they change:
        - [`run_onchange_before_install-packages-unix.sh.tmpl`](./run_onchange_before_install-packages-unix.sh.tmpl):
          installs the missing system packages and makes zsh the login shell. Only uses sudo when something is missing
        - [`run_onchange_after_install-cli-tools-unix.sh.tmpl`](./run_onchange_after_install-cli-tools-unix.sh.tmpl):
          installs mise and the tools in its config, and generates their zsh completions.
          Also reruns when the mise config or `mise.lock` changes
        - [`run_onchange_after_install-desktop-apps-macos.sh.tmpl`](./run_onchange_after_install-desktop-apps-macos.sh.tmpl):
          on macOS, installs [Homebrew](https://brew.sh) if it's missing, then the desktop apps with it
    - Plugins cloned from git: [`.chezmoiexternal.toml`](./.chezmoiexternal.toml)
    - Windows-specific, rerun by chezmoi only when they change:
        - [`run_onchange_before_install-packages-windows.ps1.tmpl`](./run_onchange_before_install-packages-windows.ps1.tmpl):
          installs gcc and Python with winget if they're missing, which Neovim needs to build its parsers and install
          its language servers
        - [`run_onchange_after_install-cli-tools-windows.ps1.tmpl`](./run_onchange_after_install-cli-tools-windows.ps1.tmpl):
          installs mise and the tools in its config. Also reruns when the mise config or `mise.lock` changes
        - [`run_onchange_after_install-desktop-apps-windows.ps1.tmpl`](./run_onchange_after_install-desktop-apps-windows.ps1.tmpl):
          installs the desktop apps with winget
        - The other software I've used, which these scripts don't install, is listed in
          [`software.md`](./reference_dotfiles/software.md)
- Encryption scripts: files with sensitive information are
  [encrypted](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/) with age.
  On the first apply, these scripts decrypt the age key with its passphrase using chezmoi's built-in age
    - Unix-specific: [`run_before_decrypt-private-key-unix.sh.tmpl`](./run_before_decrypt-private-key-unix.sh.tmpl)
    - Windows-specific: [`run_before_decrypt-private-key-windows.ps1.tmpl`](./run_before_decrypt-private-key-windows.ps1.tmpl)
- CI: [`.github/workflows/ci.yml`](./.github/workflows/ci.yml)
    - [`.github/lint.sh`](./.github/lint.sh): renders the templates for each OS, with and without the encrypted files,
      then checks them and the files that aren't templates with shellcheck, `zsh -n`, the PowerShell parser, and
      TOML, YAML and git config parsers. Also runs locally
    - [`.github/test.sh`](./.github/test.sh) and [`.github/test.ps1`](./.github/test.ps1): install the dotfiles on
      fresh Ubuntu (latest and 22.04), macOS and Windows machines, then check that applying again changes nothing,
      that the shells start cleanly with the tools from mise, and that Neovim installs its plugins, tools, language
      servers and parsers the first time it opens a file: [`.github/check-nvim.lua`](./.github/check-nvim.lua)
- Configuration files for software that is not managed with chezmoi: [`reference_dotfiles`](./reference_dotfiles)

## Installation

1. Install the prerequisites
    - Linux: [curl](https://curl.se/download.html), to install chezmoi. chezmoi installs git, zsh and the other
      packages it needs with apt
    - macOS: git, from the Xcode Command Line Tools: `xcode-select --install`. If you're installing the desktop apps,
      sign in to the App Store, which some of them come from
    - Windows: PowerShell 7, which the profile and chezmoi's scripts run in, and Git, which chezmoi uses to clone the
      yazi theme. Install them with winget:

      ```
      winget install --exact --id Microsoft.PowerShell --source winget
      winget install --exact --id Git.Git --source winget
      ```

2. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes. On Linux and macOS:

    ```
    sh -c "$(curl -fsLS get.chezmoi.io)" -- -b "$HOME/.local/bin" init --apply patrick-5546
    ```

    On Windows, in a new PowerShell 7 terminal:

    ```
    iex "&{$(irm 'https://get.chezmoi.io/ps1')} -b '~/.local/bin' -- init --apply patrick-5546"
    ```

    - `chezmoi init` asks:
        - Whether to decrypt the encrypted files with the key passphrase. Answer no if you don't have the passphrase
        - On macOS and Windows, whether to install the [desktop apps](./.chezmoidata/desktop-apps.toml). It skips
          the ones that are already installed

      It saves the answers in `~/.config/chezmoi/chezmoi.yaml`. Run `chezmoi init --prompt` to answer again
    - Then chezmoi's scripts install what's missing. Enter your password, or allow the installers that ask for
      administrator rights, when they ask
        - The packages that the dotfiles and Neovim need: with apt on Linux, and gcc ([WinLibs](https://winlibs.com))
          and Python with winget on Windows. On Linux and macOS, zsh becomes your login shell
        - mise in `~/.local/bin`, and the tools in its config. On Windows, it adds `~\.local\bin` to your Path
        - The desktop apps: with Homebrew on macOS, which it installs first if it's missing, and winget on Windows
    - Open a new terminal to start using them, or log out and back in if it doesn't start zsh

3. Keep everything up to date

    ```
    chezmoi update                 # pull and apply the latest changes
    mise upgrade                   # upgrade the tools, which updates mise.lock
    chezmoi re-add ~/.config/mise  # save mise.lock, then commit and push it
    mise self-update               # upgrade mise
    chezmoi upgrade                # upgrade chezmoi
    ```

    - To roll back an upgrade, revert its commit in the source directory (`chezmoi cd`) and run `chezmoi apply`
    - Upgrade everything else with the OS's package managers: `sudo apt upgrade` on Linux, `brew upgrade` and the
      App Store on macOS, and winget or UniGetUI on Windows

4. Optional, on Windows: install the other software I've used, listed in
   [`reference_dotfiles/software.md`](./reference_dotfiles/software.md)
