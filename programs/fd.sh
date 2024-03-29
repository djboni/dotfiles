#!/bin/bash
# Download and install fd.
set -e
VERSION=v9.0.0
SHA256=069e2d58127ddd944c03a2684ad79f72e3f9bd3e0d2642c36adc5b367c134592

. ../dotfiles/dotbase.sh
exit_if_which_is_absent

# Check if fd is already installed
if which fd > /dev/null; then
	echo "fd is already installed in $(which fd)"
	fd --version
	exit 0
fi

# Install dependencies
install_if_absent wget

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

mkdir -p ~/.local
tar -xf "downloads/fd-$VERSION-x86_64-unknown-linux-musl.tar.gz"
mv fd-$VERSION-x86_64-unknown-linux-musl/fd ~/.local/bin
rm -fr fd-$VERSION-x86_64-unknown-linux-musl
