#!/bin/bash
# Download and install Node and NPM.
set -e
VERSION=v20.15.0
SHA256=4f57f7828e6adb9f6bc77932f10e316cca68b0f160c82b21d9a2c7647c7f10bf

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if Node is already installed
if which node > /dev/null; then
	echo "Node is already installed in $(which node)"
	node --version
	exit 0
fi

# Install dependencies
install_if_absent wget xz:xz-utils

set -x

# Get source code
if [ ! -f "downloads/node-$VERSION-linux-x64.tar.xz" ]; then
	mkdir -p downloads
	wget -q "https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz" -O "downloads/node-$VERSION-linux-x64.tar.xz"
fi

# Verify the hash
sha256sum "downloads/node-$VERSION-linux-x64.tar.xz" | grep -q "$SHA256" || {
	sha256sum "downloads/node-$VERSION-linux-x64.tar.xz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local
tar -xf "downloads/node-$VERSION-linux-x64.tar.xz"
tar -cC node-$VERSION-linux-x64 bin include lib share | tar -xC ~/.local
rm -fr node-$VERSION-linux-x64
