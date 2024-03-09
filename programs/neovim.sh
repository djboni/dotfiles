#!/bin/bash
# Download and install Neovim.
set -e
VERSION=v0.9.5
SHA256=44ee395d9b5f8a14be8ec00d3b8ead34e18fe6461e40c9c8c50e6956d643b6ca

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if NeoVim is already installed
if which nvim > /dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	nvim --version
	exit 0
fi

# Install dependencies
install_if_absent curl wget unzip make gcc

set -x

# Get source code
if [ ! -f "downloads/nvim-linux64-$VERSION.tar.gz" ]; then
	mkdir -p downloads
	wget -q "https://github.com/neovim/neovim/releases/download/$VERSION/nvim-linux64.tar.gz" -O "downloads/nvim-linux64-$VERSION.tar.gz"
fi

# Verify the hash
sha256sum "downloads/nvim-linux64-$VERSION.tar.gz" | grep -q "$SHA256" || {
	sha256sum "downloads/nvim-linux64-$VERSION.tar.gz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local
tar -xf "downloads/nvim-linux64-$VERSION.tar.gz" --xform "s/nvim-linux64//" -C ~/.local
