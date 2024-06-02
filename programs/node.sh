#!/bin/bash
# Download and install Node and NPM.
set -e
VERSION=v20.14.0
SHA256=fedf8fa73b6f51c4ffcc5da8f86cd1ed381bc9dceae0829832c7d683a78b8e36

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
