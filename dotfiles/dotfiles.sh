#!/bin/bash
set -e

do_backup() {
	local FILE="$1"

	if [ -L "$FILE" ]; then
		# Remove if it is a link
		# NOTE: Must test if it's a link before file or directory.
		rm "$FILE"
	elif [ -f "$FILE" ] || [ -d "$FILE" ]; then
		# Create a backup if it is a file or directory
		mv "$FILE" "$FILE.$(date +%Y%m%d-%H%M%S)"
	elif [ ! -e "$FILE" ]; then
		# Does not exist
		:
	else
		echo "Path '$FILE' is not file, directory, or link" >&2
		exit 1
	fi
}

link_file() {
	local DEST="$1"
	local FILE="$2"
	do_backup "$DEST/$FILE"
	set -x
	ln -s "$PWD/$FILE" "$DEST/$FILE"
	{ set +x; } 2> /dev/null
}

# Files
link_file ~ .bashrc
link_file ~ .gitconfig
link_file ~ .profile
link_file ~ .tmux.conf
link_file ~ .xinitrc

# Directories
link_file ~ .config/bash
link_file ~ .config/i3
link_file ~ .config/i3status
link_file ~ .config/scripts

# Clone/update NeoVim configuration
if [ -d ~/.config/nvim ]; then
	set -x
	cd ~/.config/nvim
	git pull ||
	true # It is OK if this command fails
	{ set +x; } 2> /dev/null
else
	set -x
	git clone https://github.com/djboni/kickstart.nvim ~/.config/nvim
	{ set +x; } 2> /dev/null
fi
