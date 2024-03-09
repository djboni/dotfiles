#!/bin/bash
set -xe
cd ~/.dotfiles/dotfiles && ./dotfiles.sh

cd ~/.dotfiles/programs && ./neovim.sh
~/.local/bin/nvim --version

cd ~/.dotfiles/programs && ./node.sh
~/.local/bin/node --version

cd ~/.dotfiles/programs && ./ripgrep.sh
~/.local/bin/rg --version
