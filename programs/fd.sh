#!/bin/bash
# Download and install fd.
set -e
VERSION=v10.2.0
SHA256=d9bfa25ec28624545c222992e1b00673b7c9ca5eb15393c40369f10b28f9c932

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

# Check if fd is already installed
if [ "$OPT_FORCE" != "y" ] && command -v fd > /dev/null; then
	echo "fd is already installed in $(command -v fd)"
	fd --version
	exit 0
fi

set -x

# Get source code
if [ ! -f "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz" ]; then
	mkdir -p downloads
	wget -q "https://github.com/sharkdp/fd/releases/download/$VERSION/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz" -O "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz"
fi

# Verify the hash
sha256sum "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz" | grep -q "$SHA256" || {
	sha256sum "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/bin
tar -xf "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz"
mv fd-$VERSION-x86_64-unknown-linux-musl/fd ~/.local/bin/
rm -fr fd-$VERSION-x86_64-unknown-linux-musl
