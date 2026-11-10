#!/bin/bash
# Installs the dotfiles from this checkout the way the README does, then checks
# that applying again changes nothing and that the shells start cleanly with the
# tools from mise. It replaces your dotfiles, so it only runs in CI.
# Usage: .github/test.sh WORK, where WORK is true for a work machine, else false
set -euo pipefail

if [ "${CI:-}" != true ]; then
    echo "This replaces your dotfiles, so it only runs in CI (CI=true)" >&2
    exit 1
fi
work=$1
checkout=$(cd "$(dirname "$0")/.." && pwd)
if [ "$work" = true ]; then
    bin=$HOME/bin
else
    bin=$HOME/.local/bin
fi
export PATH="$bin:$PATH"

failed=false
fail() {
    echo "::error::$*"
    failed=true
}

# Runs a command in a pseudo-terminal, as a terminal emulator would, and prints
# its output without escape sequences
in_pty() {
    python3 -c '
import os, pty, re, signal, sys
signal.alarm(120)  # fail instead of hanging if something waits for input
pid, fd = pty.fork()
if pid == 0:
    os.execvp(sys.argv[1], sys.argv[1:])
output = b""
while True:
    try:
        data = os.read(fd, 4096)
    except OSError:  # Linux reports EIO once the command exits
        break
    if not data:
        break
    output += data
status = os.waitpid(pid, 0)[1]
sys.stdout.buffer.write(re.sub(rb"\x1b(\[[0-?]*[ -/]*[@-~]|\][^\x07\x1b]*(\x07|\x1b\\)|[=>])|\r", b"", output))
sys.exit(os.waitstatus_to_exitcode(status))
' "$@" </dev/null
}

echo "::group::Install the dotfiles"
mkdir -p "$HOME/.local/share"
cp -a "$checkout" "$HOME/.local/share/chezmoi"
installer=$(curl -fsLS get.chezmoi.io)  # separate so that set -e catches download errors
sh -c "$installer" -- -b "$bin" init --apply \
    --promptBool "Is this a work machine=$work,Decrypt the encrypted files with the key passphrase=false" </dev/null
echo "::endgroup::"

echo "::group::Check chezmoi"
if ! output=$(chezmoi apply </dev/null 2>&1) || [ -n "$output" ]; then
    fail "Applying again should do nothing, but printed: $output"
fi
output=$(chezmoi status)
[ -z "$output" ] || fail "chezmoi status should be empty, but printed: $output"
chezmoi verify || fail "chezmoi verify found differences"
mise ls
echo "::endgroup::"

echo "::group::Check the login shell"
if [ "$(uname)" = Darwin ]; then
    login_shell=$(dscl . -read "/Users/$(id -un)" UserShell | awk '{print $2}')
else
    login_shell=$(getent passwd "$(id -un)" | cut -d: -f7)
fi
case $login_shell in
    */zsh) echo "$login_shell" ;;
    *) fail "The login shell is $login_shell, not zsh" ;;
esac
echo "::endgroup::"

echo "::group::Check zsh"
output=$(in_pty zsh -i -c exit) || fail "zsh -i -c exit failed with $?"
[ -z "$output" ] || fail "zsh printed on startup: $output"
# Prints the problems it finds. It expands in zsh, not here:
# shellcheck disable=SC2016
zsh_checks='
mise_installs=${MISE_DATA_DIR:-${XDG_DATA_HOME:-$HOME/.local/share}/mise}/installs
tool_version() {
    case $1 in
        go) go version ;;
        tmux) tmux -V ;;
        *) $1 --version ;;
    esac
}
for tool in "$@"; do
    if [[ $commands[$tool] != $mise_installs/* ]]; then
        print "$tool should come from mise, but is ${commands[$tool]:-missing}"
    elif ! tool_version $tool >/dev/null 2>&1; then
        print "$tool doesn'\''t run: $(tool_version $tool 2>&1)"
    fi
done
for tool in atuin bat chezmoi delta dust fd gh lsd mise rg starship uv uvx ya yazi zoxide; do
    [[ -s ~/.config/zsh/completions/_$tool ]] || print "~/.config/zsh/completions/_$tool is missing"
    [[ $_comps[$tool] == _$tool ]] || print "$tool completes with ${_comps[$tool]:-nothing}, not _$tool"
done
[[ $(bindkey -M viins "^F") == *" fzf-file-widget" ]] || print "Ctrl-F: $(bindkey -M viins "^F")"
[[ $(bindkey -M viins "^T") == *" self-insert" ]] || print "Ctrl-T: $(bindkey -M viins "^T")"
[[ $(bindkey -M viins "^R") == *" atuin-"* ]] || print "Ctrl-R: $(bindkey -M viins "^R")"
(( $+functions[__zoxide_z] )) || print "zoxide isn'\''t initialized"
'
tools=(atuin bat copilot delta dust fd fzf gh lazygit lsd node npm nvim rg starship tmux uv uvx ya yazi zoxide)
if [ "$work" != true ]; then
    tools+=(go)
fi
output=$(in_pty zsh -i -c "$zsh_checks" zsh "${tools[@]}") || fail "The zsh checks failed with $?"
[ -z "$output" ] || fail "$output"
echo "::endgroup::"

if [ "$work" = true ]; then
    echo "::group::Check bash"
    output=$(in_pty bash -i -c true) || fail "bash -i -c true failed with $?"
    [ -z "$output" ] || fail "bash printed on startup: $output"
    # shellcheck disable=SC2016  # it expands in bash -i, not here
    bash_checks='
for tool in fd fzf node rg zoxide; do
    [[ $(type -P $tool) == "$HOME"/.local/share/mise/installs/* ]] ||
        echo "$tool should come from mise, but is $(type -P $tool)"
done
[[ $(type -t __zoxide_z) == function ]] || echo "zoxide isn'\''t initialized"
bind -X | grep -q __fzf_history__ || echo "Ctrl-R isn'\''t bound to the fzf history widget"
! bind -X | grep -q fzf-file-widget || echo "Ctrl-T shouldn'\''t be bound to the fzf file widget"
'
    output=$(in_pty bash -i -c "$bash_checks") || fail "The bash checks failed with $?"
    [ -z "$output" ] || fail "$output"
    echo "::endgroup::"
fi

if [ "$failed" = true ]; then
    exit 1
fi
echo "All checks passed"
