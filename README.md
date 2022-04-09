# dotfiles

Configuration files for my devices:
- Laptop: Dual boot Fedora 36 with [Material Shell](https://material-shell.com/) and Windows 11 with Ubuntu on WSL2 installed

## Installation

### Linux
```
mkdir -p ~/.local/bin
pushd ~/.local
sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply patrick-5546
popd
```

## Additional Setup
- Speed up neofetch in Fedora: in `/usr/bin/neofetch`, comment line `has "rpm" && tot rpm -qa` out
