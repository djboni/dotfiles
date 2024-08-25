#!/bin/bash
set -e

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

# Update to a new version
(set -x; git pull) || true # It is OK if this command fails

. dotfiles/dotbase-win.sh
(set -x; cd dotfiles && ./dotfiles-win.sh)
