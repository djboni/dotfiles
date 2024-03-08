#!/bin/bash
set -e
# Source the base file
. ../dotbase.sh

# Files
create_link ~ .bashrc
create_link ~ .gitconfig
create_link ~ .profile
create_link ~ .tmux.conf
create_link ~ .xinitrc

# Directories
mkdir -p ~/.config
create_link ~ .config/bash
create_link ~ .config/i3
create_link ~ .config/i3status
create_link ~ .config/scripts

# Clone/update NeoVim configuration
if [ -d .config/nvim ]; then
	set -x
	cd .config/nvim
	git pull ||
	true # It is OK if this command fails
	cd ../..
	{ set +x; } 2> /dev/null
else
	set -x
	git clone https://github.com/djboni/kickstart.nvim .config/nvim
	{ set +x; } 2> /dev/null
fi
create_link ~ .config/nvim
mkdir -p .config/nvim/spell
