#!/bin/bash
# Download and install JetBrains Nerd Font.
set -e
VERSION=v3.3.0
SHA256=2d83782a350b604bfa70fce880604a41a7f77c3eec8f922f9cdc3c20952ddbe4

. ../dotfiles/dotbase.sh
exit_if_which_is_absent
install_if_absent wget unzip

set -x

# Check if already installed
if [ -f ~/.local/share/fonts/JetBrainsMonoNerdFont-Regular.ttf ]; then
	echo "Already installed"
	exit 0
fi

# Get file
if [ ! -f "downloads/JetBrainsMono-$VERSION.zip" ]; then
	mkdir -p downloads
	wget -q "https://github.com/ryanoasis/nerd-fonts/releases/download/$VERSION/JetBrainsMono.zip" -O "downloads/JetBrainsMono-$VERSION.zip"
fi

# Verify the hash
sha256sum "downloads/JetBrainsMono-$VERSION.zip" | grep -q "$SHA256" || {
	sha256sum "downloads/JetBrainsMono-$VERSION.zip"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/share/fonts
ORIG_PWD="$PWD"
cd ~/.local/share/fonts
unzip "$ORIG_PWD/downloads/JetBrainsMono-$VERSION.zip"
fc-cache -fv
