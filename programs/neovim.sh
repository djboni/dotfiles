#!/bin/bash
# Build and install Neovim from source code.
set -e
VERSION=v0.9.5

# Check if NeoVim is already installed
if which nvim > /dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	echo "Version:"
	nvim --version
	exit 0
fi

set -x

# Install dependencies
if which apt; then
	sudo apt install -y git make cmake ninja-build gettext unzip curl
elif which yum; then
	sudo yum install -y git make cmake gettext unzip curl gcc
fi

# Get source code
if [ ! -d src/neovim ]; then
	git clone https://github.com/neovim/neovim src/neovim
fi

# Build and install
cd src/neovim
git fetch
git checkout "$VERSION"
make CMAKE_BUILD_TYPE=Release
sudo make install
find src/neovim -user root -exec sudo chown $USER:$USER '{}' ';'
