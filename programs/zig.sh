#!/bin/bash
# Download and install zig.
set -e
VERSION=0.14.1
SHA256=24aeeec8af16c381934a6cd7d95c807a8cb2cf7df9fa40d359aa884195c4716c

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
install_if_absent wget

# Check if already installed
if [ "$OPT_FORCE" != "y" ] && command -v zig > /dev/null; then
	echo "Already installed in $(command -v zig)"
	zig version
	exit 0
fi

set -x

# Get source code
#          zig-x86_64-linux-$VERSION
if [ ! -f "downloads/zig-x86_64-linux-$VERSION.tar.xz" ]; then
	mkdir -p downloads
	wget -q "https://ziglang.org/download/$VERSION/zig-x86_64-linux-$VERSION.tar.xz" -O "downloads/zig-x86_64-linux-$VERSION.tar.xz"
fi

# Verify the hash
sha256sum "downloads/zig-x86_64-linux-$VERSION.tar.xz" | grep -q "$SHA256" || {
	sha256sum "downloads/zig-x86_64-linux-$VERSION.tar.xz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/bin
tar -xf "downloads/zig-x86_64-linux-$VERSION.tar.xz"
mv zig-x86_64-linux-$VERSION/zig ~/.local/bin/
tar -cC zig-x86_64-linux-$VERSION lib doc | tar -xC ~/.local/
rm -fr zig-x86_64-linux-$VERSION
