#!/bin/sh
# Decrypts the key that chezmoi decrypts the encrypted files with, asking for its
# passphrase, if it isn't decrypted yet. chezmoi runs this before applying files.
set -eu

key="$HOME/.chezmoikey.txt"
if [ ! -f "$key" ]; then
    printf "# create ~/.chezmoikey.txt\n"
    "$CHEZMOI_EXECUTABLE" age decrypt --output "$key" --passphrase "$CHEZMOI_SOURCE_DIR/key.txt.age"
    chmod 600 "$key"
fi
