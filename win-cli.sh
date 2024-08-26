#!/bin/bash
set -e

UNAME="$(uname)"
case "$UNAME" in
	MINGW64_NT*) ;;
	*)
		echo "This command is only for Windows" >&2
		echo "uname: $UNAME" >&2
		exit 1
		;;
esac

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

# Update to a new version
(set -x; git pull) || true # It is OK if this command fails

. dotfiles/dotbase-win.sh
(set -x; cd dotfiles && ./dotfiles-win.sh)
