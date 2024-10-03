#!/bin/bash
# Download and install Neovim.
set -e
if ldd --version | grep -qE 'ldd .* 2\.2[0-8]'; then
	# Older glibc (2.28-)
	VERSION=v0.9.5
	SHA256=44ee395d9b5f8a14be8ec00d3b8ead34e18fe6461e40c9c8c50e6956d643b6ca
else
	# Newer glibc (2.29+)
	VERSION=v0.10.2
	SHA256=9f696e635d503b844e4e78e88a22bcf512a78f288bf471379afc3d0004e15217
fi

. ../dotfiles/dotbase.sh
exit_if_which_is_absent
install_if_absent curl wget unzip make gcc

# Check if NeoVim is already installed
if which nvim >/dev/null; then
	echo "NeoVim is already installed in $(which nvim)"
	nvim --version
	exit 0
fi

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

mkdir -p ~/.local/bin
tar -xf "downloads/nvim-linux64-$VERSION.tar.gz" --strip-components 1 -C ~/.local
