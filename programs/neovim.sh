#!/bin/bash
# Build and install Neovim from source code.
#
# If you cannot build it is possible to download the binaries and extract:
#
# mkdir download
# cd download
# wget https://github.com/neovim/neovim/releases/download/v0.9.5/nvim-linux64.tar.gz
# tar -zxf nvim-linux64.tar.gz --xform 's/nvim-linux64//' -C ~/.local
set -e
VERSION=v0.9.5
REVISION=8744ee8783a8597f9fce4a573ae05aca2f412120

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
	cd src/neovim
else
	cd src/neovim
	git fetch
fi

# Checkout and verify the revision
git checkout "$VERSION"
git rev-parse HEAD | grep -q "$REVISION" || {
	echo "Invalid revision. Should be $VERSION $REVISION" >&2
	exit 1
}

if [ "x$1" = xcleanfirst ]; then
	git clean -fdx
fi

# Build and install
make CMAKE_BUILD_TYPE=Release CMAKE_INSTALL_PREFIX="$INSTALL_PREFIX"
make install
