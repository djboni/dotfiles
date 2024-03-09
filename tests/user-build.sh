#!/bin/bash
set -xe
cd ~/.dotfiles/dotfiles && ./dotfiles.sh
cd ~/.dotfiles/programs && ./neovim.sh cleanfirst
/home/user/.local/bin/nvim --version | grep NVIM
