#!/bin/bash
set -xe
(cd dotfiles/ubuntu && ./dotfiles.sh)
sudo apt install -y git vim tmux htop
(cd programs && ./neovim.sh)
