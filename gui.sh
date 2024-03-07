#!/bin/bash
set -e

set -x
sudo apt install gitk

if [ ! -d ~/.config/wallpapers ]; then
	git clone https://gitlab.com/dtos/dtos-backgrounds.git ~/.config/wallpapers ||
	true # It is OK if this command fails
fi
