#!/bin/bash
# Download and install Node and NPM.
set -e
VERSION=v20.11.1
SHA256=d8dab549b09672b03356aa2257699f3de3b58c96e74eb26a8b495fbdc9cf6fbe

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if NPM is already installed
if which npm > /dev/null; then
	echo "NPM is already installed in $(which npm)"
	npm --version
	exit 0
fi

# Install dependencies
install_if_absent xz:xz-utils

set -x

# Get source code
if [ ! -f "downloads/node-$VERSION-linux-x64.tar.xz" ]; then
	mkdir -p downloads
	curl "https://nodejs.org/dist/$VERSION/node-$VERSION-linux-x64.tar.xz" -o "downloads/node-$VERSION-linux-x64.tar.xz"
fi

# Verify the hash
sha256sum "downloads/node-$VERSION-linux-x64.tar.xz" | grep -q "$SHA256" || {
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local
tar -xf "downloads/node-$VERSION-linux-x64.tar.xz" --xform "s/node-$VERSION-linux-x64//" -C ~/.local
