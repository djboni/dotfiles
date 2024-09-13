#!/bin/bash
set -e
# Source the base file
. dotbase.sh

# Clone/update NeoVim configuration
NVIM_CONFIG_DIR="$HOME/.config/nvim"
if [ -d "$NVIM_CONFIG_DIR" ]; then
	set -x
	cd "$NVIM_CONFIG_DIR"
	git pull || true # It is OK if this command fails
	{ set +x; } 2> /dev/null
	cd ../..
else
	set -x
	if ldd --version | grep -qE 'ldd .* 2\.2[0-8]'; then
		# Older glibc (2.28-)
		BRANCH=nvim-0.9
	else
		# Newer glibc (2.29+)
		BRANCH=master
	fi
	git clone --branch "$BRANCH" https://github.com/djboni/kickstart.nvim "$NVIM_CONFIG_DIR"
	{ set +x; } 2> /dev/null
fi

# Files
create_link ~ .bashrc
create_link ~ .bash_aliases
create_link ~ .gitconfig
create_link ~ .profile
create_link ~ .tmux.conf
create_link ~ .xinitrc
create_link ~ .vimrc

# Directories
mkdir -p ~/.config
create_link ~ .config/bash
create_link ~ .config/i3
create_link ~ .config/i3status
create_link ~ .config/scripts
