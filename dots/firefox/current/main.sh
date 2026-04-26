#!/usr/bin/env bash

# macOS path fix — not needed on Linux
#macOS=$(sw_vers -productVersion)
#if [[ ${#macOS} > 0  ]]; then
#    PATH="$PATH:/usr/local/bin"
#    pywalfox start
#fi

# Original call uses system python3 which can't find pywalfox when installed via pipx.
# Replaced with the pipx venv Python so it can resolve the module correctly.
#python -m pywalfox start || python3 -m pywalfox start || python2.7 -m pywalfox start || python3.9 -m pywalfox start

/home/foobar/.local/share/pipx/venvs/pywalfox/bin/python -m pywalfox start
