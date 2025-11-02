#!/bin/bash
# Download and install ripgrep.
set -e
VERSION=15.1.0
SHA256=1c9297be4a084eea7ecaedf93eb03d058d6faae29bbc57ecdaf5063921491599

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

# Check if ripgrep is already installed
if [ "$OPT_FORCE" != "y" ] && command -v rg > /dev/null; then
	echo "ripgrep is already installed in $(command -v rg)"
	rg --version
	exit 0
fi

set -x

# Get source code
if [ ! -f "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz" ]; then
	mkdir -p downloads
	wget -q "https://github.com/BurntSushi/ripgrep/releases/download/$VERSION/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz" -O "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
fi

# Verify the hash
sha256sum "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz" | grep -q "$SHA256" || {
	sha256sum "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/bin
tar -xf "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
mv ripgrep-$VERSION-x86_64-unknown-linux-musl/rg ~/.local/bin/
rm -fr ripgrep-$VERSION-x86_64-unknown-linux-musl
