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

install_if_absent() {
	if [ -z $WHICH_TESTED ]; then
		if which which >/dev/null 2>&1; then
			echo "Found program 'which'" >&2
			WHICH_TESTED=1
		else
			echo "Could nod find the program 'which'" >&2
			exit 1
		fi
	fi
	for PROG in "$@"; do
		EXECUTABLE="${PROG%:*}"
		PACKAGE="${PROG#*:}"

		if which "$EXECUTABLE" >/dev/null 2>&1; then
			echo "Found program '$EXECUTABLE'" >&2
			continue
		fi
		if which apt >/dev/null 2>&1; then
			set -x
			sudo apt install -y "$PACKAGE"
			{ set +x; } 2> /dev/null
		elif which yum >/dev/null 2>&1; then
			case "$PACKAGE" in
			# Ignore unavailable
			htop|ninja-build) continue ;;
			esac
			set -x
			sudo yum install -y "$PACKAGE"
			{ set +x; } 2> /dev/null
		fi
	done
}
