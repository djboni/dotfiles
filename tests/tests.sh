#!/bin/bash
set -e

# Change to this script directory
PROGRAM="$0"
PROGDIR="${PROGRAM%/*}"
set -x
cd "$PROGDIR"

docker build .. -f ubuntu.Dockerfile    -t dotfiles-ubuntu
docker build .. -f almalinux.Dockerfile -t dotfiles-almalinux
