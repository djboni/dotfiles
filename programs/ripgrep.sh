#!/bin/bash
# Download and install ripgrep.
set -e
VERSION=14.1.0
SHA256=f84757b07f425fe5cf11d87df6644691c644a5cd2348a2c670894272999d3ba7

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if ripgrep is already installed
if which rg > /dev/null; then
	echo "ripgrep is already installed in $(which rg)"
	rg --version
	exit 0
fi

# Install dependencies
install_if_absent curl wget unzip make gcc

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

mkdir -p ~/.local
tar -xf "downloads/ripgrep-$VERSION-x86_64-unknown-linux-musl.tar.gz"
mv ripgrep-$VERSION-x86_64-unknown-linux-musl/rg ~/.local/bin
rm -fr ripgrep-$VERSION-x86_64-unknown-linux-musl
