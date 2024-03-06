#!/bin/bash
set -xe
(cd dotfiles && ./dotfiles.sh)
(cd programs && ./neovim.sh)
