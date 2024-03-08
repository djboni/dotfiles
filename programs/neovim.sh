#!/bin/bash
# Build and install Neovim from source code.
#
# If you cannot build it is possible to download the binaries and extract:
#
# mkdir download
# cd download
# wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
# tar -zxf nvim-linux64.tar.gz --xform 's/nvim-linux64//' -C /usr/local
set -e
VERSION=v0.9.5
if [ -z $USER ]; then
	USER="$(whoami)"
fi

# Check if NeoVim is already installed
which which
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
cd ../..
find src/neovim -user root -exec sudo chown $USER:$USER '{}' ';'
