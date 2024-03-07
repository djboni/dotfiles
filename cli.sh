#!/bin/bash
set -xe

(cd dotfiles/ubuntu && ./dotfiles.sh)

if which apt; then
	sudo apt install -y git vim tmux htop
elif which yum; then
	sudo yum install -y git vim tmux
fi

(cd programs && ./neovim.sh)
