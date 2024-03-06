#!/bin/bash
# Build and install Neovim from source code.
set -e
VERSION=v0.9.5

# Clone my configuration
if [ -d ~/.config/nvim ]; then
	set -x
	cd ~/.config/nvim
	git pull
	{ set +x; } 2> /dev/null
else
	set -x
	git clone https://github.com/djboni/kickstart.nvim ~/.config/nvim
	{ set +x; } 2> /dev/null
fi

# Check if NeoVim is already installed
if which nvim > /dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	exit 0
fi

set -x

# Install dependencies
sudo apt install -y git make cmake ninja-build gettext unzip curl

# Get source code
[ -d src/neovim ] ||
git clone https://github.com/neovim/neovim src/neovim

# Build and install
cd src/neovim
git fetch
git checkout "$VERSION"
make CMAKE_BUILD_TYPE=Release
sudo make install
find src/neovim -user root -exec sudo chown $USER:$USER '{}' ';'
