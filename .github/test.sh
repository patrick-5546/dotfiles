#!/bin/bash
# Installs the dotfiles from this checkout the way the README does, then checks
# that applying again changes nothing, that the shells start cleanly with the
# tools from mise, and that Neovim is ready to use. It replaces your dotfiles, so
# it only runs in CI.
set -euo pipefail

if [ "${CI:-}" != true ]; then
    echo "This replaces your dotfiles, so it only runs in CI (CI=true)" >&2
    exit 1
fi
checkout=$(cd "$(dirname "$0")/.." && pwd)
bin=$HOME/.local/bin
export PATH="$bin:$PATH"

failed=false
fail() {
    echo "::error::$*"
    failed=true
}

# Runs a command in a pseudo-terminal, as a terminal emulator would, and prints
# its output without escape sequences. Stops it with exit status 124 if it takes
# over 2 minutes, which usually means it's waiting for input.
in_pty() {
    python3 -c '
import os, pty, re, signal, sys
pid, fd = pty.fork()
if pid == 0:
    os.execvp(sys.argv[1], sys.argv[1:])
output = []
def finish(status):
    text = re.sub(rb"\x1b(\[[0-?]*[ -/]*[@-~]|\][^\x07\x1b]*(\x07|\x1b\\)|[=>])|\r", b"", b"".join(output))
    sys.stdout.buffer.write(text)
    sys.stdout.flush()
    os._exit(status)
def timeout(*_):
    os.kill(pid, signal.SIGKILL)
    output.append(b"\n(timed out)")
    finish(124)
signal.signal(signal.SIGALRM, timeout)
signal.alarm(120)
while True:
    try:
        data = os.read(fd, 4096)
    except OSError:  # Linux reports EIO once the command exits
        break
    if not data:
        break
    output.append(data)
finish(os.waitstatus_to_exitcode(os.waitpid(pid, 0)[1]))
' "$@" </dev/null
}

echo "::group::Install the dotfiles"
mkdir -p "$HOME/.local/share"
cp -a "$checkout" "$HOME/.local/share/chezmoi"
installer=$(curl -fsLS get.chezmoi.io)  # separate so that set -e catches download errors
sh -c "$installer" -- -b "$bin" init --apply \
    --promptBool "Decrypt the encrypted files with the key passphrase=false" \
    --promptBool "Install the desktop apps=false" </dev/null
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

echo "::group::Check the C compiler"
# nvim-treesitter compiles its parsers with it
printf '#include <stdlib.h>\nint main(void) { return EXIT_SUCCESS; }\n' | cc -x c -o /dev/null - ||
    fail "cc can't compile a C program"
echo "::endgroup::"

echo "::group::Check git's GitHub credentials"
# git gets them from gh through mise's shim, and gh returns the token that CI
# sets in GITHUB_TOKEN
output=$(printf 'protocol=https\nhost=github.com\n\n' | GIT_TERMINAL_PROMPT=0 git credential fill 2>&1) || true
grep -q '^password=.' <<<"$output" || fail "git didn't get GitHub credentials from gh: $output"
echo "::endgroup::"

echo "::group::Check zsh"
# GitHub's Ubuntu image makes everything in /usr/share writable by everyone,
# including zsh's completion directories, so compinit would ask whether to use
# them and wait for an answer. Remove that access, as you would on your machine.
insecure=$(zsh -c 'autoload -Uz compaudit && compaudit' 2>/dev/null | sort -u) || true
if [ -n "$insecure" ]; then
    echo "Removing write access for others from the directories compinit distrusts:"
    echo "$insecure"
    echo "$insecure" | xargs sudo chmod g-w,o-w
fi
output=$(in_pty zsh -i -c exit) && status=0 || status=$?
if [ "$status" -ne 0 ] || [ -n "$output" ]; then
    fail "zsh should start without printing anything, but exited with $status and printed: $output"
fi
# On WSL, .zshrc keeps only the Windows folders it needs on PATH, in any case.
# It expands in zsh, not here:
# shellcheck disable=SC2016
output=$(WSL_DISTRO_NAME=Ubuntu PATH="$PATH:/mnt/c/WINDOWS/system32:/mnt/c/Windows:/mnt/c/Tools:/mnt/c/Program Files/Microsoft VS Code/bin" \
    in_pty zsh -i -c 'print -rl -- ${(M)path:#/mnt/*}') || true
if [ "$output" != $'/mnt/c/WINDOWS/system32\n/mnt/c/Windows\n/mnt/c/Program Files/Microsoft VS Code/bin' ]; then
    fail "On WSL, PATH should only keep System32, Windows and VS Code from /mnt, but has: $output"
fi
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
tools=(atuin bat delta dust fd fzf gh go lazygit lsd node npm nvim rg starship tmux tree-sitter uv uvx ya yazi zoxide)
output=$(in_pty zsh -i -c "$zsh_checks" zsh "${tools[@]}") && status=0 || status=$?
if [ "$status" -ne 0 ] || [ -n "$output" ]; then
    fail "The zsh checks exited with $status and printed: $output"
fi
echo "::endgroup::"

echo "::group::Check Neovim"
# Opening a file the first time installs the plugins, tools, language servers
# and parsers. mise exec puts the tools on the PATH, as zsh does. lazy.nvim's
# install log on stdout is mostly git's progress, so it's only shown on failure
nvim_dir=$(mktemp -d)
echo 'print("Hello")' >"$nvim_dir/check.py"
if ! (cd "$nvim_dir" && mise exec -- nvim --headless check.py -S "$checkout/.github/check-nvim.lua" \
    </dev/null >lazy.log); then
    cat "$nvim_dir/lazy.log"
    fail "Neovim isn't ready to use"
fi
echo "::endgroup::"

if [ "$failed" = true ]; then
    exit 1
fi
echo "All checks passed"
