#!/bin/bash
# Download and install ripgrep.
set -e
VERSION=14.1.1
SHA256=4cf9f2741e6c465ffdb7c26f38056a59e2a2544b51f7cc128ef28337eeae4d8e

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
