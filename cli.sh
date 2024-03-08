#!/bin/bash
set -xe

git pull ||
true # It is OK if this command fails

(cd dotfiles/ubuntu && ./dotfiles.sh)

which which
if which apt; then
	sudo apt install -y git vim tmux htop
elif which yum; then
	sudo yum install -y git vim tmux
fi

(cd programs && ./neovim.sh)
