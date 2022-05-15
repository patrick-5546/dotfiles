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

## Manual Setup
- Speed up neofetch in Fedora: in `/usr/bin/neofetch`, comment line `has "rpm" && tot rpm -qa` out
- [Enable RPM Fusion repositories](https://docs.fedoraproject.org/en-US/quick-docs/setup_rpmfusion/)
- (Laptop) [Install multimedia plugins](https://docs.fedoraproject.org/en-US/quick-docs/assembly_installing-plugins-for-playing-movies-and-music/)
- dnf configuration (`man dnf.conf` to see options and defaults): append the following lines
    ```
    max_parallel_downloads=10
    defaultyes=True
    keepcache=True
    ```
 
