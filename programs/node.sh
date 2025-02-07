#!/bin/bash
# Download and install Node and NPM.
set -e
VERSION=v20.18.2
SHA256=4e50f727ae09bdafecf2322c72faf7cd82bf3b8851a16b8bb63974e0d8d6eceb

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
install_if_absent wget xz

# Check if Node is already installed
if [ "$OPT_FORCE" != "y" ] && command -v node >/dev/null; then
	echo "Node is already installed in $(command -v node)"
	node --version
	exit 0
fi

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

mkdir -p ~/.local/bin
tar -xf "downloads/node-$VERSION-linux-x64.tar.xz"
tar -cC node-$VERSION-linux-x64 bin include lib share | tar -xC ~/.local
rm -fr node-$VERSION-linux-x64
