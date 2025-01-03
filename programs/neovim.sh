#!/bin/bash
# Download and install Neovim.
set -e
if ldd --version | grep -qE 'ldd .* 2\.2[0-8]'; then
	# Older glibc (2.28-)
	VERSION=v0.9.5
	SHA256=44ee395d9b5f8a14be8ec00d3b8ead34e18fe6461e40c9c8c50e6956d643b6ca
else
	# Newer glibc (2.29+)
	VERSION=v0.10.3
	SHA256=be189915a2a0da3615576e2db06a7c714aef0ae926b4da6107e589a3cc623e5c
fi

usage() {
	EXIT_STATUS="$1"
	echo "Usage: ${0##*/} [-hf]"
	exit "$EXIT_STATUS"
}

OPT_FORCE=n
while [ $# -ne 0 ]; do
	case "$1" in
		-f) OPT_FORCE=y ;;
		-h) usage 0 ;;
		*) usage 1 ;;
	esac
	shift
done

. ../dotfiles/dotbase.sh
install_if_absent curl wget unzip make gcc

# Check if NeoVim is already installed
if [ "$OPT_FORCE" != "y" ] && command -v nvim >/dev/null; then
	echo "NeoVim is already installed in $(command -v nvim)"
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
