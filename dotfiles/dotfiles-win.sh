#!/bin/bash
set -e
# Source the base file
. dotbase-win.sh

# Files
create_link ~ .bashrc
create_link ~ .bash_aliases
create_link ~ .gitconfig
create_link ~ .profile

# Directories
mkdir -p ~/.config
create_link ~ .config/bash

# Clone/update NeoVim configuration
NVIM_CONFIG_DIR="$LOCALAPPDATA/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
	set -x
	cd "$NVIM_CONFIG_DIR"
	git pull || true # It is OK if this command fails
	{ set +x; } 2> /dev/null
	cd ../..
else
	set -x
	# Newer glibc (2.29+)
	BRANCH=master
	git clone --branch "$BRANCH" https://github.com/djboni/kickstart.nvim "$NVIM_CONFIG_DIR"
	{ set +x; } 2> /dev/null
fi
