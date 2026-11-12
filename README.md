# dotfiles

My cross-platform, cross-shell configuration files and installation scripts managed with [chezmoi](https://www.chezmoi.io/):

- Zsh on Ubuntu 22.04 or later, including in WSL 2
- Zsh on macOS
- PowerShell 7 on Windows 11

## Highlights

Documentation for my setup can be found on my notes website: [Setup](https://patrick-5546.github.io/notes/setup/).

The files I think are most notable are listed below:

- Neovim configuration, based off [LazyVim](https://www.lazyvim.org): [`dot_config/nvim`](./dot_config/nvim)
- Tmux configuration: [`dot_tmux.conf`](./dot_tmux.conf)
    - Integrated with neovim: uses same theme, seamless navigation between tmux and neovim splits
- Installation scripts: improve and standardize the CLI across operating systems. chezmoi reruns each one only when
  it changes
    - CLI tools are installed and updated with [mise](https://mise.jdx.dev), with their versions pinned in its
      lockfile: [`dot_config/mise`](./dot_config/mise)
    - Desktop apps are listed once for macOS and Windows:
      [`.chezmoidata/desktop-apps.toml`](./.chezmoidata/desktop-apps.toml)
- Encryption: files with sensitive information are
  [encrypted](https://www.chezmoi.io/user-guide/frequently-asked-questions/encryption/) with age
- CI: lints the templates for each OS, then installs the dotfiles on fresh Ubuntu, macOS and Windows machines and
  checks that Neovim is ready to use: [`.github/workflows/ci.yml`](./.github/workflows/ci.yml)
- Configuration files for software that is not managed with chezmoi: [`reference_dotfiles`](./reference_dotfiles)

## Installation

1. Install the prerequisites
    - Ubuntu: [curl](https://curl.se/download.html), to install chezmoi. chezmoi installs git, zsh and the other
      packages it needs with apt
    - macOS: git, from the Xcode Command Line Tools: `xcode-select --install`. If you're installing the desktop apps,
      sign in to the App Store, which some of them come from
    - Windows: PowerShell 7, which the profile and chezmoi's scripts run in, and Git, which chezmoi, Neovim and yazi
      use. Install them with winget:

      ```
      winget install --exact --id Microsoft.PowerShell --source winget
      winget install --exact --id Git.Git --source winget
      ```

2. Install chezmoi in `~/.local/bin`, pulling and applying the latest changes. On Ubuntu and macOS:

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
        - The packages that the dotfiles and Neovim need: with apt on Ubuntu, and gcc ([WinLibs](https://winlibs.com))
          and Python with winget on Windows. On Ubuntu and macOS, zsh becomes your login shell
        - mise in `~/.local/bin`, and the tools in its config. On Windows, it adds `~\.local\bin` to your Path
        - `gh auth login`, if you aren't logged in to GitHub. git gets its GitHub credentials from gh
        - The desktop apps: with Homebrew on macOS, which it installs first if it's missing, and winget on Windows
    - On Windows, if Documents is in OneDrive, PowerShell looks for its profile there instead of in `~\Documents`,
      where chezmoi puts it. Add a profile there that loads chezmoi's:

      ```
      New-Item -Force $PROFILE -Value '. "$HOME\Documents\PowerShell\Microsoft.PowerShell_profile.ps1"'
      ```

    - Open a new terminal to start using them, or log out and back in if it doesn't start zsh

3. Keep everything up to date

    ```
    chezmoi update                 # pull and apply the latest changes
    mise upgrade                   # upgrade the tools, which updates mise.lock
    chezmoi re-add ~/.config/mise  # save mise.lock, then commit and push it
    chezmoi upgrade                # upgrade chezmoi
    ```

    - mise updates itself once a week. Like `mise upgrade`, it skips releases from the last 7 days
    - To roll back an upgrade, revert its commit in the source directory (`chezmoi cd`) and run `chezmoi apply`
    - Upgrade everything else with the OS's package managers: `sudo apt upgrade` on Ubuntu, `brew upgrade` and the
      App Store on macOS, and winget or UniGetUI on Windows

4. Optional, on Windows: install the other software I've used, listed in
   [`reference_dotfiles/software.md`](./reference_dotfiles/software.md)
