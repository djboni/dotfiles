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

# Check if NeoVim is already installed
which which >/dev/null
if which nvim > /dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	nvim --version
	exit 0
fi

# Install dependencies
. ../dotfiles/dotbase.sh
install_if_absent git make cmake ninja:ninja-build gettext unzip curl gcc

set -x

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
{ set +x; } 2>/dev/null
cd ../..
if [ -z $USER ]; then
	# USER can be unset in containers
	USER="$(whoami)"
fi
if [ $USER != root ]; then
	set -x
	find src/neovim -user root -exec sudo chown $USER:$USER '{}' ';'
fi
