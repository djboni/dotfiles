#!/bin/bash
# Download and install fil-c.
set -e
VERSION=0.678
SHA256=8c515f704b3ba524566847d78a8c324708a64d0eefadabb40094bc5130aa8995

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
install_if_absent wget patchelf

# Check if already installed
if [ "$OPT_FORCE" != "y" ] && command -v filcc > /dev/null; then
	echo "Already installed in $(command -v filcc)"
    filcc --version
	exit 0
fi

set -x

# Get source code
if [ ! -f "downloads/filc-$VERSION-linux-x86_64.tar.xz" ]; then
	mkdir -p downloads
	wget -q "https://github.com/pizlonator/fil-c/releases/download/v$VERSION/filc-$VERSION-linux-x86_64.tar.xz" -O "downloads/filc-$VERSION-linux-x86_64.tar.xz"
fi

# Verify the hash
sha256sum "downloads/filc-$VERSION-linux-x86_64.tar.xz" | grep -q "$SHA256" || {
	sha256sum "downloads/filc-$VERSION-linux-x86_64.tar.xz"
	echo "Invalid hash. Should be $VERSION $SHA256" >&2
	exit 1
}

mkdir -p ~/.local/opt/filc
tar -xf "downloads/filc-$VERSION-linux-x86_64.tar.xz" -C ~/.local/opt/filc --strip-components=1
(cd ~/.local/opt/filc; ./setup.sh || true)
grep 'PATH=.*filc' "$HOME/.config/bash/custom_bashrc_$(hostname -s).sh" || {
    echo 'PATH="$HOME/.local/opt/filc/build/bin:$PATH"' | tee -a "$HOME/.config/bash/custom_bashrc_$(hostname -s).sh"
}
