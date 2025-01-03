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
if command -v apt; then
	sudo apt install -y i3 light-locker feh blueman pasystray arandr git gitk
elif command -v yum; then
	sudo yum install -y git gitk
fi

if [ ! -d ~/.config/wallpapers ]; then
	git clone https://gitlab.com/dtos/dtos-backgrounds.git ~/.config/wallpapers ||
		true # It is OK if this command fails
fi

# If Firefox is not ESR version, remove and install the ESR version
if ! firefox --version | grep -i esr; then
	if snap list | grep firefox; then
		# Firefox is installed with snap (Ubuntu)
		sudo snap remove firefox &&
			sudo snap install firefox --channel=esr/stable
	fi
fi
