#!/bin/bash
set -e

ENCRYPT=
DECRYPT=

do_usage() {
	echo "Usage: ${0##/*} [save|restore]"
	exit $1
}

do_encrypt() {
	[ -f id_rsa.asc ] && mv id_rsa.pub "id_rsa.$(date +%Y%m%d-%H%M%S).pub"
	[ -f id_rsa.asc ] && mv id_rsa.asc "id_rsa.$(date +%Y%m%d-%H%M%S).asc"
	set -x
	cp ~/.ssh/id_rsa.pub .
	tar -zcC ~/.ssh id_rsa id_rsa.pub | gpg --symmetric --armor --no-symkey-cache > id_rsa.asc
	{ set +x; } 2> /dev/null
}

do_decrypt() {
	umask 077
	mkdir -p ~/.ssh
	[ ! -f ~/.ssh/id_rsa ] || cp ~/.ssh/id_rsa ~/.ssh/"id_rsa.$(date +%Y%m%d-%H%M%S)"
	[ ! -f ~/.ssh/id_rsa.pub ] || cp ~/.ssh/id_rsa.pub ~/.ssh/"id_rsa.$(date +%Y%m%d-%H%M%S).pub"
	set -x
	gpg --decrypt --no-symkey-cache id_rsa.asc | tar -zxC ~/.ssh
	{ set +x; } 2> /dev/null
}

if [ $# -eq 0 ]; then
	do_usage 1
fi

while [ $# -gt 0 ]; do
	case "$1" in
		-h|--help) do_usage 0 ;;
		save)      ENCRYPT=1  ;;
		restore)   DECRYPT=1  ;;
		*)         do_usage 1 ;;
	esac
	shift
done

[ -z $ENCRYPT ] || do_encrypt
[ -z $DECRYPT ] || do_decrypt
