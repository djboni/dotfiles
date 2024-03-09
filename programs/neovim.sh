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

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if NeoVim is already installed
if which nvim > /dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	nvim --version
	exit 0
fi

# Install dependencies
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
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"
make install
