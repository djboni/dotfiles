#!/bin/bash
# Download and install Neovim.
set -e
if ldd --version | grep -qE 'ldd .* 2\.2[0-8]'; then
	# Older glibc (2.28-)
	VERSION=v0.9.5
	SHA256=44ee395d9b5f8a14be8ec00d3b8ead34e18fe6461e40c9c8c50e6956d643b6ca
else
	# Newer glibc (2.29+)
	VERSION=v0.10.1
	SHA256=4867de01a17f6083f902f8aa5215b40b0ed3a36e83cc0293de3f11708f1f9793
fi

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

mkdir -p ~/.local/bin
tar -xf "downloads/nvim-linux64-$VERSION.tar.gz" --strip-components 1 -C ~/.local
