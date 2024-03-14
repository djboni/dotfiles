#!/bin/bash
set -e

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

# Install utilities
. dotfiles/dotbase.sh
install_if_absent git vim tmux htop
# cloc

# Update to a new version
(set -x; git pull) || true # It is OK if this command fails

. dotfiles/dotbase.sh
(set -x; cd dotfiles && ./dotfiles.sh)
(set -x; cd programs && ./neovim.sh)
(set -x; cd programs && ./node.sh)
(set -x; cd programs && ./ripgrep.sh)
(set -x; cd programs && ./fd.sh)
