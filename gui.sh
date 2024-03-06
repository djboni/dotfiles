#!/bin/bash
set -xe
[ -d ~/.config/wallpapers ] ||
git clone https://gitlab.com/dtos/dtos-backgrounds.git ~/.config/wallpapers ||
true # It is OK if this script fails
