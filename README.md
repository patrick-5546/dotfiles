# dotfiles

Install with
```
mkdir -p ~/.local/bin
pushd ~/.local
sh -c "$(curl -fsLS chezmoi.io/get)" -- init --apply patrick-5546
popd
```

Additional configuration
1. Speed up neofetch in Fedora: in `/usr/bin/neofetch`, comment line has `"rpm" && tot rpm -qa`
