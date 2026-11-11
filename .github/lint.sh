#!/bin/bash
# Renders the chezmoi templates for each OS, answering yes and then no to the
# prompts, and checks them along with the files that aren't templates: shell
# scripts with shellcheck, zsh files with zsh -n, PowerShell with its parser,
# and TOML, YAML and git config syntax. Needs chezmoi, zsh, shellcheck, pwsh,
# python3 and yq.
set -euo pipefail
cd "$(dirname "$0")/.."

declare -A os_data=(
    [linux]='{"os":"linux"}'
    [darwin]='{"os":"darwin"}'
    [windows]='{"os":"windows"}'
)
out=$(mktemp -d)
trap 'rm -rf "$out"' EXIT

toml() {  # toml FILE
    python3 -c 'import sys, tomllib; tomllib.load(open(sys.argv[1], "rb"))' "$1"
}

ps1() {  # ps1 FILE
    # shellcheck disable=SC2016  # PowerShell expands these
    SCRIPT="$1" pwsh -NoProfile -Command '
        $errors = $null
        [void][System.Management.Automation.Language.Parser]::ParseFile($env:SCRIPT, [ref]$null, [ref]$errors)
        $errors | ForEach-Object { Write-Error $_.ToString() }
        exit $errors.Count'
}

check() {  # check OS TEMPLATE RENDERED
    case $2 in
        *.sh.tmpl) [ "$1" = windows ] || shellcheck "$3" ;;
        *.ps1.tmpl) [ "$1" != windows ] || ps1 "$3" ;;
        *.toml.tmpl | .chezmoiexternal.toml) toml "$3" ;;
        *.yaml.tmpl | *.yml.tmpl) yq . "$3" >/dev/null ;;
        dot_gitconfig.tmpl) git config --file "$3" --list >/dev/null ;;
    esac
}

# The prompts change unrelated files, so answering all of them yes and then all
# of them no renders every branch
for os in "${!os_data[@]}"; do
    for answer in true false; do
        echo "# $os, answers: $answer"
        chezmoi=(chezmoi --source . --override-data "{\"chezmoi\":${os_data[$os]},\"apps\":$answer,\"encryption\":$answer}")
        for template in $(git ls-files '*.tmpl' .chezmoiexternal.toml .chezmoiignore); do
            rendered="$out/$os-$answer/${template%.tmpl}"
            mkdir -p "$(dirname "$rendered")"
            if [ "$template" = .chezmoi.yaml.tmpl ]; then
                "${chezmoi[@]}" execute-template --init \
                    --promptBool "Decrypt the encrypted files with the key passphrase=$answer" \
                    --promptBool "Install the desktop apps=$answer" \
                    <"$template" >"$rendered"
            else
                "${chezmoi[@]}" execute-template <"$template" >"$rendered"
            fi
            check "$os" "$template" "$rendered"
        done
    done
done

echo "# files that aren't templates"
git ls-files -z '*.sh' | xargs -0 shellcheck
for file in dot_zshenv dot_zshrc dot_config/zsh/*.zsh; do
    zsh -n "$file"
done
for file in $(git ls-files '*.ps1'); do
    ps1 "$file"
done
for file in $(git ls-files '*.toml' '*.lock' ':!:.chezmoiexternal.toml'); do
    toml "$file"
done
