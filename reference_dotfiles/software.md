# Software

Other software I've used. Unlike the CLI tools in [mise's config](../dot_config/mise/config.toml) and the
[desktop apps](../.chezmoidata/desktop-apps.toml), the dotfiles don't install it. On Windows, search for it in
UniGetUI, one of the desktop apps, or install it with `winget install --exact --id <ID>`. On macOS, install it with
`brew install --cask <cask>`, and on Linux, from its website.

## Windows, macOS and Linux

| Software | What it does | winget ID | Homebrew cask |
| --- | --- | --- | --- |
| [Discord](https://discord.com) | Chat | `Discord.Discord` | `discord` |
| [Plex](https://www.plex.tv) | Plays media from Plex servers | `Plex.Plex` | `plex` |
| [Signal](https://signal.org) | Encrypted messaging | `OpenWhisperSystems.Signal` | `signal` |
| [TeamViewer](https://www.teamviewer.com) | Remote access and support | `TeamViewer.TeamViewer` | `teamviewer` |

## Windows only

| Software | What it does | winget ID |
| --- | --- | --- |
| [Carnac](https://github.com/Code52/carnac) | Shows the keys you press, for presentations and screen recordings | `code52.Carnac` |
| [NanaZip](https://github.com/M2Team/NanaZip) | Opens and creates archives. A 7-Zip fork that's in the Windows 11 context menu | `M2Team.NanaZip` |
| [Rufus](https://rufus.ie) | Creates bootable USB drives | `Rufus.Rufus` |
| [Windows Terminal](https://github.com/microsoft/terminal) | Terminal, preinstalled on Windows 11. My settings are in [`windows_terminal/`](./windows_terminal/) | `Microsoft.WindowsTerminal` |
| [WSL](https://learn.microsoft.com/windows/wsl/) | Runs Linux. `wsl --install` installs it with Ubuntu, which the dotfiles also support. My config is in [`wsl/`](./wsl/) | `Microsoft.WSL` |
