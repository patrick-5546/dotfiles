#!/bin/bash
# Renders the chezmoi templates for each OS, with and without the encrypted
# files, and checks them along with the files that aren't templates: shell
# scripts with shellcheck, zsh files with zsh -n, PowerShell with its parser,
# and TOML, YAML and git config syntax. Needs chezmoi, zsh, shellcheck, pwsh,
# python3 and yq.
set -euo pipefail
cd "$(dirname "$0")/.."

declare -A os_data=(
    # Templates only read the kernel release to tell WSL apart from other Linux
    [linux]='{"os":"linux","kernel":{"osrelease":"6.8.0-generic"}}'
    [wsl]='{"os":"linux","kernel":{"osrelease":"5.15.167.4-microsoft-standard-WSL2"}}'
    [darwin]='{"os":"darwin"}'
    [windows]='{"os":"windows"}'
)
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

toml() {  # toml FILE
    python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$1"
}

check() {  # check OS TEMPLATE RENDERED
    case $2 in
        *.sh.tmpl) [ "$1" = windows ] || shellcheck "$3" ;;
        *.ps1.tmpl)
            # shellcheck disable=SC2016  # PowerShell expands these
            [ "$1" != windows ] || SCRIPT="$3" pwsh -NoProfile -Command '
                $errors = $null
                [void][System.Management.Automation.Language.Parser]::ParseFile($env:SCRIPT, [ref]$null, [ref]$errors)
                $errors | ForEach-Object { Write-Error $_.ToString() }
                exit $errors.Count'
            ;;
        dot_zshrc.tmpl) [ "$1" = windows ] || zsh -n "$3" ;;
        *.toml.tmpl | .chezmoiexternal.toml) toml "$3" ;;
        *.yaml.tmpl | *.yml.tmpl) yq . "$3" >/dev/null ;;
        dot_gitconfig.tmpl) git config --file "$3" --list >/dev/null ;;
    esac
}

for os in "${!os_data[@]}"; do
    for encryption in true false; do
        echo "# $os, encryption: $encryption"
        chezmoi=(chezmoi --source . --override-data "{\"chezmoi\":${os_data[$os]},\"encryption\":$encryption}")
        for template in $(git ls-files '*.tmpl' .chezmoiexternal.toml .chezmoiignore); do
            rendered="$out/$os-$encryption/${template%.tmpl}"
            mkdir -p "$(dirname "$rendered")"
            if [ "$template" = .chezmoi.yaml.tmpl ]; then
                "${chezmoi[@]}" execute-template --init \
                    --promptBool "Decrypt the encrypted files with the key passphrase=$encryption" \
                    <"$template" >"$rendered"
            else
                "${chezmoi[@]}" execute-template <"$template" >"$rendered"
            fi
            check "$os" "$template" "$rendered"
        done
    done
done

echo "# files that aren't templates"
shellcheck .github/*.sh
for file in dot_zshenv dot_config/zsh/*.zsh; do
    zsh -n "$file"
done
for file in $(git ls-files '*.toml' ':!:.chezmoiexternal.toml'); do
    toml "$file"
done
