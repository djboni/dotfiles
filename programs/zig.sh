#!/bin/bash
# Download and install zig.
set -e
VERSION=0.14.0
SHA256=d731dc81e1dff2d5f9b1d1979d554648df6d05f7723d1cc9e37430c7ca88d573

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
if [ ! -f "downloads/zig-linux-x86_64-$VERSION.tar.xz" ]; then
	mkdir -p downloads
	wget -q "https://ziglang.org/builds/zig-linux-x86_64-$VERSION.tar.xz" -O "downloads/zig-linux-x86_64-$VERSION.tar.xz"
fi

# Verify the hash
sha256sum "downloads/zig-linux-x86_64-$VERSION.tar.xz" | grep -q "$SHA256" || {
	sha256sum "downloads/zig-linux-x86_64-$VERSION.tar.xz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/bin
tar -xf "downloads/zig-linux-x86_64-$VERSION.tar.xz"
mv zig-linux-x86_64-$VERSION/zig ~/.local/bin/
tar -cC zig-linux-x86_64-$VERSION lib doc | tar -xC ~/.local/
rm -fr zig-linux-x86_64-$VERSION
