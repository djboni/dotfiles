#!/bin/bash
set -e

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

# Update to a new version
. dotfiles/dotbase.sh
install_if_absent git
(set -x; git pull) || true # It is OK if this command fails

(set -x; cd dotfiles && ./dotfiles.sh)

. dotfiles/dotbase.sh
install_if_absent vim tmux htop
(set -x; cd programs && ./node.sh)
(set -x; cd programs && ./neovim.sh)
