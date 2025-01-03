#!/bin/bash
set -e

UNAME="$(uname)"
case "$UNAME" in
	Linux*) ;;
	MINGW64_NT*)
		./win-cli.sh
		exit $?
		;;
	*)
		echo "This command is not supported by this platform" >&2
		echo "uname: $UNAME" >&2
		exit 1
		;;
esac

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
cd "$PROGDIR"

# Install utilities
. dotfiles/dotbase.sh
install_if_absent git vim tmux htop
# cloc

# Update to a new version
(set -x; git pull) || true # It is OK if this command fails

. dotfiles/dotbase.sh
(set -x; cd dotfiles && ./dotfiles.sh)
(set -x; cd programs && ./neovim.sh)
(set -x; cd programs && ./ripgrep.sh)
(set -x; cd programs && ./fd.sh)
#(set -x; cd programs && ./nerdfonts.sh)
#(set -x; cd programs && ./zig.sh)
#(set -x; cd programs && ./node.sh)
