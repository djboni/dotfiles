#!/bin/bash
set -xe

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

git pull ||
true # It is OK if this command fails

(cd dotfiles && ./dotfiles.sh)

which which
if which apt; then
	sudo apt install -y git vim tmux htop
elif which yum; then
	sudo yum install -y git vim tmux
fi

(cd programs && ./neovim.sh)
