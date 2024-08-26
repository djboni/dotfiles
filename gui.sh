#!/bin/bash
set -e

UNAME="$(uname)"
case "$UNAME" in
	Linux) ;;
	*)
		echo "This command is only for Linux" >&2
		echo "uname: $UNAME" >&2
		exit 1
		;;
esac

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

set -x
which which
if which apt; then
	sudo apt install -y i3 light-locker feh gitk
elif which yum; then
	sudo yum install -y gitk
fi

if [ ! -d ~/.config/wallpapers ]; then
	git clone https://gitlab.com/dtos/dtos-backgrounds.git ~/.config/wallpapers ||
	true # It is OK if this command fails
fi
