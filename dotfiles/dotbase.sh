#!/bin/bash
# This script just defines some functions and is not meant to be
# sourced (. dotbase.sh).

# Determine the installation prefix when building from source
if [ "$(whoami)" == root ]; then
	INSTALL_PREFIX=/usr/local
else
	INSTALL_PREFIX=~/.local
fi

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

check_if_program_is_absent() {
	local EXECUTABLE="$1"
	if command -v "$EXECUTABLE" >/dev/null 2>&1; then
		echo "Found program '$EXECUTABLE'" >&2
		return 1
	else
		echo "Could not find the program '$EXECUTABLE'" >&2
		return 0
	fi
}

install_if_absent() {
	# Usage: install_if_absent cmake ninja
	for EXECUTABLE in "$@"; do
		PACKAGE="$EXECUTABLE"
		check_if_program_is_absent "$EXECUTABLE" || continue

		if command -v apt >/dev/null 2>&1; then
			# Debian, Ubuntu
			case "$PACKAGE" in
				xz) PACKAGE=xz-utils ;;
			esac
			set -x
			sudo apt install -y "$PACKAGE"
			{ set +x; } 2> /dev/null
		elif command -v yum >/dev/null 2>&1; then
			# RHEL, Alma, Rocky
			case "$PACKAGE" in
				# Ignore unavailable
				htop|ninja-build) continue ;;
				xz) PACKAGE=xz-libs ;;
			esac
			set -x
			sudo yum install -y "$PACKAGE"
			{ set +x; } 2> /dev/null
		elif command -v pacman >/dev/null 2>&1; then
			# Arch
			case "$PACKAGE" in
				xz) PACKAGE=xz-utils ;;
			esac
			set -x
			yes | sudo pacman -Sy "$PACKAGE"
			{ set +x; } 2> /dev/null
		elif command -v apk >/dev/null 2>&1; then
			# Alpine
			set -x
			apk add "$PACKAGE"
			{ set +x; } 2> /dev/null
		fi
	done
}
