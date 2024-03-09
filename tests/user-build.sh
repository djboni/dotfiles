#!/bin/bash
set -xe
cd ~/.dotfiles/dotfiles && ./dotfiles.sh

cd ~/.dotfiles/programs && ./node.sh
~/.local/bin/node --version

cd ~/.dotfiles/programs && ./neovim.sh cleanfirst
~/.local/bin/nvim --version
