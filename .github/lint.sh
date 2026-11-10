#!/bin/bash
# Renders the chezmoi templates for each OS and machine type, then checks the
# results: shellcheck for shell scripts, zsh -n, the PowerShell parser, and TOML,
# YAML and git config syntax. Needs chezmoi, zsh, shellcheck, pwsh, python3 and yq.
set -euo pipefail
cd "$(dirname "$0")/.."

declare -A os_data=(
    [ubuntu]='{"os":"linux","osRelease":{"id":"ubuntu"},"kernel":{"osrelease":"6.8.0-45-generic"}}'
    [fedora]='{"os":"linux","osRelease":{"id":"fedora"},"kernel":{"osrelease":"6.11.4-301.fc41.x86_64"}}'
    [wsl]='{"os":"linux","osRelease":{"id":"ubuntu"},"kernel":{"osrelease":"5.15.167.4-microsoft-standard-WSL2"}}'
    [darwin]='{"os":"darwin"}'
    [windows]='{"os":"windows"}'
)
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

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
        *.toml.tmpl | .chezmoiexternal.toml)
            python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$3" ;;
        *.yaml.tmpl | *.yml.tmpl) yq . "$3" >/dev/null ;;
        dot_gitconfig.tmpl) git config --file "$3" --list >/dev/null ;;
    esac
}

for os in "${!os_data[@]}"; do
    for machine in personal personal-without-encryption work; do
        case $machine in
            personal) work=false encryption=true ;;
            personal-without-encryption) work=false encryption=false ;;
            work) work=true encryption=false ;;
        esac
        echo "# $os $machine"
        chezmoi=(chezmoi --source . --override-data "{\"chezmoi\":${os_data[$os]},\"work\":$work,\"encryption\":$encryption}")
        for template in $(git ls-files '*.tmpl' .chezmoiexternal.toml .chezmoiignore); do
            rendered="$out/$os-$machine/${template%.tmpl}"
            mkdir -p "$(dirname "$rendered")"
            if [ "$template" = .chezmoi.yaml.tmpl ]; then
                "${chezmoi[@]}" execute-template --init \
                    --promptBool "Is this a work machine=$work,Decrypt the encrypted files with the key passphrase=$encryption" \
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
shellcheck --shell bash --exclude SC1090,SC1091 dot_bashrc  # sources files that only exist after apply
for file in dot_config/zsh/*.zsh; do
    zsh -n "$file"
done
