#!/bin/bash
set -ex

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
