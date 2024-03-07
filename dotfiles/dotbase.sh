#!/bin/bash
# This script just defines some functions and is not meant to be
# sourced (. dotbase.sh).

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

create_link() {
	local DEST="$1"
	local FILE="$2"
	do_backup "$DEST/$FILE"
	set -x
	ln -s "$PWD/$FILE" "$DEST/$FILE"
	{ set +x; } 2> /dev/null
}
