#!/bin/bash
set -e
if [ ! -d ~/.config/wallpapers ]; then
	set -x
	git clone https://gitlab.com/dtos/dtos-backgrounds.git ~/.config/wallpapers ||
	true # It is OK if this command fails
	{ set +x; } 2> /dev/null
fi
